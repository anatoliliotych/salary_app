module Sinatra
  module App
    module Helpers
      def authorize!
        redirect(to('/login')) unless authenticated?
      end

      def authenticated?
        !!session[:current_user]
      end
    end
  end
end
