## QRCody - QRCode Microservice

QRCody is a very small [Sinatra](http://www.sinatrarb.com/) application that provides on-the-fly [QR Code](http://www.qrcode.com/en/) generation with built-in caching. I needed an alternative to Google's depracated and soon to be gone [Infographics API](https://developers.google.com/chart/infographics/docs/qr_codes) so I decided to write my own.

### Running the app

The application can be run directly from within the app directory using `thin` (included in Gemfile)

```
thin start
```

Once running, you can generate QR codes by visiting `http://localhost:3000/qr` and supplying a `label` parameter. For example [http://localhost:3000/qr?label=https://github.com/bjedrocha](http://localhost:3000/qr?label=https://github.com/bjedrocha)

Rack::Cache is used to cache generated versions of QR codes. These cached files and metadata are stored in the tmp/ directory and will get regenerated as necessary.

### License

Copyright (c) 2015 Bart Jedrocha, released under the MIT License.