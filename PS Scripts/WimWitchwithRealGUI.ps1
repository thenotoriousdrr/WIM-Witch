#Your XAML goes here :)
$inputXML = @"
<Window x:Class="WIM_Witch_Tabbed.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WIM_Witch_Tabbed"
        mc:Ignorable="d"
        Title="WIM Witch" Height="500" Width="800">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="34*"/>
            <ColumnDefinition Width="165*"/>
        </Grid.ColumnDefinitions>
        <TabControl Grid.ColumnSpan="2" Margin="0,0,0.2,-0.2">
            <TabItem Header="Source WIM" Margin="0" Width="75">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="359*"/>
                        <ColumnDefinition Width="430*"/>
                    </Grid.ColumnDefinitions>
                    <Grid.RowDefinitions>
                        <RowDefinition/>
                    </Grid.RowDefinitions>
                    <TextBox x:Name="SourceWIMSelectWIMTextBox" HorizontalAlignment="Left" Height="25" Margin="26,98,0,0" TextWrapping="Wrap" Text="Select WIM File" VerticalAlignment="Top" Width="500" IsEnabled="False" Grid.ColumnSpan="2"/>
                    <Label Content="Source Wim " HorizontalAlignment="Left" Height="25" Margin="26,70,0,0" VerticalAlignment="Top" Width="100"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Select the path to the driver source that contains the drivers that will be injected by DISM." VerticalAlignment="Top" Height="42" Width="353" Grid.ColumnSpan="2"/>
                    <Button x:Name="SourceWIMSelectButton" Content="Select" HorizontalAlignment="Left" Height="25" Margin="92.281,142,0,0" VerticalAlignment="Top" Width="75" Grid.Column="1"/>
                    <TextBox x:Name="SourceWIMImgDesTextBox" HorizontalAlignment="Left" Height="23" Margin="94,155,0,0" TextWrapping="Wrap" Text="ImageDescription" VerticalAlignment="Top" Width="225" IsEnabled="False"/>
                    <TextBox x:Name="SourceWimArchTextBox" HorizontalAlignment="Left" Height="23" Margin="94,183,0,0" TextWrapping="Wrap" Text="Architecture" VerticalAlignment="Top" Width="225" IsEnabled="False"/>
                    <TextBox x:Name="SourceWimVerTextBox" HorizontalAlignment="Left" Height="23" Margin="94,211,0,0" TextWrapping="Wrap" Text="Version" VerticalAlignment="Top" Width="225" IsEnabled="False"/>
                    <TextBox x:Name="SourceWimSPBuildTextBox" HorizontalAlignment="Left" Height="23" Margin="94,239,0,0" TextWrapping="Wrap" Text="SPBuild" VerticalAlignment="Top" Width="225" IsEnabled="False"/>
                    <TextBox x:Name="SourceWimLangTextBox" HorizontalAlignment="Left" Height="23" Margin="94,267,0,0" TextWrapping="Wrap" Text="Languages" VerticalAlignment="Top" Width="225" IsEnabled="False"/>
                    <Label Content="Edition" HorizontalAlignment="Left" Height="30" Margin="22,151,0,0" VerticalAlignment="Top" Width="68"/>
                    <Label Content="Arch" HorizontalAlignment="Left" Height="30" Margin="22,183,0,0" VerticalAlignment="Top" Width="68"/>
                    <Label Content="Version" HorizontalAlignment="Left" Height="30" Margin="22,211,0,0" VerticalAlignment="Top" Width="68"/>
                    <Label Content="Patch Level" HorizontalAlignment="Left" Height="30" Margin="22,239,0,0" VerticalAlignment="Top" Width="68"/>
                    <Label Content="Languages" HorizontalAlignment="Left" Height="30" Margin="22,267,0,0" VerticalAlignment="Top" Width="68"/>
                </Grid>
            </TabItem>
            <TabItem Header="JSON" Margin="-2,0,3,0" Width="75">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="733*"/>
                    </Grid.ColumnDefinitions>
                    <TextBox x:Name="JSONTextBox" HorizontalAlignment="Left" Height="25" Margin="26,144,0,0" TextWrapping="Wrap" Text="Select JSON File" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Label x:Name="JSONLabel" Content="Source JSON" HorizontalAlignment="Left" Height="25" Margin="26,114,0,0" VerticalAlignment="Top" Width="100"/>
                    <Button x:Name="JSONButton" Content="Select" HorizontalAlignment="Left" Height="25" Margin="451,193,0,0" VerticalAlignment="Top" Width="75" IsEnabled="False"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Select a JSON file for use in deploying Autopilot systems. The file will be copied to processing folder during the build" VerticalAlignment="Top" Height="42" Width="353"/>
                    <CheckBox x:Name="JSONEnableCheckBox" Content="Enable Autopilot " HorizontalAlignment="Left" Margin="26,80,0,0" VerticalAlignment="Top" ClickMode="Press"/>

                </Grid>
            </TabItem>
            <TabItem Header="Drivers" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="75">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="733*"/>
                    </Grid.ColumnDefinitions>
                    <TextBox x:Name="DriverDir1TextBox" HorizontalAlignment="Left" Height="25" Margin="26,144,0,0" TextWrapping="Wrap" Text="Select Driver Source Folder" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Label x:Name="DirverDirLabel" Content="Driver Source" HorizontalAlignment="Left" Height="25" Margin="26,114,0,0" VerticalAlignment="Top" Width="100"/>
                    <Button x:Name="DriverDir1Button" Content="Select" HorizontalAlignment="Left" Height="25" Margin="562,144,0,0" VerticalAlignment="Top" Width="75" IsEnabled="False"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Select the path to the driver source that contains the drivers that will be injected by DISM." VerticalAlignment="Top" Height="42" Width="353"/>
                    <CheckBox x:Name="DriverCheckBox" Content="Enable Driver Injection" HorizontalAlignment="Left" Margin="26,80,0,0" VerticalAlignment="Top"/>
                    <TextBox x:Name="DriverDir2TextBox" HorizontalAlignment="Left" Height="25" Margin="26,189,0,0" TextWrapping="Wrap" Text="Select Driver Source Folder" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Button x:Name="DriverDir2Button" Content="Select" HorizontalAlignment="Left" Height="25" Margin="562,189,0,0" VerticalAlignment="Top" Width="75" IsEnabled="False"/>
                    <TextBox x:Name="DriverDir3TextBox" HorizontalAlignment="Left" Height="25" Margin="26,234,0,0" TextWrapping="Wrap" Text="Select Driver Source Folder" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Button x:Name="DriverDir3Button" Content="Select" HorizontalAlignment="Left" Height="25" Margin="562,234,0,0" VerticalAlignment="Top" Width="75" IsEnabled="False"/>
                    <TextBox x:Name="DriverDir4TextBox" HorizontalAlignment="Left" Height="25" Margin="26,281,0,0" TextWrapping="Wrap" Text="Select Driver Source Folder" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Button x:Name="DriverDir4Button" Content="Select" HorizontalAlignment="Left" Height="25" Margin="562,281,0,0" VerticalAlignment="Top" Width="75" IsEnabled="False"/>
                    <TextBox x:Name="DriverDir5TextBox" HorizontalAlignment="Left" Height="25" Margin="26,328,0,0" TextWrapping="Wrap" Text="Select Driver Source Folder" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Button x:Name="DriverDir5Button" Content="Select" HorizontalAlignment="Left" Height="25" Margin="562,328,0,0" VerticalAlignment="Top" Width="75" IsEnabled="False"/>

                </Grid>
            </TabItem>
            <TabItem Header="Make It So" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="75">
                <Grid>
                    <Grid.ColumnDefinitions>

                        <ColumnDefinition Width="20*"/>
                        <ColumnDefinition Width="769*"/>

                    </Grid.ColumnDefinitions>
                    <Button x:Name="MISFolderButton" Content="Select" HorizontalAlignment="Left" Margin="430,155,0,0" VerticalAlignment="Top" Width="75" RenderTransformOrigin="0.39,-2.647" Grid.Column="1"/>
                    <TextBox x:Name="MISWimNameTextBox" HorizontalAlignment="Left" Height="25" Margin="5.508,85,0,0" TextWrapping="Wrap" Text="Enter Target WIM Name" VerticalAlignment="Top" Width="500" Grid.Column="1"/>
                    <TextBox x:Name="MISDriverTextBox" HorizontalAlignment="Left" Height="23" Margin="122,345,0,0" TextWrapping="Wrap" Text="Driver Y/N" VerticalAlignment="Top" Width="120" Grid.Column="1" IsEnabled="False"/>
                    <Label Content="Drivers Selected?" HorizontalAlignment="Left" Height="30" Margin="19,343,0,0" VerticalAlignment="Top" Width="101" Grid.Column="1"/>
                    <TextBox x:Name="MISJSONTextBox" HorizontalAlignment="Left" Height="23" Margin="122,374,0,0" TextWrapping="Wrap" Text="JSON Select Y/N" VerticalAlignment="Top" Width="120" Grid.Column="1" IsEnabled="False"/>
                    <Label Content="JSON Selected?" HorizontalAlignment="Left" Margin="19,372,0,0" VerticalAlignment="Top" Width="102" Grid.Column="1"/>
                    <TextBox x:Name="MISWimFolderTextBox" HorizontalAlignment="Left" Height="23" Margin="5.508,119,0,0" TextWrapping="Wrap" Text="New WIM Folder" VerticalAlignment="Top" Width="500" IsEnabled="False" Grid.Column="1"/>
                    <TextBlock HorizontalAlignment="Left" Margin="5.508,20,0,0" TextWrapping="Wrap" Text="Enter a name, and select a destination forlder, for the  image to be created. Once complete, and build parameters verified, Make it so!" VerticalAlignment="Top" Height="42" Width="353" Grid.Column="1"/>
                    <Button x:Name="MISMakeItSoButton" Content="Make it so!" HorizontalAlignment="Left" Margin="310,339,0,0" VerticalAlignment="Top" Width="353" Height="64" FontSize="24" Grid.Column="1"/>
                    <TextBox x:Name="MISMountTextBox" HorizontalAlignment="Left" Height="25" Margin="5,219,0,0" TextWrapping="Wrap" Text="Select Mount Path" VerticalAlignment="Top" Width="500" IsEnabled="False" Grid.Column="1"/>
                    <Label Content="Mount Path" HorizontalAlignment="Left" Margin="5,194,0,0" VerticalAlignment="Top" Height="25" Width="100" Grid.Column="1"/>
                    <Button x:Name="MISMountSelectButton" Content="Select" HorizontalAlignment="Left" Margin="430,255,0,0" VerticalAlignment="Top" Width="75" Height="25" Grid.Column="1"/>

                </Grid>
            </TabItem>
            <TabItem x:Name="Logging" Header="Logging" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="75">
                <Grid>
               
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Log rolls downstairs, alone or in pairs, rolls over your neighbor's dog. It fits on your back. It's great for a snack It's Log, Log, Log!" VerticalAlignment="Top" Height="42" Width="353" Grid.ColumnSpan="2"/>
                    <TextBox x:Name="LoggingTextBox" TextWrapping="Wrap" Text="TextBox" Margin="26,67,25.2,36.8" Grid.ColumnSpan="2"/>
            
                </Grid>
            </TabItem>



        </TabControl>

    </Grid>
