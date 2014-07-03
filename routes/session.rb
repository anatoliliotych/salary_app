# encoding: utf-8

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
              raise "Ldap user not found." unless user
              if user
                download_salary_file(auth_settings)
                session[:user] = auth_settings[:user]
                session[:current_user] = Storage.get_russian_name(user)
                session[:period]     = nil
              end
              redirect to('/')
            rescue => ex
              puts ex.message
              puts ex.backtrace
              session[:user_login] = auth_settings[:user]
              flash[:error] = "Что-то пошло не так! Попробуйте снова!"
              redirect back
            end
          end

          logout = lambda do
            session[:current_user] = nil
            session[:user] = nil
            session[:name] = nil
            session[:period] = nil
            session.clear
            @@storage = nil
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

