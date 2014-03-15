@echo off

REM -- Laravel 4 Commander --

call:setTitle

IF "%1"=="" goto:eof
IF "%1"=="setup" call:setup %*
IF "%1"=="install" call:install %1 %2
IF "%1"=="p" call:setup setup project %2
IF "%1"=="project" call:setup setup project %2
IF "%1"=="c" call:controller %*
IF "%1"=="controller" call:controller %*
IF "%1"=="m" call:model %*
IF "%1"=="model" call:model %*
IF "%1"=="v" call:view %*
IF "%1"=="view" call:view %*
IF "%1"=="mig" call:migration %*
IF "%1"=="migration" call:migration %*
IF "%1"=="r" call:resource %*
IF "%1"=="resource" call:resource %*
IF "%1"=="migrate" call:migrate %1 %2
IF "%1"=="rollback" call:rollback
IF "%1"=="artisan" call:artisan %*
IF "%1"=="help" call:help
IF "%1"=="info" call:info
IF "%1"=="composer" call:composer %*
IF "%1"=="s" call:scaffold %*
IF "%1"=="scaffold" call:scaffold %*
IF "%1"=="seed" call:seed %*
goto:eof

::subroutines follow

:setTitle
    SET version=1.2
    SET title=Laravel 4 Commander - v%version%
    TITLE %title%
goto:eof


:setup
    IF "%2"=="composer" (
        call:setupComposer %*
        goto:savedTxt
        goto:eof
    )
    IF "%2"=="base" (
        call:setupProjectBase
        goto:savedTxt
        goto:eof
    )
    IF "%2"=="project" (
        call:setupProject %*
        goto:savedTxt
        goto:eof
    )

    call:setupComposer
    cls
    call:setupProjectBase
    goto:savedTxt

goto:eof

:savedTxt
    cls
    echo.
    echo Settings have be saved
    echo.
    call:info
    ::pause
goto:eof

:setupComposer
    call:readSettings
    IF "%3"=="rollback" (
    call:buildSettings cRollback
    goto:eof
    )
    setlocal enableextensions enabledelayedexpansion
    echo Composer setup
    echo.
    echo Do you want to use the following as the composer run command?
    echo.
    echo %COMPOSER_CALL%
    echo.
    set /P composerq1=(y/n) :
    IF "%composerq1%"=="n" (
    echo.
    set /P composerq2=Enter new path :
    IF "!composerq2!" NEQ "" (
    call:buildSettings composer !composerq2!
    echo.
    echo Path has been changed
    echo.
    )
    )
    endlocal
goto:eof

:setupProjectBase
    call:readSettings
    setlocal enableextensions enabledelayedexpansion
    echo Project Base
    echo.
    echo Do you want to use the following as your project base dir?
    echo.
    echo %PROJECT_BASE_DIR%
    echo.
    set /P pb1=(y/n) :
    IF "%pb1%"=="n" (
        echo.
        set /P pb2=Enter new path [no trailing slash]:
        IF "!pb2!" NEQ "" (
            IF NOT EXIST !pb2! goto:noprojectbase !pb2!
            call:buildSettings base !pb2!
        )
    )
    endlocal
goto:eof

:setupProject
    call:readSettings
    IF "%3" NEQ "" (
        IF NOT EXIST %PROJECT_BASE_DIR%\%3\artisan goto:proj_notexists
        call:buildSettings project %3
        goto:eof
    )
    setlocal enableextensions enabledelayedexpansion
    echo Working Project
    echo.
    echo Do you want to use the following as your working project?
    echo.
    echo %PROJECT_FOLDER%
    echo.
    set /P pf1=(y/n):
    IF "%pf1%"=="n" (
        echo.
        set /P pf2=Enter new folder [no trailing slash] :
        IF "!pf2!" NEQ "" (
            IF NOT EXIST %PROJECT_BASE_DIR%\!pf2!\artisan goto:proj_notexists
            call:buildSettings project !pf2!
        )
    )
    endlocal
goto:eof


:buildSettings
    IF "%1"=="composer" (
        echo SET PROJECT_BASE_DIR=%PROJECT_BASE_DIR%> laravel4_current.cmd
        echo SET PROJECT_FOLDER=%PROJECT_FOLDER%>> laravel4_current.cmd
        echo SET COMPOSER_CALL=%2>> laravel4_current.cmd
        echo SET COMPOSER_CALL_DEFAULT=%COMPOSER_CALL_DEFAULT%>> laravel4_current.cmd
        goto:eof
    )
    IF "%1"=="base" (
        echo SET PROJECT_BASE_DIR=%2> laravel4_current.cmd
        echo SET PROJECT_FOLDER=%PROJECT_FOLDER%>> laravel4_current.cmd
        echo SET COMPOSER_CALL=%COMPOSER_CALL%>> laravel4_current.cmd
        echo SET COMPOSER_CALL_DEFAULT=%COMPOSER_CALL_DEFAULT%>> laravel4_current.cmd
    )
    IF "%1"=="project" (
        echo SET PROJECT_BASE_DIR=%PROJECT_BASE_DIR%> laravel4_current.cmd
        echo SET PROJECT_FOLDER=%2>> laravel4_current.cmd
        echo SET COMPOSER_CALL=%COMPOSER_CALL%>> laravel4_current.cmd
        echo SET COMPOSER_CALL_DEFAULT=%COMPOSER_CALL_DEFAULT%>> laravel4_current.cmd
    )
    IF "%1"=="cRollback" (
        echo SET PROJECT_BASE_DIR=%PROJECT_BASE_DIR%> laravel4_current.cmd
        echo SET PROJECT_FOLDER=%PROJECT_FOLDER%>> laravel4_current.cmd
        echo SET COMPOSER_CALL=%COMPOSER_CALL_DEFAULT%>> laravel4_current.cmd
        echo SET COMPOSER_CALL_DEFAULT=%COMPOSER_CALL_DEFAULT%>> laravel4_current.cmd
    )

