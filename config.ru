require './app/bunny'

use Rack::Reloader, 0
use Rack::Static, urls: ["/public"]
#use Rack::Auth::Basic do |username, password|
#  username == "log" and password == "pass"
#end
run Bunny
