module Battler
  module Card
    class Armor
      include Abstract

      def initialize(@data : ArmorData); end

      private def data : PrintableData
        data = [
          {
            "Type"     => "Armor",
            "Subtype"  => @data[:race].to_s
          },
          {
            "DF bonus" => @data[:race] == Race::DurableArmor && @data[:df] <= 10 ?
                          (@data[:df] * 100).to_s :
                          "#{@data[:df] * 100} / #{(@data[:df] - 10) * 100}"
          }
        ]

        if @data[:special] > 0
          data << {
            "Special"  => SPECIAL_DESCRIPTIONS[@data[:special]]? || "Unknown (#{@data[:special]})"
          }
        end

        data
      end
    end
  end
end
