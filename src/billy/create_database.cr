require "db"
require "pg"

module Billy
  module CreateDatabase
    def create_database(drop_if_exists = false)
      initial_db = "postgres://127.0.0.1:5432/postgres"
      db_name    = "billy_test"

      db        = DB.open initial_db
      db_exists = db.query_one(
        "SELECT EXISTS(SELECT datname FROM pg_catalog.pg_database WHERE datname = '#{db_name}');",
        &.read(Bool)
      )

      begin
        if db_exists && !drop_if_exists
          puts "!!! Database #{db_name} already exists. To drop run command with `drop_if_exists: true`\n"
        else
          puts "Dropping #{db_name} if exists\n" if drop_if_exists
          puts "Creating #{db_name}\n"
          db.exec "DROP DATABASE IF EXISTS #{db_name};"
          db.exec "CREATE DATABASE #{db_name};"
          puts "Successfully created #{db_name}\n"
        end
      end
    end
  end
end
