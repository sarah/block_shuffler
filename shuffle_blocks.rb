require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  colors = ["blue", "red"]
  haml :index, :locals => {colors: colors}
end
