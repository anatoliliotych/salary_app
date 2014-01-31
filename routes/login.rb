module Sinatra
  module App
    module Routing
      module Login
        def self.registered(app)
          show_login = lambda do
            haml :login
          end

          receive_login = lambda do
            auth_settings = {
              user: params[:username],
              pass: params[:password]
            }

            user = LdapUser.find(auth_settings)
            if user
              session[:current_user] = user
            end
            redirect '/'
          end

          app.get  '/login', &show_login
          app.post '/login', &receive_login
        end
      end
    end
  end
end

