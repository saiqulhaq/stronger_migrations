module StrongerMigrations
  class ColumnsController < ApplicationController
    # params =>
    #   table_name: :users,
    #   column: :column_x
    def index
      if valid?(params.require(:table_name), params.require(:column_name))
        render json: { status: true }
      else
        render json: { status: false, errors: @missing_columns }
      end
    end

    def valid?(table_name, column_name)
      all_models = ActiveRecord::Base.descendants
      selected_model = all_models.find {|model| model.table_name == table_name }
      return true if selected_model.ignored_columns.include?(column_name)

      @missing_columns = "The model of table #{table_name} doesn't ignore the #{column_name} column yet"
      false
    end
  end
end
