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

function Invoke-Graph{
    param($Uri, [ValidateSet('PATCH', 'GET')] $Method, $Body)

    $accesstoken = Get-PnPGraphAccessToken
    if($Uri.StartsWith('https')){
        $graphUri = $Uri
    }
    else {
        $graphUri = 'https://graph.microsoft.com/v1.0/{0}' -f $Uri
    }
    
    $res = Invoke-RestMethod -Headers @{Authorization = "Bearer $accesstoken" } -Uri $graphUri -Method $Method -Body $Body -ContentType 'application/json'
    Write-Output $res
}

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