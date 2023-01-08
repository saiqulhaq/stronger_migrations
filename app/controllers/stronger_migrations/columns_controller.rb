module StrongerMigrations
  class ColumnsController < ApplicationController
    # params =>
    #   table_name: :users,
    #   column: :column_x
    def index
      if valid?(params.require(:table_name), params.require(:column_name))
        render json: { success: true }
      else
        render json: { success: false, errors: @missing_columns }
      end
    end

    def valid?(table_name, column_name)
      @all_models ||= ObjectSpace.each_object(Class).select do |c|
        next if c == ApplicationRecord
        next if c == ActiveRecord::Base
        begin
          c.respond_to?(:table_name)
        rescue TypeError
          false
        end
      end
      selected_model = @all_models.select {|model| model.table_name == table_name }.last
      return true if selected_model.ignored_columns.include?(column_name)

      @missing_columns = "The model of table #{table_name} doesn't ignore the #{column_name} column yet"
      false
    end
  end
end
