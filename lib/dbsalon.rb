require 'pg'
require 'client'
require 'stylist'

class DBSalon
  # Add value to column
  define_singleton_method(:add_to_column) do |column_name, column_value|
    insert_id = DBSALON.exec("INSERT INTO '#{column_name}' VALUES( '#{column_value}' ) RETURNING id;")
    return insert_id;
  end

  # Get specific value from column 
  define_singleton_method(:get_specific_from_column) do |column_name, search_name, column_value|
    found = DBSALON.exec("SELECT * FROM '#{column_name}' WHERE '#{search_name} = '#{column_name};")
    if column_name == "stylist"
      return Stylist.new( {name: fetch_first(found, "name"), id: fetch_first(found, "id") } )
    elsif column_name == "client"
      return Client.new( {name: fetch_first( found, "name"), id: fetch_first(found, "id") } )
    end
  end

  # UTILITY : Fetch first from PG::Result
  define_singleton_method(:fetch_first) do |found, fetch_name|
    return found.first.fetch(fetch_name)
  end
end
