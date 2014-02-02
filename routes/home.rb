module Sinatra
  module App
    module Routing
      module Home

        def self.registered(app)

          show_home = lambda do
            authorize!
            @@storage      ||= Storage.new
            @periods       = @@storage.periods
            @users         = @@storage.users_by_period(session[:period])
            @selected_user = @@storage.user_info(name:   session[:name],
                                                 period: session[:period])
            haml :index
          end

          select_user = lambda do
            session[:name] = URI.decode(params[:name])
            redirect to('/')
          end

          select_period = lambda do
            session[:period] = params[:period]
            redirect to('/')
          end

          app.get  '/', &show_home
          app.post '/user', &select_user
          app.post '/period', &select_period
        end
      end
    end
  end
end
