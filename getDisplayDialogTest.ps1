function getDisplayDialog() {
     Param (
          [Parameter(Mandatory = $true)] [string] $dialogText,
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

     #Write-host "Dialog text is: $dialogText"
     $display
     "display dialog $dialogText"|/usr/bin/osascript
}

$dialogText = "Test dialog text"
getDisplayDialog -dialogText $dialogText 

