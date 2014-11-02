require 'logger'
require 'singleton'

class Log
  include Singleton

  attr_reader :logger

  def initialize()
    @logger = Logger.new STDERR
    @logger.level = Logger::WARN
    @logger.progname = 'apigen'
    @logger.formatter = proc do |serverity, time, progname, msg|
      "#{progname} (#{serverity.downcase}): #{msg}\n"
    end
  end

  def Log.init(level: Logger::DEBUG)
    Log.instance.logger.level = level
  end

  def Log.d(msg)
    Log.instance.logger.debug msg
  end

  def Log.i(msg)
    Log.instance.logger.info msg
  end

  def Log.w(msg)
    Log.instance.logger.warn msg
  end

  def Log.e(msg)
    Log.instance.logger.error msg
  end

end

class NullLoger < Logger
end
