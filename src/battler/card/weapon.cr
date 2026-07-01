module Battler
  module Card
    class Weapon
      include Abstract

      def initialize(@data : WeaponData); end

      private def data : PrintableData
        data = [
          {
            "Type"     => "Weapon",
            "Subtype"  => @data[:race].to_s
          },
          {
            "ST bonus" => @data[:race] == Race::DurableWeapon && @data[:st] <= 10 ?
                          (@data[:st] * 100).to_s :
                          "#{@data[:st] * 100} / #{(@data[:st] - 10) * 100}"
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
