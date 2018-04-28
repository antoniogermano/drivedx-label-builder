--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~--   --~~-- GLOBAL VARIABLES

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

global mainAppName
global mainAppPath
global parentFolderPath
global errorCode
global appList

global reportError
global sendReportScript
global progressBarScript





--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~--   --~~-- HANDLES

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

on sendReport(a, b, c, d)
	
	-- runs sendReport from sendReport script with given info
	if reportError is yes then
		display dialog "Error loading send report script. Unable to send report" with title mainAppName buttons {"Okay"} default button "Okay"
		quit
	else
		tell sendReportScript to sendReport()
	end if
end sendReport
------------------------------

on mainAppError(errorNumber, description)
	
	-- displays dialog with error code and error number. prompts user to send report or not
	set response to (display dialog errorCode & errorNumber & return & return & mainAppName & " encountered an error and needs to close. Would you like to send an error report?" & return & return & "details: " & return & description with title mainAppName buttons {"No", "Yes"} default button "Yes")
	
	-- if user input is yes then sends report
	if button returned of response is "Yes" then sendReport(mainAppName, errorCode, errorNumber, description)
end mainAppError
------------------------------

on appError(errorNumber, appName, description)
	
	-- displays dialog with error code, error number, and app name
	try
		set response to (display dialog errorCode & errorNumber & appName & return & return & appName & " encountered an error" & return & return & description buttons {"Continue"} default button "Continue")
	on error
		mainAppError("M001-" & errorNumber, "couldn't display error after failing to open " & appName)
		quit
	end try
end appError
------------------------------

on openApp(appName)
	
	-- opens app by given name
	try
		activate application appName
		if appName is "Terminal" then
			tell application "Terminal" to close windows
			delay 0.5
		end if
	on error e
		appError("A001-", appName, e)
	end try
end openApp
------------------------------

on openApps(appNames)
	
	-- opens multiple apps in one command
	repeat with appName in appNames
		openApp(appName)
	end repeat
end openApps
------------------------------

on quitApp(appName)
	
	-- quits app by given name
	try
		do shell script "killall '" & appName & "'"
	on error killallError
		try
			do shell script "pkill '" & appName & "'"
		on error pkillError
			appError("A002-", appName, killallError & return & pkillError)
		end try
	end try
end quitApp
------------------------------

on quitApps(appNames)
	
	-- quits multiple apps in one command
	repeat with appName in appNames
		if application appName is running then quitApp(appName)
	end repeat
end quitApps
------------------------------

on displayNotification(nMessage, nTitle, nSubtitle, nSound)
	
	-- activates finder (so notification can be displayed), displays notification with given information, and activates main app (so it is the frontmost window)
	activate application "Finder"
	display notification nMessage with title nTitle subtitle nSubtitle sound name nSound
	activate application mainAppName
end displayNotification
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
		mainAppError("M002-" & scriptName, "Couldn't find script file " & scriptName & " in " & parentFolderPath)
		quit
	else if searchResultsLength is 1 then
		set searchResult to searchResults
	else if searchResultsLength is greater than 1 then
		set searchResult to (choose from list searchResultsParagraphs with prompt "Multiple files found matching " & scriptName & return & return & "please select the desired file" with title mainAppName)
		if searchResult is false then mainAppError("M003-" & scriptName, "User didn't select one of following options: " & searchResultsParagraphs)
		quit
	end if
	
	-- loads script file
	try
		set tmpScript to load script searchResult
	on error e
		mainAppError("M004-" & scriptName, e)
		quit
	end try
	
	return tmpScript
end loadScript
------------------------------

on loadScripts() -- loads various scripts using loadScript handle
	
	-- loads send report script
	set reportError to no
	try
		set sendReportScript to loadScript("sendReport")
	on error
		set reportError to yes
	end try

	-- loads progress bar script
	set progressBarScript to loadScript("progressBar")
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
	tell application "Finder" to set parentFolderPath to container of mainAppPath
end getInfo
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




--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~~~~~~--   --~~-- MAIN SCRIPT

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

getInfo()
loadScripts()
------------------------------

set appList to {"Terminal", "Activity Monitor", "Disk Utility"}

--startProgressBar(0, 0, "Test progress bar", "Loading...")





--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--   --~~-- END

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--