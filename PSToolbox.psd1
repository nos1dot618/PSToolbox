@{
    RootModule           = "PSToolbox.psm1"
    ModuleVersion        = "0.1.0"
    GUID                 = "5932950d-6ac9-46dc-9fd3-3f538ce8d590"
    Author               = "Lakshay Chauhan"
    Copyright            = "(c) 2026 Lakshay Chauhan. Licensed under the MIT License."
    Description          = "General-purpose PowerShell utility functions."
    PowerShellVersion    = "5.1"
    RequiredModules      = @(
        "PSLogger"
    )
    FunctionsToExport    = @(
        "Add-PathEntry"
        "New-Directory"
        "New-SymbolicLink"
        "Update-FileTimestamp"
        "ConvertTo-Psd1Literal"
    )
    CmdletsToExport      = @()
    AliasesToExport      = @()
    VariablesToExport    = @()
    FormatsToProcess     = @()
    TypesToProcess       = @()
    NestedModules        = @()
    ScriptsToProcess     = @()
    CompatiblePSEditions = @("Desktop", "Core")
    PrivateData          = @{
        PSData = @{
            Tags          = @(
                "PowerShell"
                "Utilities"
                "Filesystem"
                "Environment"
                "Symlink"
            )
            ProjectUri    = "https://gitlab.com/ninthcircle/PSToolbox"
            LicenseUri    = "https://opensource.org/licenses/MIT"
            RepositoryUri = "https://gitlab.com/ninthcircle/PSToolbox"
            ReleaseNotes  = "Initial release."
        }
    }
}
