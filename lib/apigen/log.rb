require 'logger'

class Log

  attr_reader :logger

  def initialize(level: Logger::DEBUG)
    @logger = Logger.new STDERR
  end

  def Log.d(msg)
    Log.get.logger.debug msg
  end

  def Log.i(msg)
    Log.get.logger.info msg
  end

  def Log.w(msg)
    Log.get.logger.warn msg
  end

  def Log.e(msg)
    Log.get.logger.error msg
  end

  def Log.get
    @@instance
  end

  def Log.init(level:Logger::DEBUG)
    @@instance = Log.new level: level
  end

end
