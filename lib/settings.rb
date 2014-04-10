require 'ostruct'
require 'yaml'

module Settings
  extend self

  def config
    YAML.load_file(File.expand_path('../../config/config.yml', __FILE__)) || {}
  end

  def common
    OpenStruct.new(config['common'])
  end

  def ldap
    OpenStruct.new(config['ldap'])
  end

  def smtp
    OpenStruct.new(config['smtp'])
  end
end

