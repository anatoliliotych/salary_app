require 'sinatra'
require 'sinatra/base'
require 'haml'

require_relative 'helpers/helpers'
$LOAD_PATH.push File.expand_path('../routes', __FILE__)
%w{ session home }.each { |file| require file }

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
%w{ ldap_user settings utils storage }.each { |file| require file }

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)

  enable :sessions

  helpers Sinatra::App::Helpers
  helpers Utils

  register Sinatra::App::Routing::Session
  register Sinatra::App::Routing::Home
end
