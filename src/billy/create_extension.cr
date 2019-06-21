require "./database_connection"

module CreateExtension
  include DatabaseConnection

  def create_extension(name : String | Symbol)
    connection do |db|
      db.exec("CREATE EXTENSION IF NOT EXISTS \"#{name}\";")
    end
  end
end
