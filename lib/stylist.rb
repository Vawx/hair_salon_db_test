require './lib/dbsalon'

class Stylist
    attr_reader( :name, :id )
    define_method(:initialize) do |attributes|
      @name = attributes.fetch(:name)
      @id = attributes.fetch(:id)
    end

    define_singleton_method(:all) do
      return DBSalon.get_all_from_column("stylist")
    end

    define_singleton_method(:get_stylist_by_id) do |id|
      return DBSalon.get_specific_from_column("stylist", "id", id.to_i)
    end

    define_singleton_method(:get_all_clients) do |match|
      return DBSalon.get_all_specific_from_column("client", "stylist", match)
    end

    define_singleton_method(:save_to_db) do |stylist_name|
      existing_stylist = DBSalon.get_specific_from_column("stylist", "name", stylist_name )
      if existing_stylist.name != nil
        if existing_stylist.name.length == 0
          @id = DBSalon.add_to_column( "stylist", stylist_name, "name" ).first.fetch("id").to_i
        else
          @id = existing_stylist.id.to_i
        end
        return @id
      else
        @id = DBSalon.add_to_column( "stylist", stylist_name, "name" ).first.fetch("id").to_i
        return @id
      end
    end
end
