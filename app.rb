require 'rubygems'
require 'bundler'
require 'rqrcode'

Bundler.require

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

      image = RQRCode::QRCode.new(params[:label], level: :l).as_png(size: params[:size])
      image_path = "#{params[:label]}.png"
      image.save(image_path)

      Dragonfly.app.fetch_file(image_path).to_response(env)
    end
  end
end