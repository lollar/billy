require "db"
require "pg"

module DatabaseConnection
  def connection(&block)
    database_url = "postgres://127.0.0.1:5432/billy_test"
    database     = DB.open database_url

    begin
      yield database
    ensure
      database.close
    end
  end
end