</Window>

"@ 
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
}
catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties in your textboxes (PowerShell cannot process them)"
    throw
}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
  
$xaml.SelectNodes("//*[@Name]") | %{"trying item $($_.Name)";
    try {Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
Get-FormVariables


#===========================================================================
# Functions for Controls
#===========================================================================

#Funtion to select mounting directory
Function SelectMountDir {

Add-Type -AssemblyName System.Windows.Forms
$browser = New-Object System.Windows.Forms.FolderBrowserDialog
$browser.Description = "Select the mount folder"
$null = $browser.ShowDialog()
$MountDir = $browser.SelectedPath
$WPFMISMountTextBox.text = $MountDir #I SCREWED UP THIS VARIABLE
update-log -Data "Mount directory selected" -Class Information

}

#Function to select Source WIM
Function SelectSourceWIM {

$SourceWIM = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'WIM (*.wim)|'
}
$null = $SourceWIM.ShowDialog()
$WPFSourceWIMSelectWIMTextBox.text = $SourceWIM.FileName

try
{
    $ImageInfo = get-windowsimage -ImagePath $WPFSourceWIMSelectWIMTextBox.text -index 1 -ErrorAction Stop
}
catch
{
    Update-Log -data $_.Exception.Message -class Error
    Update-Log -data "The WIM file selected may be borked. Try a different one" -Class Warning
    Return
}


update-log -Data "WIM file selected" -Class Information
$WPFSourceWIMImgDesTextBox.text = $ImageInfo.ImageDescription
$WPFSourceWimVerTextBox.Text = $ImageInfo.Version
$WPFSourceWimSPBuildTextBox.text = $ImageInfo.SPBuild
$WPFSourceWimLangTextBox.text = $ImageInfo.Languages
if ($ImageInfo.Architecture -eq 9) {
    $WPFSourceWimArchTextBox.text = 'x64'}
    Else{
    $WPFSourceWimArchTextBox.text = 'x86'}

}
 
#Function to Select JSON File
Function SelectJSONFile {

$JSON = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'JSON (*.JSON)|'
}
$null = $JSON.ShowDialog()
$WPFJSONTextBox.Text = $JSON.FileName
update-log -Data "JSON file selected" -Class Information
}

