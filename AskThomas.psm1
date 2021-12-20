Write-Host "PSScriptRoot is $PSScriptRoot"

get-item $PSScriptRoot/modules/*.ps1 | ForEach-Object {
    Write-Host "Import Module: $($_.name)"
    . $_.FullName
}
