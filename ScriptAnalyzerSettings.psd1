@{
    ExcludeRules = @(
        'PSAvoidUsingWriteHost',
        'PSUseToExportFieldsInManifest'
        'PSUseDeclaredVarsMoreThanAssignments'
    )

    Rules = @{
        PSAvoidUsingCmdletAliases = @{
            Whitelist = @('task')
        }
    }
}

