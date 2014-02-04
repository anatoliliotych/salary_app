require 'spec_helper'

describe Storage do
  context 'no salary.xls file' do
    it 'should fail' do
      setting = double
      allow(Settings).to receive(:common) { setting }
      allow(setting).to receive(:path) { nil }
      ->() { Storage.new }.
        should raise_error "File 'files/salary.xls' has wrong content or doesn't exist."
    end
  end

  context 'invalid salary.xls file' do
    it 'should fail with proper message on any Roo::Excel.new failure' do
      allow(Roo::Excel).to receive(:new) { raise 'Something went wrong.' }
      ->() { Storage.new }.
        should raise_error "File 'files/salary.xls' has wrong content or doesn't exist."
    end

    it 'should fail if content seems to be wrong' do
      doc = double
      allow(Roo::Excel).to receive(:new) { doc }
      allow(doc).to receive(:sheets) { ['foo'] }
      ->() { Storage.new }.
        should raise_error "File 'files/salary.xls' has wrong content or doesn't exist."
    end
  end

  context '#get_periods' do
    before(:each) do
      sheets = %w{ Employees November_13 December_13 }
      doc = double
      allow(Roo::Excel).to receive(:new) { doc }
      allow(doc).to receive(:sheets) { sheets }
      @storage = Storage.new
    end

    it 'should return proper list of periods' do
      expect(@storage.get_periods).to be_eql ['November 13', 'December 13'].reverse
    end
  end

  context '#users_by_period' do
    before(:each) do
      @doc = double
      allow(Roo::Excel).to receive(:new) { @doc }
    end

    it 'should return {} when called without period' do
      allow(@doc).to receive(:sheets) { ['Employees'] }
      @storage = Storage.new
      expect(@storage.users_by_period(nil).is_a?(Hash)).to be_true
      expect(@storage.users_by_period(nil).empty?).to be_true
    end

    it 'should return proper existing data' do
      allow(@doc).to receive(:sheets) { ['Employees', 'November 13'] }
      @storage = Storage.new
      data_row = 'row'
      @storage.stub(:get_data).and_return('November 13' => data_row )
      expect(@storage.users_by_period('November 13')).to be_eql data_row
    end

    it 'should return proper data after processing' do
      allow(@doc).to receive(:sheets) { ['Employees', 'November 13'] }
      @storage = Storage.new
      data_row = 'row'
      period = 'November 13'
      @storage.stub(:process_period_tab).and_return(data_row)
      expect(@storage.get_data.keys.include?(period)).to be_false
      expect(@storage.users_by_period(period)).to be_eql data_row
      expect(@storage.get_data.keys.include?(period)).to be_true
    end
  end

  context '#user_info' do
    before(:each) do
      doc = double
      allow(Roo::Excel).to receive(:new) { doc }
      allow(doc).to receive(:sheets) { ['Employees', 'November 13'] }
      @storage = Storage.new
    end

    it 'should return nil without name and period' do
      params = {
        name:   nil,
        period: nil
      }
      expect(@storage.user_info(params)).to be_nil
    end

    it 'should return proper data' do
      data_row = {'anatoli' => 'data'}
      @storage.stub(:get_data).and_return('November 13' => data_row )
      params = {
        name: 'anatoli',
        period: 'November 13'
      }
      expect(@storage.user_info(params)).to be_eql data_row['anatoli']
    end
  end

  context '#process_period_tab' do
    before(:each) do
      @row1 = ['', 'anatoli', '1/1/1900']+['1']*42
      @row2 = ['', 'QA'] + ['']*43
      @row3 = ['', 'C++'] + ['']*43
      @doc = double
      allow(Roo::Excel).to receive(:new) { @doc }
      allow(@doc).to receive(:sheets) { ['Employees', 'November 13'] }
      @storage = Storage.new
      @storage.stub(:set_period).and_return { nil }
      @row1.each_index do |i|
        @doc.stub(:cell).with(1,i+1).and_return(@row1[i])
        @doc.stub(:cell).with(2,i+1).and_return(@row2[i])
        @doc.stub(:cell).with(3,i+1).and_return(@row3[i])
      end
      allow(@doc).to receive(:last_row) { 3 }
    end
    it 'should return proper data' do
      res = { "anatoli" => {
        :name=>"anatoli",
        :start_date=>"1/1/1900",
        :com=>"1", :sup=>"1", :est=>"1", :int=>"1", :edu=>"1",
        :off=>"1", :sick=>"1", :vac=>"1", :unpaid=>"1",
        :holidays=>"1", :total=>"1", :pay=>"1", :over=>"1",
        :bonus=>"1", :fine=>"1", :vac_cur_year=>"1",
        :vac_prev_year=>"1", :vac_cur_month=>"1", :jan_w=>"1",
        :jan_c=>"1", :feb_w=>"1", :feb_c=>"1", :mar_w=>"1",
        :mar_c=>"1", :apr_w=>"1", :apr_c=>"1", :may_w=>"1",
        :may_c=>"1", :jun_w=>"1", :jun_c=>"1", :jul_w=>"1",
        :jul_c=>"1", :aug_w=>"1", :aug_c=>"1", :sep_w=>"1",
        :sep_c=>"1", :oct_w=>"1", :oct_c=>"1", :nov_w=>"1",
        :nov_c=>"1", :dec_w=>"1", :dec_c=>"1"
      }}
      expect(@storage.process_period_tab('November 13')).to be_eql res
    end
  end
end
