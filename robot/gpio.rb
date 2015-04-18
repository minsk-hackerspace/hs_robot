require 'singleton'

class Hash
  def method_missing(name, *args, &block)
    return self[name.to_sym]
  end
end

class GPIO
  include Singleton
  attr_accessor :pins
  # main entry for the DSL
  def config(hash)
    @pins = {} # a hash of available pins
    # set up pins
    hash.each do |k, v|
      @pins[k] = Pin.new(k.to_s, v[:number])
      export v[:number]
      @pins[k].as v[:direction]
    end
  end

  def destroy
    @pins.each do |k, v|
      unexport v[:number]
    end
  end

  # method missing used to return the pin named earlier in the hash parameter to access
  def method_missing(name, *args, &block)
    if @pins.keys.include?(name)
      return @pins[name]
    end
  end

  class << self
    def export(gpio_num)
      write "export", gpio_num
    end

    def unexport(gpio_num)
      write "unexport", gpio_num
    end

    def read(gpio_num)
      File.read("/sys/class/gpio/gpio#{gpio_num}/value").to_i
    end

    def write(command, value)
      log [command, value]
      File.open("/sys/class/gpio/#{command}", "w") do |f|
        f.write value
      end
    end

    def log(msg)
      puts msg
      File.open("log.log", "w+") do |f|
        f.write msg
      end
    end

  end
end