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

NewSoftSerial mySerial =  NewSoftSerial(11, 10);
int pot = 2;
int potval = 0;

void setup()  {
	mySerial.begin(9600);
}

void loop() {
	potval = analogRead(pot);
	mySerial.println(potval);
}
