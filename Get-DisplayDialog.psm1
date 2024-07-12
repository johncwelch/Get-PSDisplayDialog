#!/usr/bin/env pwsh

<#
.SYNOPSIS
Synopsis

.DESCRIPTION
Description

.EXAMPLE
example

.EXAMPLE
second example

.EXAMPLE
third example

.NOTES
Notes

.LINK
hhttps://github.com/johncwelch/Get-PSDisplayDialog
#>

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

     if (-Not $IsMacOS) {
          Write-Host "This script only runs on macOS, exiting"
          Exit
     }

     
}