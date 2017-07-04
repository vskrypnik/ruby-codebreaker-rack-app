require 'codebreaker'

require './source/template-context'
require './source/server/cookie'
require './source/server/controller'

class Application < Controller

  action :home

  action :play do
    next redirect 'set-nickname' if nickname.nil?
    next redirect 'play-new' if self.game.finish?

    context = Context.new
    context[:hint] = hint

    if @params['output']
      output = @params['output']
      context[:output] = output
    end

    render 'play', context
  end

  action :play, :post do
    input = parse @params
    output = game.check input

    unless game.finish?
      next redirect "play?output=#{output}"
    end

    stage = output.to_s.downcase
    url = "result?stage=#{stage}"
    redirect url
  end

  action 'set-nickname', :get do
    next redirect 'play' if nickname
    render 'set-nickname'
  end

  action 'set-nickname', :post do
    nickname = @params['nickname']
    cookie = Cookie.new 'nickname', nickname
    redirect 'play-new', cookie
  end

  action 'play-new' do
    self.hint = nil
    self.game.start
    redirect 'play'
  end

  action 'play-again' do
    next redirect 'play' unless game.finish?
    render 'play-again'
  end

  action :hint, :post do
    self.hint = hint || game.hint
    redirect 'play'
  end

  action :result do
    next redirect 'play' unless game.finish?
    context = Context.new @params
    render 'result', context
  end

  action :save do
    next redirect 'play' unless game.finish?

    if %w(y yes).include? @params['response']&.downcase
      game.write nickname, @session[:id]
      next redirect 'play-again'
    end

    redirect 'play-again'
  end

  action :score do
    games = Codebreaker::Game.read
    context = Context.new
    context[:games] = games
    render 'score', context
  end

  private

  def parse(params)
    params.keys.sort.inject(String.new) do |string, key|
      string << params[key] if key.match /^digit[1-4]$/
      string
    end
  end

  def nickname
    @request.cookies['nickname']
  end

  protected

  def game
    @session[:game]
  end

  def hint
    @session[:hint]
  end

  def hint=(value)
    @session[:hint] = value
  end

end