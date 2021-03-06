require_relative('../features/config')

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
%w{ ldap_user utils settings storage }.each { |file| require file }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
