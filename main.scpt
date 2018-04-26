--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~--   --~~-- GLOBAL VARIABLES

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

global mainAppName
global mainAppPath
global progressBarScript





--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~--   --~~-- HANDLES

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

on getInfo()
    
    -- gets this application's / script's name
    set mainAppName to name of me

    -- gets this application's / script's path
    set mainAppPath to path to me
end getInfo
------------------------------

on mainAppError(errorNumber)

end mainAppError
------------------------------

on appError(errorDescription, appName)
    display dialog appName & " encountered an error"
end appError
------------------------------

on startProgressBar(a, b, c, d)

    -- starts a new progress bar or resets current one
    tell progressBarScript to startProgressBar(a, b, c, d)
end startProgressBar
------------------------------

on advanceProgressBar()

    -- advances current open progress bar
    tell progressBarScript to startProgressBar(a, b, c, d)
end advanceProgressBar
------------------------------

on findFile(searchPath, fileName)

    -- searchs for given fileName in given searchPath
    ((path to me as text) & "Contents:Resources:Scripts:" & scriptName & ".scpt")
    return filePath
end findFile
------------------------------

on loadScript(scriptName) -- usage = "tell tmpScript to handleName()"

    -- gets path to script by searching for given name
    findFile(path to me, scriptName)
    set tmpScriptPath to result

    -- gets POSIX path of previous path
    set tmpScriptPathPOSIX to POSIX path of tmpScriptPath

    -- loads script file
    set tmpScript to load script file tmpScriptPath
    return tmpScript
end loadScript
------------------------------

on loadScripts()

    -- loads progress bar script
    loadScript("progressBar")
    set progressBarScript to result
end loadScripts





--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~~~~~~--   --~~-- MAIN SCRIPT

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

getInfo()
loadScripts()
startProgressBar(0, 0, "Test progress bar", "Loading...")




--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--   --~~-- END

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--