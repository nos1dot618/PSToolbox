<#
.SYNOPSIS
Creates or replaces a symbolic link.

.DESCRIPTION
Creates a symbolic link at the specified destination pointing to the specified
target.

If an item already exists at the destination:

- Existing symbolic links, junctions, or hard links are removed and replaced.
- Existing regular files or directories are removed recursively before creating
  the new symbolic link.

Supports -WhatIf and -Confirm.

.PARAMETER Target
The path that the symbolic link will point to.

The target does not need to exist.

.PARAMETER Destination
The path where the symbolic link will be created.

.EXAMPLE
New-SymbolicLink -Target "C:\Projects\Dotfiles" -Destination "$HOME\.dotfiles"

Creates a symbolic link named ".dotfiles" in the user's home directory.

.EXAMPLE
New-SymbolicLink -Target ".\config" -Destination ".\current"

Creates a symbolic link using relative paths.

.INPUTS
None.

.OUTPUTS
None.
#>
function New-SymbolicLink {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = "Medium",
        PositionalBinding = $false
    )]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Target,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Destination
    )

    try {
        if (Test-Path -LiteralPath $Destination) {
            if ($PSCmdlet.ShouldProcess($Destination, "Remove existing item")) {
                Remove-Item -LiteralPath $Destination -Recurse -Force -ErrorAction Stop
            }
        }

        if ($PSCmdlet.ShouldProcess($Destination, "Create symbolic link to '$Target'")) {
            New-Item -ItemType SymbolicLink -Path $Destination -Target $Target -Force -ErrorAction Stop | Out-Null
            Write-InfoLog -Message @(
                "Created symbolic link",
                "from `"$Destination`"",
                "to `"$Target`"."
            )
        }
    }
    catch {
        Write-ErrorLog -Message @(
            "Failed to create symbolic link",
            "from `"$Destination`"",
            "to `"$Target`".",
            $_.Exception.Message
        )
    }
}
