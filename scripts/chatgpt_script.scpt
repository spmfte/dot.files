-- Get the home directory as the default starting point
set defaultDirectory to do shell script "echo ~"

-- Use AppleScript's dialog for choices
set choiceList to {"repair", "rice", "enhance", "custom"}
set userChoice to choose from list choiceList with prompt "Choose an option:" default items {"custom"}
if userChoice is false then
    display dialog "Choice was cancelled. Exiting."
    return
end if

-- Handle the "custom" option
if userChoice as string is "custom" then
    set message to text returned of (display dialog "Enter your custom message:" default answer "")
    if message is "" then
        display dialog "Input was cancelled or empty. Exiting."
        return
    end if
else
    -- Prompt for directory confirmation or modification
    set currentDirectory to text returned of (display dialog "Confirm or modify the directory:" default answer defaultDirectory)

    -- Prompt for file name
    set activeFile to text returned of (display dialog "Enter the file name (if not, just leave blank):" default answer "")

    -- Get user input for the selected option
    set userInput to text returned of (display dialog "Describe what you want:" default answer "")
    if userInput is "" then
        display dialog "Input was cancelled or empty. Exiting."
        return
    end if

    -- Construct the message based on the chosen option
    set message to "Help me " & (userChoice as string) & " my " & activeFile & " config. I am in " & currentDirectory & " and " & userInput & "."
end if

-- Copy message to clipboard
do shell script "echo " & quoted form of message & " | pbcopy"

-- Activate ChatGPT and paste the message
tell application "ChatGPT"
    activate
    delay 1
    tell application "System Events"
        keystroke "v" using command down
    end tell
end tell

