require 'uri'
require 'rack'

module QRCody
  class Response

    def initialize(image, env)
      @image, @env = image, env
    end

    def to_response
      response = begin
        if !(request.head? || request.get?)
          [405, method_not_allowed_headers, ["method not allowed"]]
        elsif etag_matches?
          [304, cache_headers, []]
        else
          [200, success_headers, (request.head? ? [] : image)]
        end
      rescue RuntimeError => e
        [500, {"Content-Type" => "text/plain"}, ["Internal Server Error"]]
      end
      response
    end

    private

    attr_reader :image, :env

    def request
      @request ||= Rack::Request.new(env)
    end

    def etag_matches?
      return @etag_matches unless @etag_matches.nil?
      if_none_match = env['HTTP_IF_NONE_MATCH']
      @etag_matches = if if_none_match
        if_none_match.tr!('"','')
        if_none_match.split(',').include?(image.signature) || if_none_match == '*'
      else
        false
      end
    end

    def method_not_allowed_headers
      {
        'Content-Type' => 'text/plain',
        'Allow' => 'GET, HEAD'
      }
    end

    def success_headers
      headers = standard_headers.merge(cache_headers)
      headers.delete_if{|k, v| v.nil? }
    end

    def standard_headers
      {
        "Content-Type" => mime_type,
        "Content-Length" => image.file_size.to_s,
        "Content-Disposition" => filename_string
      }
    end

    def cache_headers
      {
        "Cache-Control" => "public, max-age=31536000", # (1 year)
        "ETag" => %("#{image.signature}")
      }
    end

    def filename_string
      %(filename="qrcode.png")
    end

    def mime_type
      "image/png"
    end

  end
end