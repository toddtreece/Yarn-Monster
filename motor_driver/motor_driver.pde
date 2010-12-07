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
NewSoftSerial mySerial =  NewSoftSerial(6, 5);

int dir = 10;
int stepper = 11;
int ms1 = 12;
int ms2 = 9;
int sleep = 13;
int pot = 2;
int potval = 0;
int resolution = 2;

int id = 0;
int last = 0;
Messenger message = Messenger();

void messageReady() {
  while ( message.available() ) {
    id = message.readInt();
  }
}

void setup(){
	mySerial.begin(9600);
	Serial.begin(9600);
	pinMode(dir, OUTPUT);
	pinMode(stepper, OUTPUT);
	pinMode(ms1, OUTPUT);
	pinMode(ms2, OUTPUT);
	pinMode(sleep, OUTPUT);
	digitalWrite(sleep, HIGH);
	digitalWrite(ms1, ms1_state(resolution));
	digitalWrite(ms2, ms2_state(resolution));
        message.attach(messageReady);
}

void loop() {
   while (mySerial.available()){
     message.process(mySerial.read());
   }
   set_speed(id);
} 

void set_speed(int val){
        if(val < 10) {
          digitalWrite(sleep, LOW);
        } else {
          val = 1600 - val;
  	digitalWrite(sleep, HIGH);
  	digitalWrite(dir, LOW);
  	digitalWrite(stepper, LOW);
  	digitalWrite(stepper, HIGH);
  	delayMicroseconds(val);
        }
	
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

