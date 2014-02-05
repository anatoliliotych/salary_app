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
    end
  end
end
