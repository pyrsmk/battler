require "kemal"
require "./battler/**"

before_all do |env|
  env.response.content_type = "application/json"
end

get "/barcode/:barcode" do |env|
  Battler::Barcode.new(env.params.url["barcode"]).to_json
end

error ArgumentError do
  { type: "error", message: "Invalid barcode" }.to_json
end

Kemal.run
