MODULE LEERULZ
  !*****************************************************
  ! * Copyright (C) 2019 Lee Justice, Lemster68@gmail.com
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
  ! Module Name: LEERULZ
  ! Version:     1.0
  ! Description: See below
  ! Date:        2019-09-26
  ! Author:      Lee Justice  Lemster68@gmail.com
  ! Internet:    http://github.com/ernell/ABB-RAPID-UTILITY-LIBRARY
  !*****************************************************
  !
  ! This module contains two routines, rEnter and rExit which are 
  ! intended to be universal handshake routines for requesting
  ! entry from the cell controller to enter an area, fixture or
  ! robot interference zone.  When called, the user must pass in
  ! the parameters and switches unique to the user's installation.
  ! I.E., Digital inputs and digital outputs from your IO map, your
  ! tool and workobjects, if used.  Nothing is hard-coded, so there
  ! is no need to rewrite these routines for your particular
  ! project.  Both routines have Backward handlers so the user will
  ! be able to step backwards through the procedure call.  The robot
  ! will move back to where it came from using the parameter passed
  ! which should be the parameter robtarget or jointtarget from which
  ! it came when requesting entry or exit.  Then It will set or reset
  ! the digital output for clear as appropriate to enter or exit.
  ! pass in the parameter for the path interpolation used, linear, joint
  ! or MoveAbsJ. Or, the default will be joint interpolation.
  ! Example procedure call:
  ! rEnter "Station 1", doSta1EntRequest, diSta1ClearEnter1, doSta1InFixture, tGripper\WObj:=wobjStation1\swMoveJoint\pPreviouspoint:=p10;
  !
  ! Older S4C, S4C+ robots require developer functions option, I think, to use functions 
  ! like ArgName().  I think in newer IRC5 such things are now standard.
		
  PROC rEnter(
    string area,
    VAR signaldo request,
    VAR signaldi signal,
    VAR signaldo notclear,
    PERS tooldata tool,
    \PERS wobjdata WObj
    \switch swMoveAbs
    |switch swMoveLin
    |switch swMoveJoint
    \robtarget pPreviouspoint
    |jointtarget jposPrevious)

    VAR num nDummy;
    VAR bool bTimeFlag;
    VAR errnum erBreakFlag;
    CONST string stFixClear:="Clear signal has been received, ";

    IF (NOT Present(pPreviouspoint)) AND (NOT Present(jposPrevious)) THEN
      TPErase;
      TPWrite "Neither a robtarget nor a jointtarget   were provided!!!";
      TPWrite "Please remedy this from where this";
      TPWrite "procedure was called.";
      TPWrite "Backwards execution will NOT be possible!!!";
    ENDIF
    IF (Present(jposPrevious)) AND (NOT Present(swMoveAbs)) THEN
      TPErase;
      TPWrite "The optional switch for MoveAbsJ was    not provided";
      TPWrite " but a jointtarget was!!!";
      TPWrite "Please remedy this from where this";
      TPWrite "procedure was called.";
      TPWrite "Backwards execution will NOT be possible!!!";
    ENDIF
    Set request;
    WaitUntil signal=1\MaxTime:=2\TimeFlag:=bTimeFlag;
    IF bTimeFlag AND OpMode()=OP_MAN_PROG THEN
      TPWrite "Waiting for Clear signal, ";
      TPReadFK nDummy,ArgName(signal),"","",""," ",""\DIBreak:=signal\BreakFlag:=erBreakFlag;
    ELSE
      TPWrite "Waiting for Clear signal, ";
      TPWrite ArgName(signal);
      WaitDI signal,1;
    ENDIF
    TPWrite stFixClear;
    TPWrite ArgName(signal);
    Reset notclear;
    Reset request;
  BACKWARD
    IF (NOT Present(pPreviouspoint)) AND (NOT Present(jposPrevious)) THEN
      TPErase;
      TPWrite "Neither a robtarget nor a jointtarget were provided!!!";
      TPWrite "Please remedy this from where this procedure";
      TPWrite "was called.";
    ENDIF
    IF Present(swMoveAbs) THEN
      MoveAbsJ jposPrevious,v500,fine,Tool\WObj?WObj;
    ELSEIF Present(swMoveLin) THEN
      MoveL pPreviouspoint,v500,fine,Tool\WObj?WObj;
    ELSE
      MoveJ pPreviouspoint,v500,fine,Tool\WObj?WObj;
    ENDIF
    TPWrite "Robot clearing " + area;
    Set notclear;
    RETURN;
  ENDPROC

  PROC rExit(
    string area,
    VAR signaldo request,
    VAR signaldi signal,
    VAR signaldo notclear,
    PERS tooldata tool,
    \PERS wobjdata WObj
    \switch swMoveAbs
    |switch swMoveLin
    |switch swMoveJoint
    \robtarget pPreviouspoint
    |jointtarget jposPrevious)

    VAR num nDummy;
    VAR bool bTimeFlag;
    VAR errnum erBreakFlag;
    CONST string stExiting:="Robot exiting ";
    CONST string stReturning:="Robot Returning ";

    IF (NOT Present(pPreviouspoint)) AND (NOT Present(jposPrevious)) THEN
      TPErase;
      TPWrite "Neither a robtarget nor a jointtarget   were provided!!!";
      TPWrite "Please remedy this from where this";
      TPWrite "procedure was called.";
      TPWrite "Backwards execution will NOT be possible!!!";
    ENDIF
    IF (Present(jposPrevious)) AND (NOT Present(swMoveAbs)) THEN
      TPErase;
      TPWrite "The optional switch for MoveAbsJ was    not provided";
      TPWrite " but a jointtarget was!!!";
      TPWrite "Please remedy this from where this";
      TPWrite "procedure was called.";
      TPWrite "Backwards execution will NOT be possible!!!";
    ENDIF
    Set request;
    WaitUntil signal=1\MaxTime:=2\TimeFlag:=bTimeFlag;
    IF bTimeFlag AND OpMode()=OP_MAN_PROG THEN
      TPWrite "Waiting for Clear signal, ";
      TPReadFK nDummy,ArgName(signal),"","",""," ",""\DIBreak:=signal\BreakFlag:=erBreakFlag;
    ELSE
      TPWrite "Waiting for Clear signal, ";
      TPWrite ArgName(signal);
      WaitDI signal,1;
    ENDIF
    TPWrite stExiting+area;
    ! The VAR signaldo notclear is not set here
    ! because some motion is necessary to get the 
    ! robot actually clear.  If it were set here
    ! then the robot is not clear because no Motion
    ! has occurred yet.
    Reset request;
  BACKWARD
    Reset notclear;
    IF Present(swMoveAbs) THEN
      MoveAbsJ jposPrevious,v500,fine,Tool\WObj?WObj;
    ELSEIF Present(swMoveLin) THEN
      MoveL pPreviouspoint,v500,fine,Tool\WObj?WObj;
    ELSE
      MoveJ pPreviouspoint,v500,fine,Tool\WObj?WObj;
    ENDIF
    TPWrite stReturning+area;
    RETURN;
  ENDPROC
ENDMODULE