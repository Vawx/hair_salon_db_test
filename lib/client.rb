require './lib/dbsalon'

class Client
  attr_reader( :name, :id )

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:save_to_db) do |client_name|
    @id = DBSalon.add_to_column( "client", client_name, "name" )
    return @id
  end
end
