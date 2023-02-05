module StrongerMigrations
  class Engine < ::Rails::Engine
    isolate_namespace StrongerMigrations
    config.generators.api_only = true

    ActiveSupport.on_load(:active_record) do
      ::StrongMigrations::Checker.class_eval do
        alias original_check_remove_column check_remove_column

        def check_remove_column(method, *args)
          table_name = args.first
          column = args.second
          if StrongMigrations.check_enabled?(method, version: version)
            response = check_api(table_name, column)
            if response.status == 200
              response_body = JSON.parse(response.body)
              return original_check_remove_column(method, *args) if response_body['status']
            end
            @migration.stop!("Should be ignored first #{args.inspect}", header: "Fooo bar")
          else
            original_check_remove_column(method, *args)
          end
        end

        private

        def check_api(table_name, column_name)
          params = {
            table_name: table_name,
            column_name: column_name
          }
          url = "http://web:3000/stronger_migrations/columns?#{params.to_param}"
          Faraday.get(url)
        end
      end
    end
  end
end
