@echo off
rem --------------------------------------------------------
rem ▼パスの詳細
rem
rem  set dropfpath=%1             //　ファイルフルパス（c:\XXX\XXX\xxx.file）
rem  set fname=%~n1%~x1      //　ファイル名（XXX.apk）
rem  set sfname=%~n1　　　　　//　ファイル名のみ（XXX.apkのXXX部分）
rem  set rundir=%~d0%~p0　　 //　batファイルのPATH
rem
rem --------------------------------------------------------


set dropfpath=%1
set fname=%~n1%~x1
set sname=%~n1
set rundir=%~d0%~p0

rem --------------------------------------------------------
rem - Dropしたファイルをtmpフォルダにコピー
rem - Dropしたファイルをfname%.origとしてoutputへコピー
rem --------------------------------------------------------

cd %rundir%
mkdir tmp
mkdir output
xcopy %dropfpath% tmp\
echo F | xcopy /y %dropfpath% output\%fname%.orig

rem --------------------------------------------------------
rem - apktoolで、Dropしたtmp配下のapkファイルを展開
rem --------------------------------------------------------

cd tmp
call apktool d -s -f %fname%

rem --------------------------------------------------------
rem - values-enをvalues-jaとしてコピー
rem --------------------------------------------------------

xcopy /S /E %sfname%\res\values-en %sfname%\res\values-ja\

rem --------------------------------------------------------
rem - apktool で、repakage
rem --------------------------------------------------------

call apktool b %sfname%

rem --------------------------------------------------------
rem - 作成されたresources.arscファイルを7za（未圧縮）で上書き
rem --------------------------------------------------------

xcopy %sfname%\build\apk\resources.arsc .\
7za.exe u -tzip -mx=0 %fname% resources.arsc

rem --------------------------------------------------------
rem - 完成したapkファイルをouputディレクトリにコピー
rem --------------------------------------------------------

cd %rundir% 
echo F | xcopy tmp\%fname% output\%fname%


rem --------------------------------------------------------
rem - tmpディレクトリを削除
rem --------------------------------------------------------

rmdir /s /q tmp
pause
