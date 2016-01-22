require 'sinatra'
require 'sinatra/reloader'
require 'pry'
also_reload( './lib/**/*.rb')

#ruby wstest.rb -p $PORT -o $IP

get '/' do
  erb :index
end
