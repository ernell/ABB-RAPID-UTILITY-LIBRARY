%%%
  VERSION:1
  LANGUAGE:ENGLISH
%%%

MODULE SoftLimits_S4C
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
  ! Module Name: SoftLimits_S4C
  ! Version:     1.0
  ! Description: Allows the user to set soft limits using this program
  !              S4, S4C, S4C+ vintage controllers, IRB 6600
  ! Date:        2019-10-01
  ! Author:      Lee Justice <Lemster68@gmail.com>
  ! Internet:    http://github.com/ernell/ABB-RAPID-UTILITY-LIBRARY
  !*****************************************************
  
  VAR num nNewLimit:=0;
  PERS num nLimit:=-1.5708;

  PROC rSetLimits()
    VAR num nAxis;
    VAR num nChoice;
    VAR num nFKMore;
    VAR bool bUpper;
    VAR bool bLower;
    VAR bool bDegrees;
    VAR bool bRadians;
    VAR string stLimit;

    TPErase;
    TPWrite "This routine will let you set softlimits";
    TPWrite "right here without going into system";
    TPWrite "parameters.  You don't have to know ";
    TPWrite "where to find them.  Cool, huh?";
lblMore:
    TPReadNum nAxis,"Which axis would you like to set limits?";
    TEST nAxis
    CASE 1:
      TPReadNum nChoice,"1=Upper or 2=Lower limit please";
      TEST nChoice
      CASE 1:
        bUpper:=TRUE;
      CASE 2:
        bLower:=TRUE;
      ENDTEST
      IF bUpper THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-3.14159) OR nLimit>3.14159) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_1","upper_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-3.14159) OR nLimit>3.14159) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_1","upper_joint_bound",nNewLimit;
        ENDTEST
      ELSEIF bLower THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-3.14159) OR nLimit>3.14159) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_1","lower_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-3.14159) OR nLimit>3.14159) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_1","lower_joint_bound",nNewLimit;
        ENDTEST
      ENDIF
    CASE 2:
      TPReadNum nChoice,"1=Upper or 2=Lower limit please";
      TEST nChoice
      CASE 1:
        bUpper:=TRUE;
      CASE 2:
        bLower:=TRUE;
      ENDTEST
      IF bUpper THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-1.13446) OR nLimit>1.48353) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_2","upper_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-1.13446) OR nLimit>1.48353) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_2","upper_joint_bound",nNewLimit;
        ENDTEST
      ELSEIF bLower THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-1.13446) OR nLimit>1.48353) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_2","lower_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-1.13446) OR nLimit>1.48353) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_2","lower_joint_bound",nNewLimit;
        ENDTEST
      ENDIF
    CASE 3:
      TPReadNum nChoice,"1=Upper or 2=Lower limit please";
      TEST nChoice
      CASE 1:
        bUpper:=TRUE;
      CASE 2:
        bLower:=TRUE;
      ENDTEST
      IF bUpper THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-3.14159) OR nLimit>1.22173) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_3","upper_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-3.14159) OR nLimit>1.22173) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_3","upper_joint_bound",nNewLimit;
        ENDTEST
      ELSEIF bLower THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-3.14159) OR nLimit>1.22173) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_3","lower_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-3.14159) OR nLimit>1.22173) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_3","lower_joint_bound",nNewLimit;
        ENDTEST
      ENDIF
    CASE 4:
      TPReadNum nChoice,"1=Upper or 2=Lower limit please";
      TEST nChoice
      CASE 1:
        bUpper:=TRUE;
      CASE 2:
        bLower:=TRUE;
      ENDTEST
      IF bUpper THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-5.23599) OR nLimit>5.23599) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_4","upper_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-5.23599) OR nLimit>5.23599) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_4","upper_joint_bound",nNewLimit;
        ENDTEST
      ELSEIF bLower THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-5.23599) OR nLimit>5.23599) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_4","lower_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-5.23599) OR nLimit>5.23599) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_4","lower_joint_bound",nNewLimit;
        ENDTEST
      ENDIF
    CASE 5:
      TPReadNum nChoice,"1=Upper or 2=Lower limit please";
      TEST nChoice
      CASE 1:
        bUpper:=TRUE;
      CASE 2:
        bLower:=TRUE;
      ENDTEST
      IF bUpper THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-2.0944) OR nLimit>2.0944) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_5","upper_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-2.0944) OR nLimit>2.0944) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_5","upper_joint_bound",nNewLimit;
        ENDTEST
      ELSEIF bLower THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-2.0944) OR nLimit>2.0944) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_5","lower_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-2.0944) OR nLimit>2.0944) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_5","lower_joint_bound",nNewLimit;
        ENDTEST
      ENDIF
    CASE 6:
      TPReadNum nChoice,"1=Upper or 2=Lower limit please";
      TEST nChoice
      CASE 1:
        bUpper:=TRUE;
      CASE 2:
        bLower:=TRUE;
      ENDTEST
      IF bUpper THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-6.28319) OR nLimit>6.28319) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_6","upper_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-6.28319) OR nLimit>6.28319) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_6","upper_joint_bound",nNewLimit;
        ENDTEST
      ELSEIF bLower THEN
        TPReadNum nChoice,"Please select 1=Degrees or 2=Radians";
        TEST nChoice
        CASE 1:
          TPReadNum nLimit,"Please enter the degrees";
          rDeg_to_Rads;
          IF (nLimit<(-6.28319) OR nLimit>6.28319) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_6","lower_joint_bound",nNewLimit;
        CASE 2:
          TPReadNum nLimit,"Please enter the radians";
          IF (nLimit<(-6.28319) OR nLimit>6.28319) THEN
            TPWrite "I'm sorry but that number seems outside   the allowed limits.";
            TPWrite "Please reenter the number or change the";
            TPWrite "softlimit manually in system parameters.";
            GOTO lblMore;
          ENDIF
          nNewLimit:=nLimit;
          WriteCfgData "/MOC/ARM/irb_6","lower_joint_bound",nNewLimit;
        ENDTEST
      ENDIF
    ENDTEST
    TPReadFK nFKMore,"Set more limits?","YES",stEmpty,stEmpty,stEmpty,"NO";
    TEST nFKMore
    CASE 1:
      GOTO lblMore;
    CASE 5:
      TPErase;
      TPWrite "You Must restart the controller";
      TPWrite "for these changes to take effect.";
      TPWrite "Thanks, Have a great day";
      WaitTime 3;
      EXIT;
    ENDTEST
  ENDPROC

  PROC rDeg_to_Rads()
    VAR num nResult;

    nResult:=(pi/180)*nLimit;
    nLimit:=nResult;
  ENDPROC
ENDMODULE
