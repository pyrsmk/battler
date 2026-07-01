version 3

# Initialize the project.
task :init do
  run "shards check || shards install"
  run "cd web && npm install"
end

# Run the CLI app.
task :cli do |barcode|
  run "crystal run ./src/cli.cr -- #{barcode}"
end

# Run the API server.
task :api do
  run "crystal run ./src/api.cr"
end

# Run the web dev server (Vite).
task :web do
  run "cd web && npx vite"
end

# Build the CLI/API apps.
task :build do
  run "crystal build ./src/cli.cr --release -o bin/battler"
  run "crystal build ./src/api.cr --release -o bin/battler_api_server"
end

# Build the web app.
task :build_web do
  run "cd web && npx vite build"
end
