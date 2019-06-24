@echo off
SETLOCAL enabledelayedexpansion
REM ////////////////////////////////////////////////////////////
REM 
REM ██╗██████╗ ██╗███████╗       ██████╗  █████╗ ████████╗    ███╗   ███╗ █████╗  ██████╗ ██╗ ██████╗
REM ██║██╔══██╗██║██╔════╝       ██╔══██╗██╔══██╗╚══██╔══╝    ████╗ ████║██╔══██╗██╔════╝ ██║██╔════╝
REM ██║██████╔╝██║███████╗       ██████╔╝███████║   ██║       ██╔████╔██║███████║██║  ███╗██║██║     
REM ██║██╔══██╗██║╚════██║       ██╔══██╗██╔══██║   ██║       ██║╚██╔╝██║██╔══██║██║   ██║██║██║     
REM ██║██║  ██║██║███████║    ██╗██████╔╝██║  ██║   ██║       ██║ ╚═╝ ██║██║  ██║╚██████╔╝██║╚██████╗
REM ╚═╝╚═╝  ╚═╝╚═╝╚══════╝    ╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝ ╚═════╝
REM 

REM ////////////////////////////////////////////////////////////
CALL :DISPLAY_IMAGE IRIS_BAT_MAGIC

REM ////////////////////////////////////////////////////////////
SET HELP_PAGE_URL=https://docs.google.com/document/d/1PeirNC95tBaTUcsZ-M9ZBNjpj9ViAIiyZ6VMsxO0oL4/edit?usp=sharing

REM ////////////////////////////////////////////////////////////
CALL :NEW_LINE_ECHO
CALL :UNDERLINED_SECTION_ECHO "--- Setup Git configs... ---"
CALL :NEW_LINE_ECHO

REM echo Current file is: %~nx0
SET current_file_name=%~nx0

REM ////////////////////////////////////////////////////////////

set is_info_incorect=false
IF "%current_file_name%"=="change.bat" set is_info_incorect=true
IF "%current_file_name%"=="iamstupid.bat" set is_info_incorect=true
IF "%current_file_name%"=="imstupid.bat" set is_info_incorect=true
IF "%current_file_name%"=="stupid.bat" set is_info_incorect=true
IF "%is_info_incorect%" == "true" (
    CALL :SET_GITHUB_USER_EMAIL
    CALL :SET_GITHUB_USER_NAME
    copy "%~nx0" "setup.bat"
    setup.bat & del "%~nx0" & pause
)

REM ////////////////////////////////////////////////////////////
CALL :IS_GITHUB_USER_EMAIL_SET email_is_set
IF %email_is_set% EQU TRUE (
    CALL :GET_GITHUB_USER_EMAIL_VALUE user_email_value
    CALL :CYAN_ECHO "Github user.email is set to "!user_email_value!""
    CALL :UNDERLINED_NOTE_ECHO "This is the user email we commit from"
) ELSE (
    CALL :SET_GITHUB_USER_EMAIL
)
CALL :NEW_LINE_ECHO

REM ////////////////////////////////////////////////////////////
CALL :IS_GITHUB_USER_NAME_SET username_is_set
IF %username_is_set% EQU TRUE (
    CALL :GET_GITHUB_USER_NAME_VALUE user_name_value
    CALL :CYAN_ECHO "Github user.name is set to "!user_name_value!""
    CALL :UNDERLINED_NOTE_ECHO "This is the user name we commit from"
) ELSE (
    CALL :SET_GITHUB_USER_NAME
)
CALL :NEW_LINE_ECHO

REM ////////////////////////////////////////////////////////////
IF %username_is_set% EQU TRUE (
    CALL :MAGENTA_ECHO "If your Github name or email are incorrect,"
    CALL :MAGENTA_ECHO "rename this file to change.bat and double click it to enter new values"
    CALL :NEW_LINE_ECHO
)

REM ////////////////////////////////////////////////////////////
CALL :BOLD_ECHO_AND_RUN "git config --global credential.helper store"
CALL :UNDERLINED_NOTE_ECHO "Remember my password"
CALL :NEW_LINE_ECHO

