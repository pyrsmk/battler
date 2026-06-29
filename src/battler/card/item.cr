module Battler
  module Card
    class Item
      include Abstract

      def initialize(@data : ItemData); end

      private def data : PrintableData
        [
          {
            "Type"     => "Item",
            "Race"     => @data[:race].to_s
          },
          {
            "HP bonus" => (@data[:hp] * 100).to_s,
            "PP bonus" => @data[:pp].to_s,
            "MP bonus" => @data[:mp].to_s
          },
          {
            "Special"  => SPECIAL_DESCRIPTIONS[@data[:special]]? || "Unknown (#{@data[:special]})"
          }
        ]
      end
    end
  end
end
