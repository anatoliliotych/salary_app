module Sinatra
  module App
    module Routing
      module Home

        def self.registered(app)

          show_home = lambda do
            authorize!
            @@storage      ||= Storage.new
            @periods       = @@storage.periods
            session[:period] ||= @periods.first
            session[:name] ||= session[:current_user]
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

          send_complain = lambda do
            smtp_options = Settings.smtp.marshal_dump

            smtp_options.merge!(
              :password => params[:pass],
              :user_name => session[:user])

            Pony.options = { :to => Settings.common.to, :via => :smtp, :via_options => smtp_options }
            user_mail = "#{session[:user]}@#{Settings.smtp.domain}"
            begin
              Pony.mail(
                :from => user_mail,
                :cc => user_mail,
                :body => params[:body],
                :subject => Settings.common.subj)
            rescue => ex
              puts ex.message
              halt 503
            end
          end

          app.get  '/', &show_home
          app.post '/user', &select_user
          app.post '/period', &select_period
          app.post '/complain', &send_complain
        end
      end
    end
  end
end