REM ////////////////////////////////////////////////////////////
CALL :BOLD_ECHO_AND_RUN "git config --global push.default simple"
CALL :UNDERLINED_NOTE_ECHO "Push only the current branch. We don't use branches in small projects because they cause confusion"
CALL :NEW_LINE_ECHO

REM ////////////////////////////////////////////////////////////
CALL :BOLD_ECHO_AND_RUN "git config --global http.postBuffer 524288000"
CALL :UNDERLINED_NOTE_ECHO "Enables you to push large files"
CALL :NEW_LINE_ECHO

REM ////////////////////////////////////////////////////////////
CALL :BOLD_ECHO_AND_RUN "git config --global core.compression 0"
CALL :UNDERLINED_NOTE_ECHO "Disables compression and uses less CPU and more Internet"
CALL :NEW_LINE_ECHO

REM ////////////////////////////////////////////////////////////
CALL :BOLD_ECHO_AND_RUN "git config --global core.longpaths true"
CALL :UNDERLINED_NOTE_ECHO "Commit without problems long paths and subfolders with a lot of characters"
CALL :NEW_LINE_ECHO

REM ////////////////////////////////////////////////////////////
CALL :UNDERLINED_SECTION_ECHO "--- Setup PHP panel without errors ---"
CALL :NEW_LINE_ECHO

REM ////////////////////////////////////////////////////////////
CALL :NEXT_COMMAND_ACTION_ECHO "Copy Database defines.php.TEMPLATE to defines.php"
CALL :NEXT_COMMAND_EXPLANATION_ECHO "We use defines.php.TEMPLATE to test different things and ignoring them on commit"
CALL :BOLD_ECHO_AND_RUN "copy custom-code\defines.php.TEMPLATE custom-code\defines.php"
CALL :NEW_LINE_ECHO

REM ////////////////////////////////////////////////////////////
CALL :NEXT_COMMAND_ACTION_ECHO "Copy Database config.php.TEMPLATE to config.php"
CALL :NEXT_COMMAND_EXPLANATION_ECHO "We use config.php.TEMPLATE file for different usernames and passwords on people workstations"
CALL :BOLD_ECHO_AND_RUN "copy custom-code\database\config.php.TEMPLATE custom-code\database\config.php"
CALL :IMPORTANT_ECHO "Default MySQL password in config.php is username:"root" password:"". Change it if you use something different"
CALL :NEW_LINE_ECHO

REM Ask if user wants help
REM ////////////////////////////////////////////////////////////
REM CALL :ASK_IF_USER_WANTS_HELP

REM ////////////////////////////////////////////////////////////
REM CALL :DISPLAY_IMAGE PRESS_KEY_TO_CONTINUE

REM Wait until key is pressed is the file was double clicked
REM ////////////////////////////////////////////////////////////
CALL :PAUSE_SCRIPT_IF_DOUBLE_CLICKED

REM This is the end of the program
REM ////////////////////////////////////////////////////////////
EXIT /B %ERRORLEVEL%

REM ////////////////////////////////////////////////////////////

REM Set functions we are going to use
REM ////////////////////////////////////////////////////////////

