# Connecting to Azure AD
Connect-AzureAD

# Define variables
$Array = @()
$AllSKU = Get-AzureADSubscribedSku
 
# Get all licenses status
$AllSKU | sort SkuPartNumber | foreach {
    $SkuPartNumber = $_.SkuPartNumber
    $Bought = $_.PrepaidUnits.enabled
    $Suspended = $_.PrepaidUnits.Suspended
    $Warning = $_.PrepaidUnits.Warning
    $Assigned = $_.ConsumedUnits
    $Rest = $Bought - $Assigned
 
    # Store Data
    $Array += New-Object psobject -Property @{
        License = $SkuPartNumber
        Bought = $Bought
        Assigned = $Assigned
        Will_Expired = $Warning
        Suspended = $Suspended
        Rest = $Rest
        }
    
    # Release variables
    $SkuPartNumber = $null
    $Bought = $null
    $Assigned = $null
    $Warning = $null
    $Suspended = $null
    $Rest = $null
         
    }
 
# Export Data to csv
$Array | Export-Csv C:\temp\Licenses.csv -Delimiter ";" -Encoding UTF8 -NoTypeInformation
