require_relative '../helpers'

module Sinatra
  module App
    module Routing
      module Home
        def self.registered(app)
          show_home = lambda do
            authorize!
            haml :index
          end

          app.get  '/', &show_home
        end
      end
    end
  end
end
