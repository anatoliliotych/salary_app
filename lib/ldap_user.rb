require 'net/ldap'

class LdapUser
  def self.find(opts)
      ldap_connection = ldap_connect(opts)
      return nil unless ldap_connection
      filter = Net::LDAP::Filter.pres('objectclass')
      filter &= Net::LDAP::Filter.eq('mailnickname', opts[:user])
      results = ldap_connection.search(filter: filter)
      first_result = results.first if results
      first_result[:displayname].first if first_result
    rescue => ex
      puts "NET::LDAP connection has failed with message: #{ex.message}"
      raise "NET::LDAP connection has failed."
  end

  def self.ldap_connect(opts)
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
    Net::LDAP.new connection_settings
   end

  def self.ldap_settings
    {
      host: Settings.ldap.host,
      port: Settings.ldap.port,
      base: Settings.ldap.base
    }
  end
end
