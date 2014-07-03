module Sinatra
  module App
    module Helpers
      def authorize!
        redirect to('/login') unless authenticated?
      end

      def authenticated?
        !!session[:current_user]
      end

      def translate_period(n)
        month, year = n.split(" ")
        month = t(month)
        "#{month} #{year}"
      end

      def highlight_vac(start_date,vac_cur_year)
        current_date = Time.now.strftime("%Y-%m-01").split('-')
        start_date = start_date.strftime("%m-%d").split('-')
        start_date.unshift Time.now.year
        end_of_work_year = start_date
        if Time.new(*current_date) > Time.new(*start_date)
           end_of_work_year.shift
           end_of_work_year.unshift(Time.now.year + 1)
        end
        time = Time.new(*end_of_work_year) - Time.new(*current_date)
        vac_cur_year.to_i > 64 && (time / (3600 * 24 * 30)) <= 3
      end
    end
  end
end
