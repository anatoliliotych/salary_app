require 'sinatra'
require 'sinatra/base'

require_relative 'helpers'
$LOAD_PATH.push File.expand_path('../routes', __FILE__)
%w{ login home logout}.each { |file| require file }

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
%w{ ldap_user settings }.each { |file| require file }

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)

  enable :sessions

  helpers Sinatra::App::Helpers

  register Sinatra::App::Routing::Login
  register Sinatra::App::Routing::Logout
  register Sinatra::App::Routing::Home
end
