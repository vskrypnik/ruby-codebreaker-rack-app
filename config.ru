require 'bundler'
Bundler.require

require './source/application'
require './source/server/middleware/game-middleware'
require './source/server/middleware/session-middleware'

use Rack::Reloader

use Rack::Static,
    :urls => %w(/stylesheets /javascript),
    :root => 'resources/static'

use SessionMiddleware
use GameMiddleware

run Application