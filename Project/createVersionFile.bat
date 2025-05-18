echo #################### %3 ################### >  %2
echo | set /p dummyName="head: "                    >> %2
%1 rev-parse --abbrev-ref HEAD                      >> %2
echo headenv: %GIT_BRANCH%                          >> %2
echo | set /p dummyName="hash: "                    >> %2
%1 rev-parse HEAD                                   >> %2
echo | set /p dummyName="date: "                    >> %2
%1 show -s --format=%%ai HEAD                       >> %2
echo | set /p dummyName="ccount: "                  >> %2
%1 rev-list --count HEAD                            >> %2
echo ############################################## >> %2
