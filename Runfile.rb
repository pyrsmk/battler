version 3

# Initialize the project.
task :init do
  run "shards check || shards install"
end

# Run the CLI app.
task :cli do |barcode|
  run "crystal run ./src/cli.cr -- #{barcode}"
end

# Run the webserver.
task :http do
  run "crystal run ./src/http.cr"
end

# Build the apps.
task :build do
  run "crystal build ./src/cli.cr --release -o bin/battler"
  run "crystal build ./src/http.cr --release -o bin/server"
end
