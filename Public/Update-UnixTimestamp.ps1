<#
.SYNOPSIS
Creates a file if it does not exist or updates its last write time.

.DESCRIPTION
Updates the LastWriteTime of an existing file to the current date and time.

If the specified file does not exist, an empty file is created.

Supports -WhatIf and -Confirm.

.PARAMETER FilePath
The path to the file to update or create.

Accepts pipeline input by value and by property name. The property name
'FullName' is also accepted.

.EXAMPLE
Update-FileTimestamp -FilePath "notes.txt"

Creates "notes.txt" if it does not exist; otherwise updates its last write time.

.EXAMPLE
Get-ChildItem *.log | Update-FileTimestamp

Updates the last write time of all .log files.

.INPUTS
System.String

.OUTPUTS
None.
#>
function Update-FileTimestamp {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = "Low"
    )]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias("FullName")]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath
    )

    process {
        try {
            $timestamp = Get-Date

            if (Test-Path -LiteralPath $FilePath) {
                if ($PSCmdlet.ShouldProcess($FilePath, "Update last write time")) {
                    (Get-Item -LiteralPath $FilePath -ErrorAction Stop).LastWriteTime = $timestamp
                    Write-InfoLog -Message @(
                        "Updated last write time of",
                        "`"$FilePath`"."
                    )
                }
            }
            else {
                if ($PSCmdlet.ShouldProcess($FilePath, "Create file")) {
                    New-Item -ItemType File -Path $FilePath -Force -ErrorAction Stop | Out-Null
                    Write-InfoLog -Message @(
                        "Created file",
                        "`"$FilePath`"."
                    )
                }
            }
        }
        catch {
            Write-ErrorLog -Message @(
                "Failed to update `"$FilePath`".",
                $_.Exception.Message
            )
        }
    }
}
