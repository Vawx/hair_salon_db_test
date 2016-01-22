require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
require './lib/stylist'
require './lib/client'
also_reload( './lib/**/*.rb')

#ruby wstest.rb -p $PORT -o $IP
DBSALON = PG.connect( {:dbname => 'salon'})

get '/' do
  @clients = DBSalon.get_all_from_column("client")
  @stylists = DBSalon.get_all_from_column("stylist")
  erb :index
end

post '/add_stylist' do
  client_name = params.fetch( "client_name" )
  stylist_name = params.fetch( "stylist_name" )

  if client_name.length > 0
    Client.save_to_db(client_name, stylist_name)
  end

  if stylist_name.length > 0
    Stylist.save_to_db(stylist_name)
  end

  redirect '/'
end
