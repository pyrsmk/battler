version 3

# Initialize the project.
task :init do
  run "shards check || shards install"
end

# Run the development app.
task :app do |barcode|
  run "crystal run ./src/battler.cr -- #{barcode}"
end

# Build the app.
task :build do
  run "crystal build ./src/battler.cr --release -o bin"
end
