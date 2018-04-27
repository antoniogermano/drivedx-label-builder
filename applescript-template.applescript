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
		mainAppError("001-" & errorNumber)
	end try
	
	-- tries to open app again
	if response is "Retry" then
		try
			openApp(appName)
		on error
			display dialog "Unable to open " & appName & ". Ensure that it is installed and uncorrupted" with title mainAppName buttons {"Okay"} default button "Okay"
		end try
	end if
end appError
------------------------------

on openApp(errorNumber, appName)
	
	-- opens app by given name
	try
		activate application appName
	on error
		appError(errorNumber, appName)
	end try
end openApp
------------------------------

on displayNotification(nMessage, nTitle, nSubtitle, nSound)
	
	-- activates finder (so notification can be displayed), displays notification with given information, and activates main app (so it is the frontmost window)
	activate application "Finder"
	display notification nMessage with title nTitle subtitle nSubtitle sound name nSound
	activate application mainAppName
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

on loadScript(scriptName) -- loads script by given name
	
	-- gets path to script by searching for given name
	set searchResults to findFile(parentFolderPath as alias, scriptName)
    set searchResultsParagraphs to paragraphs of searchResults
    set searchResultsLength to length of searchResultsParagraphs

    -- 
    if searchResultsLength is 0 then
        displayNotification("", mainAppName, scriptName & " was not found", "Basso")
		mainAppError("002-" & scriptName)
    else if searchResultsLength is 1 then
        set searchResult to searchResults
    else if searchResultsLength is greater than 1 then
        set searchResult to (choose from list searchResultsParagraphs with prompt "Multiple files found matching " & scriptName & return & return & "please select the desired file" with title mainAppName)
        if searchResult is false then quit
    end if

	-- loads script file
	try
		set tmpScript to (load script file (searchResult as alias))
	on error e
		--displayNotification("", mainAppName, "Error loading script file " & scriptName, "Basso")
		mainAppError("003-" & scriptName & return & return & e)
	end try
	
	return tmpScript
end loadScript
------------------------------

on loadScripts() -- loads various scripts using loadScript handle
	
	-- loads progress bar script
	loadScript("progressBar")
	set progressBarScript to result
end loadScripts
------------------------------

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