#Function to select the paths for the driver fields
Function SelectDriverSource($DriverTextBoxNumber) {
write-host $DriverTextBoxNumber
Add-Type -AssemblyName System.Windows.Forms
$browser = New-Object System.Windows.Forms.FolderBrowserDialog
$browser.Description = "Select the Driver Source folder"
$null = $browser.ShowDialog()
$DriverDir = $browser.SelectedPath
$DriverTextBoxNumber.Text = $DriverDir
update-log -Data "Driver path selected" -Class Information
}



#Function for the Make it So button
Function MakeItSo {

#check for working directory, make if does not exist, delete files if they exist
$FolderExist = Test-Path C:\WIMWitch\Staging -PathType Any
update-log -Data "Checking to see if the staging path exists..." -Class Information

try
{
    if ($FolderExist = $False) {
        New-Item -ItemType Directory -Force -Path C:\WIMWitch\Staging -ErrorAction Stop
        update-log -Data "Path did not exist, but it does now :)" -Class Information -ErrorAction Stop}
    Else{
        Remove-Item –path c:\WIMWitch\Staging\* -Recurse -ErrorAction Stop
        update-log -Data "The path existed, and it has been purged." -Class Information -ErrorAction Stop}
}
catch
{
    Update-Log -data $_.Exception.Message -class Error
    Update-Log -data "Something is wrong with folder C:\WIMWitch\Staging. Try deleting manually if it exists" -Class Error
    return
}



#Copy source WIM
update-log -Data "Copying source WIM to the staging folder" -Class Information

try
{
    Copy-Item $WPFSourceWIMSelectWIMTextBox.Text -Destination "C:\WIMWitch\Staging" -ErrorAction Stop
}
catch
{
    Update-Log -data $_.Exception.Message -class Error
    Update-Log -Data "The file couldn't be copied. No idea what happened" -class Error
    return
}

update-log -Data "Source WIM has been copied to the source folder" -Class Information

#Rename copied source WiM

try
{
    $wimname = Get-Item -Path C:\WIMWitch\Staging\*.wim -ErrorAction Stop
    Rename-Item -Path $wimname -NewName $WPFMISWimNameTextBox.Text -ErrorAction Stop
}
catch
{
    Update-Log -data $_.Exception.Message -class Error
    Update-Log -data "The copied source file couldn't be renamed. This shouldn't have happened." -Class Error
    Update-Log -data "Go delete the WIM from C:\WIMWitch\Staging\, then try again" -Class Error
    return
}

update-log -Data "Copied source WIM has been renamed" -Class Information
$wimname = Get-Item -Path C:\WIMWitch\Staging\*.wim
update-log -Data "Mounting source WIM" -Class Information

try
{
    Mount-WindowsImage -Path $WPFMISMountTextBox.Text -ImagePath $wimname -Index 1 -ErrorAction Stop
}
catch
{
    Update-Log -data $_.Exception.Message -class Error
    Update-Log -data "The WIM couldn't be mounted. Make sure the mount directory is empty" -Class Error
    Update-Log -Data "and that it isn't an active mount point" -Class Error
    return
}


#Inject Autopilot JSON file
update-log -Data "Injecting JSON file" -Class Information

try
{
    $autopilotdir = $WPFMISMountTextBox.Text + "\windows\Provisioning\Autopilot"
    Copy-Item $WPFJSONTextBox.Text -Destination $autopilotdir -ErrorAction Stop
}
catch
{
    Update-Log -data $_.Exception.Message -class Error
    Update-Log -data "JSON file couldn't be copied. Check to see if the correct SKU" -Class Error
    Update-Log -Data "of Windows has been selected" -Class Error
    Update-log -Data "The WIM is still mounted. You'll need to clean that up manually until" -Class Error
    Update-Log -data "I get around to handling that error more betterer" -Class Error
    Update-Log -data "- <3 Donna" -Class Error
    return  
}


#Inject Drivers
update-log -Data "The driver function needs to be updated. There's no error handling" -Class Information 
update-log -Data "it will attempt to inject whatever it finds. Good luck. -D" -Class Information 
Add-WindowsDriver -path $WPFMISMountTextBox.text -Driver $WPFDriverDir1TextBox.text -Recurse
update-log -Data "Injecting drivers from path 1" -Class Information 
Add-WindowsDriver -path $WPFMISMountTextBox.text -Driver $WPFDriverDir2TextBox.text -Recurse 
update-log -Data "Injecting drivers from path 2" -Class Information 
Add-WindowsDriver -path $WPFMISMountTextBox.text -Driver $WPFDriverDir3TextBox.text -Recurse 
update-log -Data "Injecting drivers from path 3" -Class Information 
Add-WindowsDriver -path $WPFMISMountTextBox.text -Driver $WPFDriverDir4TextBox.text -Recurse 
update-log -Data "Injecting drivers from path 4" -Class Information 
Add-WindowsDriver -path $WPFMISMountTextBox.text -Driver $WPFDriverDir5TextBox.text -Recurse 
update-log -Data "Injecting drivers from path 5" -Class Information 

#Copy log to mounted WIM
try
{
    update-log -Data "Attempting to copy log to mounted image" -Class Information 
    $mountlogdir = $WPFMISMountTextBox.Text + "\windows\"
    Copy-Item C:\WIMWitch\logging\WIMWitch.log -Destination $mountlogdir -ErrorAction Stop
    $CopyLogExist = Test-Path $mountlogdir\WIMWitch.log -PathType Leaf
    if ($CopyLogExist -eq $true) {update-log -Data "Log filed copied successfully" -Class Information}
}
catch
{
   Update-Log -data $_.Exception.Message -class Error
   update-log -data "Coudn't copy the log file to the mounted image." -class Error
}

#Dismount, commit, and move WIM

update-log -Data "Dismounting WIM file, committing changes" -Class Information 
try
{
    Dismount-WindowsImage -Path $WPFMISMountTextBox.Text -save -ErrorAction Stop
}
catch
{
    Update-Log -data $_.Exception.Message -class Error
    Update-Log -data "The WIM couldn't save. You will have to manually discard the" -Class Error
    Update-Log -data "mounted image manually" -Class Error
    return
}

update-log -Data "WIM dismounted" -Class Information 

try
{
    Move-Item -Path $wimname -Destination $WPFMISWimFolderTextBox.Text -ErrorAction Stop
}
catch
{
    Update-Log -data $_.Exception.Message -class Error
    Update-Log -data "The WIM couldn't be copied. You can still retrieve it from staging path." -Class Error
    Update-Log -data "The file will be deleted when the tool is rerun." -Class Error
    return
}
update-log -Data "Moved saved WIM to target directory" -Class Information 


#Copy log here
try
{
    update-log -Data "Copying build log to target folder" -Class Information 
    Copy-Item -Path C:\WIMWitch\logging\WIMWitch.log -Destination $WPFMISWimFolderTextBox.Text -ErrorAction Stop
    $logold = $WPFMISWimFolderTextBox.Text + "\WIMWitch.log"
    $lognew = $WPFMISWimFolderTextBox.Text + "\" + $WPFMISWimNameTextBox.Text + ".log"
    Rename-Item $logold -NewName $lognew -Force -ErrorAction Stop
}
catch
{
    Update-Log -data $_.Exception.Message -class Error
    Update-Log -data "The log file couldn't be copied and renamed. You can still snag it from the source." -Class Error
    update-log -Data "Job's done." -Class Information 
    return
}
update-log -Data "Job's done." -Class Information 
}

