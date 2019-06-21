require "./billy/*"

module Billy
  extend CreateDatabase
  extend CreateExtension
end

Billy.create_database(drop_if_exists: true)
Billy.create_extension("uuid-ossp")

class CreateUsersTable < Billy::CreateTable
  def self.up
    create_table(:users) do |table|
      table.add_column(:username).of_type(String).not_null.unique
      table.add_column(:email).of_type(String).not_null.unique
      table.add_column(:pin).of_type(Int8).unique
      table.add_column("guid uuid").default("uuid_generate_v4()")
    end
  end
end

CreateUsersTable.up
