MODULE Recover
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
  ! Module Name: Recover
  ! Version:     1.0
  ! Description: Can be used in robot homing/recovery by finding the robtarget
  ! which is closest to the current robot position.  You could change it to a
  ! function which will return the robtarget.
  ! Date:        <2019-09-26>
  ! Author:      Lee Justice <Lemster68@gmail.com>
  ! Internet:    http://github.com/ernell/ABB-RAPID-UTILITY-LIBRARY
  !*****************************************************
  VAR string stRobt:=stEmpty;
  VAR string stClosestPoint;
  CONST num nMaxRecoverDist:=2000;
  PERS tooldata tCheck;
  PERS string stToolName;
  TASK PERS wobjdata wobjCheck:=[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
  PERS string stWobjName:="wobj0";
  
  PROC FindNearestPoint()
    VAR robtarget pCurrentPosition;
    VAR num n12Distance:=10000;
    VAR robtarget checkrobt;
    VAR datapos block;
    
    GetSysData tCheck\ObjectName:=stToolName;
    GetSysData wobjCheck\ObjectName:=stWobjName;
    pCurrentPosition:=CRobT(\Tool:=tCheck\WObj:=wobjCheck);
    ! the user will need to change "R1_Data" to the name of
    ! the module which contains your robtarget declarations.
    ! Or, change the SetDataSearch instruction to look for all
    ! robtargets in the system.
    SetDataSearch "robtarget"\InMod:="R1_Data";
    WHILE GetNextSym(stRobt,block\Recursive) DO
      GetDataVal stRobt\TaskName:="T_ROB1", checkrobt;
   	  ! Compare current robot position with stored robtarget
      ! If it is less than maximum recovery distance store the name
      ! and distance from current position.
      IF (Distance(checkrobt.trans,pCurrentPosition.trans) < nMaxRecoverDist) THEN
        ! Check to see if point is within Maximum recovery
        ! but maybe farther than last compared point.
        ! Should update n12Distance if closer point is found.
        IF Distance(checkrobt.trans,pCurrentPosition.trans) < n12Distance THEN
          n12Distance:=Distance(checkrobt.trans,pCurrentPosition.trans);
          stClosestPoint:=stRobt;
        ELSE
          ! Do nothing, point is farther from last found point
          ! within max recover distance nMaxRecoverDist.
        ENDIF
      ENDIF
    ENDWHILE
    IF n12Distance >= nMaxRecoverDist THEN
      TPWrite "Nearest taught point is Not Found!!!  Caution!!!";
      TPWrite "Not close enough to a known taught point!!!";
      TPWrite "Active tool used to check was " + stToolName;
      TPWrite "Active work object used to check was " + stWobjName;
    ELSE
      TPWrite "Nearest taught point is: " + stClosestPoint;
      TPWrite "Distance from current position is: "\Num:=n12Distance;
      TPWrite "Active tool used to check was " + stToolName;
      TPWrite "Active work object used to check was " + stWobjName;
    ENDIF
  ENDPROC

ENDMODULE