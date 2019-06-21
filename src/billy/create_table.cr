require "./database_connection"

module Billy
  class CreateTable
    include DatabaseConnection

    def self.create_table(table_name : Symbol)
      table = new table_name
      yield table
      table.create!
    end

    def initialize(@table_name : Symbol)
      @columns = [] of AddColumn
    end

    def add_column(column_name : Symbol | String)
      @columns << AddColumn.new(column_name)
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

  class AddColumn
    DATABASE_TYPE_MAP = {
      "String" => "varchar(256)",
      "Int8"   => "smallint",
      "Int16"  => "smallint",
      "Int32"  => "integer",
      "Int64"  => "bigint"
    }

    def initialize(name : Symbol | String)
      @string_builder = ["#{name}"]
    end

    def of_type(type) : AddColumn
      @string_builder << "#{DATABASE_TYPE_MAP[type.to_s]}"
      self
    end

    def unique : AddColumn
      @string_builder << "UNIQUE"
      self
    end

    def not_null : AddColumn
      @string_builder << "NOT NULL"
      self
    end

    def default(value) : AddColumn
      @string_builder << "DEFAULT #{value}"
      self
    end

    def as_sql : String
      @string_builder.join(" ")
    end
  end
end