goto:eof


:install
    call:readSettings installcheck
    echo Installing Laravel to %2
    IF "%2"=="" GOTO no_dest
    IF EXIST %PROJECT_BASE_DIR%\%2 GOTO dest_exists
    call:changeBase

    echo.
    echo Running composer setup
    echo Please wait.....
    %COMPOSER_CALL% create-project laravel/laravel %2 --prefer-dist


    call:buildSettings project %2
    call:readSettings change


    echo.
    echo Install complete
    echo The working project has been set to this new installation
    echo.
    pause
    exit
goto:eof

:no_dest
    echo You didn't enter a project folder
    echo Cancelling Installation
    pause
goto:eof

:dest_exists
    echo.
    echo Destination already exists
    echo %2
    echo.
    echo Cancelling Installation
    pause
goto:eof

:proj_notexists
    echo.
    echo The project location can not be found !
    echo.
    echo If you intended to start a new project please call:
    echo install [folder_location]
    echo.
    echo Otherwise please run again with a current project destination.
    echo.
    pause
    exit
goto:eof


:readSettings
    :: set local vars from laravel_current.cmd
    IF NOT EXIST laravel4_current.cmd goto:nosettings
    IF EXIST laravel4_current.cmd call laravel4_current.cmd

    IF "%~1"=="installcheck" (
        IF "%PROJECT_BASE_DIR%"=="" goto:projectDirMissing
        IF NOT EXIST %PROJECT_BASE_DIR% goto:noprojectbase
    )
    IF "%~1"=="change" (
        IF "%PROJECT_BASE_DIR%"=="" goto:projectDirMissing
        IF NOT EXIST %PROJECT_BASE_DIR% goto:noprojectbase
        IF NOT EXIST %PROJECT_BASE_DIR%\%PROJECT_FOLDER% goto:noproject
        %PROJECT_BASE_DIR:~,1%:
        cd %PROJECT_BASE_DIR%\%PROJECT_FOLDER%
    )
goto:eof

:changeBase
    IF "%PROJECT_BASE_DIR%"=="" goto:projectDirMissing
    IF NOT EXIST %PROJECT_BASE_DIR% goto:noprojectbase
    %PROJECT_BASE_DIR:~,1%:
    cd %PROJECT_BASE_DIR%
goto:eof

:projectDirMissing
    echo.
    echo The Project base path has not yet been set.
    echo.
    echo Please run setup
    pause
    exit
goto:eof

:nosettings
    echo.
    echo The Settings file(laravel4_current.cmd) could not be found.
    echo.
    echo Please make sure you have all files within this folder
    echo %cd%
    pause
    exit
goto:eof

:noproject
    echo.
    echo A working project has not been found.
    echo.
    echo Please set this using: project [project_dir]
    pause
    exit
goto:eof

:noprojectbase
    echo.
    echo The project base folder could not be found.
    echo %PROJECT_BASE_DIR% %1
    echo.
    echo Please create the folder and try again.
    pause
    exit
goto:eof

:info
    call:readSettings
    echo The project base folder is: %PROJECT_BASE_DIR%
    echo.
    echo The current working folder is: %PROJECT_FOLDER%
    echo.
    echo The current composer call is: %COMPOSER_CALL%
    echo.
    pause
goto:eof


:artisan
    setlocal enableextensions enabledelayedexpansion
    set extras=
    SET /A COUNT=1
    FOR %%A IN (%*) DO (
        IF "!COUNT!" gtr "2" (
            set extras=!extras! %%A
        )
       SET /A COUNT+=1
    )
    IF "%extras%" NEQ "" set extras=%extras:~1%
    call:readSettings change
    php artisan %2 %extras%
    endlocal
    pause
goto:eof

:composer
    setlocal enableextensions enabledelayedexpansion
    call:readSettings change

    if "%2"=="d" (
        %COMPOSER_CALL% dump-autoload -o
        endlocal
        pause
        goto:eof
    )

    set extras=
    SET /A COUNT=1
    FOR %%A IN (%*) DO (
        IF "!COUNT!" gtr "2" (
            set extras=!extras! %%A
        )
       SET /A COUNT+=1
    )
    IF "%extras%" NEQ "" set extras=%extras:~1%
    %COMPOSER_CALL% %2 %extras%
    endlocal
    pause
