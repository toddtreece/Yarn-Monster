//                                                     _             
//                                                    | |            
//  _   _  __ _ _ __ _ __    _ __ ___   ___  _ __  ___| |_  ___ _ __ 
// | | | |/ _` | '__| '_ \  | '_ ` _ \ / _ \| '_ \/ __| __|/ _ \ '__|
// | |_| | (_| | |  | | | | | | | | | | (_) | | | \__ \ |_|  __/ |   
//  \__, |\__,_|_|  |_| |_| |_| |_| |_|\___/|_| |_|___/\__|\___|_|   
//   __/ |                                                           
//  |___/                                                            
// 
// yarn monster
// motor_driver.pde
// Copyright 2010 Todd Treece
// http://unionbridge.org/design/yarn-monster
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
// 

#include <NewSoftSerial.h>
#include <Messenger.h>
#include <pt.h>

NewSoftSerial xbee =  NewSoftSerial(6, 5);
Messenger message = Messenger();

// pin definitions
int dir = 10;
int stepper = 11;
int ms1 = 12;
int ms2 = 9;
int sleep = 13;

// variable definitions
int resolution = 2;
int current_val = 0;
int motor_speed = 0;
int motor_dir = HIGH;
static long nextMillis = 0;
static struct pt thread;

void setup(){
  xbee.begin(9600);
  pinMode(dir, OUTPUT);
  pinMode(stepper, OUTPUT);
  pinMode(ms1, OUTPUT);
  pinMode(ms2, OUTPUT);
  pinMode(sleep, OUTPUT);
  digitalWrite(sleep, HIGH);
  digitalWrite(ms1, ms1_state(resolution));
  digitalWrite(ms2, ms2_state(resolution));
  message.attach(message_ready);
  PT_INIT(&thread);
}

void loop() {
  set_speed(&thread);
  while (xbee.available()){
    message.process(xbee.read());
  }
} 

void message_ready() {
  while (message.available()) {
    current_val = message.readInt();
    if(current_val < 1025){
		motor_speed = current_val;
    } else if(current_val == 2000){
		motor_dir = LOW;
    } else if(current_val == 2001){
		motor_dir = HIGH;
    }
  }
}

static int set_speed(struct pt *pt){	
  PT_BEGIN(pt);
  while (1) {
    nextMillis = millis() + (1600- motor_speed);
    PT_WAIT_UNTIL(pt, nextMillis < millis());
	if(motor_speed < 10) {
	  digitalWrite(sleep, LOW);
	} else {
	  digitalWrite(sleep, HIGH);
	  digitalWrite(dir, motor_dir);
	  digitalWrite(stepper, LOW);
	  digitalWrite(stepper, HIGH);
	}
  }
  PT_END(pt);
}

int ms1_state(int state){
  switch(state){
    case 1:
      state = 0;
      break;
    case 2:
      state = 1;
      break;
     case 3:
       state = 0;
       break;
     case 4:
       state = 1;
       break;
  }
  return state;
}


int ms2_state(int state){              
  switch(state){                                       
    case 1:
      state = 0;
      break;
    case 2:
      state = 0;
      break;
    case 3:
      state = 1;
      break;
    case 4:
      state = 1;
    break;
  }
  return state;
}
