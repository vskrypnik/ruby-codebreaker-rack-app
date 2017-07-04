class Action

  def initialize
    @routes = Hash.new
  end

  def add(methods, &block)
    methods.each do |method|
      @routes[method] = block
    end
  end

  def handler(method)
    if has_method? method
      @routes[method]
    end
  end

  def has_method?(method)
    @routes.keys.include? method.to_sym
  end

end