module Billy
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
