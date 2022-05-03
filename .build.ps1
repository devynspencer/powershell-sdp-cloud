#requires -modules InvokeBuild, BuildHelpers

Set-StrictMode -Version Latest

# Configure build environment
. "$PSScriptRoot\build.properties.ps1"

# Load build tasks from separate module
# https://github.com/nightroman/Invoke-Build/tree/master/Tasks/Import
Import-Module Builder -Force

foreach ($TaskFile in (Get-Command '*.tasks' -Module 'Builder')) {
    . $TaskFile
}
