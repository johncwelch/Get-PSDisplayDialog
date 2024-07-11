function getDisplayDialog {
     Param (
          [Parameter(Mandatory = $true)] [string] $dialogText,
          [Parameter(Mandatory = $false)] [string] $defaultAnswer,
          [Parameter(Mandatory = $false)] [bool] $hiddenAnswer,
          [Parameter(Mandatory = $false)] [array] $buttons,
          [Parameter(Mandatory = $false)] [string] $defaultButtonText,
          [Parameter(Mandatory = $false)] [int] $defaultButtonInt,
          [Parameter(Mandatory = $false)] [string] $cancelButtonText,
          [Parameter(Mandatory = $false)] [int] $cancelButtonInt,
          [Parameter(Mandatory = $false)] [string] $title,
          [Parameter(Mandatory = $false)] [string] $iconText,
          [Parameter(Mandatory = $false)] [int] $iconInt,
          [Parameter(Mandatory = $false)] [string] $iconEnum = "caution",
          [Parameter(Mandatory = $false)] [string] $iconPath,
          [Parameter(Mandatory = $false)] [int] $givingUpAfter 
     )

##building the full command will end up being a big fat if then else chain, but it will be worth it
##or we could put everything in an array and switch-case the whole thing
##do checks for wher eyou have ints/strings/etc for the same thign, like default button, icons, etc. 

"display dialog `"$dialogText`" default answer `"$defaultAnswer`" with icon $iconEnum"|/usr/bin/osascript 
}

$dialogText = "This is a test dialog"
$defaultAnswer = "default answer"
$iconEnum = "caution"
#getDisplayDialog -dialogText $dialogText -defaultAnswer $defaultAnswer 
"display dialog `"$dialogText`" default answer `"$defaultAnswer`" with icon $iconEnum"|/usr/bin/osascript
#getDisplayDialog -dialogText "this is more text" -title "here's a title"

