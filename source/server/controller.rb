require './source/template-render'
require './source/template-context'
require './source/server/action'
require './source/server/cookie'
require './source/server/processors/path-processor'
require './source/server/processors/method-processor'
require './source/server/utilities/redirect'

class Controller

  @@actions = Hash.new

  def self.action(path, *methods, &block)
    path = PathProcessor::process path.to_s
    methods = MethodProcessor::process methods
    action = @@actions[path]

    unless block
      block = Proc.new { render path.to_s }
    end

    if action
      update action, methods, &block
    else
      create path, methods, &block
    end
  end

  def self.create(path, methods, &block)
    action = Action.new
    action.add methods, &block
    @@actions[path] = action
  end

  def self.update(action, methods, &block)
    action.add methods, &block
  end

  def self.call(args)
    new(args).send :process
  end

  private

  def initialize(args)
    @layout = self.class.to_s.downcase
    @request = Rack::Request.new args
    @session = @request.session
    @params = @request.params
    @method = request_method
    @path = request_path
  end

  def process
    action = @@actions[@path]
    return not_found unless action

    handler = action.handler @method
    return not_found unless handler

    instance_eval &handler
  end

  def request_path
    @request.path[1..-1].to_sym
  end

  def request_method
    @request.request_method.downcase.to_sym
  end

  def not_found
    Rack::Response.new do |response|
      response.status = 404
    end
  end

  def redirect(path, *cookies)
    Redirect::create path, *cookies
  end

  def render(view, context=nil)
    Rack::Response.new(Render::render @layout, view, context)
  end

  private_class_method :create
  private_class_method :update

end