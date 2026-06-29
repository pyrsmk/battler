module Battler
  module Card
    class Character
      include Abstract

      def initialize(@data : CharacterData); end

      private def data : PrintableData
        [
          {
            "Type"    => @data[:type].to_s,
            "Race"    => @data[:race].to_s,
            "Job"     => @data[:job].to_s
          },
          {
            "HP"      => hero? || enemy? ?
                         (@data[:hp] * 100).to_s :
                         "#{@data[:hp] * 100} / #{(@data[:hp] // 10) * 100}",
            "ST"      => hero? || enemy? ?
                         (@data[:st] * 100).to_s :
                         "#{@data[:st] * 100} / #{(@data[:st] // 10 + 1) * 100}",
            "DF"      => hero? || enemy? ?
                         (@data[:df] * 100).to_s :
                         "#{@data[:df] * 100} / #{(@data[:df] // 10 + 3) * 100}",
            "SPD"     => @data[:spd].to_s,
            "PP"      => @data[:pp].to_s,
            "MP"      => @data[:mp].to_s
          },
          {
            "Special"  => SPECIAL_DESCRIPTIONS[@data[:special]]? || "Unknown (#{@data[:special]})"
          }
        ]
      end

      private def hero?
        @data[:special] == 50
      end

      private def enemy?
        @data[:type] == CharacterType::Enemy
      end
    end
  end
end
