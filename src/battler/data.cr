module Battler
  class Data
    property barcode   : String
    property hp        : Int32
    property st        : Int32
    property df        : Int32
    property speed     : Int32
    property race      : Int32
    property job       : Int32
    property pp        : Int32
    property mp        : Int32
    property special   : Int32
    property post_read : Bool
    property enemy     : Bool

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
      @enemy     = false
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
      race = Race.from_value?(@race)
      return "Unknown" unless race
      if FIGHTERS.includes?(race)
        "Fighter"
      elsif WEAPONS.includes?(race)
        "Weapon"
      elsif ARMORS.includes?(race)
        "Armor"
      else
        "Item"
      end
    end

    def special_description : String
      SPECIAL_DESCRIPTIONS[@special]? || (@special == 0 ? "None" : "Unknown (#{@special})")
    end

    def hero? : Bool
      @special == 50
    end

    def fighter? : Bool
      FIGHTERS.includes?(Race.from_value?(@race))
    end

    def mode_name : String
      @enemy ? "C2 (Enemy)" : "C0 / C1"
    end

    def display
      rows = build_rows
      width = rows.map{ |_, v| v.size }.max
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

    private def build_rows : Array({String, String})
      race = Race.from_value?(@race)

      rows = [] of {String, String}
      rows << {"Barcode", @barcode}
      rows << {"Mode",    mode_name}
      rows << {"Type",    card_type}
      rows << {"Race",    race_name}
      rows << {"Job",     job_name} if fighter?

      if fighter?
        if hero? || @enemy
          rows << {"HP", (@hp * 100).to_s}
          rows << {"ST", (@st * 100).to_s}
          rows << {"DF", (@df * 100).to_s}
        else
          rows << {"HP", "#{@hp * 100} / #{(@hp // 10) * 100}"}
          rows << {"ST", "#{@st * 100} / #{(@st // 10 + 1) * 100}"}
          rows << {"DF", "#{@df * 100} / #{(@df // 10 + 3) * 100}"}
        end
        rows << {"Speed", @speed.to_s}
        rows << {"PP",    @pp.to_s}
        rows << {"MP",    @mp.to_s}
      elsif race && WEAPONS.includes?(race)
        rows << {"ST bonus", (@st * 100).to_s}
      elsif race && ARMORS.includes?(race)
        rows << {"DF bonus", (@df * 100).to_s}
      else
        rows << {"Job", job_name}
        rows << {"HP restore", (@hp * 100).to_s} if @hp != 0
        rows << {"PP restore", @pp.to_s}         if @pp != 0
        rows << {"MP restore", @mp.to_s}         if @mp != 0
      end

      rows << {"Special", special_description}
      rows
    end
  end
end
