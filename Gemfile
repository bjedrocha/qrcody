source 'https://rubygems.org'

gem "activesupport", :require => "active_support/core_ext/array/extract_options"
gem "sinatra", require: "sinatra/base"
gem "sinatra-param"

# QR Code Generation
gem "rqrcode-with-patches", git: "https://github.com/bjedrocha/rqrcode.git", branch: "simplified-png-export"
gem "uuidtools"

# Server
gem "thin"
gem "rack-cache", require: "rack/cache"

# Development
group :development do
  gem "byebug"
  gem "shotgun"
end