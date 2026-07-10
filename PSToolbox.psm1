Import-Module PSLogger -ErrorAction Stop

$Public = Get-ChildItem -Path (Join-Path $PSScriptRoot "Public") -Filter *.ps1 -Recurse
$Private = Get-ChildItem -Path (Join-Path $PSScriptRoot "Private") -Filter *.ps1 -Recurse

foreach ($File in $Private) {
    . $File.FullName
}

foreach ($File in $Public) {
    . $File.FullName
}

Export-ModuleMember -Function $Public.BaseName
