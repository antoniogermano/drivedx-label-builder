----------------------------------------
-------------------------------- HANDLES
----------------------------------------

on saveReport()

	-- opens DriveDx
    activate application "DriveDx"

	-- sets name of file to be saved
	set fileName to "DriveDx_Report_TMP.txt"
	
	tell application "System Events"
		tell application process "DriveDx"
			
			-- brings window to front
			set frontmost to true
			
			delay 0.25
			
			tell menu bar 1
				tell menu bar item "Actions"
					tell menu 1
						
						-- clicks save report menu button
						click menu item "Refresh Drive(s) Health Status"

						delay 2.5

						-- clicks save report menu button
						click menu item "Save Drive(s) Health Report..."
						
						delay 0.25
						
						-- renames file to be saved
						keystroke fileName
						
						delay 0.25
						
						-- saves file
						keystroke return

						delay 1
					end tell
				end tell
			end tell
		end tell
	end tell
	
	-- activate application name of me
	
	return fileName
end saveReport
----------------------------------------

on readFile(fileName)
	
	-- gets path to the downloaded file -- TODO handle finding more than one txt file with set name
	set theFile to do shell script "mdfind -name " & fileName
	
	repeat
		try
			
			-- reads contents of the file
			set theFileContents to read theFile

			-- delays to let DriveDx finish writting file
			delay 2.5

			-- reads contents of the file again to get all data
			set theFileContents to read theFile
			
			-- exits repeat if contents of file were read
			exit repeat
		on error
			
			-- pause before trying again
			delay 0.5
		end try
	end repeat
	
	-- deletes saved file after reading data from it
	do shell script "rm " & theFile -- TODO uncomment after testing
	
	return theFileContents
end readFile
----------------------------------------

on separateData(theFileContents)

	-- initially sets final report to blank
	set finalReport to {}

	-- specifies list of subcategories to grab data from
	set desiredSubcategoriesList to {" ###", "DEVICE CAPABILITIES ===", "PROBLEMS SUMMARY ===", "IMPORTANT HEALTH INDICATORS ==="}
	
	-- specifies list of data to get from report for each subcategory
	set desiredInfoList to {"Volumes ", "Advanced SMART Status ", "Total Capacity ", "Model Family  ", "Model  ", "Drive Type ", "Reallocated Sector Count ", "Current Pending Sector Count ", "Offline Uncorrectable Sector Count ", "UDMA CRC Error Count "}
	
	-- separates info for each drive
	set oldDelims to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "
### "
	set allDrives to text items of theFileContents

	-- repeats through info for each drive in report
	repeat with currentDrive in allDrives

		-- initially sets final item to blank
		set finalItem to "BLANKBLANKBLANK"

		-- separates subcategories
		set AppleScript's text item delimiters to "
=== "
		set currentSubcategoryList to text items of currentDrive

		-- repeats through each subcategory for current drive
		repeat with currentSubcategory in currentSubcategoryList
		
			-- repeat throguh each desired subcategory
			repeat with desiredSubcategory in desiredSubcategoriesList

				-- ignores system info and continues if current subcategory is in desired subcategory list
				if currentSubcategory contains "SYSTEM INFORMATION" then
				else if currentSubcategory is "" then
				else if currentSubcategory contains desiredSubcategory then

					-- repeats over each line in current subcategory
					repeat with currentLine in paragraphs of currentSubcategory

						-- repeats with each item in desired info list
						repeat with desiredInfo in desiredInfoList

							-- continue if desired info is on current line
							if currentLine contains desiredInfo then

								-- sets tmpItem to second item of current line
								if currentSubcategory contains "IMPORTANT HEALTH INDICATORS ===" then
									set AppleScript's text item delimiters to "     "
									set tmpItem to text item 2 through -2 of currentLine
								else
									set AppleScript's text item delimiters to ": "
									set tmpItem to text item 2 of currentLine
								end if

								-- adds tmpItem to final report
								if currentLine contains "Volumes " then
									set finalItem to desiredInfo & "===  " & tmpItem as text & return & return & finalItem
								else if finalItem is "BLANKBLANKBLANK" then
									set finalItem to desiredInfo & "===  " & tmpItem as text & return
								else
									set finalItem to finalItem & desiredInfo & "===  " & tmpItem as text & return
								end if
							end if
						end repeat
					end repeat
				end if
			end repeat
		end repeat
		copy finalItem to end of finalReport
	end repeat
	set AppleScript's text item delimiters to oldDelims
	return finalReport
end separateData
----------------------------------------

on displayResults(finalReport)

	-- activates this app
	activate application name of me

	-- goes through each item in final report
	repeat with finalItem in finalReport
		log finalItem
		if finalItem contains "BLANKBLANKBLANK" then
		else
			set response to display dialog finalItem with title name of me buttons {"Quit","Next drive"} default button "Next drive"
			if button returned of response is "Quit" then
				quit
			end if
		end if
	end repeat

	-- prompts user to run again or quit
	set response to display dialog "End of drives." & return & return & "Run again?" with title name of me buttons {"Quit","Yes"} default button "Yes"
	if button returned of response is "Quit" then
		quit
	end if
end displayResults
----------------------------------------
---------------------------- END HANDLES
----------------------------------------



----------------------------------------
---------------------------- MAIN SCRIPT
----------------------------------------

repeat
	saveReport()
	readFile(result)
	separateData(result)
	displayResults(result)
end repeat
----------------------------------------
------------------------ END MAIN SCRIPT
----------------------------------------
