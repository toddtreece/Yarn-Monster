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
NewSoftSerial mySerial =  NewSoftSerial(6, 5);

int dir = 10;
int stepper = 11;
int ms1 = 12;
int ms2 = 9;
int sleep = 13;
int pot = 2;
int potval = 0;
int resolution = 2;
int lastSensorReading = 0;
int inByte = -1;
char inString[2];
int stringPos = 0;

char buffer[4];
int received;

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
}

void loop() {
	if (mySerial.available()) {
		buffer[received++] = mySerial.read();
		buffer[received] = '\0';
		if (received >= (sizeof(buffer)-1)) {
			//Serial.print(buffer);
			int myInt = atoi(buffer);
			received = 0;
		}
	}
}

void set_speed(int val){
	val = val + 1;
	digitalWrite(sleep, HIGH);
	digitalWrite(dir, LOW);
	digitalWrite(stepper, LOW);
	digitalWrite(stepper, HIGH);
	delayMicroseconds(val);
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
