require 'ostruct'
require 'yaml'

module Config

  extend self

  def config
    YAML.load_file(File.expand_path('../config/test_config.yml', __FILE__)) || {}
  end

  def correct_ldap_user
    OpenStruct.new(config['correct_ldap_user'])
  end

  def invalid_ldap_user
    OpenStruct.new(config['invalid_ldap_user'])
  end
end

