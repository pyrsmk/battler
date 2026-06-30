module Battler
  module Card
    class Armor
      include Abstract

      def initialize(@data : ArmorData); end

      private def data : PrintableData
        [
          {
            "Type"     => "Armor",
            "Race"     => @data[:race].to_s
          },
          {
            "DF bonus" => @data[:race] == Race::DurableArmor && @data[:df] <= 10 ?
                          (@data[:df] * 100).to_s :
                          "#{@data[:df] * 100} / #{(@data[:df] - 10) * 100}"
          },
          {
            "Special"  => SPECIAL_DESCRIPTIONS[@data[:special]]? || "Unknown (#{@data[:special]})"
          }
        ]
      end
    end
  end
end
