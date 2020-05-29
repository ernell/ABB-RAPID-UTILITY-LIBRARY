MODULE RANDOM_GEN
  !*****************************************************
  ! * Copyright (C) 2020 Lee Justice <Lemster68@gmail.com>
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
  ! Module Name: <RANDOM_GEN.MOD>
  ! Version:     1.0
  ! Description: Pseudo random number generator, picks a number based on 
  !              system minute and seconds when called.
  ! Date:        <2020-05-29>
  ! Author:      Lee Justice <Lemster68@gmail.com>
  ! Internet:    http://github.com/ernell/ABB-RAPID-UTILITY-LIBRARY
  !***************************************************** 

    FUNC num fRandomGenerator()
      VAR num nRandom;
      VAR num nMinute;
      VAR num nSecond;
      VAR num nArrayPointer1;
      VAR num nArrayPointer2;
      VAR num myNumArray10x10{10,10}:=[[51,22,83,14,5,86,77,8,29,70],[91,42,93,74,45,16,87,38,99,90],[21,2,23,24,35,26,37,28,89,30],[61,72,3,84,65,76,67,18,79,50]
      ,[1,12,33,54,75,36,57,88,59,40],[41,92,43,34,95,46,17,78,49,80],[31,82,53,44,25,56,27,98,19,20],[71,62,13,94,55,66,7,48,69,10]
      ,[81,32,63,4,85,6,97,58,9,100],[11,52,73,64,15,96,47,68,39,60]];
      ! Random number generation based on minutes and seconds of system time
      nMinute:=GetTime(\Min);      
      nSecond:=GetTime(\Sec);
      IF nMinute = 0 THEN
        ! Cannot point to array index 0, will cause array index out of bounds
        nArrayPointer1 := 1;
      ELSEIF nMinute >= 1 AND nMinute <= 6 THEN
        nArrayPointer1 := 1;
      ELSEIF nMinute >= 7 AND nMinute <= 12 THEN
        nArrayPointer1 := 2;
      ELSEIF nMinute >= 13 AND nMinute <= 18 THEN
        nArrayPointer1 := 3;
      ELSEIF nMinute >= 19 AND nMinute <= 24 THEN
        nArrayPointer1 := 4;
      ELSEIF nMinute >= 25 AND nMinute <= 30 THEN
        nArrayPointer1 := 5;
      ELSEIF nMinute >= 31 AND nMinute <= 36 THEN
        nArrayPointer1 := 6;
      ELSEIF nMinute >= 37 AND nMinute <= 42 THEN
        nArrayPointer1 := 7;
      ELSEIF nMinute >= 43 AND nMinute <= 48 THEN
        nArrayPointer1 := 8;
      ELSEIF nMinute >= 49 AND nMinute <= 54 THEN
        nArrayPointer1 := 9;
      ELSEIF nMinute >= 55 AND nMinute <= 60 THEN
        nArrayPointer1 := 10;
      ENDIF
      IF nSecond = 0 THEN
        ! Cannot point to array index 0, will cause array index out of bounds
        nArrayPointer2 := 1;
      ELSEIF nSecond >= 1 AND nSecond <= 6 THEN
        nArrayPointer2 := 1;
      ELSEIF nSecond >= 7 AND nSecond <= 12 THEN
        nArrayPointer2 := 2;
      ELSEIF nSecond >= 13 AND nSecond <= 18 THEN
        nArrayPointer2 := 3;
      ELSEIF nSecond >= 19 AND nSecond <= 24 THEN
        nArrayPointer2 := 4;
      ELSEIF nSecond >= 25 AND nSecond <= 30 THEN
        nArrayPointer2 := 5;
      ELSEIF nSecond >= 31 AND nSecond <= 36 THEN
        nArrayPointer2 := 6;
      ELSEIF nSecond >= 37 AND nSecond <= 42 THEN
        nArrayPointer2 := 7;
      ELSEIF nSecond >= 43 AND nSecond <= 48 THEN
        nArrayPointer2 := 8;
      ELSEIF nSecond >= 49 AND nSecond <= 54 THEN
        nArrayPointer2 := 9;
      ELSEIF nSecond >= 55 AND nSecond <= 60 THEN
        nArrayPointer2 := 10;
      ENDIF
      nRandom:=myNumArray10x10{nArrayPointer1,nArrayPointer2};
      TPWrite "Random number generated is: "\Num:=nRandom;
      RETURN nRandom;      
    ENDFUNC
    
    PROC testFunc()
      VAR num nTest;
      
      nTest:=fRandomGenerator();
      WaitTime 5;
      TPWrite "Random number generated is: "\Num:=nTest;
    ENDPROC
ENDMODULE
