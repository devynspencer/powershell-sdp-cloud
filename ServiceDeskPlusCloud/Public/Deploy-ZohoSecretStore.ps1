function Deploy-ZohoSecretStore {
    $StoreParams = @{
        Name = 'Zoho'
        Description = 'Secret management for the ServiceDeskPlusCloud module'
        ModuleName = 'Microsoft.PowerShell.SecretStore'
    }

    Register-SecretVault @StoreParams
}
