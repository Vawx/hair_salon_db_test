require 'dbsalon'

class Client
  attr_reader( :name, :id )

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:save_client_to_db) do |client|
    result =
    @id
  end
end
