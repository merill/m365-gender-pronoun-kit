# Microsoft 365 Gender Pronoun Kit
This project is a collection of scripts that will allow you to add a Pronoun field to your Microsoft 365 tenant. Once set up users will be able to update their preferred pronoun from their Microsoft 365 Profile and have it appear in the Microsoft 365 Profile card.

## Why Pronouns (She/Her, They/Them, He/Him...)?
Often, people make assumptions about the gender of another person based on the person’s appearance or name. These assumptions aren’t always correct, and the act of making an assumption (even if correct) sends a potentially harmful message -- that people have to look a certain way to demonstrate the gender that they are or are not.

Just as it can be offensive or even harassing to make up a nickname for someone and call them that nickname against their will, it can be offensive or harassing to guess at someone’s pronouns and refer to them using those pronouns if that is not how that person wants to be known.

## How does this Gender Pronoun kit help?
This kit is a collection of scripts and guidance to help you add the Pronoun field to the user profile of your Microsoft 365 tenant.

![Demo of Pronoun field displayed and editable in M365 User Profile and Profile Card](https://github.com/merill/media/blob/main/M365-Pronoun-Demo.gif?raw=true)

## Solution Overview
To add the Pronoun to the user profile card and allow users to edit the field requires a few different components in Office 365. 
* Azure Active Directory 
* Profile Card
* SharePoint User Profile


## Installation Guide
### Create the Pronoun property in the Microsoft 365 Profile Card

```powershell
    .\Set-ProfileCardPronoun.ps1 -PronounAttribute 'extensionAttribute1'
```

### Create an application in Azure AD
This application ('User Pronoun Sync App') will be created with the appropriate application permissions for running the daily sync job. This sync job will copy the users' Pronoun from SharePoint/Delve to Azure AD.
```powershell
    Install-Module PnP.PowerShell -Scope CurrentUser
    Register-PnPAzureADApp -ApplicationName 'User Pronoun Sync App' -Tenant {tenant-name}.onmicrosoft.com -GraphApplicationPermissions 'User.ReadWrite.All' -SharePointApplicationPermissions 'User.Read.All' -DeviceLogin
```

Note the Client Id / Application Id of the app that was created in the previous step. This will be used as the ClientId when running Invoke-PronounSync. The .pfx created in the previous step needs to be stored securely.

### Set up a scheduled job to sync the Pronoun values from SharePoint to Azure AD
Update the parameters below and run the script. 
```powershell
    .\Invoke-PronounSync.ps1 -Tenant {tenant-name}.onmicrosoft.com -Url 'https://{tenant-name}-admin.sharepoint.com' -ClientId {ClientId of User Pronoun Sync app created above} -CertificatePath .\PnPPowerShell.pfx -PronounAttribute 'extensionAttribute1'
```

Once the sync is run successfully you can set it up on your platform of choice to run on a daily schedule. Options for automation may include
* Server (On Premises or Public Cloud)
* Azure Automation
* Azure DevOps


This can be scheduled to run as a daily job nightly to run in either Azure DevOps 
* Browse to https://pora-admin.sharepoint.com/_layouts/15/appinv.aspx
* Look up the ID based on the Client ID created in the previous step


    <AppPermissionRequests AllowAppOnlyPolicy="true">
        <AppPermissionRequest Scope="http://sharepoint/content/tenant" Right="Read" />
    </AppPermissionRequests>


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
