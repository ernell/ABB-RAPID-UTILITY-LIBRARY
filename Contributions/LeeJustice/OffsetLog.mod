MODULE OffsetLog
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
  ! Module Name: OffsetLog
  ! Version:     1.0
  ! Description: !  This module shows how to make a text file for logging
  !                 data.  A lot of people like to make a .csv file to
  !                 open with excel.  I prefer the readability of a text
  !                 file. With some adaptation, you could change it to
  !                 write a .csv file
  ! Date:        2019-10-18
  ! Author:      Lee Justice <Lemster68@gmail.com>
  ! Internet:    http://github.com/ernell/ABB-RAPID-UTILITY-LIBRARY
  !*****************************************************
  ! Data logging module to record trueview offsets
  ! provided to R62 for roof load onto car.
  !
  ! Boolean bQuiet is switch to turn on or off
  ! TPWrites as desired.
  !
  ! Boolean bLogData is switch to turn on or off
  ! the data logging altogether.
  !
  ! Numeric nFreeFlashPer is the percent value
  ! of flash drive free space below which the
  ! program will erase the log file and begin a new
  ! file, so the flash drive will not fill up.
  ! Adjust as desired.
  !
  ! Created: 10-09-2011
  !
  PERS string ActiveStylString;
  PERS num nXoffset;
  PERS num nYoffset;
  PERS num nFreeFlashPer:=32;
  PERS bool ComDevIsOpen:=FALSE;
  PERS bool bQuiet:=FALSE;
  PERS bool bLogData:=FALSE;
  
  PROC rLogOffsets()
    VAR iodev datalog;
    VAR string stDate;
    VAR string stTime;
    VAR num nFreespace;
    VAR num nTotalspace;

    IF bLogData THEN
    	stDate:=CDate();
      stTime:=CTime();
      nFreespace:=FSSize("HOME:/Offsets.txt"\Free);
      nTotalspace:=FSSize("HOME:/Offsets.txt"\Total);
      IF ((nTotalspace-nFreespace)/nTotalspace)*100<nFreeFlashPer THEN
        IF ComDevIsOpen Close datalog;
        Open "HOME:"\File:="Offsets.txt",datalog\Write;
        ComDevIsOpen:=TRUE;
        Write datalog,stDate+", "+stTime+", "+"New offset data log created.";
        ErrWrite\W,"File removed","Removing Offsets.txt from the HOME directory."\RL2:="To keep flash drive from filling.";
      ELSE
        IF ComDevIsOpen Close datalog;
        Open "HOME:"\File:="Offsets.txt",datalog\Append;
        ComDevIsOpen:=TRUE;
        Write datalog,stDate + ", " + stTime + ", " + ActiveStylString + ", " + " nXoffset is: "\Num:=nXoffset\NoNewLine;
        Write datalog,", nYoffset is: "\Num:=nYoffset;
        Close datalog;
        ComDevIsOpen:=FALSE;
        IF bQuiet THEN
      	  ! Do nothing, only silence TPWrites
        ELSE
      	  TPWrite "The file containing the offset data is  in the HOME directory.";
          TPWrite "Use the File Manager to retrieve a copyof Offsets.txt.";
        ENDIF
      ENDIF
    ENDIF
    RETURN;
  ERROR
    TEST ERRNO
    CASE ERR_FILEACC:
      IF ComDevIsOpen Close datalog;
      Open "HOME:"\File:="Offsets.txt",datalog\Write;
      Write datalog,stDate+", "+stTime+", "+"New offset data log created.";
      Close datalog;
      RETRY;
    DEFAULT:
      Stop;
      ! An unanticipated error has occurred
      ! see sytem variable ERRNO for cause.
    ENDTEST
  ENDPROC
ENDMODULE
