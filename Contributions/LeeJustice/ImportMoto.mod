MODULE ImportMoto
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
  ! Module Name: ImportMoto
  ! Version:     1.2
  ! Description: Reads motoman files to create usable ABB data and motions
  !              If, for instance you want to replace Motoman with ABB.
  ! Date:        <2019-09-26>
  ! Author:      Lee Justice <Lemster68@gmail.com>
  ! Internet:    http://github.com/ernell/ABB-RAPID-UTILITY-LIBRARY
  !*****************************************************
  
  ! Version 1.0  9-23-2016  LJ
  ! Version 1.1 10-04-2018  LJ  Will no longer write null value robtagets,
  ! i.e., "UNUSED" from VAR.DAT, also, will not write motions for "UNUSED"
  ! in order to eliminate clutter, useless stuff.
  ! Version 1.2  10-08-2016  LJ  Fixed bug in which a PULSE type position
  ! variable messed up the conversion.
  ! 
  !  This program will read a Motoman VAR.DAT, TOOL.CND and UFRAME.CND files
  !  and extract the position data, tool data and user frames, writing
  !  them into ABB modules with ABB datatypes.  It will also build
  !  a motion module populated with move instructions to move to the
  !  translated positions with the tool used and work object used same
  !  as was used in the Motoman.
  !  Copy the VAR.DAT, TOOL.CND and UFRAME.CND into the ABB "HOME"
  !  directory.  Run "ReadVarDat".  Four ABB modules will be written to
  !  the "HOME" directory:  ImportPos.mod, ImportTool.mod, ImportFrame.mod
  !  and ImportMotion.mod.  You may then load these modules into the 
  !  controller's memory.
  !  Developed and tested using files from DX100 controller, I do not know
  !  how the compatibility is with other controllers.
  
  PERS string stBuffer2{18}:=["//TOOL 0","///NAME CAL TOOL","-1.619","300.932","1016.922","0.0000","0.0000","0.0000","0.000","0.000","0.000","8.500","0.000","0.000","0.001","0.000","0","0"];
  PERS string stBuffer3{6}:=["950.00","0.000","50.000","0.0000","0.0000","90.0000"];
  PERS num nBuffer3{6}:=[1413.874,-2.064,117.457,0.0516,-0.0043,0.0255];
  VAR bool bToolUsed{64};
  VAR bool bFrameUsed{20};



  PROC ReadVarDat()
    VAR iodev Vardat;
    VAR iodev ToolCnd;
    VAR iodev UframeCnd;
    VAR iodev WriteMod;
    VAR iodev WriteToolMod;
    VAR iodev WriteFrameMod;
    VAR iodev WriteMotionMod;
    VAR string stReadpointer;
    VAR string stReadpointer2;
    VAR string stReadpointer3;
    VAR bool bGood;
    VAR bool bWriteOnce;
    VAR num nData;
    VAR num nX;
    VAR num nY;
    VAR num nZ;
    VAR num nRx;
    VAR num nRy;
    VAR num nRz;
    VAR string stPart;
    CONST string stUnused:="""UNUSED""";
    VAR string stBuffer{14}:=["","","","","","","","","","","","","",""];
    VAR string stText;
    VAR robtarget pTemp;

    Close Vardat;
    Close ToolCnd;
    Close UframeCnd;
    Open "Home" \File:="VAR.DAT", Vardat\Read;
    WHILE stReadpointer <> EOF DO
      ! start reading in the contents of the VAR.DAT file
      stText:=ReadStr(Vardat);
      stReadpointer:=ReadStr(Vardat\Delim:="\2C"\Discardheaders);
      IF stReadpointer = "///P" THEN
        ! all other variables have been read, now position
        ! variables have been reached.
        Close WriteMod;
        Open "HOME:" \File:="ImportPos.mod", WriteMod\Write;
        Write WriteMod, "MODULE ImportPos";
        Close WriteToolMod;
        Open "HOME:" \File:="ImportTool.mod", WriteToolMod\Write;
        Write WriteToolMod, "MODULE ImportTool";
        Close WriteToolMod;
        Open "HOME:" \File:="ImportFrame.mod", WriteFrameMod\Write;
        Write WriteFrameMod, "MODULE ImportFrame";
        Close WriteFrameMod;
        Open "HOME:" \File:="ImportMotion.mod", WriteMotionMod\Write;
        Write WriteMotionMod, "MODULE ImportMotion";
        Write WriteMotionMod, "  PROC motions()";
        Close WriteMotionMod;
        FOR i FROM 0 TO 1023 DO
          FOR m FROM 1 TO 14 DO
            stBuffer{m}:=ReadStr(Vardat\Delim:="\2C"\Discardheaders);
            IF stBuffer{1} = stUnused THEN
              GOTO Skip;
            ENDIF
          ENDFOR
          IF stBuffer{1} = """PULSE""0" THEN
            GOTO Skip;
          ENDIF
        Write WriteMod, "  PERS robtarget p" + ValToStr(i) + ":=[["\NoNewLine; 
Skip:
          IF stBuffer{1} = """RECTAN""0" THEN
            Close ToolCnd;
            Open "HOME:" \File:="TOOL.CND", ToolCnd\Read;
            stReadpointer2:=stEmpty;
            WHILE stReadpointer2 <> "//TOOL " + stBuffer{3} DO
              stReadpointer2:=ReadStr(ToolCnd\Delim:="\2C");
            ENDWHILE
            !Stop;
            IF stReadpointer2 = "//TOOL " + stBuffer{3} THEN
              stBuffer2{1}:=stReadpointer2;
              FOR j FROM 2 TO 17 DO
                stBuffer2{j}:=ReadStr(ToolCnd\Delim:="\2C");
              ENDFOR
            ENDIF
            bGood:=StrToVal(stBuffer{3},nData);
            nData:=nData + 1;
            IF NOT bToolUsed{nData} THEN
              Open "HOME:" \File:="ImportTool.mod", WriteToolMod\Append;
              Write WriteToolMod, "  PERS tooldata tMoto" + stBuffer{3} + ":=[TRUE,[["\NoNewLine;
              Write WriteToolMod, stBuffer2{3} + "," + stBuffer2{4} + "," + stBuffer2{5} + "]"\NoNewLine;
              bGood:=StrToVal(stBuffer2{8},nRz);
              bGood:=StrToVal(stBuffer2{7},nRy);
              bGood:=StrToVal(stBuffer2{6},nRx);
              Write WriteToolMod, ","\Orient:=NOrient(OrientZYX(nRz,nRy,nRx))\NoNewLine;
              Write WriteToolMod, "],[" + stBuffer2{12}\NoNewLine;
              bGood:=StrToVal(stBuffer2{9},nX);
              bGood:=StrToVal(stBuffer2{10},nY);
              bGood:=StrToVal(stBuffer2{11},nZ);
              Write WriteToolMod, ","\Pos:=[nX,nY,nZ]\NoNewLine;
              Write WriteToolMod, ",[1,0,0,0],0,0,0]];" + "  !" + stBuffer2{2};
              Close WriteToolMod;
              bToolUsed{nData}:=TRUE;
            ENDIF
            Close UframeCnd;
            Open "HOME:" \File:="UFRAME.CND", UframeCnd\Read;
            WHILE stReadpointer3 <> "//UFRAME " + stBuffer{2} DO
              IF stBuffer{2} = "0" THEN
                IF NOT bWriteOnce THEN
                  Open "HOME:" \File:="ImportFrame.mod", WriteFrameMod\Append;
                  Write WriteFrameMod, "  PERS wobjdata wobjMoto0:=[FALSE,TRUE,"""",[[0,0,0],"\NoNewLine;
                  Write WriteFrameMod, "[1,0,0,0]],[[0,0,0],[1,0,0,0]]];";
                  bWriteOnce:=TRUE;
                  Close WriteFrameMod;
                ENDIF
                GOTO Abort;
              ENDIF
              stReadpointer3:=ReadStr(UframeCnd\Delim:="\2C");
              ! If the end of file is reached without finding the 
              ! uframe we are looking for.
              IF stReadpointer3 = "EOF" Stop;
            ENDWHILE
            ! read the next seven lines to get to the BUSER, what is useful
            FOR k FROM 1 TO 7 DO
              stReadpointer3:=ReadStr(UframeCnd);
            ENDFOR
            FOR k FROM 1 TO 6 DO
              stBuffer3{k}:=ReadStr(UframeCnd\Delim:="\2C");
            ENDFOR
            stPart:=StrPart(stBuffer3{1},11,6);
            stBuffer3{1}:=stPart;
            bGood:=StrToVal(stBuffer3{1},nX);
            bGood:=StrToVal(stBuffer3{2},nY);
            bGood:=StrToVal(stBuffer3{3},nZ);
            bGood:=StrToVal(stBuffer{2},nData);
            IF NOT bFrameUsed{nData} THEN
              Open "HOME:" \File:="ImportFrame.mod", WriteFrameMod\Append;
              Write WriteFrameMod, "  PERS wobjdata wobjMoto" + stBuffer{2} + ":=[FALSE,TRUE,"""","\NoNewLine;
              Write WriteFrameMod, "["\Pos:=[nX,nY,nZ]\NoNewLine;
              bGood:=StrToVal(stBuffer3{6},nRz);
              bGood:=StrToVal(stBuffer3{5},nRy);
              bGood:=StrToVal(stBuffer3{4},nRx);
              Write WriteFrameMod, ","\Orient:=NOrient(OrientZYX(nRz,nRy,nRx))\NoNewLine;
              Write WriteFrameMod, "],[[0,0,0],[1,0,0,0]]];";
              Close WriteFrameMod;
              bFrameUsed{nData}:=TRUE;
            ENDIF
 Abort:
            Close UframeCnd;
            Write WriteMod, stBuffer{7} + ","\NoNewLine;
            Write WriteMod, stBuffer{8} + ","\NoNewLine;
            Write WriteMod, stBuffer{9} + "]"\NoNewLine;
            bGood:=StrtoVal(stBuffer{10},nRx);
            bGood:=StrtoVal(stBuffer{11},nRy);
            bGood:=StrtoVal(stBuffer{12},nRz);
            pTemp.rot:=NOrient(OrientZYX(nRz,nRy,nRx));
            Write WriteMod, ","\Orient:=pTemp.rot\NoNewLine;
            Write WriteMod, "," + "[0,0,0,0],[0,0,9E9,9E9,9E9,9E9]];";
          ELSEIF stBuffer{1} = stUnused THEN
            GOTO Skip2;
          ELSEIF stBuffer{1} = """PULSE""0" THEN
            GOTO Skip2;
          ELSE
            Stop;
            ! need to figure out what else is going on here
          ENDIF
          Open "HOME:" \File:="ImportMotion.mod", WriteMotionMod\Append;
          Write WriteMotionMod, "    MoveJ p" + ValToStr(i) + ",v100,fine," + "tMoto" + stBuffer{3} + "\\wobj:=wobjMoto" + stBuffer{2} + ";";
Skip2:
          Close WriteMotionMod;
        ENDFOR
        Write WriteMod, "ENDMODULE";
        Open "HOME:" \File:="ImportTool.mod", WriteToolMod\Append;
        Write WriteToolMod, "ENDMODULE";
        Open "HOME:" \File:="ImportFrame.mod", WriteFrameMod\Append;
        Write WriteFrameMod, "ENDMODULE";
        Open "HOME:" \File:="ImportMotion.mod", WriteMotionMod\Append;
        Write WriteMotionMod, "  ENDPROC";
        Write WriteMotionMod, "ENDMODULE";
        Close WriteMod;
        Close WriteToolMod;
        Close WriteFrameMod;
        Close WriteMotionMod;
      ENDIF
    ENDWHILE
  ENDPROC
	PROC Main()
		ReadVarDat;
		Stop;
	ENDPROC
ENDMODULE