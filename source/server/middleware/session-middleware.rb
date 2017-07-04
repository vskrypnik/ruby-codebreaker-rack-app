require 'rack'

require './source/server/cookie'
require './source/server/utilities/redirect'
require './source/server/managers/session-manager'

class SessionMiddleware

  def initialize(application)
    @application = application
    @manager = SessionManager.instance
  end

  def call(args)
    @request = Rack::Request.new args
    @session = @manager.session session

    if @session.id != session
      cookie = Cookie.new 'session', @session.id
      return Redirect::create @request.path, cookie
    end

    begin
      @session.restore_session @request.session
      @application.call @request.env
    ensure
      @session.update_session @request.session
    end
  end

  private

  def session
    @request.cookies['session']
  end

end