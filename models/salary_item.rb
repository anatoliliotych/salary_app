class SalaryItem
  include DataMapper::Resource
  belongs_to :user

  property :id,    Serial
  property :period, String
  # working hours
  property :com, String, :default  => 0
  property :sup, String, :default  => 0
  property :est, String, :default  => 0
  property :int, String, :default  => 0
  property :edu, String, :default  => 0
  property :off, String, :default  => 0
  property :sick, String, :default  => 0
  property :vac, String, :default  => 0
  property :unpaid, String, :default  => 0
  property :holidays, String, :default  => 0
  property :total, String, :default  => 0
  property :pay, String, :default  => 0
  property :over, String, :default  => 0
  property :bonus, String, :default  => 0
  property :fine, String, :default  => 0
  property :vac_cur_year, String, :default  => 0
  property :vac_prev_year, String, :default  => 0
  property :vac_cur_month, String, :default  => 0

  # ilnesses
  property :jan_w, String, :default  => 0
  property :jan_c, String, :default  => 0
  property :feb_w, String, :default  => 0
  property :feb_c, String, :default  => 0
  property :mar_w, String, :default  => 0
  property :mar_c, String, :default  => 0
  property :apr_w, String, :default  => 0
  property :apr_c, String, :default  => 0
  property :may_w, String, :default  => 0
  property :may_c, String, :default  => 0
  property :jun_w, String, :default  => 0
  property :jun_c, String, :default  => 0
  property :jul_w, String, :default  => 0
  property :jul_c, String, :default  => 0
  property :aug_w, String, :default  => 0
  property :aug_c, String, :default  => 0
  property :sep_w, String, :default  => 0
  property :sep_c, String, :default  => 0
  property :oct_w, String, :default  => 0
  property :oct_c, String, :default  => 0
  property :nov_w, String, :default  => 0
  property :nov_c, String, :default  => 0
  property :dec_w, String, :default  => 0
  property :dec_c, String, :default  => 0
end
