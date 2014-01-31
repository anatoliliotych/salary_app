module Sinatra
  module App
    module Routing
      module Logout
        def self.registered(app)
          logout = lambda do
            session[:current_user] = nil
            redirect to('/')
          end

          app.get  '/logout', &logout
        end
      end
    end
  end
end


