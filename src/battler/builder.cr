module Battler
  class Builder
    def build(barcode : String) : Data
      validate_length!(barcode)
      validate_checksum!(barcode)

      data = Data.new(barcode)

      if prepost_check(barcode)
        pre_reading(data)
      else
        data.post_read = true
        post_reading(data)
      end

      data
    end

    # Determines whether to use direct (pre) or formula-based (post) reading.
    # Pre-reading: barcode digits map directly to stats.
    # Post-reading: stats derived from a non-linear formula using upper digits.
    private def prepost_check(barcode : String) : Bool
      return false if barcode.size == EAN_8

      first = barcode[0].to_i

      if first == 0 || first == 1
        race_digit = barcode[7].to_i
        if race_digit <= 4
          true
        else
          hp = barcode[0..2].to_i
          st = barcode[3..4].to_i
          df = barcode[5..6].to_i
          hp <= 50 && st <= 19 && df <= 19
        end
      else
        barcode[2].to_i == 9 && barcode[9].to_i == 5
      end
    end

    # --- Pre-reading (direct stat mapping) ---

    private def pre_reading(data : Data)
      b = data.barcode
      data.race    = b[7].to_i
      data.special = b[10..11].to_i

      race = Race.from_value?(data.race)

      if race && FIGHTERS.includes?(race)
        pre_read_fighter(data)
      elsif race && WEAPONS.includes?(race)
        pre_read_weapon(data)
      elsif race && ARMORS.includes?(race)
        pre_read_armor(data)
      else
        pre_read_item(data)
      end
    end

    private def pre_read_fighter(data : Data)
      b = data.barcode
      data.hp    = b[0..2].to_i
      data.st    = b[3..4].to_i
      data.df    = b[5..6].to_i
      data.speed = b[9].to_i
      data.job   = b[8].to_i
      data.pp    = 5

      if data.hp >= 200
        check_stdf = b[3..4].to_i
        bonus_stdf = [13, 29, 45, 61, 77, 93].includes?(check_stdf)

        case Race.from_value?(data.race)
        when Race::Mechanical
          data.st += 100 + (bonus_stdf ? 100 : 0)
          data.df += (bonus_stdf ? 100 : 0)
          data.st -= 255 if data.st > 256
        when Race::Animal
          check_df = b[5..6].to_i
          bonus_df = [13, 29, 45, 61, 77, 93].includes?(check_df)
          data.st += (bonus_df ? 100 : 0)
          data.df += 100 + (bonus_df ? 100 : 0)
          data.df = data.st - 255 if data.df > 256
        when Race::Aquatic
          data.st += 100
          data.df += 100
        end
      end

      data.mp = data.job >= 6 ? 10 : 0
    end

    private def pre_read_weapon(data : Data)
      data.st = data.barcode[3..4].to_i
    end

    private def pre_read_armor(data : Data)
      data.df = data.barcode[5..6].to_i
    end

    private def pre_read_item(data : Data)
      b = data.barcode
      data.job = b[8].to_i
      case data.job
      when 0..4 then data.hp = b[0..2].to_i
      when 7    then data.pp = b[3..4].to_i
      when 8..9 then data.mp = b[5..6].to_i
      end
    end

    # --- Post-reading (formula-based stat derivation) ---

    private def post_reading(data : Data)
      b  = data.barcode
      es = data.ean_shift

      data.race = b[12 + es].to_i
      race = Race.from_value?(data.race)

      if race && FIGHTERS.includes?(race)
        post_read_fighter(data)
      elsif race && WEAPONS.includes?(race)
        post_read_weapon(data)
      elsif race && ARMORS.includes?(race)
        post_read_armor(data)
      else
        post_read_item(data)
      end

      post_read_special(data)
    end

    private def post_read_fighter(data : Data, shift : Int32 = 0)
      b  = data.barcode
      es = data.ean_shift

      data.hp = "#{b[11 + es + shift].to_i // 2}#{b[10 + es + shift]}#{b[9 + es + shift]}".to_i

      tmpst = b[10 + es + shift].to_i + 7
      tmpst -= 10 if tmpst > 11
      tmpst2 = (b[9 + es + shift].to_i + 5) % 10
      data.st = "#{tmpst}#{tmpst2}".to_i

      tmpdf = (b[9 + es + shift].to_i + 7) % 10
      tmpdf2 = (b[8 + es + shift].to_i + 7) % 10
      data.df = "#{tmpdf}#{tmpdf2}".to_i

      data.speed = b[10 + es].to_i
      data.job   = data.is_ean13? ? b[5].to_i : 4
      data.pp    = 5
      data.mp    = data.job >= 6 ? 10 : 0
    end

    private def post_read_weapon(data : Data)
      b  = data.barcode
      es = data.ean_shift
      d10 = b[10 + es].to_i
      d9  = b[9 + es].to_i

      prefix = case d10
               when 5..8 then "1"
               when 3..4 then "3"
               else           "2"
               end
      data.st = "#{prefix}#{(d9 + 5) % 10}".to_i
    end

    private def post_read_armor(data : Data)
      b  = data.barcode
      es = data.ean_shift
      d9 = b[9 + es].to_i
      d8 = b[8 + es].to_i

      mod = (d8 + 7) % 10
      data.df = case d9
                when 3..6 then mod
                when 1..2 then "2#{mod}".to_i
                else           "1#{mod}".to_i
                end
    end

    private def post_read_item(data : Data)
      b  = data.barcode
      es = data.ean_shift
      data.job = 0
      data.hp  = "#{b[11 + es].to_i // 8}#{b[10 + es]}#{b[9 + es]}".to_i
    end

    private def post_read_special(data : Data)
      b  = data.barcode
      es = data.ean_shift
      d8 = b[8 + es].to_i

      data.special = case d8
                     when 0..3 then b[10 + es].to_i
                     when 8..9 then "2#{b[10 + es]}".to_i
                     else           "1#{b[10 + es]}".to_i
                     end
    end

    # --- Validation ---

    private def validate_length!(barcode : String)
      raise ArgumentError.new("Barcode must contain digits only") unless barcode.matches?(/^\d+$/)
      raise ArgumentError.new("Barcode must be #{EAN_8} or #{EAN_13} digits (got #{barcode.size})") unless [EAN_8, EAN_13].includes?(barcode.size)
    end

    private def validate_checksum!(barcode : String)
      b = barcode.size == EAN_8 ? barcode.rjust(EAN_13, '0') : barcode

      digits    = b[0...-1].chars.map(&.to_i)
      sum_odds  = digits.each_with_index.select { |_, i| i.even? }.sum { |d, _| d }
      sum_evens = digits.each_with_index.select { |_, i| i.odd? }.sum { |d, _| d }
      check     = (10 - ((sum_odds + sum_evens * 3) % 10)) % 10

      raise ArgumentError.new("Invalid checksum (expected #{check}, got #{b[-1].to_i})") unless check == b[-1].to_i
    end
  end
end
