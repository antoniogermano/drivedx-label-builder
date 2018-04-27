--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~--   --~~-- GLOBAL VARIABLES

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

global mainAppName
global mainAppPath
global parentFolderPath
global progressBarScript
global errorCode




--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~--   --~~-- HANDLES

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

on getInfo()
    
    -- sets beginning part of error codes
    set errorCode to "APL_SCRIPT_TMPLATE_ERROR: "

    -- gets this application's / script's name
    set mainAppName to name of me

    -- gets this application's / script's path
    set mainAppPath to path to me

    -- gets the parent folder of this application
    tell application "Finder" to set parentFolderPath to parent of mainAppPath
end getInfo
------------------------------

on sendReport(errorNumber)

    -- TODO send error report
end sendReport
------------------------------

on mainAppError(errorNumber)

    -- displays dialog with error code and error number. prompts user to send report or not
    set response to (display dialog errorCode & errorNumber & return & return & mainAppName & " encountered an error and needs to close. Would you like to send an error report" with title mainAppName buttons {"No", "Yes"} default button "Yes")

    -- if user input is yes then sends report
    if button returned of response is "Yes" then sendReport(errorNumber)

    -- quits this app
    quit
end mainAppError
------------------------------

on appError(errorNumber, appName)

    -- displays dialog with error code, error number, and app name
    try
        set response to (display dialog errorCode & errorNumber & return & return & appName & " encountered an error and could not open. would you like to try and reopen?" buttons {"Retry", "Continue"} default button "Continue")
    on error
        mainAppError("0001")
    end try

    if response is "Retry" then
        try
            openApp(appName)
        on error
            display dialog "Unable to open " & appName & ". Ensure that it is installed and uncorrupted" with title mainAppName buttons {"", ""}
        end try
    end if
end appError
------------------------------

on displayNotification(nMessage, nTitle, nSubtitle, nSound)

    -- activates finder (so notification can be displayed), displays notification with given information, and activates main app (so it is the frontmost window)
    tell application "Finder" to activate
    display notification nMessage with title nTitle subtitle nSubtitle sound name nSound
    tell application mainAppName to activate
end displayNotification
------------------------------

on startProgressBar(a, b, c, d)

    -- starts a new progress bar or resets current one
    tell progressBarScript to startProgressBar(a, b, c, d)
end startProgressBar
------------------------------

on advanceProgressBar(a, b, c, d)

    -- advances current open progress bar
    tell progressBarScript to advanceProgressBar(a, b, c, d)
end advanceProgressBar
------------------------------

on findFile(tmpPath, scriptName)

    -- searchs for given fileName in tmpPath and returns results
    set searchResults to (do shell script "mdfind -onlyin " & POSIX path of tmpPath & " -name " & scriptName)
    return searchResults
end findFile
------------------------------

on loadScript(scriptName) -- loads script by fin

    -- gets path to script by searching for given name
    findFile(parentFolderPath as alias, scriptName)
    set tmpScriptPath to result

    display dialog tmpScriptPath

    -- loads script file
    set tmpScript to load script file tmpScriptPath
    return tmpScript
end loadScript
------------------------------

on loadScripts() -- loads various scripts using loadScript handle

    -- loads progress bar script
    loadScript("progressBar")
    set progressBarScript to result
end loadScripts
------------------------------

on openApp(errorNumber, appName)

    -- opens app by given name
    try
        tell application appName to activate
    on error
        appError(errorNumber, appName)
    end try
end openApp





--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~~~~~~--   --~~-- MAIN SCRIPT

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

getInfo()
loadScripts()

--startProgressBar(0, 0, "Test progress bar", "Loading...")




--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--   --~~-- END

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--