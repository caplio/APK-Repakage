set file=%1
set fname=%~n1%~x1
set sname=%~n1
set rundir=%~d0%~p0

cd %rundir%
mkdir tmp
xcopy %file% tmp\

java -jar tools\signapk.jar tools\testkey.x509.pem tools\testkey.pk8 tmp\%fname% %sname%-Sign.zip

pause
