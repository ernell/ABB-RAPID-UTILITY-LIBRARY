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
  ! Module Name: Calculator
  ! Version:     1.0
  ! Description: Addition, subtraction, multiplication and division
  ! Date:        2019-10-01
  ! Author:      Lee Justice <Lemster68@gmail.com>
  ! Internet:    http://github.com/ernell/ABB-RAPID-UTILITY-LIBRARY
  !*****************************************************
  
MODULE Calculator_Mod
  PROC TP_Calculator()
    VAR num nResult:=0;
    VAR num nInput1:=0;
    VAR num nInput2:=0;
    VAR num nDummy:=0;
    VAR string stOperator:="";

    ! This procedure is a simple teach pendant
    ! calculator to be used for adddition, subtraction
    ! multiplication or division.
lblDoOver:
    TPErase;
    TPReadNum nInput1,"Please enter the first number of your    calculation.";
    TPReadFK nDummy,"Please select the operator function key","+","-","*","/","Back";
    TEST nDummy
    CASE 1:
      stOperator:="+";
    CASE 2:
      stOperator:="-";
    CASE 3:
      stOperator:="*";
    CASE 4:
      stOperator:="/";
    CASE 5:
      GOTO lblDoOver;
    ENDTEST
    TPReadNum nInput2,"Please enter the second number of your calculation.";
    TEST nDummy
    CASE 1:
      nResult:=nInput1+nInput2;
    CASE 2:
      nResult:=nInput1-nInput2;
    CASE 3:
      nResult:=nInput1*nInput2;
    CASE 4:
      nResult:=nInput1/nInput2;
    ENDTEST
    TPWrite ""\Num:=nInput1;
    TPWrite stOperator\Num:=nInput2;
    TPWrite " = "\Num:=nResult;
  ENDPROC
ENDMODULE
