class GPIO
  def mode(pin, mode)
    `gpio mode #{pin} #{mode}`
  end

  def write(pin, value)
    `gpio write #{pin} #{value}`
  end

  def write_bulk(commands:)
    command_str = ''
    commands.each_pair do |pin, value|
      command_str << "gpio write #{pin} #{value} && "
    end
    command_str << 'echo finish'
    p command_str
    `#{command_str}`
  end
end


class Robot
  STAND_BY = 1
  PWM_A = 0
  PWM_B = 6
  AIN1 = 3
  AIN2 = 2
  BIN1 = 4
  BIN2 = 5
  OUT = 'out'.freeze
  IN = 'in'.freeze
  PWM = 'pwm'.freeze

  def self.init
    p 'gpio init'
    @gpio ||= GPIO.new
    @gpio.mode(STAND_BY, OUT)
    @gpio.mode(PWM_A, OUT)
    @gpio.mode(PWM_B, OUT)
    @gpio.mode(AIN1, OUT)
    @gpio.mode(AIN2, OUT)
    @gpio.mode(BIN1, OUT)
    @gpio.mode(BIN2, OUT)

    @gpio.write STAND_BY, 1
  end

  def initialize
    @gpio ||= GPIO.new
  end

  def forward
    @gpio.write_bulk(commands: right_forward.merge(left_forward))
  end

  def backward
    @gpio.write_bulk(commands: left_backward.merge(right_backward))
  end

  def left
    @gpio.write_bulk(commands: left_forward.merge(right_stop))
  end

  def right
    @gpio.write_bulk(commands: right_forward.merge(left_stop))
  end

  def stop
    @gpio.write_bulk(commands: left_stop.merge(right_stop))
  end

  def left_forward
    {
        AIN1 => 1,
        AIN2 => 0,
        PWM_A => 1
    }
  end

  def right_forward
    {
        BIN1 => 1,
        BIN2 => 0,
        PWM_B => 1
    }
  end

  def left_stop
    {
        AIN1 => 0,
        AIN2 => 0,
        PWM_A => 1
    }
  end

  def right_stop
    {
        BIN1 => 0,
        BIN2 => 0,
        PWM_B => 1
    }
  end

  def right_backward
    {
        BIN1 => 0,
        BIN2 => 1,
        PWM_B => 1
    }
  end

  def left_backward
    {
        AIN1 => 0,
        AIN2 => 1,
        PWM_A => 1
    }
  end

  def stand_by
    @gpio.write STAND_BY, 0
  end

  def turn_on
    @gpio.write STAND_BY, 1
  end

  def profiler(n)
    t = Time.now
    n.times do |i|
      @gpio.write i% 10, rand(2)
    end
    p t - Time.now
  end

  def profiler_d(n)
    t = Time.now
    n.times do |i|
      @gpio.write_d i% 10, rand(2)
    end
    p t - Time.now
  end
end
