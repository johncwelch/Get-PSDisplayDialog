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
          #[Parameter(Mandatory = $false)][string] $iconText,
          #[Parameter(Mandatory = $false)][int] $iconInt,
          [Parameter(Mandatory = $false)][string] $iconEnum,
          [Parameter(Mandatory = $false)][string] $iconPath,
          [Parameter(Mandatory = $false)][int] $givingUpAfter 
     )

     #we're not doing $iconText/$iconInt because that's based on resource name/number which seems really old and not applicable anymore
     #but if you've a real need for it, I can be convinced.

	$hasDefaultButton = $false
     $hasCancelButton = $false
     $hasIcon = $false

     #default dialog command (this is required so it ALWAYS has to be here)
     $displayDialogCommand = "display dialog `"$dialogText`" "

	#as we process each condition, we build out the display dialog command

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

     ##cancel button
     #basically just like default button 
     #may turn this into its own function. May not. feel cute, may delete later
     if($cancelButtonInt -gt 0) {
		#there's a default button int specified
		$hasCancelButton = $true #we won't check for text in this case
		$displayDialogCommand = $displayDialogCommand + "cancel button $cancelButtonInt "
	} elseif ((-not [string]::IsNullOrEmpty($cancelButtonText)) -and (-not $hasCancelButton)) {
		#there's something besides nothing in $hasDefaultButton and we haven't already done something with $defaultButtonInt
		$hasCancelButton = $true
		$displayDialogCommand = $displayDialogCommand + "cancel button `"$cancelButtonText`" "
	} elseif (-not [string]::IsNullOrEmpty($cancelButtonText)) {
		#just in case we hit a weird condition
		$hasCancelButton = $true
		$displayDialogCommand = $displayDialogCommand + "cancel button `"$cancelButtonText`" "
	} else {
		#we are going to ignore everything if this is hit
	}
	
     ##title
     if(-not [string]::IsNullOrEmpty($title)){
          #there's something in the title
          $displayDialogCommand = $displayDialogCommand + "with title `"$title`" "

     }

     ##iconEnum and/or path
     if(-not [string]::IsNullOrEmpty($iconEnum)){
          #$iconEnum wins if both enum and path are filled out
          $hasIcon = $true
          $displayDialogCommand = $displayDialogCommand + "with icon $iconEnum "
     } elseif ((-not [string]::IsNullOrEmpty($iconPath)) -and (-not $hasIcon)) {
          #no $iconEnum but $iconPath
          $hasIcon = $true
          $displayDialogCommand = $displayDialogCommand + "with icon `(posix file `"$iconPath`"`) "
     } elseif (-not [string]::IsNullOrEmpty($iconPath)){
          #weird condition
          $hasIcon = $true
          $displayDialogCommand = $displayDialogCommand + "with icon `(posix file `"$iconPath`"`) "
     } else {
          #we are going to ignore everything if this is hit
     }
	
     ##giving up after
     #note that setting giving up after to 0 or negative integers is the same as infinity.
     #the default value is 0, so we check for greater than 0 
     if($givingUpAfter -gt 0){
          #$givingUpAfter is a positive integer greater than 0
          #convert to string so it works in the command string even though it will be read as an int.
          #command string building is weird, sigh.
          $givingUpAfterString = [string]$givingUpAfter
          $displayDialogCommand = $displayDialogCommand + "giving up after $givingUpAfterString "
     }

	
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

$dialogReplyString = Get-DisplayDialog -dialogText "Test Dialog" -givingUpAfter 20
#-buttons "one","two","three"

#test for cancel button
if($dialogReplyString.Contains("execution error: User canceled. `(-128`)")) {
     #Write-Output "user hit cancel button"
	return "userCancelError"
}

#$dialogReplyString.GetType()
Write-Output "`n"
Write-Output "`n"
#build initial reply array
$dialogReplyArray = $dialogReplyString.Split(",")

#build dialog reply without trailing/leading spaces
foreach($item in $dialogReplyArray) {
    $dialogReply.Add($item.trim()) |Out-Null #so we don't see 0/1/etc.
}
return $dialogReply



