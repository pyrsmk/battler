module Battler
  module Card
    class Item
      include Abstract

      def initialize(@data : ItemData); end

      private def data : PrintableData
        data = [] of Hash(String, String)

        data << {
          "Barcode" => @data[:barcode],
          "Mode"    => @data[:hp] != 0 || @data[:pp] != 0 || @data[:mp] != 0 ?
                       @data[:modes].map(&.to_s).join(" / ") :
                       Mode::C1.to_s
        }
        data << {
          "Type"     => "Item",
          "Subtype"  => @data[:hp] != 0 || @data[:pp] != 0 || @data[:mp] != 0 ?
                        @data[:race].to_s :
                        "Hint"
        }
        data << { "HP bonus" => (@data[:hp] * 100).to_s } if @data[:hp] > 0
        data << { "PP bonus" => @data[:pp].to_s }         if @data[:pp] > 0
        data << { "MP bonus" => @data[:mp].to_s }         if @data[:mp] > 0

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
