require './config/environment'
require 'sinatra/base'
require 'rack-flash'



class ApplicationController < Sinatra::Base
  enable :sessions
  use Rack::Flash
  configure do
    set :session_secret, "secret"
    set :public_folder, 'public'
    set :views, 'app/views'
    set :method_override, true 
  end

  get '/' do
    erb :welcome
  end


end