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

get '/client/:id/:stylist_id' do
  @client = Client.get_client_by_id(params[:id])
  @stylist = Stylist.get_stylist_by_id(params[:stylist_id])
  erb :client
end

get '/stylist/:id' do
  @stylist = Stylist.get_stylist_by_id(params[:id])
  @clients = Stylist.get_all_clients(@stylist.name)
  erb :stylist
end

get '/single_client/:id' do
  @client = Client.get_client_by_id(params[:id])
  erb :single_client
end

post '/add_client_to_stylist/:id/:stylist_id' do
  Client.change_stylist( Stylist.get_stylist_by_id( params[:stylist_id] ).name, params[:id])
  redirect '/client/' + params[:id] + '/' + params[:stylist_id]
end

post '/rename_client/:id/:stylist_id' do
  Client.rename( params.fetch("new_client_name"), params[:id] )
  redirect '/client/' + params[:id] + '/' + params[:stylist_id]
end

post 'rename_single_client/:id' do
  Client.rename( params.fetch("new_client_name"), params[:id] )
  redirect '/single_client/' + params[:id]
end

post '/rename_stylist/:id' do
  new_stylist_name = params.fetch("new_stylist_name")
  if new_stylist_name.length > 0
    Stylist.get_all_clients( Stylist.get_stylist_by_id( params[:id] ).name ).each do |client|
      Client.change_stylist( new_stylist_name, client.id )
    end
    Stylist.rename( params.fetch("new_stylist_name"), params[:id])
    redirect'/stylist/' + params[:id]
  end
  redirect '/'
end

post '/add_client/:id/:redirect_id' do
  existing_stylist = Stylist.get_stylist_by_id(params[:id])
  client_name = params.fetch("client_name")
  if client_name.length > 0
    Client.save_to_db( client_name, existing_stylist.name )
  end
  redirect_id = params[:redirect_id].to_i
  if redirect_id == 0
    redirect '/'
  else
    redirect '/stylist/' + params[:id]
  end
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

post '/delete_client/:id/:stylist_id' do
  Client.delete(params[:id])
  redirect '/stylist/' + params[:stylist_id]
end

post 'delete_single_client/:id' do
  Client.delete(params[:id])
  redirect '/'
end

post '/delete_stylist/:id' do
  Stylist.get_all_clients( Stylist.get_stylist_by_id( params[:id] ).name ).each do |client|
    Client.change_stylist( '', client.id )
  end
  Stylist.delete(params[:id])
  redirect '/'
end
