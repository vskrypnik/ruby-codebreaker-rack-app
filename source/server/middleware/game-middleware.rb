require 'rack'
require 'codebreaker'

class GameMiddleware

  def initialize(application)
    @application = application
  end

  def call(args)
    @request = Rack::Request.new args
    @session = @request.session

    unless initialized?
      game = Codebreaker::Game.new
      game.start

      @session[:game] = game
      @session[:hint] = nil
    end

    @application.call args
  end

  private

  def initialized?
    [:game, :hint].inject do |result, key|
      result and exist? key
    end
  end

  def exist?(key)
    @session.keys.include? key.to_sym
  end

end