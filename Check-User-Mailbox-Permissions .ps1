# Connect to Exchange Online
Connect-ExchangeOnline  -ShowProgress $true

# Specify the domain you want to check against
$specificDomain = "specificdomain.com"

# Initialize a flag to control the loop
$isValidEmail = $false

# Keep prompting until a valid email address is provided
while (-not $isValidEmail) 
{
    # Prompt the user for the target email address
    $targetUser = Read-Host -Prompt "Please enter the email address of the target user"

    # Check if the targetUser's email address belongs to the specific domain
    if ($targetUser -match "@$specificDomain$") 
    {
        # Set the flag to exit the loop
        $isValidEmail = $true  
    } 
    else 
    {
        Write-Host "$targetUser does not belong to the domain $specificDomain. Please try again.`n"
    }
}

#Display user to allow search to complete
Write-Host "Processing, please wait until the search is complete."

# Get mailbox permissions
$mailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox, RoomMailbox -ResultSize Unlimited

# Iterate through each mailbox
foreach ($mailbox in $mailboxes) 
{
    #Filter out mailbox that user has access to
    $mailboxPermissions = Get-MailboxPermission -Identity $mailbox.DistinguishedName -User $targetUser
    
    # Display mailboxes that the target user has access to
    if ($null -ne $mailboxPermissions) 
    {
        if ($mailbox.RecipientTypeDetails -eq "RoomMailbox")
        {
            Write-Host "$targetUser has access to the room mailbox: $($mailbox.DisplayName)"
        }
        Else
        {
            Write-Host "$targetUser has access to mailbox: $($mailbox.DisplayName)"
        }
    }
    
}

#Notify user search is complete
Write-Host "Search complete."

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false

