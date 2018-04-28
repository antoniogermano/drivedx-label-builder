on sendReport(mainAppName, errorCode, errorNumber, description)
    display dialog mainAppName & return & return & errorCode & return & return & errorNumber & return & return & description
end sendReport

sendReport("Test: " & name of me, "Test: " & "SND-RPT-ERROR-001", "Test: " & "001-" & "Test Application", "Test: " & "test description")
