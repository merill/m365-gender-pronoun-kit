<#
 .Synopsis
 Runs a sync to update Azure AD attribute that contains the pronoun with the corresponding value from the SharePoint/Delve user profile.
#>
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]$Url,
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]$Tenant,
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]$ClientId,
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]$CertificatePath,

    [ValidateSet('extensionAttribute1', 'extensionAttribute2', 'extensionAttribute3', 'extensionAttribute4', 'extensionAttribute5', 
    'extensionAttribute6', 'extensionAttribute7', 'extensionAttribute8', 'extensionAttribute9', 'extensionAttribute10', 
    'extensionAttribute11', 'extensionAttribute12', 'extensionAttribute13', 'extensionAttribute14', 'extensionAttribute15')]
    [System.String]$PronounAttribute = "extensionAttribute1"
)
. .\Shared.ps1
Connect-PnPOnline -Tenant $Tenant -Url $Url -ClientId $ClientId -CertificatePath $CertificatePath
$aadUsers = (Invoke-Graph -Uri 'users?$select=id,userPrincipalName,onPremisesExtensionAttributes&$top=999' -Method GET)
do{
    foreach ($aadUser in $aadUsers.value){
        Write-Host "Checking $($aadUser.UserPrincipalName)"
        $pnpUser = Get-PnPUserProfileProperty -Account $aadUser.UserPrincipalName
        $aadPronun = $aadUser.onPremisesExtensionAttributes."$PronounAttribute"    
        $pnpPronoun = $pnpUser.UserProfileProperties.Pronoun
        if($pnpPronoun -eq '') {$pnpPronoun = $null}
        if($aadPronun -ne $pnpPronoun){
            Write-Host "  > Updating"
            $body = @{
                onPremisesExtensionAttributes = @{
                    "$PronounAttribute" = $pnpPronoun
                }
            }
            Invoke-Graph -Uri "users/$($aadUser.id)" -Method PATCH -Body (ConvertTo-Json $body -Depth 3)
        }    
    }
    if($null -ne $aadUsers.'@odata.nextLink') { $aadUsers = Invoke-Graph -Uri $aadUsers.'@odata.nextLink' -Method GET }
} while ($null -ne $aadUsers.'@odata.nextLink') 