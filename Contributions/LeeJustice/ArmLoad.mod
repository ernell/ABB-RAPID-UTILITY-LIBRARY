MODULE ArmLoad
  !*****************************************************
  ! * Copyright (C) 2019 Lee Justice <Lemster68@gmail.com>
  ! *
  ! * Licensed under the Apache License, Version 2.0 (the "License");
  ! * you may not use this file except in compliance with the License.
  ! * You may obtain a copy of the License at
  ! *
  ! *      http://www.apache.org/licenses/LICENSE-2.0
  ! *
  ! * Unless required by applicable law or agreed to in writing, software
  ! * distributed under the License is distributed on an "AS IS" BASIS,
  ! * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ! * See the License for the specific language governing permissions and
  ! * limitations under the License.
  !*****************************************************

  !*****************************************************
  ! Module Name: ArmLoad
  ! Version:     1.0
  ! Description: Sets the prerequisite Armloads before you use LoadID for EOAT
  ! Date:        <2019-09-27>
  ! Author:      Lee Justice <Lemster68@gmail.com>
  ! Internet:    http://github.com/ernell/ABB-RAPID-UTILITY-LIBRARY
  !*****************************************************
  !
  !  This was written for IRC5 controllers on a BMW project
  !  Nice for when you have hundreds of robots to set Armload parameters
  !  The end user should enter the correct loads for their application.
  !  All armloads ARE NOT the same.  We had IRB6640 and 7600 robots only.
  !  If you have different types use these as a template to add your types.
  VAR num nDummy;
  VAR string stSerialNoHigh;
  CONST string stArmLoadOne:="r1_load_1";
  CONST string stArmLoadTwo:="r1_load_2";
  CONST string stArmLoadThree:="r1_load_3";
  CONST num nLoad_1Mass:=9;
  CONST num nLoad_2Mass:=7;
  CONST num n66Load_3Mass:=30;
  CONST num n76Load_3Mass:=31.3;
  CONST num nL1MassCenterX:=0.3;
  CONST num nL1MassCenterY:=0.3;
  CONST num nL1MassCenterZ:=0.7;
  CONST num nL2MassCenterX:=0;
  CONST num nL2MassCenterY:=0.5;
  CONST num nL2MassCenterZ:=0.6;
  CONST num nL3MassCenterX:=0.4;
  CONST num nL3MassCenterY:=0;
  CONST num nL3MassCenterZ:=0.4;

  PROC rSetArmLoads()
 	  WriteCfgData "/MOC/ARM/rob1_1","use_customer_arm_load",stArmLoadOne;
 	  WriteCfgData "/MOC/ARM/rob1_2","use_customer_arm_load",stArmLoadTwo;
 	  WriteCfgData "/MOC/ARM/rob1_3","use_customer_arm_load",stArmLoadThree;
	  ReadCfgData "MOC/ROBOT_SERIAL_NUMBER/rob_1","robot_serial_number_high_part",stSerialNoHigh;
 	  WriteCfgData "/MOC/ARM_LOAD/r1_load_1","mass",nLoad_1Mass;
 	  WriteCfgData "/MOC/ARM_LOAD/r1_load_2","mass",nLoad_2Mass;
	  IF stSerialNoHigh = "  66" THEN
	   	WriteCfgData "/MOC/ARM_LOAD/r1_load_3","mass",n66Load_3Mass;
	  ELSEIF stSerialNoHigh = "6640" THEN
	   	WriteCfgData "/MOC/ARM_LOAD/r1_load_3","mass",n66Load_3Mass;
	  ELSEIF stSerialNoHigh = "  76" THEN
	 	  WriteCfgData "/MOC/ARM_LOAD/r1_load_3","mass",n76Load_3Mass;
	  ELSEIF stSerialNoHigh = "7600" THEN
	 	  WriteCfgData "/MOC/ARM_LOAD/r1_load_3","mass",n76Load_3Mass;
	  ELSE
	  	TPErase;
	  	TPWrite "Sorry, Robot type was not determined!";
	  	TPWrite "You will have to enter armload manually";
	  	TPWrite "for r1_load_3 to ensure accuracy.";
	  	WaitTime 10;
	  ENDIF
	  WriteCfgData "/MOC/ARM_LOAD/r1_load_1","mass_centre_x",nL1MassCenterX;
	  WriteCfgData "/MOC/ARM_LOAD/r1_load_1","mass_centre_y",nL1MassCenterY;
	  WriteCfgData "/MOC/ARM_LOAD/r1_load_1","mass_centre_z",nL1MassCenterZ;
	  WriteCfgData "/MOC/ARM_LOAD/r1_load_2","mass_centre_x",nL2MassCenterX;
	  WriteCfgData "/MOC/ARM_LOAD/r1_load_2","mass_centre_y",nL2MassCenterY;
	  WriteCfgData "/MOC/ARM_LOAD/r1_load_2","mass_centre_z",nL2MassCenterZ;
	  WriteCfgData "/MOC/ARM_LOAD/r1_load_3","mass_centre_x",nL3MassCenterX;
	  WriteCfgData "/MOC/ARM_LOAD/r1_load_3","mass_centre_y",nL3MassCenterY;
  	WriteCfgData "/MOC/ARM_LOAD/r1_load_3","mass_centre_z",nL3MassCenterZ;
  	TPErase;
  	TPWrite "Armloads are now set!";
  	TPWrite "They are not in effect until after      restart!";
  	TPReadFK nDummy,"Do you wish to restart the controller   now?","YES",stEmpty,stEmpty,stEmpty,"NO";
  	TEST nDummy
  	  CASE 1:
  	    TPErase;
  	    TPWrite "WarmStart in 5 seconds, please continue running program.";
  	    WaitTime 5;
  	    WarmStart;
  	DEFAULT:
  	    ! do nothing
  	    TPErase;
  	    TPWrite "OK, restart at your convenience.";
  	    TPWrite "Changes have no effect until restart!!!";
  	ENDTEST
  ENDPROC
ENDMODULE