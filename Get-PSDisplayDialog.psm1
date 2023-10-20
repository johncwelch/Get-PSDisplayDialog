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

function Get-PSDisplayDialog {
     param($keys)

     if (-Not $IsMacOS) {
          Write-Host "This script only runs on macOS, exiting"
          Exit-PSSession
     }
}