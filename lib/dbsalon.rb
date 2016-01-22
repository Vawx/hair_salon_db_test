require 'pg'
require './lib/client'
require './lib/stylist'

class DBSalon
  # Add value to column
  define_singleton_method(:add_to_column) do |column_name, column_value, column_id|
    insert_id = DBSALON.exec("INSERT INTO #{column_name} (#{column_id}) VALUES( '#{column_value}' ) RETURNING id;")
    return insert_id;
  end

  # Add two values to column
  define_singleton_method(:add_two_to_column) do |column_name, column_value, column_value_two, column_id, column_id_two|
    insert_id = DBSALON.exec("INSERT INTO #{column_name} (#{column_id}, #{column_id_two}) VALUES( '#{column_value}', '#{column_value_two}' ) RETURNING id;")
    return insert_id;
  end

  # Get specific value from column
  define_singleton_method(:get_specific_from_column) do |column_name, search_name, column_value|
    found = DBSALON.exec("SELECT * FROM #{column_name} WHERE #{search_name} = '#{column_value}';")
    if column_name == "stylist"
      return Stylist.new( {name: fetch_first(found, "name"), id: fetch_first(found, "id") } )
    elsif column_name == "client"
      return Client.new( {name: fetch_first( found, "name"), id: fetch_first(found, "id") } )
    end
  end

  define_singleton_method(:get_all_specific_from_column) do |column_name, search_name, column_value|
    found = DBSALON.exec("SELECT * FROM #{column_name} WHERE #{search_name} = '#{column_value}';")
    found_list = []
    found.each do |specific|
      if column_name == "stylist"
        found_list.push( Stylist.new( {name: specific.fetch("name"),
                                       id: specific.fetch("id")} ) )
      elsif column_name = "client"
        found_list.push( Client.new( {name: specific.fetch("name"),
                                      stylist: specific.fetch("stylist"),
                                      id: specific.fetch("id")} ) )
      end
    end
    return found_list
  end

  # Get all from column
  define_singleton_method(:get_all_from_column) do |column_name|
    found = DBSALON.exec("SELECT * FROM #{column_name};")
    found_list = []
    found.each do |each|
      if column_name == "stylist"
        found_list.push( Stylist.new( {name: each.fetch("name"), id: each.fetch("id")} ) )
      elsif column_name == "client"
        found_list.push( Client.new( {name: each.fetch("name"), stylist: each.fetch("stylist"), id: each.fetch("id")} ) )
      end
    end
    return found_list
  end

  # UTILITY : Fetch first from PG::Result
  define_singleton_method(:fetch_first) do |found, fetch_name|
    return found.first.fetch(fetch_name) if found.first != nil
  end
end
