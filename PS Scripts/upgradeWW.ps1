Function Check-WIMWitchVer{

    function upgrade-wimwitch {
        Write-Output "Would you like to upgrade WIM Witch?"
        $yesno = Read-Host -Prompt "(Y/N)"
        Write-Output $yesno
        if (($yesno -ne "Y") -and ($yesno -ne "N")) {
            Write-Output "Invalid entry, try again."
            upgrade-wimwitch
        }

        if ($yesno -eq "y") {
 
            try{
                Save-Script -Name "WIMWitch" -Path $PSScriptRoot -Force -ErrorAction Stop
                Write-Output "New version has been applied. WIM Witch will now exit."
                Write-Output "Please restart WIM Witch"
                exit}
            catch{
                Write-Output "Couldn't upgrade. Try again when teh tubes are clear"
                return}
           
            }
        
               
        if ($yesno -eq "n") {
            Write-Output "You'll want to upgrade at some point"
            }
  
    }

Write-Output "The currently installed version of WIM Witch is " $WWScriptVer
Write-Output "Checking for updates from PowerShell Gallery..."


try{
    $WWCurrentVer = (Find-Script -Name "WIMWitch" -ErrorAction Stop) 
    Write-Output "The latest version from the Gallery is " $WWCurrentVer
    }
catch{
    Write-output "Couldn't retreive script info from the PowerShell Gallery"
    Write-Output "Try rebooting the internet and trying again"
    Write-Output "Continuing on with loading WIM Witch..."
    return
    }



If (($WWCurrentVer -gt $WWScriptVer) -and ($auto -ne "yes")){upgrade-wimwitch}

if (($WWCurrentVer -gt $WWScriptVer) -and ($auto -eq "yes")){Write-Output "Skipping WIM Witch upgrade. Please launch WIM Witch in GUI mode to update."} 

If ($WWCurrentVer -eq $WWScriptVer){Write-Output "WIM Witch is up to date. Starting WIM Witch"}

If ($WWCurrentVer -gt $WWScriptVer){
    Write-Output "The local copy of WIM Witch is more current that the most current"
    Write-Output "version available. Did you violate the Temporal Prime Directive?"
    }

}

function Backup-WIMWitch{

#Find local script name
$scriptname = split-path $MyInvocation.PSCommandPath -Leaf
#Write-host (split-path $MyInvocation.PSCommandPath -Leaf)
Copy-Item -Path $scriptname -Destination $PSScriptRoot\backup
replace-name -file $PSScriptRoot\backup\$scriptname -extension ".ps1"






}

Backup-WIMWitch