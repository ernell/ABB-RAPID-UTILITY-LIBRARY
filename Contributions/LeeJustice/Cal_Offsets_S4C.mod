%%%
  VERSION:1
  LANGUAGE:ENGLISH
%%%

MODULE Cal_Offsets_S4C
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
  ! Module Name: Cal_Offsets_S4C
  ! Version:     1.0
  ! Description: Read and optionally write calibration offsets
  !              S4, S4C, S4C+ vintage This is just for checking, 
  !              because you cannot run a program yet if your REV
  !              counters are not updated and you should not do that
  !              really if you have not verified cal offsets.
  ! Date:        2019-10-01
  ! Author:      Lee Justice <Lemster68@gmail.com>
  ! Internet:    http://github.com/ernell/ABB-RAPID-UTILITY-LIBRARY
  !*****************************************************
  ! This module was written pre IRC5 controller, you can change it  for
  ! IRC5 or wait for me to update

  PROC Write_Offsets()
    VAR num nAxisMotor;
    VAR num nNewOffset;
    VAR num nFKDummy;

    TPErase;
    TPWrite "You nave chosen to change offsets.";
lblMore:
    TPReadNum nAxisMotor,"Which Axis please? 1-6";
    TEST nAxisMotor
    CASE 1:
lblRetry1:
      TPReadNum nNewOffset,"Please key in the offset.";
      IF (nNewOffset<(-6.283) OR nNewOffset>6.283) THEN
        TPWrite "I'm sorry, that number seems invalid.";
        GOTO lblRetry1;
      ELSE
        WriteCfgData "/MOC/MOTOR_CALIB/irb_1","cal_offset",nNewOffset;
      ENDIF
    CASE 2:
lblRetry2:
      TPReadNum nNewOffset,"Please key in the offset.";
      IF (nNewOffset<(-6.283) OR nNewOffset>6.283) THEN
        TPWrite "I'm sorry, that number seems invalid.";
        GOTO lblRetry2;
      ELSE
        WriteCfgData "/MOC/MOTOR_CALIB/irb_2","cal_offset",nNewOffset;
      ENDIF
    CASE 3:
lblRetry3:
      TPReadNum nNewOffset,"Please key in the offset.";
      IF (nNewOffset<(-6.283) OR nNewOffset>6.283) THEN
        TPWrite "I'm sorry, that number seems invalid.";
        GOTO lblRetry3;
      ELSE
        WriteCfgData "/MOC/MOTOR_CALIB/irb_3","cal_offset",nNewOffset;
      ENDIF
    CASE 4:
lblRetry4:
      TPReadNum nNewOffset,"Please key in the offset.";
      IF (nNewOffset<(-6.283) OR nNewOffset>6.283) THEN
        TPWrite "I'm sorry, that number seems invalid.";
        GOTO lblRetry4;
      ELSE
        WriteCfgData "/MOC/MOTOR_CALIB/irb_4","cal_offset",nNewOffset;
      ENDIF
    CASE 5:
lblRetry5:
      TPReadNum nNewOffset,"Please key in the offset.";
      IF (nNewOffset<(-6.283) OR nNewOffset>6.283) THEN
        TPWrite "I'm sorry, that number seems invalid.";
        GOTO lblRetry5;
      ELSE
        WriteCfgData "/MOC/MOTOR_CALIB/irb_5","cal_offset",nNewOffset;
      ENDIF
    CASE 6:
lblRetry6:
      TPReadNum nNewOffset,"Please key in the offset.";
      IF (nNewOffset<(-6.283) OR nNewOffset>6.283) THEN
        TPWrite "I'm sorry, that number seems invalid.";
        GOTO lblRetry6;
      ELSE
        WriteCfgData "/MOC/MOTOR_CALIB/irb_6","cal_offset",nNewOffset;
      ENDIF
    ENDTEST
    TPReadFK nFKDummy,"Any more?","YES",stEmpty,stEmpty,stEmpty,"NO";
    TEST nFKDummy
    CASE 1:
      GOTO lblMore;
    CASE 2:
      TPWrite "Thank you, have a great day.";
      WaitTime 2;
      EXIT;
    ENDTEST
  ENDPROC

  PROC Read_Offsets()
    VAR num nCalOffset1;
    VAR num nCalOffset2;
    VAR num nCalOffset3;
    VAR num nCalOffset4;
    VAR num nCalOffset5;
    VAR num nCalOffset6;
    VAR num nFKDummy;

    TPErase;
    TPWrite "Greetings, this routine will let you    view calibration offsets.";
    TPWrite "Then you may change any if you like.";
    TPReadFK nFKDummy,"Please select OK to continue",stEmpty,stEmpty,stEmpty,stEmpty,"OK";
    ReadCfgData "/MOC/MOTOR_CALIB/irb_1","cal_offset",nCalOffset1;
    ReadCfgData "/MOC/MOTOR_CALIB/irb_2","cal_offset",nCalOffset2;
    ReadCfgData "/MOC/MOTOR_CALIB/irb_3","cal_offset",nCalOffset3;
    ReadCfgData "/MOC/MOTOR_CALIB/irb_4","cal_offset",nCalOffset4;
    ReadCfgData "/MOC/MOTOR_CALIB/irb_5","cal_offset",nCalOffset5;
    ReadCfgData "/MOC/MOTOR_CALIB/irb_6","cal_offset",nCalOffset6;
    TPWrite "Calibration offset Axis 1 is: "\Num:=nCalOffset1;
    TPWrite "Calibration offset Axis 2 is: "\Num:=nCalOffset2;
    TPWrite "Calibration offset Axis 3 is: "\Num:=nCalOffset3;
    TPWrite "Calibration offset Axis 4 is: "\Num:=nCalOffset4;
    TPWrite "Calibration offset Axis 5 is: "\Num:=nCalOffset5;
    TPWrite "Calibration offset Axis 6 is: "\Num:=nCalOffset6;
    TPReadFK nFKDummy,"Do you wish to change any offsets?","YES",stEmpty,stEmpty,stEmpty,"NO";
    TEST nFKDummy
    CASE 1:
      Write_Offsets;
    CASE 5:
      TPWrite "Thank you, have a great Day.";
      WaitTime 3;
      EXIT;
    ENDTEST
  ENDPROC
ENDMODULE
