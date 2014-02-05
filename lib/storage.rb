require 'roo'

class Storage

  WORKING_HOURS = {
    com: 4, sup: 5, est: 6, int: 7, edu: 8, off: 9, sick: 10, vac: 11,
    unpaid: 12, holidays: 13, total: 14, pay: 15, over: 16, bonus: 17,
    fine: 18, vac_cur_year: 19, vac_prev_year: 20, vac_cur_month: 21
  }

  ILNESSES = {
    jan_w: 22, jan_c: 23, feb_w: 24, feb_c: 25, mar_w: 26, mar_c: 27,
    apr_w: 28, apr_c: 29, may_w: 30, may_c: 31, jun_w: 32, jun_c: 33,
    jul_w: 34, jul_c: 35, aug_w: 36, aug_c: 37, sep_w: 38, sep_c: 39,
    oct_w: 40, oct_c: 41, nov_w: 42, nov_c: 43, dec_w: 44, dec_c: 45
  }

  attr_reader :periods

  def initialize
      @doc = self.class.init_doc
      raise 'Strange salary.xls.' unless @doc.sheets.first == 'Employees'
      @periods = get_periods
      @data = get_data
    rescue => ex
      puts "Roo:Excel has failed with message: #{ex.message}"
      raise "File 'files/salary.xls' has wrong content or doesn't exist."
  end

  def get_periods
    sheets = @doc.sheets.dup - ['Employees']
    sheets.map! { |e| e.gsub('_', ' ') }
    sheets.reverse
  end

  def get_data
    return @data if @data
    {}
  end

  def users_by_period(period)
    return {} unless period
    @data = get_data
    return  @data[period] if @data.keys.include?(period)
    @data[period] = process_period_tab(period)
  end

  def user_info(params)
    name = params[:name]
    period = params[:period]
    return nil unless name || period

    @data = get_data
    return nil unless @data[period]
    @data[period][name]
  end

  def set_period(period)
    @doc.default_sheet = period.gsub(' ', '_')
  end

  def get_tab_row_count
    @doc.last_row
  end

  def get_cell_value(line,col)
    @doc.cell(line, col)
  end

  def process_period_tab(period)
    users = {}
    set_period(period)

    1.upto(get_tab_row_count) do |line|
      name = get_cell_value(line, 2)
      next unless name.is_a?(String)
      next if ['QA', 'C++', 'Flash/Actionscript', 'Graphic Design'].include?(name)
      if name
        users[name] = {}
        username = users[name]
        username[:name] = name
        username[:start_date] = get_cell_value(line, 3)

        WORKING_HOURS.each { |k, v| username[k] = get_cell_value(line, v).to_i || 0 }
        ILNESSES.each { |k, v| username[k] = get_cell_value(line, v).to_i }
      end
    end
    users
  end
  class << self
    def init_doc
      file_path = Settings.common.path
      raise 'File salary.xls doesn\'t exist' unless file_path
      Roo::Excel.new(file_path)
    end

    def get_russian_name(name)
      doc = init_doc
      doc.default_sheet = "Employees"
      6.upto(doc.last_row) do |line|
        e_name = doc.cell(line, 3)
        return doc.cell(line, 2) if e_name == name
      end
    end
  end
end
