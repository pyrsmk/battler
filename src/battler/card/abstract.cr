module Battler
  module Card
    alias PrintableData = Array(Hash(String, String))

    module Abstract
      @_to_s : String?

      abstract def data : PrintableData

      def to_s : String
        @_to_s ||= (
          lines = [] of String
          groups = [
            {
              "Barcode" => @data[:barcode],
              "Mode"    => @data[:modes].map(&.to_s).join(" / "),
            }
          ].concat(data)

          width = groups.map{ |group| group.map{ |key, value| value.size }.max }.max
          separator = "+--------------+-#{"-" * width}-+"
          lines << separator

          groups.each do |group|
            group.each do |label, value|
              lines << "| %-12s | %-*s |" % [label, width, value]
            end
            lines << separator
          end

          lines.join("\n")
        )
      end
    end

    SPECIAL_DESCRIPTIONS = {
      0 => "None",
      1 => "3× ST damage vs Job 1 opponents",
      2 => "3× ST damage vs Job 2 opponents",
      3 => "3× ST damage vs Job 3 opponents",
      4 => "3× ST damage vs Job 4 opponents",
      5 => "3× ST damage vs Job 5 opponents",
      6 => "3× ST damage vs Job 6 opponents",
      7 => "3× ST damage vs Job 7 opponents",
      8 => "3× ST damage vs Job 8 opponents",
      10 => "3× ST damage vs Job 0 opponents",
      11 => "3× ST damage vs Race 1 opponents",
      12 => "3× ST damage vs Race 2 opponents",
      13 => "3× ST damage vs Race 3 opponents",
      14 => "3× ST damage vs Race 4 opponents",
      15 => "3× ST damage vs Race 0 opponents",
      16 => "Cursed: ST -50%",
      17 => "ST +50%",
      21 => "DF +30%",
      23 => "Opponent ST -30%",
      25 => "Opponent DF -30%",
      26 => "Opponent DF -50%",
      27 => "Opponent DF -80%",
      28 => "Opponent HP -30% (before battle)",
      30 => "Cursed: 50% chance to drain HP instead",
      31 => "Cursed: 50% chance to penalize ST instead",
      32 => "Cursed: 50% chance to penalize DF instead",
      37 => "Own first-strike rate up",
      38 => "Own hit rate up",
      39 => "Opponent hit rate up",
      40 => "Own hit rate down",
      41 => "Opponent hit rate down",
      43 => "Opponent recovery rate down",
      44 => "Own recovery rate up",
      50 => "Hero card",
      65 => "On defeat: hero gains +1000 HP",
      66 => "On defeat: hero gains +3000 HP",
      70 => "On defeat: hero gains +200 ST",
      71 => "On defeat: hero gains +400 ST",
      72 => "On defeat: hero gains +600 ST",
      73 => "On defeat: hero gains +800 ST",
      75 => "On defeat: hero gains +200 DF",
      76 => "On defeat: hero gains +400 DF",
      77 => "On defeat: hero gains +600 DF",
      78 => "On defeat: hero gains +800 DF",
    }

    SPECIAL_CURSED = [16, 30, 31, 32]
  end
end
