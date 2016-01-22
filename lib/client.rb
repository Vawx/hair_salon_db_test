require './lib/dbsalon'

class Client
  attr_reader( :name, :stylist, :id )

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @stylist = attributes.fetch(:stylist)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:get_client_by_id) do |id|
    return DBSalon.get_specific_from_column("client", "id", id.to_i)
  end

  define_singleton_method(:rename) do |new_name, id|
    DBSalon.update_specific_from_column("client", "name", new_name, "id", id.to_i)
  end

  define_singleton_method(:save_to_db) do |client_name, stylist_name|
    @id = DBSalon.add_two_to_column( "client", client_name, stylist_name, "name", "stylist" )
    return @id
  end
end