#Function to assign the target directory
Function SelectTargetDir {

Add-Type -AssemblyName System.Windows.Forms
$browser = New-Object System.Windows.Forms.FolderBrowserDialog
$browser.Description = "Select the target folder"
$null = $browser.ShowDialog()
$TargetDir = $browser.SelectedPath
$WPFMISWimFolderTextBox.text = $TargetDir #I SCREWED UP THIS VARIABLE
update-log -Data "Target directory selected" -Class Information 
}

#Function to enable logging
#Syntax = update-log -Data "Hello this is a test" -Class Warning
Function Update-Log
{
    Param(
    [Parameter(
        Mandatory=$true, 
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true,
        Position=0
    )]
    [string]$Data,

    [Parameter(
        Mandatory=$false, 
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true,
        Position=0
    )]
    [string]$Solution = $Solution,

    [Parameter(
        Mandatory=$false, 
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true,
        Position=1
    )]
    [validateset('Information','Warning','Error')]
    [string]$Class = "Information"

    )
    $global:ScriptLogFilePath = $Log
    $LogString = "$(Get-Date) $Class  -  $Data"
    $HostString = "$(Get-Date) $Class  -  $Data"

    
    Add-Content -Path $Log -Value $LogString
    switch ($Class)
    {
        'Information'{
            Write-Host $HostString -ForegroundColor Gray
            }
        'Warning'{
            Write-Host $HostString -ForegroundColor Yellow
            }
        'Error'{
            Write-Host $HostString -ForegroundColor Red
            }
        Default {}
    }
    $WPFLoggingTextBox.text = Get-Content -Path $Log -Delimiter "\n"
}

