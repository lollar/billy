require "./database_connection"
require "./add_column"

module Billy
  class CreateTable
    include DatabaseConnection

    def self.create_table(table_name : Symbol)
      table = new table_name
      yield table
      table.create!
    end

    def initialize(@table_name : Symbol)
      @columns = [] of Billy::AddColumn
    end

    def add_column(column_name : Symbol | String)
      @columns << Billy::AddColumn.new(column_name)
      @columns.last
    end

    def create!
      sql_string =
        <<-SQL
        CREATE TABLE #{@table_name} (
        id SERIAL PRIMARY KEY,
        #{@columns.map(&.as_sql).join(",\n")},
        created_at timestamp DEFAULT current_timestamp
        );
        SQL

      connection do |db|
        db.exec(sql_string)
      end
    end
  end
end
