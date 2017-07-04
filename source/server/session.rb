require 'digest'
require 'codebreaker'

class Session

  def initialize(id)
    @data = Hash.new
    @data[:id] = id
  end

  private

  def method_missing(method, *args, &block)
    return super if respond_to? method

    if @data.respond_to? method
      @data.send method, *args, &block
    end
  end

  public

  def restore_session(destination)
    destination.merge! @data
  end

  def update_session(source)
    @data.merge! source
  end

  def id
    @data[:id]
  end

end