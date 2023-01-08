require "stronger_migrations/version"
require "stronger_migrations/engine"
require "faraday"

module StrongerMigrations
  # Your code goes here...
end

module StrongMigrations
  module Migration
    def remove_column(table_name, column_name, type = nil, **options)
      binding.pry
      response = check_api(table_name, column_name)
      if response.status == 200
        response_body = JSON.parse(response.body)
        if response_body['status']
          return super(table_name, column_name, type, options)
        end
      end
      raise_error
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
