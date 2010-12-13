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
// remote.pde
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

NewSoftSerial xbee =  NewSoftSerial(11, 10);

// pin definitions
int pot = 2;
int dirswitch = 4;

// variable definitions
int pot_current = 0;
int pot_previous;
int switch_current;
int switch_previous;

void setup()  {
  xbee.begin(9600);
  pinMode(dirswitch, INPUT);
}

void loop() {
  pot_current = analogRead(pot);
  if(pot_current != pot_previous){
    pot_previous = pot_current;
    xbee.println(pot_current);
    delay(250);    
  }
  switch_current = digitalRead(dirswitch);
  if(switch_current == HIGH && switch_previous != HIGH) {
    switch_previous = HIGH;
    xbee.println(2001);
    delay(250);
  } else if (switch_current == LOW && switch_previous != LOW) {
    switch_previous = LOW;
    xbee.println(2000);
    delay(500);
  }
}
