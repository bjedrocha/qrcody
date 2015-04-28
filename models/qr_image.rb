require 'uuidtools'
require 'rqrcode'
require 'models/response'

module QRCody
  class QRImage

    # provides timestamped uuid generation
    include UUIDTools

    def initialize(data, *args)
      options = args.extract_options!

      @data = data
      @size = options[:size] || 125
      @level = (options[:level] || :l).to_sym
    end

    def generate!
      @image = RQRCode::QRCode.new(data, { level: level }).as_png(size: size, file: filepath)
      self
    end

    def to_response(env={"REQUEST_METHOD" => "GET"})
      Response.new(self, env).to_response
    end

    def signature
      @signature ||= UUID.timestamp_create
    end

    def file_size
      File.size(filepath)
    end

    # can be passed directly to body
    def each(&block)
      File.open(filepath, 'rb') do |io|
        while part = io.read(block_size)
          yield part
        end
      end
    end

    private

    attr_reader :data, :level, :size, :filepath

    def filepath
      @filepath ||= File.join("tmp/generated", "#{signature}.png")
    end

    def block_size
      8192
    end

  end
end