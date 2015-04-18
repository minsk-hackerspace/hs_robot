require 'concurrent/async'

class Pin
  include Concurrent::Async
  attr_accessor :name, :number, :direction

  def initialize(name, number)
    init_mutex
    @name = name
    @number = number
  end

  # set input or output
  # gpio_num is the GPIO pin number, dir is the direction - either :out or :in
  def as(dir=:out)
    @direction = dir.to_s
    GPIO.write "gpio#{@number}/direction", @direction
  end

  # send a high value to the pin
  def on
    GPIO.write "gpio#{@number}/value", "1"
  end

  # send a low value to the pin
  def off
    GPIO.write "gpio#{@number}/value", "0"
  end

  # send a PWM (pulse width modulation) signal to the pin
  def pwm(value)
    GPIO.write "gpio#{@number}/value", value
  end

  # read from the pin
  def read
    GPIO.read @number
  end

  # watch the pin for change and trigger the block once
  def watch_once_for(value, &block)
    watching = true
    while watching
      if read == value
        GPIO.instance_eval &block
        watching = false
      end
    end
  end

  # watch the pin for change and trigger the block over and over again
  def watch_for(value, &block)
    while true
      if read == value
        GPIO.instance_eval &block
      end
    end
  end
end

