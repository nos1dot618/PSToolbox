<#
.SYNOPSIS
Adds one or more directories to the PATH environment variable.

.DESCRIPTION
Adds the specified directory to the user PATH environment variable,
the current PowerShell session PATH, or both, depending on the selected
scope.

The supplied path is expanded and resolved to its canonical filesystem
path before being compared against existing PATH entries. Duplicate
entries are ignored.

If the specified path does not exist or cannot be resolved, an error is
raised.

This cmdlet supports pipeline input and PowerShell's ShouldProcess
feature, allowing use with -WhatIf and -Confirm.

.PARAMETER Path
The directory to add to the PATH environment variable.

Environment variables contained in the path are expanded before the path
is resolved.

.PARAMETER Scope
Specifies which PATH environment variable(s) to update.

Valid values are:

- User    : Updates the user's persistent PATH.
- Session : Updates only the current PowerShell session.
- Both    : Updates both the user and session PATHs (default).

.EXAMPLE
Add-PathEntry -Path "$env:USERPROFILE\bin"

Adds the directory to both the user and current session PATH.

.EXAMPLE
Add-PathEntry -Path "C:\Tools" -Scope User

Adds the directory only to the user's persistent PATH.

.EXAMPLE
Add-PathEntry -Path "C:\Tools" -Scope Session

Adds the directory only to the current PowerShell session.

.EXAMPLE
"C:\Tools", "C:\Git\bin" | Add-PathEntry

Adds multiple directories from the pipeline.

.EXAMPLE
Get-ChildItem C:\ThirdParty -Directory | Add-PathEntry

Adds each directory returned from the pipeline.

.NOTES
The current PowerShell session is updated immediately. Changes to the
user PATH are visible to newly started processes.
#>
function Add-PathEntry {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = "Medium"
    )]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias("FullName")]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Parameter()]
        [ValidateSet("User", "Session", "Both")]
        [string]$Scope = "Both"
    )

    begin {
        $UpdateUser = $Scope -in "User", "Both"
        $UpdateSession = $Scope -in "Session", "Both"
    }

    process {
        try {
            $Path = [Environment]::ExpandEnvironmentVariables($Path)
            if (-not (Test-Path -LiteralPath $Path)) {
                Write-WarnLog -Message "Path `"$Path`" does not exist, skipping adding it to the PATH."
                return
            }
            $Path = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).ProviderPath.TrimEnd("\")

            if ($UpdateUser) {
                $CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
                if ([string]::IsNullOrWhiteSpace($CurrentPath)) {
                    $PathEntries = @()
                }
                else {
                    $PathEntries = $CurrentPath -split ";" |
                    Where-Object { $_ } |
                    ForEach-Object { $_.TrimEnd("\") }
                }

                if ($PathEntries -notcontains $Path) {
                    if ($PSCmdlet.ShouldProcess("User PATH", "Add '$Path'")) {
                        $NewPath = @($PathEntries + $Path) -join ";"
                        [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
                        Write-InfoLog -Message "Added `"$Path`" to User PATH."
                    }
                }
            }

            if ($UpdateSession) {
                $SessionEntries = $env:PATH -split ";" |
                Where-Object { $_ } |
                ForEach-Object { $_.TrimEnd("\") }

                if ($SessionEntries -notcontains $Path) {
                    if ($PSCmdlet.ShouldProcess("Session PATH", "Add '$Path'")) {
                        $env:PATH = @($env:PATH, $Path) -join ";"
                        Write-InfoLog -Message "Added `"$Path`" to Session PATH."
                    }
                }
            }
        }
        catch {
            Write-ErrorLog -Message @(
                "Failed to add path entry `"$Path`".",
                $_.Exception.Message
            )
            throw
        }
    }
}
