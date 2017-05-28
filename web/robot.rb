class GPIO
  def mode(pin, mode)
    `gpio mode #{pin} #{mode}`
  end

  def write(pin, value)
    `gpio write #{pin} #{value}`
  end

  def write_bulk(commands:)
    command_str = ''
    commands.each do |command|
      command_str << "gpio write #{command[:pin]} #{command[:value]} && "
    end
    command_str << 'echo finish'
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

  def initialize
    @gpio = GPIO.new
    @gpio.mode(STAND_BY, OUT)
    @gpio.mode(PWM_A, OUT)
    @gpio.mode(PWM_B, OUT)
    @gpio.mode(AIN1, OUT)
    @gpio.mode(AIN2, OUT)
    @gpio.mode(BIN1, OUT)
    @gpio.mode(BIN2, OUT)

    @gpio.write STAND_BY, 1
  end

  def forward
    right_forward
    left_forward
  end

  def backward
    left_backward
    right_backward
  end

  def left
    left_forward
    right_stop
  end

  def right
    right_forward
    left_stop
  end

  def stop
    left_stop
    right_stop
  end

  def destroy
    @gpio.destroy
  end

  def left_forward
    @gpio.write AIN1, 1
    @gpio.write AIN2, 0
    @gpio.write PWM_A, 1
  end

  def right_forward
    @gpio.write BIN1, 1
    @gpio.write BIN2, 0
    @gpio.write PWM_B, 1
  end

  def left_stop
    #   alias stopb='gpio write $BIN1 0 && gpio write $BIN2 0 && gpio write $PWMB 1'
    @gpio.write AIN1, 0
    @gpio.write AIN2, 0
    @gpio.write PWM_A, 1
  end

  def right_stop
    @gpio.write BIN1, 0
    @gpio.write BIN2, 0
    @gpio.write PWM_B, 1
  end

  def right_backward
    @gpio.write BIN1, 0
    @gpio.write BIN2, 1
    @gpio.write PWM_B, 1
  end

  def left_backward
    @gpio.write AIN1, 0
    @gpio.write AIN2, 1
    @gpio.write PWM_A, 1
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
