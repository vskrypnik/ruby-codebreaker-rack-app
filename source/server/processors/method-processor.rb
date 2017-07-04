module MethodProcessor

  @methods = [:get, :post, :put, :patch, :delete, :update]

  def self.process(methods)
    methods.map! do |method|
      if correct? method
        method.to_sym
      end
    end

    methods.compact!
    methods.empty? ? [:get] : methods
  end

  def self.correct?(method)
    @methods.include? method.to_sym if method
  end

end