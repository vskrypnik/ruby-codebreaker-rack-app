class Context

  attr_reader :content

  def initialize(argument='')
    if argument.is_a? String
      @data = Hash.new
      @content = argument
    elsif argument.is_a? Hash
      @data = argument
    else
      message = 'Incompatible type!'
      raise ArgumentError.new message
    end
  end

  public

  def []=(key, value)
    @data[key] = value
  end

  def data(name)
    @data[name]
  end

  def binding
    super
  end

end