#Removes old log and creates if does not exist
Function Set-Logging{

$FileExist = Test-Path -Path C:\WIMWitch\logging\WIMWitch.Log -PathType Leaf
if ($FileExist -eq $False) {
    New-Item -ItemType Directory -Force -Path C:\WIMWitch\Logging
    New-Item -Path C:\WIMWitch\logging -Name "WIMWitch.log" -ItemType "file" -Value "***Logging Started***"}
    Else{
     Remove-Item -Path C:\WIMWitch\logging\WIMWitch.log
     New-Item -Path C:\WIMWitch\logging -Name "WIMWitch.log" -ItemType "file" -Value "***Logging Started***"}
}

#===========================================================================
# Run commands to reset values of files, etc.
#===========================================================================
Set-Logging #Clears out old logs from previous builds


#===========================================================================
# Set default values for certain variables
#===========================================================================

#Set the value of the JSON field in Make It So tab
$WPFMISJSONTextBox.Text = "False"

#Set the value of the Driver field in the Make It So tab
$WPFMISDriverTextBox.Text = "False"

#Set the path and name for logging
$Log = "C:\WIMWitch\logging\WIMWitch.log"

#===========================================================================
# Section for Buttons to call functions
#===========================================================================

#Mount Dir Button                                                    
$WPFMISMountSelectButton.Add_Click({SelectMountdir}) 

