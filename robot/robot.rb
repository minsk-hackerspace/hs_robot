require_relative 'gpio'

class Robot
  attr_accessor :last_activity, :gpio

  def initialize
    @gpio = GPIO.instance
    @gpio.config(pwm_a: {number: 23, direction: :out}, pwm_b: {number: 23, direction: :out}, dir_a: {number: 23, direction: :out}, dir_b: {number: 23, direction: :out})
    at_exit do
      @gpio.destroy
    end
  end

  def forward
    @gpio.pins[:dir_a].on
    @gpio.pins[:dir_b].on
    @gpio.pins[:pwm_a].pwm(100)
    @gpio.pins[:pwm_b].pwm(100)
  end

  def backward
    @gpio.pins[:dir_a].off
    @gpio.pins[:dir_b].off
    @gpio.pins[:pwm_a].pwm(70)
    @gpio.pins[:pwm_b].pwm(70)
  end

  def left
    @gpio.pins[:dir_b].on
    @gpio.pins[:pwm_a].pwm(0)
    @gpio.pins[:pwm_b].pwm(50)
  end

  def right
    @gpio.pins[:dir_a].on
    @gpio.pins[:pwm_a].pwm(50)
    @gpio.pins[:pwm_b].pwm(0)
  end

  def stop
    @gpio.pins[:dir_a].off
    @gpio.pins[:dir_b].off
    @gpio.pins[:pwm_a].pwm(0)
    @gpio.pins[:pwm_b].pwm(0)
  end
end