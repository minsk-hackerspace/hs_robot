int pwm_a = 3;  //PWM control for motor outputs 1 and 2 is on digital pin 3
int pwm_b = 11;  //PWM control for motor outputs 3 and 4 is on digital pin 11
int dir_a = 12;  //direction control for motor outputs 1 and 2 is on digital pin 12
int dir_b = 13;  //direction control for motor outputs 3 and 4 is on digital pin 13

void setup()
{
  pinMode(pwm_a, OUTPUT);  //Set control pins to be outputs
  pinMode(pwm_b, OUTPUT);
  pinMode(dir_a, OUTPUT);
  pinMode(dir_b, OUTPUT);
 
  Serial.begin(9600);
}
void stop_engine(char engine){
  if (engine == 'l' || 'a') {
    analogWrite(pwm_a, 0);
  }
  if (engine == 'r' || 'b') {
    analogWrite(pwm_b, 0);
  }
};

void stop(){
  stop_engine('a');
  stop_engine('b');  
};

void run(char engine, int speed = 100){
  if (engine == 'l' || 'a') {
    analogWrite(pwm_a, speed);
  }
  if (engine == 'r' || 'b') {
    analogWrite(pwm_b, speed);
  }
};

void forward(int speed=100){
  digitalWrite(dir_a, LOW); 
  digitalWrite(dir_b, LOW);

  run('a', speed);
  run('b', speed);
};

void backward(int speed=100){
  digitalWrite(dir_a, HIGH); 
  digitalWrite(dir_b, HIGH);

  run('a', speed);
  run('b', speed);
};



void loop()
{
  if (Serial.available() > 0 )  {

    char command = Serial.read();

    if (command == 'w') {
      forward(100);
    }

    if (command == 's') {
      backward(70);
    }
    
    if (command == ' ') {
      stop();
    }


    // Debug
    Serial.println(command);
  }
}