#Source WIM File Button
$WPFSourceWIMSelectButton.Add_Click({SelectSourceWIM}) 

#JSON File selection Button
$WPFJSONButton.Add_Click({SelectJSONFile}) 

#Target Folder selection Button
$WPFMISFolderButton.Add_Click({SelectTargetDir}) 

#Driver Directory Buttons
$WPFDriverDir1Button.Add_Click({SelectDriverSource -DriverTextBoxNumber $WPFDriverDir1TextBox}) 
$WPFDriverDir2Button.Add_Click({SelectDriverSource -DriverTextBoxNumber $WPFDriverDir2TextBox}) 
$WPFDriverDir3Button.Add_Click({SelectDriverSource -DriverTextBoxNumber $WPFDriverDir3TextBox}) 
$WPFDriverDir4Button.Add_Click({SelectDriverSource -DriverTextBoxNumber $WPFDriverDir4TextBox}) 
$WPFDriverDir5Button.Add_Click({SelectDriverSource -DriverTextBoxNumber $WPFDriverDir5TextBox}) 

#Make it So Button, which builds the WIM file
$WPFMISMakeItSoButton.Add_Click({MakeItSo}) 

#Logging window
$WPFLoggingTextBox.text = Get-Content -Path $Log -Delimiter "\n"