goto:eof

:controller
    setlocal enableextensions enabledelayedexpansion
    set extras=
    SET /A COUNT=1
    FOR %%A IN (%*) DO (
        IF "!COUNT!" gtr "2" (
        set extras=!extras! %%A
        )
       SET /A COUNT+=1
    )
    IF "%extras%" NEQ "" set extras=%extras:~1%
    call:readSettings change
    php artisan generate:controller %2 %extras%
    endlocal
    pause
goto:eof

:model
    call:readSettings change
    php artisan generate:model %2
    pause
goto:eof

:view
    setlocal enableextensions enabledelayedexpansion
    set extras=
    SET /A COUNT=1
    FOR %%A IN (%*) DO (
        IF "!COUNT!" gtr "2" (
            IF "%%A"=="--path" (
                set extras=!extras! %%A=
            ) else (
                set extras=!extras! %%A
            )
        )
       SET /A COUNT+=1
    )
    call:readSettings change
    php artisan generate:view %2 %extras%
    endlocal
    pause
goto:eof

:migration
    setlocal enableextensions enabledelayedexpansion
    set extras=
    SET /A COUNT=1
    FOR %%A IN (%*) DO (
        IF "!COUNT!" gtr "2" (
            IF "%%A"=="--fields" (
                set extras=!extras! %%A=
            ) else (
                set extras=!extras! %%A
            )
        )
       SET /A COUNT+=1
    )
    call:readSettings change
    php artisan generate:migration %2 %extras%
    endlocal
    echo.
    pause
goto:eof

:migrate
    call:readSettings change
    IF "%2"=="install" (
    php artisan migrate:install
    pause
    goto:eof
    ) else (
    php artisan migrate
    )
    pause
goto:eof

:rollback
    call:readSettings change
    php artisan migrate:rollback
    pause
goto:eof

:resource
    setlocal enableextensions enabledelayedexpansion
    set extras=
    SET /A COUNT=1
    FOR %%A IN (%*) DO (
        IF "!COUNT!" gtr "2" (
            IF "%%A"=="--fields" (
                set extras=!extras! %%A=
            ) else (
                set extras=!extras! %%A
            )
        )
       SET /A COUNT+=1
    )
    call:readSettings change
    php artisan generate:resource %2 %extras%
    endlocal
    pause
goto:eof


:scaffold
    setlocal enableextensions enabledelayedexpansion
    set extras=
    SET /A COUNT=1
    FOR %%A IN (%*) DO (
        IF "!COUNT!" gtr "2" (
            IF "%%A"=="--fields" (
                set extras=!extras! %%A=
            ) else (
                set extras=!extras! %%A
            )
        )
       SET /A COUNT+=1
    )
    call:readSettings change
    php artisan generate:scaffold %2 %extras%
    endlocal
    pause
goto:eof

:seed
    setlocal enableextensions enabledelayedexpansion
    set extras=
    SET /A COUNT=1
    FOR %%A IN (%*) DO (
        IF "!COUNT!" gtr "2" (
            set extras=!extras! %%A
        )
       SET /A COUNT+=1
    )
    IF "%extras%" NEQ "" set extras=%extras:~1%
    call:readSettings change
    php artisan generate:seed %2 %extras%
    endlocal
    pause
goto:eof

:help
echo The following commands are available
echo.
echo -- Settings --
echo setup	-Starts the setup routine by running all individual settings below.
echo setup composer [rollback]	-Runs the composer command setup
echo setup base		-Set the project base dir
echo setup project [dir_name]	-Set the working project folder
echo setup json	[rollback]	-Set the composer.json download location
echo setup app [rollback]	-Set the app.php download location
echo.
echo The optional rollback commands will reset the individual items back to their defaults
echo.
echo -- General --
echo help	-Show the help text.
echo info	-Shows the current settings.
echo project [dir_name]	-Change the working project folder.
echo install [dir_name]	-Install Laravel to chosen folder within the project base and set as current project.
echo.
echo -- Controller --
echo c [name] [methods/actions]
echo controller [name] [methods/actions]
echo Example: c Admin
echo.
echo -- Model --
echo m [name]
echo model [name]
echo Example: m Post
echo.
echo -- View --
echo v [name/s]
echo view [name/s]
echo example: v dog
echo.
echo -- Migration --
echo mig [action] [schema]
echo migration [action] [schema]
echo Example: mig create_posts_table --fields="title:string, body:text"
echo.
echo migrate [install]	-To execute the migrate, include install to set up migration tables
echo rollback	-To execute the rollback
echo.
echo -- Other --
echo r [name]
echo resource [name]
echo Example: r dog --fields="name:string"
echo s [name]
echo scaffold [name]
echo Example: s tweet --fields="author:string, body:text"
echo.
echo seed [name]
echo Example: seed dog
echo.
echo artisan [command]	-Run any command in the current working project
echo composer [command] -Run any composer command in the current working project
echo composer d -Runs composer dump-autoload -o
echo.
pause
goto:eof