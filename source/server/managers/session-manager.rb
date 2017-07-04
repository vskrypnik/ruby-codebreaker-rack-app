require 'singleton'

require './source/server/session'

class SessionManager
  include Singleton

  def initialize
    @sessions = Hash.new
  end

  private

  def generate
    session = Session.new hashcode
    @sessions[session.id] = session
  end

  def hashcode
    hashcode = Time.now.to_f.to_s.chars
    hashcode = hashcode.shuffle.join
    Digest::MD5.hexdigest hashcode
  end

  def valid?(hashcode)
    hashcode and exist? hashcode
  end

  def exist?(hashcode)
    @sessions.keys.include? hashcode
  end

  public

  def session(hashcode)
    if valid? hashcode
      return @sessions[hashcode]
    end

    generate
  end

end