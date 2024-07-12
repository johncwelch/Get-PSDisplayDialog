function Get-DisplayDialog {
     Param (
          [Parameter(Mandatory = $true,Position=0)][string] $dialogText,
          [Parameter(Mandatory = $false)][string] $defaultAnswer,
          [Parameter(Mandatory = $false)][bool] $hiddenAnswer = $false, #default for this is false normally
          [Parameter(Mandatory = $false)][array] $buttons = @(),
          [Parameter(Mandatory = $false)][string] $defaultButtonText,
          [Parameter(Mandatory = $false)][int] $defaultButtonInt,
          [Parameter(Mandatory = $false)][string] $cancelButtonText,
          [Parameter(Mandatory = $false)][int] $cancelButtonInt,
          [Parameter(Mandatory = $false)][string] $title,
          [Parameter(Mandatory = $false)][string] $iconText,
          [Parameter(Mandatory = $false)][int] $iconInt,
          [Parameter(Mandatory = $false)][string] $iconEnum,
          [Parameter(Mandatory = $false)][string] $iconPath,
          [Parameter(Mandatory = $false)][int] $givingUpAfter 
     )
	$hasDefaultButton = $false

     #default dialog command
     $displayDialogCommand = "display dialog `"$dialogText`" "

     #is there a default answer? if there is, put it on the end of the command
     if(-not [string]::IsNullOrEmpty($defaultAnswer)) {
          $displayDialogCommand = $displayDialogCommand + "default answer `"$defaultAnswer`" "
     }

     #is hidden reply true? (we also check for default answer, because without that, hidden reply is functionally stupid to care about)
     #note that we already added the default answer, so this is just setting the hidden answer flag if it's true
     if((-not[string]::IsNullOrEmpty($defaultAnswer) -and ($hiddenAnswer))){
          $displayDialogCommand = $displayDialogCommand + "with hidden answer "
     }

     #-buttons processing. We first test for a count between 1 and three. If it's 0, we don't care, if it's > 3, pop error and exit
     if(($buttons.length) -lt 1) {
           
     } elseif($buttons.Length -eq 1){
		#is this the only button? stupid but allowable, we only want one button, no commas and break out of the if
          $button = $buttons[0]
          $displayDialogCommand = $displayDialogCommand + "buttons `{`"$button`"`}"
     } elseif(($buttons.Length) -gt 3) {
          #by default display dialog always has a dialog reply. Piping the output to out-null supresses that so we get the
          #dialog to display, but nothing else
          "display dialog `"you can't list more than three buttons`""|/usr/bin/osascript |Out-Null
          Exit
     } else {
          #buttons are an applescript list of strings, aka {"one","two"} so first, bulid the first brace
          #now build the buttons
    		$buttonList = ""
		foreach($button in $buttons) {
			#Write-Output $buttons.IndexOf($button)
			#Write-host "The index is $buttons.IndexOf($button)"
			
			#if we get here, there's > 1 button in the list
			if(($buttons.IndexOf($button)) -eq 0) {
				#first button
				$buttonList = $buttonList + "`"$button`","
			} elseif ($buttons.IndexOf($button) -eq ($buttons.Length) - 1)  {

				#is this the last button? if so, we want no commas
				$buttonList = $buttonList + "`"$button`""
			} else {
				#middle term, we want a trailing comma
				$buttonList = $buttonList + "`"$button`","
			}
		}
		$displayDialogCommand = $displayDialogCommand + "buttons `{$buttonList`} "
     }

	##default button
	#buttons start at 1,if there's no default buttons, defaultButtonInt will = 0
	if($defaultButtonInt -gt 0) {
		#there's a default button int specified
		$hasDefaultButton = $true #we won't check for text in this case
		$displayDialogCommand = $displayDialogCommand + "default button $defaultButtonInt "
	} elseif ((-not [string]::IsNullOrEmpty($defaultButtonText)) -and (-not $hasDefaultButton)) {
		#there's something besides nothing in $hasDefaultButton and we haven't already done something with $defaultButtonInt
		$hasDefaultButton = $true
		$displayDialogCommand = $displayDialogCommand + "default button `"$defaultButtonText`" "
	} elseif (-not [string]::IsNullOrEmpty($defaultButtonText)) {
		#just in case we hit a weird condition
		$hasDefaultButton = $true
		$displayDialogCommand = $displayDialogCommand + "default button `"$defaultButtonText`" "
	} else {
		#we are going to ignore everything if this is hit
	}
	#Write-Output "`n The default button text: $defaultButtonText and the default button int: $defaultButtonInt`n"
	
	Write-Output "$displayDialogCommand"
	
	$dialogReply = $displayDialogCommand|/usr/bin/osascript -so
	
	#Write-Output "The dialog reply is: $dialogReply"
     
     return $dialogReply

##building the full command will end up being a big fat if then else chain, but it will be worth it
##or we could put everything in an array and switch-case the whole thing
##do checks for wher you have ints/strings/etc for the same thign, like default button, icons, etc. 

#"display dialog `"$dialogText`" default answer `"$defaultAnswer`" with icon $iconEnum"|/usr/bin/osascript 
}

#we have to do this because we can't modify an array(list) we are iterating through
[System.Collections.ArrayList]$dialogReplyArray = @()
[System.Collections.ArrayList]$dialogReply = @()

$dialogReplyString = Get-DisplayDialog -dialogText "Test Dialog" -defaultAnswer "Default answer" -buttons "one","two","three" 
#-buttons "one","two","three"

#test for cancel button
if($dialogReplyString.Contains("execution error: User canceled. `(-128`)")) {
     #Write-Output "user hit cancel button"
	return "userCancelError"
}

#$dialogReplyString.GetType()
Write-Output "`n"
#build initial reply array
$dialogReplyArray = $dialogReplyString.Split(",")

#build dialog reply without trailing/leading spaces
foreach($item in $dialogReplyArray) {
    $dialogReply.Add($item.trim()) |Out-Null #so we don't see 0/1/etc.
}
$dialogReply


