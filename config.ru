require './app/bunny'

use Rack::Reloader, 0
use Rack::Static, urls: ["/public"]
run Bunny
