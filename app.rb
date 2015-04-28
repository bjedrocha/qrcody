require 'rubygems'
require 'bundler'

Bundler.require # Load the needed gems from the gemfile.

$: << File.expand_path('../', __FILE__) # Required so that Sinatra knows where to find all the routes and such.

require 'models/qr_image'

module QRCody
  class App < Sinatra::Application
    helpers Sinatra::Param

    configure do
      disable :method_override
      disable :static
    end

    get '/qr' do
      param :label, String, required: true
      param :size, Integer, default: 125
      param :level, String, default: 'l'

      qrcode = QRImage.new(params[:label], size: params[:size], level: params[:level]).generate!
      qrcode.to_response(env)
    end
  end
end