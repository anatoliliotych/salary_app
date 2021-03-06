# encoding: utf-8

require 'sinatra'
require 'sinatra/base'
require 'haml'
require 'sinatra/flash'
require 'sinatra/i18n'
require 'pony'
require 'dm-core'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'dm-types'

require_relative 'helpers/helpers'
$LOAD_PATH.push File.expand_path('../routes', __FILE__)
%w{ session home }.each { |file| require file }

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
%w{ ldap_user settings utils storage}.each { |file| require file }

$LOAD_PATH.push File.expand_path('../models', __FILE__)
%w{ user salary_item }.each { |file| require file }

DataMapper.setup :default, "sqlite://#{Dir.pwd}/db/salary.db"
DataMapper.auto_upgrade!

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :locales, File.join(File.dirname(__FILE__), 'config/en.yml')

  use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/'

  helpers Sinatra::App::Helpers
  helpers Utils

  register Sinatra::I18n
  register Sinatra::Flash
  register Sinatra::App::Routing::Session
  register Sinatra::App::Routing::Home
end
