require './lib/dbsalon'

class Client
  attr_reader( :name, :stylist, :id )

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @stylist = attributes.fetch(:stylist)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:save_to_db) do |client_name, stylist_name|
    @id = DBSalon.add_two_to_column( "client", client_name, stylist_name, "name", "stylist" )
    return @id
  end
end
