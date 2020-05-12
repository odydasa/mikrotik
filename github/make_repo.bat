@ECHO OFF
SETLOCAL
FOR /F %%A IN (README.md) DO CALL :make %%A
git add .
git commit -m "Add github repositories"
git push
ENDLOCAL
GOTO :EOF

:make
SET _git=%*
IF NOT DEFINED _git GOTO :EOF
IF "%_git:~0,1%"=="#" GOTO :EOF
IF "%_git:~0,1%"==";" GOTO :EOF
ECHO Cloning: %_git%
FOR %%A IN ("%_git%") DO SET _folder=%%~dpA
SET _folder=%_folder:~0,-1%
FOR %%A IN ("%_folder%") DO SET _folder=%%~nxA
IF EXIST "%_folder%" (
  git rm -r -f "%_folder%" > nul
  git rm --cached "%_folder%" > nul
  IF EXIST "%_folder%" RD /S /Q "%_folder%" > nul
)
git fetch %_git% "%_folder%"
RD /S /Q "%_folder%\.git"
icacls "%_folder%" /setowner Everyone /C /T /L > nul
attrib -a -i "%_folder%" /S /D /L
git add "%_folder%" > nul
ECHO.
GOTO :EOF