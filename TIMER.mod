%%%
  VERSION:1
  LANGUAGE:ENGLISH
%%%

MODULE TIMER(VIEWONLY)
  
  !*****************************************************
  ! * Copyright (C) 2013 Robert Andersson <rob@ernell.se>
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
  ! Module Name: TIMER
  ! Version:     0.1
  ! Description: A simple timer with basic functionality
  ! Date:        2013-11-18
  ! Author:      Robert Andersson <rob@ernell.se>
  ! Internet:    http://github.com/ernell/ABB-RAPID-UTILITY-LIBRARY
  !*****************************************************

  LOCAL VAR clock clTimer;
  LOCAL PERS num nTimer:=0;

  !*****************************************************
  ! Start the timer
  !*****************************************************
  PROC TimerStart()
    nTimer:=0;
    ClkReset clTimer;
    ClkStart clTimer;
  ENDPROC

  !*****************************************************
  ! Resume the timer
  !*****************************************************
  PROC TimerResume()
    ClkStart clTimer;
  ENDPROC

  !*****************************************************
  ! Stop the timer, save the value
  !*****************************************************
  PROC TimerStop()
    ClkStop clTimer;
    nTimer:=ClkRead(clTimer);
  ENDPROC
  
  !*****************************************************
  ! Return the timervalue
  !*****************************************************
  FUNC num GetTimer()
    RETURN nTimer;
  ENDFUNC

  !*****************************************************
  ! Print timer value
  ! Examples:
  !    TimerPrint;
  !      Timer: 0.235
  !    TimerPrint\row_number:=5;
  !      5. Timer: 4.743
  !*****************************************************
  PROC TimerPrint(\num row_number)

    VAR string stMessage;

    IF Present(row_number) THEN
      stMessage:=NumToStr(row_number,0)+". Timer: "+NumToStr(GetTimer(),3);
      TPWrite stMessage;
    ELSE
      TPWrite "Timer: "\Num:=GetTimer();
    ENDIF
  ENDPROC
ENDMODULE
