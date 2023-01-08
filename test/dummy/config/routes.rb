Rails.application.routes.draw do
  mount StrongerMigrations::Engine => "/stronger_migrations"
end
