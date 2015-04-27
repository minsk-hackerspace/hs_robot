require_relative 'gpio'

class Robot
  attr_accessor :last_activity, :gpio

  def initialize
    @gpio = GPIO.instance
    @gpio.config(led: {number: 26, direction: :out}, pwm_a: {number: 17, direction: :out}, pwm_b: {number: 18, direction: :out}, dir_a: {number: 23, direction: :out}, dir_b: {number: 24, direction: :out})
  end

  def light_switch
    if 0 == @gpio.pins[:led].read
      @gpio.pins[:led].on
    else
      @gpio.pins[:led].off
    end
  end

  def forward
    @gpio.pins[:dir_a].on
    @gpio.pins[:dir_b].on
    @gpio.pins[:pwm_a].on
    @gpio.pins[:pwm_b].on
  end

  def backward
    @gpio.pins[:dir_a].off
    @gpio.pins[:dir_b].off
    @gpio.pins[:pwm_a].on
    @gpio.pins[:pwm_b].on
  end

  def left
    @gpio.pins[:dir_b].on
    @gpio.pins[:pwm_a].off
    @gpio.pins[:pwm_b].on
    sleep 0.3
    stop
  end

  def right
    @gpio.pins[:dir_a].on
    @gpio.pins[:pwm_a].on
    @gpio.pins[:pwm_b].off
    sleep 0.3
    stop
  end

  def stop
    @gpio.pins[:dir_a].off
    @gpio.pins[:dir_b].off
    @gpio.pins[:pwm_a].off
    @gpio.pins[:pwm_b].off
  end

  def destroy
    @gpio.destroy
  end
end
