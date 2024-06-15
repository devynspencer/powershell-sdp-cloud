function Export-ServiceDeskResponse {
    param (
        # The API response object to mock
        [Parameter(Mandatory)]
        $Response,

        # Unique identifier for the generated mock data files
        [ValidateNotNull()]
        $Id = (New-Guid).Guid,

        # Description of the mock data, and applicable test context
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        $Description,

        [Parameter(Mandatory)]
        [ValidateSet(
            'Asset',
            'Change',
            'Note',
            'Problem',
            'Project',
            'Request',
            'Solution',
            'Task',
            'Topic',
            'Worklog'
        )]
        $ResourceType,

        # Path to save the mock data files to
        $Destination = 'C:\temp\ServiceDeskPlus',

        # TODO: Support exporting to multiple formats at once
        # Format to save the response in
        [ValidateSet('CliXML', 'JSON', 'PSD1', 'Hashtable')]
        $Format
    )

    # Ensure the destination directory exists
    if (!(Test-Path $Destination)) {
        Write-Verbose "[Export-ServiceDeskResponse] Mock data directory not found at [$Destination], creating..."
        $null = mkdir $Destination -ErrorAction SilentlyContinue
    }

    # Handle the response format
    Write-Verbose "[Export-ServiceDeskResponse] Saving [$ResourceType] response in [$Format] format..."
    $FilePrefix = "$($ResourceType.ToLower())-$Id"

    switch ($Format) {
        'CliXML' {
            $FilePath = "$Destination\$FilePrefix.xml"
            $Response | Export-Clixml -Path $FilePath
        }

        'JSON' {
            $FilePath = "$Destination\$FilePrefix.json"
            $Response | ConvertTo-Json -Depth 4 | Out-File -FilePath $FilePath
        }

        'PSD1' {
            $FilePath = "$Destination\$FilePrefix.psd1"
            # TODO: Sounds like we need to write another function to export to a .psd1 file.
            # Example: https://gitlab.com/warren.postma/hai/-/snippets/33366
        }

        'Hashtable' {
            $Response | Set-Clipboard
            Write-Verbose "[Export-ServiceDeskResponse] Response [$Id] copied to clipboard!"
        }
    }

    if ($FilePath) {
        Write-Verbose "[Invoke-ServiceDeskApi] Response [$Id] logged to [$FilePath]"
    }
}
