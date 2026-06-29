module Battler
  module Card
    class Weapon
      include Abstract

      def initialize(@data : WeaponData); end

      private def data : PrintableData
        [
          {
            "Type"     => "Weapon",
            "Race"     => @data[:race].to_s
          },
          {
            "ST bonus" => @data[:race] == Race::DurableWeapon ?
                          "#{@data[:st] * 100} / #{(@data[:st] - 10) * 100}" :
                          (@data[:st] * 100).to_s
          },
          {
            "Special"  => SPECIAL_DESCRIPTIONS[@data[:special]]? || "Unknown (#{@data[:special]})"
          }
        ]
      end
    end
  end
end
