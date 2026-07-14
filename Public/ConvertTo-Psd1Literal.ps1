<#
.SYNOPSIS
    Converts a PowerShell object into a PowerShell data file (PSD1) literal.

.DESCRIPTION
    Recursively converts common PowerShell data types into their corresponding
    PSD1/PowerShell literal representation.

    Supported types include:
    - $null
    - Boolean values
    - Strings
    - Hashtable
    - PSCustomObject
    - Arrays and other enumerable collections

    Hashtable keys and PSCustomObject properties are recursively converted,
    producing nested PSD1-compatible hashtable syntax. Enumerable collections
    are emitted as PowerShell array literals.

    This function is intended for generating PowerShell source text and does
    not guarantee support for every .NET type. Unsupported objects are emitted
    using their ToString() representation.

.PARAMETER Value
    The object to convert into a PowerShell literal.

.PARAMETER IndentLevel
    The current indentation level used when formatting nested hashtables.
    This parameter is intended for internal recursive calls.

.OUTPUTS
    System.String

.EXAMPLE
    $Object | ConvertTo-Psd1Literal

    Converts the supplied object into a PSD1-compatible string representation.

.EXAMPLE
    ConvertTo-Psd1Literal @{
        Name = "MyModule"
        Enabled = $true
        Tags = @("PowerShell", "Module")
    }

    Returns:

    @{
        Name = "MyModule"
        Enabled = $true
        Tags = @("PowerShell", "Module")
    }
#>
function ConvertTo-Psd1Literal {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        $Value,
        [int]$IndentLevel = 0
    )

    $Indent = " " * ($IndentLevel * 4)

    if ($null -eq $Value) { return "$null" }

    if ($Value -is [bool]) { return ($(if ($Value) { "`$true" } else { "`$false" })) }

    if ($Value -is [string]) {
        $Escaped = $Value -replace "\$", "```$"
        return "`"$Escaped`""
    }

    if ($Value -is [HashTable]) {
        $Lines = foreach ($Entry in $Value.GetEnumerator()) {
            $ValueText = ConvertTo-Psd1Literal -Value $Entry.Value -IndentLevel ($IndentLevel + 1)
            "$Indent" + "    $($Entry.Key) = $ValueText"
        }
        return "@{`n$($Lines -join "`n")`n$Indent}"
    }

    if ($Value -is [PSCustomObject]) {
        $Lines = foreach ($Entry in $Value.PSObject.Properties) {
            $ValueText = ConvertTo-Psd1Literal -Value $Entry.Value -IndentLevel ($IndentLevel + 1)
            "$Indent" + "    $($Entry.Name) = $ValueText"
        }
        return "@{`n$($Lines -join "`n")`n$Indent}"
    }

    if ($Value -is [System.Collections.IEnumerable] -and -not ($Value -is [string])) {
        $Items = foreach ($Item in $Value) { (ConvertTo-Psd1Literal -Value $Item -IndentLevel ($IndentLevel + 1)) }
        return "@(" + ($Items -join ", ") + ")"
    }

    return $Value.ToString()
}