REM Function BOLD_ECHO_AND_RUN display param 1 and run it
REM Use it like this: 
REM CALL :BOLD_ECHO_AND_RUN "COMMAND_TO_RUN"
REM %~1 means the first argument passes to the functions
REM [1m and other are ANSI Escape Sequences
REM ////////////////////////////////////////////////////////////
:BOLD_ECHO_AND_RUN
    echo [1m  %~1 [0m
    %~1
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:BOLD_ECHO
    echo [1m  %~1 [0m
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:GREEN_ECHO
    echo [92m  %~1 [0m
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:MAGENTA_ECHO
    echo [95m  %~1 [0m
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:UNDERLINED_SECTION_ECHO
    echo  [4m[92m%~1[0m
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:UNDERLINED_NOTE_ECHO
    echo   [4m[93m^^%~1[0m
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:NEW_LINE_ECHO
    echo.
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:NEXT_COMMAND_ACTION_ECHO
    echo   [96m^> %~1[0m
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:CYAN_ECHO
    echo [96m  %~1[0m
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:NEXT_COMMAND_EXPLANATION_ECHO
    echo   [0m - %~1[0m
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:IMPORTANT_ECHO
    echo   [7m%~1[0m
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:OPEN_PANEL_HELP_PAGE
    start "" %HELP_PAGE_URL%
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:IS_GITHUB_USER_EMAIL_SET
    SET github_user_email_value=
    git config user.email > git_config_check
    SET /p github_user_email_value= < git_config_check
    DEL git_config_check
    REM echo github_user_email_value: %github_user_email_value%
    IF DEFINED github_user_email_value (
        REM echo github_user_email_value is DEFINED
        SET %~1=TRUE
    ) ELSE (
        REM echo github_user_email_value is NOT DEFINED
        SET %~1=FALSE
    )
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:GET_GITHUB_USER_EMAIL_VALUE
    SET github_user_email_value=
    git config user.email > git_config_check
    SET /p github_user_email_value= < git_config_check
    DEL git_config_check
    CALL :MAKE_VARIABLE_SAFE github_user_email_value "%github_user_email_value%"
    REM echo github_user_email_value: %github_user_email_value%
    SET %~1=%github_user_email_value%
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:SET_GITHUB_USER_EMAIL
    REM It's a strange fact that you can commit from another persons name https://superuser.com/questions/816341/github-lets-me-commit-as-another-user/1234339. Please don't do this here
    SET /p github_user_email=What is your Github Email?:
    CALL :MAKE_VARIABLE_SAFE github_user_email "%github_user_email%"
    echo [1m  git config --global --replace-all user.email %github_user_email%[0m
    CALL :UNDERLINED_NOTE_ECHO "This is the user email we commit from"
    git config --global --replace-all user.email %github_user_email%
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:IS_GITHUB_USER_NAME_SET
    SET github_user_name_value=
    git config user.name > git_config_check
    SET /p github_user_name_value= < git_config_check
    DEL git_config_check
    REM echo github_user_name_value: %github_user_name_value%
    IF DEFINED github_user_name_value (
        REM echo github_user_name_value is DEFINED
        SET %~1=TRUE
    ) ELSE (
        REM echo github_user_name_value is NOT DEFINED
        SET %~1=FALSE
    )
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:GET_GITHUB_USER_NAME_VALUE
    SET github_user_name_value=
    git config user.name > git_config_check
    SET /p github_user_name_value= < git_config_check
    DEL git_config_check
    CALL :MAKE_VARIABLE_SAFE github_user_name_value "%github_user_name_value%"
    REM echo github_user_email_value: %github_user_name_value%
    SET %~1=%github_user_name_value%
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:SET_GITHUB_USER_NAME
    REM It's a strange fact that you can commit from another persons name https://superuser.com/questions/816341/github-lets-me-commit-as-another-user/1234339. Please don't do this here
    SET /p github_user_name=What is your Github Username?:
    CALL :MAKE_VARIABLE_SAFE github_user_name "%github_user_name%"
    echo [1m  git config --global --replace-all user.name %github_user_name%[0m
    CALL :UNDERLINED_NOTE_ECHO "This is the user name we commit from"
    git config --global --replace-all user.name %github_user_name%
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:PAUSE_SCRIPT_IF_DOUBLE_CLICKED
    SETLOCAL enabledelayedexpansion
        set current_call_line=%cmdcmdline:"=%
        REM echo current_call_line: %current_call_line%
        REM echo Current file is: %~nx0
        set current_call_line_without_file_name=!current_call_line:%~nx0=!
        REM echo current_call_line_without_file_name: %current_call_line_without_file_name%
        if not "%current_call_line%" == "%current_call_line_without_file_name%" pause
    ENDLOCAL
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:ASK_IF_USER_WANTS_HELP
    SET display_help=
    SET /p display_help=Skip help page with more info?(Y/N):
    IF NOT DEFINED display_help SET "display_help=y"
    REM echo You typed: %display_help%
    if /i %display_help%==n CALL :OPEN_PANEL_HELP_PAGE
EXIT /B 0

:MAKE_VARIABLE_SAFE
    SET variable_to_make_safe="%~2"
    REM echo variable_to_make_safe: %variable_to_make_safe%
    SET variable_to_make_safe_without_spaces=%variable_to_make_safe: =%
    REM echo variable_to_make_safe_without_spaces: %variable_to_make_safe_without_spaces%
    IF NOT %variable_to_make_safe%==%variable_to_make_safe_without_spaces% (
        REM echo variable HAVE spaces
        SET %~1="%~2"
    ) ELSE (
        REM echo variable DOESN'T HAVE spaces
        SET %~1=%~2
    )
EXIT /B 0

REM ////////////////////////////////////////////////////////////
:DISPLAY_IMAGE
    for /f "delims=: tokens=1*" %%A in ('findstr /b ":::%~1:::" "%~f0"') do (echo.%%B)
EXIT /B 0

REM Image definitions are below
REM ////////////////////////////////////////////////////////////

REM ////////////////////////////////////////////////////////////
::IMAGE:PRESS_KEY_TO_CONTINUE::
:::PRESS_KEY_TO_CONTINUE::: 
:::PRESS_KEY_TO_CONTINUE:::       _ _,---._
:::PRESS_KEY_TO_CONTINUE:::    ,-','       `-.___
:::PRESS_KEY_TO_CONTINUE:::   /-;'               `._
:::PRESS_KEY_TO_CONTINUE:::  /\/          ._   _,'o \
:::PRESS_KEY_TO_CONTINUE::: ( /\       _,--'\,','"`. )
:::PRESS_KEY_TO_CONTINUE:::  |\      ,'o     \'    //\
:::PRESS_KEY_TO_CONTINUE:::  |      \        /   ,--'""`-.
:::PRESS_KEY_TO_CONTINUE:::  :       \_    _/ ,-'         `-._
:::PRESS_KEY_TO_CONTINUE:::   \        `--'  /                )
:::PRESS_KEY_TO_CONTINUE:::    `.  \`._    ,'     ________,','
:::PRESS_KEY_TO_CONTINUE:::      .--`     ,'  ,--` __\___,;'
:::PRESS_KEY_TO_CONTINUE:::       \`.,-- ,' ,`_)--'  /`.,'
:::PRESS_KEY_TO_CONTINUE:::        \( ;  | | )      (`-/
:::PRESS_KEY_TO_CONTINUE:::          `--'| |)       |-/
:::PRESS_KEY_TO_CONTINUE:::            | | |        | |
:::PRESS_KEY_TO_CONTINUE:::            | | |,.,-.   | |_
:::PRESS_KEY_TO_CONTINUE:::            | `./ /   )---`  )
:::PRESS_KEY_TO_CONTINUE:::           _|  /    ,',   ,-'
:::PRESS_KEY_TO_CONTINUE:::          ,'|_(    /-<._,' |--,
:::PRESS_KEY_TO_CONTINUE:::          |    `--'---.     \/ \
:::PRESS_KEY_TO_CONTINUE:::          |          / \    /\  \
:::PRESS_KEY_TO_CONTINUE:::        ,-^---._     |  \  /  \  \
:::PRESS_KEY_TO_CONTINUE:::     ,-'        \----'   \/    \--`.
:::PRESS_KEY_TO_CONTINUE:::    /            \              \   \
:::PRESS_KEY_TO_CONTINUE::: 
REM ////////////////////////////////////////////////////////////

REM ////////////////////////////////////////////////////////////
::IMAGE:IRIS_BAT_MAGIC::
:::IRIS_BAT_MAGIC:::    __     __       __       ___                __     __  
:::IRIS_BAT_MAGIC::: | |__) | /__`     |__)  /\   |      |\/|  /\  / _` | /  ` 
:::IRIS_BAT_MAGIC::: | |  \ | .__/    .|__) /~~\  |      |  | /~~\ \__> | \__, 
:::IRIS_BAT_MAGIC:::
REM ////////////////////////////////////////////////////////////

REM ////////////////////////////////////////////////////////////