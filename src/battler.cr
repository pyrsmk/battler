require "./battler/constants"
require "./battler/data"
require "./battler/builder"

barcode = ARGV.first?

if barcode.nil? || barcode.empty?
  STDERR.puts "Barcode expected"
  exit 1
end

begin
  data = Battler::Builder.new.build(barcode)
  data.display
rescue error : ArgumentError
  STDERR.puts "Error: #{error.message}"
  exit 1
end
