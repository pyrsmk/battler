module Battler
  class Barcode
    alias Cards = Card::Character | Card::Weapon | Card::Armor | Card::Item

    @_to_s : String?

    def initialize(@barcode : String); end

    def to_s : String
      @_to_s ||= (
        validate_format!
        validate_size!
        validate_checksum!
        (should_preread? ? preread : postread).to_s
      )
    end

    def ean_8? : Bool
      @barcode.size == 8
    end

    def ean_13? : Bool
      @barcode.size == 13
    end

    private def ean_shift : Int32
      ean_13? ? 0 : -5
    end

    private def validate_format!
      unless @barcode.matches?(/^\d+$/)
        raise ArgumentError.new("Barcode must contain digits only")
      end
    end

    private def validate_size!
      unless ean_8? || ean_13?
        raise ArgumentError.new("Barcode must be 8 or 13 digits (got #{@barcode.size})")
      end
    end

    private def validate_checksum!
      barcode   = ean_8? ? @barcode.rjust(13, '0') : @barcode
      digits    = barcode[0...-1].chars.map(&.to_i)
      sum_odds  = digits.each_with_index.select{ |_, i| i.even? }.sum{ |d, _| d }
      sum_evens = digits.each_with_index.select{ |_, i| i.odd? }.sum{ |d, _| d }
      check     = (10 - ((sum_odds + sum_evens * 3) % 10)) % 10
      unless check == barcode[-1].to_i
        raise ArgumentError.new("Invalid checksum (expected #{check}, got #{barcode[-1].to_i})")
      end
    end

    private def type(job : Job) : CharacterType
      enemy? ?
      CharacterType::Enemy :
      (
        WIZARD_JOBS.includes?(job) ?
        CharacterType::Wizard :
        CharacterType::Soldier
      )
    end

    private def character?(race : Race) : Bool
      [
        Race::Mechanical,
        Race::Animal,
        Race::Aquatic,
        Race::Bard,
        Race::Human
      ].includes?(race)
    end

    private def enemy? : Bool
      @barcode[0].to_i >= 2 &&
      @barcode[2].to_i == 9 &&
      @barcode[9].to_i == 5
    end

    private def weapon?(race : Race) : Bool
      [
        Race::OneUseWeapon,
        Race::DurableWeapon
      ].includes?(race)
    end

    private def armor?(race : Race) : Bool
      [
        Race::OneUseArmor,
        Race::DurableArmor
      ].includes?(race)
    end

    private def should_preread? : Bool
      return false if ean_8?

      # Basic check.
      if [0, 1].includes?(@barcode[0].to_i)
        race_digit = @barcode[7].to_i
        return true if race_digit <= 4

        hp = @barcode[0..2].to_i
        st = @barcode[3..4].to_i
        df = @barcode[5..6].to_i
        hp <= 50 && st <= 19 && df <= 19
      # Enemy format check.
      else
        @barcode[2].to_i == 9 && @barcode[9].to_i == 5
      end
    end

    # Pre-reading: barcode digits map directly to stats.
    private def preread : Cards
      race = Race.from_value(@barcode[7].to_i)

      if character?(race)
        Card::Character.new(preread_character)
      elsif weapon?(race)
        Card::Weapon.new(preread_weapon)
      elsif armor?(race)
        Card::Armor.new(preread_armor)
      else
        Card::Item.new(preread_item)
      end
    end

    private def preread_character : CharacterData
      race = Race.from_value(@barcode[7].to_i)
      job = Job.from_value(@barcode[8].to_i)
      hp = @barcode[0..2].to_i
      st = @barcode[3..4].to_i
      df = @barcode[5..6].to_i
      spd = @barcode[9].to_i
      pp = 5
      mp = @barcode[8].to_i >= 6 ? 10 : 0
      special = @barcode[10..11].to_i

      if hp >= 200
        case race
        when Race::Mechanical
          bonus = [13, 29, 45, 61, 77, 93].includes?(@barcode[3..4].to_i)
          st += 100 + (bonus ? 100 : 0)
          st -= 255 if st > 256
          df += (bonus ? 100 : 0)
        when Race::Animal
          bonus = [13, 29, 45, 61, 77, 93].includes?(@barcode[5..6].to_i)
          st += (bonus ? 100 : 0)
          df += 100 + (bonus ? 100 : 0)
          df = df - 255 if df > 256
        when Race::Aquatic
          st += 100
          df += 100
        end
      end

      {
        barcode: @barcode,
        modes:   enemy? ? [Mode::C2] : [Mode::C0, Mode::C1],
        type:    type(job),
        race:    race,
        job:     job,
        hp:      hp,
        st:      st,
        df:      df,
        spd:     spd,
        pp:      pp,
        mp:      mp,
        special: special,
      }
    end

    private def preread_weapon : WeaponData
      {
        barcode:  @barcode,
        modes:    [Mode::C0, Mode::C1],
        race:     Race.from_value(@barcode[7].to_i),
        st:       @barcode[3..4].to_i,
        special:  0,
      }
    end

    private def preread_armor : ArmorData
      {
        barcode:  @barcode,
        modes:    [Mode::C0, Mode::C1],
        race:     Race.from_value(@barcode[7].to_i),
        df:       @barcode[5..6].to_i,
        special:  0,
      }
    end

    private def preread_item : ItemData
      job = @barcode[8]

      {
        barcode:  @barcode,
        modes:    [Mode::C0, Mode::C1],
        race:     Race.from_value(@barcode[7].to_i),
        hp:       (0..4).includes?(job.to_i) ? @barcode[0..2].to_i : 0,
        pp:       job.to_i == 7 ? @barcode[3..4].to_i : 0,
        mp:       (8..9).includes?(job.to_i) ? @barcode[5..6].to_i : 0,
        special:  0,
      }
    end

    # Post-reading: stats derived from a non-linear formula using upper digits.
    private def postread : Cards
      race = Race.from_value(@barcode[12 + ean_shift].to_i)

      if character?(race)
        Card::Character.new(postread_character)
      elsif weapon?(race)
        Card::Weapon.new(postread_weapon)
      elsif armor?(race)
        Card::Armor.new(postread_armor)
      else
        Card::Item.new(postread_item)
      end
    end

    private def postread_character : CharacterData
      job = Job.from_value(ean_13? ? @barcode[5].to_i : 4)

      {
        barcode: @barcode,
        modes:   [Mode::C0, Mode::C1],
        type:    type(job),
        race:    Race.from_value(@barcode[12 + ean_shift].to_i),
        job:     job,
        hp:      "#{@barcode[11 + ean_shift].to_i // 2}#{@barcode[10 + ean_shift]}#{@barcode[9 + ean_shift]}".to_i,
        st:      (
          st1 = @barcode[10 + ean_shift].to_i + 7
          st1 -= 10 if st1 > 11
          st2 = (@barcode[9 + ean_shift].to_i + 5) % 10
          "#{st1}#{st2}".to_i
        ),
        df:      (
          df1 = (@barcode[9 + ean_shift].to_i + 7) % 10
          df2 = (@barcode[8 + ean_shift].to_i + 7) % 10
          "#{df1}#{df2}".to_i
        ),
        spd:     @barcode[10 + ean_shift].to_i,
        pp:      5,
        mp:      job.value >= 6 ? 10 : 0,
        special: postread_special,
      }
    end

    private def postread_weapon : WeaponData
      prefix = case @barcode[10 + ean_shift].to_i
               when 5..8 then "1"
               when 3..4 then "3"
               else           "2"
               end

      {
        barcode:  @barcode,
        modes:    [Mode::C0, Mode::C1],
        race:     Race.from_value(@barcode[12 + ean_shift].to_i),
        st:       "#{prefix}#{(@barcode[9 + ean_shift].to_i + 5) % 10}".to_i,
        special:  postread_special,
      }
    end

    private def postread_armor : ArmorData
      mod = (@barcode[8 + ean_shift].to_i + 7) % 10

      {
        barcode: @barcode,
        modes:   [Mode::C0, Mode::C1],
        race:    Race.from_value(@barcode[12 + ean_shift].to_i),
        df:      case @barcode[9 + ean_shift].to_i
                 when 3..6 then mod
                 when 1..2 then "2#{mod}".to_i
                 else           "1#{mod}".to_i
                 end,
        special: postread_special,
      }
    end

    private def postread_item : ItemData
      {
        barcode: @barcode,
        modes:   [Mode::C0, Mode::C1],
        race:    Race.from_value(@barcode[12 + ean_shift].to_i),
        hp:      "#{@barcode[11 + ean_shift].to_i // 8}#{@barcode[10 + ean_shift]}#{@barcode[9 + ean_shift]}".to_i,
        pp:      0,
        mp:      0,
        special: postread_special,
      }
    end

    private def postread_special : Int32
      case @barcode[8 + ean_shift].to_i
      when 0..3 then @barcode[10 + ean_shift].to_i
      when 8..9 then "2#{@barcode[10 + ean_shift]}".to_i
      else           "1#{@barcode[10 + ean_shift]}".to_i
      end
    end
  end
end
