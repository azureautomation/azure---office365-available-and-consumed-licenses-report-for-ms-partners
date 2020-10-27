################################
####### Azure & Office365 ######
## Licensing and usage report ##
####### For MS Partners   ######
################################

# Author: Maor Bracha
# https://il.linkedin.com/in/maorbracha


Import-Module MsOnline;
Write-Host "Welcome to the Office365 & Azure licensing report for MS partners!";
Write-Host "Author: Maor Bracha";
Write-Host "Contact me on LinkedIn: https://il.linkedin.com/in/maorbracha";
Start-Sleep -Seconds 3;
Write-Host;
Write-Host;
Write-Host "Please type in delegate admin credentials";
Write-Host "Please type in delegate admin credentials";
Write-Host "Please type in delegate admin credentials";
Connect-MsolService;
$ResultsFilePath = Read-Host -Prompt "Please select a path for the results file without a file name (Example - 'C:\Users\MaorBracha\Desktop\')";
Write-Host "Retrieving clients information, Please wait.";
$Tenants = Get-MsolPartnerContract -All;
Start-Sleep -Seconds 1;
Write-Host $Tenants.Count "clients found.";
Start-Sleep -Seconds 1;
Write-Host "Enumerating available licenses, consumed and available units.";
Start-Sleep -Seconds 1;
$TenantsLicenses = New-Object System.Collections.ArrayList;
Foreach($Tenant in $Tenants)
       {
       $CompanyDetails = Get-MsolCompanyInformation -TenantId $Tenant.TenantId;
       Write-Host "Processing:" $CompanyDetails.DisplayName;
       $AccountSKU = Get-MsolAccountSku -TenantId $Tenant.TenantId;
       Foreach($Sku in $AccountSKU)
             {
             $SkuInformation = @{
                                               "Company Name" = $CompanyDetails.DisplayName;
                                               "License Type" = $Sku.AccountSkuId.Split(":")[1];
                                               "Available" = $Sku.ActiveUnits;
                                               "Consumed" = $Sku.ConsumedUnits;
                                               }
             $SkuObject = New-Object PSObject -Property $SkuInformation;
             $TenantsLicenses.Add($SkuObject) | Out-Null;
             }
       }

Write-Host "Process complete!";
Write-Host "Exporting results to:";
If(!($ResultsFilePath.EndsWith("\"))){$ResultsFilePath=$ResultsFilePath+"\"};
$ResultsFilePath=$ResultsFilePath+"Licensing report.csv";
Write-Host "Exporting results to:" $ResultsFilePath;
Start-Sleep -Seconds 3;
$TenantsLicenses | Export-Csv $ResultsFilePath;
