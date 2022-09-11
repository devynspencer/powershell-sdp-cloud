<#
.SYNOPSIS
    Deploy a new secret store to store ServiceDesk Plus Cloud API tokens, secrets, and credentials.

.EXAMPLE
    Deploy-ZohoSecretStore
#>

function Deploy-ZohoSecretStore {
    $StoreParams = @{
        Name = 'Zoho'
        Description = 'Secret management for the ServiceDeskPlusCloud module'
        ModuleName = 'Microsoft.PowerShell.SecretStore'
    }

    Register-SecretVault @StoreParams
}
