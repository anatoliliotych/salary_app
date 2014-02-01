require 'spec_helper.rb'

include Utils

describe Utils do
  describe "#download_salary_file" do
    context "with invalid creds" do
      it 'should fail with proper message' do
        params = {
          user: 'user',
          pass: 'pass'
        }
        ->() {::Utils.download_salary_file(params)}.should raise_error "File salary.xls can't be downloaded."
      end
    end

    context 'with invalid url' do
      it 'should fail with proper message' do
        params = {
          user: 'user',
          pass: 'pass'
        }
        setting = double
        allow(Settings).to receive(:common) { setting }
        allow(setting).to receive(:url) { 'http://example.org' }
        allow(setting).to receive(:path) { 'files/salary.xls' }
        ->() { ::Utils.download_salary_file(params) }.should raise_error "File salary.xls can't be downloaded."
      end
    end

    context 'with valid creds' do
      before(:each) do
        @params = {
          user: Config.correct_ldap_user.username,
          pass: Config.correct_ldap_user.password
        }
      end

      it 'should pass' do
        ->() {::Utils.download_salary_file(@params)}.should_not raise_error
      end

      it 'should skip download if file size is the same' do
        allow(File).to receive(:exists?) { true }
        allow(File).to receive(:size) { '1' }
        resp = double
        allow(HTTPI).to receive(:head) { resp }
        allow(resp).to receive(:headers) { {
          'Content-Length' => '1',
          'Content-Type'   => "application/vnd.ms-excel"
        }}
        allow(resp).to receive(:code) { 200 }
        expect(HTTPI).to_not receive(:get)
        ::Utils.download_salary_file(@params)
      end
    end
  end
end
