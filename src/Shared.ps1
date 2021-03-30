function Invoke-Graph{
    param(
        $Uri,
        [ValidateSet('PATCH', 'GET', 'POST')] $Method, 
        $Body,
        [ValidateSet('v1.0', 'beta')] $ApiVersion = "v1.0"
    )

    $accesstoken = Get-PnPGraphAccessToken
    if($Uri.StartsWith('https')){
        $graphUri = $Uri
    }
    else {
        $graphUri = 'https://graph.microsoft.com/{0}/{1}' -f $ApiVersion, $Uri
    }
    
    $res = Invoke-RestMethod -Headers @{Authorization = "Bearer $accesstoken" } -Uri $graphUri -Method $Method -Body $Body -ContentType 'application/json'
    Write-Output $res
}
