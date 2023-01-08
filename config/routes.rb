StrongerMigrations::Engine.routes.draw do
  resources :columns, only: :index
end
