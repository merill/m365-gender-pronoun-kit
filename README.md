# Microsoft 365 Gender Pronoun Kit
This project is a collection of scripts that will allow you to add a Pronoun field to your Microsoft 365 tenant. Once set up users will be able to update their preferred pronoun from their Microsoft 365 Profile and have it appear in the Microsoft 365 Profile card.

## Installing the module
```powershell
    Install-Module PnP.PowerShell
    Register-PnPAzureADApp -ApplicationName "PnPPowerShell" -Tenant pora.onmicrosoft.com -GraphApplicationPermissions "User.ReadWrite.All" -SharePointApplicationPermissions "User.Read.All" -DeviceLogin

    Connect-PnPOnline -Tenant pora.onmicrosoft.com -Url "https://pora-admin.sharepoint.com" -ClientId 1d93462e-0f39-4e4c-898a-b6b1df5fa997 -CertificatePath .\PnPPowerShell.pfx



    Install-Module AzureADExporter
```
* Browse to https://pora-admin.sharepoint.com/_layouts/15/appinv.aspx
* Look up the ID based on the Client ID created in the previous step


    <AppPermissionRequests AllowAppOnlyPolicy="true">
        <AppPermissionRequest Scope="http://sharepoint/content/tenant" Right="Read" />
    </AppPermissionRequests>

## Using the module

### Connecting to your tenant
```powershell
    Connect-AzureADExporter
```

### Exporting all objects and settings
```powershell
    Invoke-AADExporter -Path 'C:\AzureADBackup\'
```

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
