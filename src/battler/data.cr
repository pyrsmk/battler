module Battler
  class Data
    property barcode  : String
    property hp       : Int32
    property st       : Int32
    property df       : Int32
    property speed    : Int32
    property race     : Int32
    property job      : Int32
    property pp       : Int32
    property mp       : Int32
    property special  : Int32
    property post_read : Bool

    def initialize(@barcode)
      @hp        = 0
      @st        = 0
      @df        = 0
      @speed     = 0
      @race      = 0
      @job       = 0
      @pp        = 0
      @mp        = 0
      @special   = 0
      @post_read = false
    end

    def is_ean13? : Bool
      @barcode.size == EAN_13
    end

    def ean_shift : Int32
      is_ean13? ? 0 : -5
    end

    def race_name : String
      Race.from_value?(@race).try(&.to_s) || "Unknown (#{@race})"
    end

    def job_name : String
      Job.from_value?(@job).try(&.to_s) || "Unknown (#{@job})"
    end

    def card_type : String
      r = Race.from_value?(@race)
      return "Unknown" unless r
      if FIGHTERS.includes?(r)
        "Fighter"
      elsif WEAPONS.includes?(r)
        "Weapon"
      elsif ARMORS.includes?(r)
        "Armor"
      else
        "Item"
      end
    end

    def special_description : String
      SPECIAL_DESCRIPTIONS[@special]? || (@special == 0 ? "None" : "Unknown (#{@special})")
    end

    # Story mode (C1) stats — stats divided by 10 with small fixed bonuses
    def story_hp : Int32
      @hp // 10
    end

    def story_st : Int32
      @st // 10 + 1
    end

    def story_df : Int32
      @df // 10 + 3
    end

    def display
      r = Race.from_value?(@race)
      is_fighter = r && FIGHTERS.includes?(r)

      rows = build_rows(r, is_fighter)
      width = rows.map { |_, v| v.size }.max

      sep = "+--------------+-#{"-" * width}-+"
      rows.each_with_index do |(label, value), i|
        puts sep if i == 0 || label == "Type" || label == "HP" || label == "Special"
        if label.empty?
          puts "| %-12s | %-*s |" % ["", width, value]
        else
          puts "| %-12s | %-*s |" % [label, width, value]
        end
      end
      puts sep
    end

    private def build_rows(r, is_fighter) : Array({String, String})
      rows = [] of {String, String}

      rows << {"Barcode",   @barcode}
      rows << {"Read mode", @post_read ? "Post-reading" : "Pre-reading"}
      rows << {"Type",      card_type}
      rows << {"Race",      race_name}
      rows << {"Job",       job_name} if is_fighter

      if is_fighter
        rows << {"HP",    "#{@hp * 100} / #{story_hp * 100}"}
        rows << {"ST",    "#{@st * 100} / #{story_st * 100}"}
        rows << {"DF",    "#{@df * 100} / #{story_df * 100}"}
        rows << {"Speed", @speed.to_s}
        rows << {"PP",    @pp.to_s}
        rows << {"MP",    @mp.to_s}
      elsif r && WEAPONS.includes?(r)
        rows << {"ST bonus", (@st * 100).to_s}
      elsif r && ARMORS.includes?(r)
        rows << {"DF bonus", (@df * 100).to_s}
      else
        rows << {"Job",        job_name}
        rows << {"HP restore", (@hp * 100).to_s} if @hp != 0
        rows << {"PP restore", @pp.to_s}         if @pp != 0
        rows << {"MP restore", @mp.to_s}         if @mp != 0
      end

      rows << {"Special", special_description}
      rows
    end
  end
end
