require "./battler/**"

barcode = ARGV.first?

if barcode.nil? || barcode.empty?
  STDERR.puts "Barcode expected"
  exit 1
end

begin
  puts Battler::Barcode.new(barcode).to_s
rescue error : ArgumentError
  STDERR.puts "Error: #{error.message}"
  exit 1
end
