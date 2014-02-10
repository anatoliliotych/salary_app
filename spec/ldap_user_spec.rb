require 'spec_helper.rb'

describe LdapUser do

  context '#find without creds' do
    it 'should return nil' do
      expect(LdapUser.find({})).to be_nil
    end
  end

  context '#find with invalid creds' do
    before(:each) do
      ldap_conf = {
        domain: 'dom',
        host: 'example.org',
        port: 123,
        base: 'base'
      }
      settings = OpenStruct.new(ldap_conf)
      allow(Settings).to receive(:ldap) { settings }
      @ldap = double
      allow(Net::LDAP).to receive(:new) { @ldap }
      allow(@ldap).to receive(:search) { nil }
    end

    it 'should return nil' do
      expect(LdapUser.find({
        user: 'name',
        pass: 'pass'
      })).to be_nil
    end
  end

  context '#find with invalid host in ldap settings' do
    before(:each) do
      ldap_conf = {
        domain: 'dom',
        host: 'host',
        port: 123,
        base: 'base'
      }
      settings = OpenStruct.new(ldap_conf)
      allow(Settings).to receive(:ldap) { settings }
      @ldap = double
    end

    it 'raises an exception' do
      -> (){ LdapUser.find({ user: 'name', pass: 'pass' }) }.
        should raise_error "NET::LDAP connection has failed."
    end
  end

  context '#find with valid creds' do
    before(:each) do
      @ldap = double
      allow(Net::LDAP).to receive(:new) { @ldap }
      allow(@ldap).to receive(:search) { [displayname: ['name']] }
    end

    it 'should return valid user name' do
      expect(LdapUser.find({
        user: 'name',
        pass: 'pass'
      })).to be_eql 'name'
    end
  end
end
