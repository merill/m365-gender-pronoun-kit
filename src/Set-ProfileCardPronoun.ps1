<#
 .Synopsis
 Creates the Pronoun property in the Microsoft 365 Profile Card for the specified tenant

 #>
param(
    [ValidateSet('extensionAttribute1', 'extensionAttribute2', 'extensionAttribute3', 'extensionAttribute4', 'extensionAttribute5', 
    'extensionAttribute6', 'extensionAttribute7', 'extensionAttribute8', 'extensionAttribute9', 'extensionAttribute10', 
    'extensionAttribute11', 'extensionAttribute12', 'extensionAttribute13', 'extensionAttribute14', 'extensionAttribute15')]
    [System.String]$PronounAttribute = "extensionAttribute1",
    [switch] $Force
)
$ErrorActionPreference = 'Stop'

. .\Shared.ps1
Connect-MgGraph -Scopes 'User.ReadWrite.All'

$uri = "https://graph.microsoft.com/beta/organization/$((Get-MgContext).TenantId)/settings/profileCardProperties"

$profileCard = Invoke-MgGraphRequest -Uri $uri -Method GET
if(!$Force -and $profileCard.value.length -gt 0){
    Write-Warning "Existing profile card found."
    Write-Host (ConvertTo-Json $profileCard.value -Depth 5)
    Write-Error 'No changes were made because an existing profile card was found.'
    Write-Error 'Use the -Force parameter to overwrite the current profile card.'
    exit
}

$directoryPropertyName = $PronounAttribute -replace 'extension', 'custom' 
$body = @{
    directoryPropertyName = $directoryPropertyName
    annotations = @(
        @{
            displayName = 'Pronoun'
        }
    )
}

$bodyJson = ConvertTo-Json $body -Depth 3
$result = Invoke-MgGraphRequest -Uri $uri -Method PATCH -Body $bodyJson
Write-Host 'Pronoun profile card has been set succesfully.'