#===========================================================================
# Section for Checkboxes to call functions
#===========================================================================

#Enable JSON Selection
$WPFJSONEnableCheckBox.Add_Click({
    If ($WPFJSONEnableCheckBox.IsChecked -eq $true){
        $WPFJSONButton.IsEnabled = $True
        $WPFMISJSONTextBox.Text = "True"}
        else{
        $WPFJSONButton.IsEnabled = $False
        $WPFMISJSONTextBox.Text = "False"}
    })
 
#Enable Driver Selection  
$WPFDriverCheckBox.Add_Click({
    If ($WPFDriverCheckBox.IsChecked -eq $true){
        $WPFDriverDir1Button.IsEnabled = $True
        $WPFDriverDir2Button.IsEnabled = $True
        $WPFDriverDir3Button.IsEnabled = $True
        $WPFDriverDir4Button.IsEnabled = $True
        $WPFDriverDir5Button.IsEnabled = $True
        $WPFMISDriverTextBox.Text = "True"
        }
        else{
        $WPFDriverDir1Button.IsEnabled = $False
        $WPFDriverDir2Button.IsEnabled = $False
        $WPFDriverDir3Button.IsEnabled = $False
        $WPFDriverDir4Button.IsEnabled = $False
        $WPFDriverDir5Button.IsEnabled = $False
        $WPFMISDriverTextBox.Text = "False"
        }
    })

#===========================================================================

     


#===========================================================================
# Commands before forms load
#===========================================================================






#write-host "To show the form, run the following" -ForegroundColor Cyan
#'$Form.ShowDialog() | out-null'

#===========================================================================
# Shows the form
#===========================================================================


 $Form.ShowDialog() | out-null


