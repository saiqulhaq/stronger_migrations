module StrongerMigrations
  class Engine < ::Rails::Engine
    isolate_namespace StrongerMigrations
    config.generators.api_only = true
  end
end
