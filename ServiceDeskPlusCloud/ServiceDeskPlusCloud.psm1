# Load public and private functions
foreach ($File in (Get-ChildItem "$PSScriptRoot\public", "$PSScriptRoot\private" -Recurse -Filter '*.ps1')) {
    . $File.FullName
}

# Export all public functions
foreach ($File in (Get-ChildItem "$PSScriptRoot\public" -Recurse -Filter '*.ps1')) {
    Export-ModuleMember $File.BaseName
}
