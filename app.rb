require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
also_reload( './lib/**/*.rb')

#ruby wstest.rb -p $PORT -o $IP
DBSALON = PG.connect( {:dbname => 'salon'})

get '/' do
  erb :index
end
