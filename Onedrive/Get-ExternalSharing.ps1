# Connect to Sharepoint Online
Connect-SPOService -Url https://MonTenant-admin.sharepoint.com/
 
# Collect all Sharepoint Sites and filter on OneDrive
$AllOneDrive = Get-SPOSite -IncludePersonalSite $true -Limit all -Filter "Url -like '-my.sharepoint.com/personal/'"
 
# Define variabes
$ArrayOneDriveMembers = @()
$SortOneDrive = $AllOneDrive | sort Url
 
$SortOneDrive | foreach {
    $OneDriveUrl = $_.Url
    $OneDriveOwner = $_.Owner
    $OneDriveStorageQuota = $_."Storage Quota"
    $OneDriveTitle = $_.Title
    # Get the list of members for the current OneDrive
    Try {
        $OneDriveMembers = Get-SPOUser -Site $OneDriveUrl -ErrorAction stop
        }
    Catch {
        Write-Output "$OneDriveUrl;$OneDriveTitle" | Add-Content C:\temp\Onedriveerrors.txt
        }
     
    # Define a new variable
    $OneDriveExternal = $OneDriveMembers.where({$_.Usertype -eq "Guest"})
 
    # Check if the new variable is empty, if not collect logs
    If ($OneDriveExternal.count -ne 0) {
         
        # Display some informations
        Write-Host "External Users are present in $OneDriveTitle" -ForegroundColor Green
        $OneDriveExternal.count
 
        # Store Data
        $OneDriveExternal | foreach {
            $DisplayName = $_.DisplayName
            $LoginName = $_.LoginName
             
            $ArrayOneDriveMembers += New-Object psobject -Property @{
                OneDriveUrl = $OneDriveUrl
                OneDriveOwner = $OneDriveOwner
                OneDriveStorageQuota = $OneDriveStorageQuota
                OneDriveTitle = $OneDriveTitle
                DisplayName = $DisplayName
                LoginName = $LoginName
                }
            # Release Variables
            $DisplayName = $null
            $LoginName = $null
            }
        }
     
    # Release variables
    $OneDriveUrl = $null
    $OneDriveOwner = $null
    $OneDriveStorageQuota = $null
    $OneDriveTitle = $null
    $OneDriveMembers = $null
    }
 
# Export to CSV
$ArrayOneDriveMembers | Export-Csv c:\temp\ExternalOneDriveMembers.csv -Encoding UTF8 -Delimiter ";" -NoTypeInformation
