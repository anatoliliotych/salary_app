require 'net/ldap'

class LdapUser
  def self.find(opts)
      @username = opts[:user]
      @password = opts[:pass]
      return nil unless @username && @password

      auth_params = {
        auth: {
          method:   :simple,
          username: "#{Settings.ldap.domain}\\#{@username}",
          password: @password
        }
      }

      connection_settings = ldap_settings.merge!(auth_params)
      @ldap_connection = Net::LDAP.new connection_settings

      filter = Net::LDAP::Filter.pres('objectclass')
      filter &= Net::LDAP::Filter.eq('mailnickname', @username)
      results = @ldap_connection.search(filter: filter)
      first_result = results.first if results
      first_result[:mail].first if first_result
    rescue => ex
      puts "NET::LDAP connection has failed with message: #{ex.message}"
      return nil
  end

  def self.ldap_settings
    {
      host: Settings.ldap.host,
      port: Settings.ldap.port,
      base: Settings.ldap.base
    }
  end
end
