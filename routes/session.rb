module Sinatra
  module App
    module Routing
      module Session
        def self.registered(app)
          show_login = lambda do
            haml :login
          end

          receive_login = lambda do
            begin
              auth_settings = {
                user: params[:username],
                pass: params[:password]
              }

              user = LdapUser.find(auth_settings)
              if user
                download_salary_file(auth_settings)
                session[:current_user] = user
                session[:period]     = nil
              end
              redirect to('/')
            rescue
              flash[:error] = 'Что-то пошло не так! Попробуйте снова!'
              redirect back
            end
          end

          logout = lambda do
            session[:current_user] = nil
            redirect to('/')
          end

          app.get  '/logout', &logout
          app.get  '/login', &show_login
          app.post '/login', &receive_login
        end
      end
    end
  end
end

