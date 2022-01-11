#Connect-MicrosoftTeams
Connect-MicrosoftTeams
 
# Define Variables
$ArrayTeamsMembers = @()
$AllTeams = Get-Team
 
$AllTeams | foreach {
    $GroupId = $_.GroupId
    $DisplayName = $_.DisplayName
    $Visibility = $_.Visibility
    $Archived = $_.Archived
    $MailNickName = $_.MailNickName
    $Description = $_.Description
 
    # Search External members
    $Members = Get-TeamUser -GroupId $GroupId
    $External = $Members.where({$_.Role -eq "Guest"})
 
    If ($External.count -ne 0) {
        Write-Host "External User(s) are present in $DisplayName" -ForegroundColor Green
        $External.count
        $External | foreach {
            $UserId = $_.UserId
            $User = $_.User
 
            $ArrayTeamsMembers += New-Object psobject -Property @{
                GroupId = $GroupId
                DisplayName = $DisplayName
                Visibility = $Visibility
                Archived = $Archived
                MailNickName = $MailNickName
                Description = $Description
                UserId = $UserId
                User = $User
                }
            $UserId = $null
            $User = $null
            }
        }
 
    $GroupId = $null
    $DisplayName = $null
    $Visibility = $null
    $Archived = $null
    $MailNickName = $null
    $Description = $null
    $Members = $null
    $External = $null
    }
 
$ArrayTeamsMembers | Export-Csv c:\temp\ExternalTeamsMembers.csv -Encoding UTF8 -Delimiter ";" -NoTypeInformation
