<#
.SYNOPSIS
    Creates a directory if it does not already exist.

.DESCRIPTION
    Creates the specified directory when it does not already exist.

    If the directory already exists, no action is taken.

    If a file exists at the specified path, an error is written.

    Supports -WhatIf and -Confirm.

.PARAMETER Path
    The directory path to create.

    This parameter accepts pipeline input by value and by property
    name (FullName).

.EXAMPLE
    New-Directory -Path "C:\Logs"

    Creates C:\Logs if it does not already exist.

.EXAMPLE
    "C:\Logs","C:\Temp" | New-Directory

    Creates each directory from the pipeline.

.OUTPUTS
    System.IO.DirectoryInfo

    Returns the created directory. Nothing is returned when the
    directory already exists.

.NOTES
    Wrapper around New-Item that safely creates directories while
    supporting ShouldProcess.
#>
function New-Directory {
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
        [string]$Path
    )

    process {
        try {
            if (Test-Path -LiteralPath $Path) {
                if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
                    Write-ErrorLog "A file already exists at `"$Path`"."
                }
                return
            }

            if ($PSCmdlet.ShouldProcess($Path, "Create directory")) {
                New-Item -ItemType Directory -Path $Path -Force -ErrorAction Stop | Out-Null
                Write-InfoLog -Message "Created directory `"$Path`"."
            }
        }
        catch {
            Write-ErrorLog -Message @(
                "Failed to create directory `"$Path`".",
                $_.Exception.Message
            )
            throw
        }
    }
}
