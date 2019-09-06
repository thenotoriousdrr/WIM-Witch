﻿# Self-elevate the script if required
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 If ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-ExecutionPolicy Bypass -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}


#Your XAML goes here :)
$inputXML = @"
<Window x:Class="WIM_Witch_Tabbed.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WIM_Witch_Tabbed"
        mc:Ignorable="d"
        Title="WIM Witch v0.9 Beta" Height="500" Width="800">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="128*"/>
        </Grid.ColumnDefinitions>
        <TabControl Grid.ColumnSpan="2" Margin="0,0,0.2,-0.2" Background="#FFC4BBDF">
            <TabItem Header="Source WIM" Margin="0" Width="100">
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
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Select the WIM file, and then Edition, that will serve as the base for the custom WIM." VerticalAlignment="Top" Height="42" Width="353" Grid.ColumnSpan="2"/>
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
                    <TextBox x:Name="SourceWimIndexTextBox" HorizontalAlignment="Left" Height="23" Margin="94,297,0,0" TextWrapping="Wrap" Text="Index" VerticalAlignment="Top" Width="225" IsEnabled="False"/>
                    <Label Content="Index" HorizontalAlignment="Left" Height="30" Margin="22,297,0,0" VerticalAlignment="Top" Width="68"/>
                </Grid>
            </TabItem>
            <TabItem Header="Updates" Height="20" Width="100">
                <Grid>
                    <TextBlock HorizontalAlignment="Left" Margin="20,183,0,0" TextWrapping="Wrap" Text="Installed version of OSD Update:" VerticalAlignment="Top"/>
                    <TextBox x:Name="UpdatesOSDBVersion" HorizontalAlignment="Left" Height="23" Margin="194,182,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120" IsEnabled="False"/>
                    <Button x:Name="UpdateOSDBUpdateButton" Content="Install / Update" HorizontalAlignment="Left" Margin="194,236,0,0" VerticalAlignment="Top" Width="120" IsEnabled="False"/>
                    <TextBlock HorizontalAlignment="Left" Height="42" Margin="387,140,0,0" TextWrapping="Wrap" Text="Select which version of Windows 10 to download current patches for. Updating will also purge superseded updates." VerticalAlignment="Top" Width="335"/>
                    <TextBlock HorizontalAlignment="Left" Height="23" Margin="419,187,0,0" TextWrapping="Wrap" Text="1903" VerticalAlignment="Top" Width="35"/>
                    <TextBlock HorizontalAlignment="Left" Height="23" Margin="497,187,0,0" TextWrapping="Wrap" Text="1809" VerticalAlignment="Top" Width="35"/>
                    <TextBlock HorizontalAlignment="Left" Height="23" Margin="569,187,0,0" TextWrapping="Wrap" Text="1803" VerticalAlignment="Top" Width="35"/>
                    <TextBlock HorizontalAlignment="Left" Height="23" Margin="638,187,0,0" TextWrapping="Wrap" Text="1709" VerticalAlignment="Top" Width="35"/>
                    <TextBlock HorizontalAlignment="Left" Margin="20,28,0,0" TextWrapping="Wrap" Text="Click the check box to enable updates for the selected WIM file. " VerticalAlignment="Top" Height="23" Width="353"/>
                    <CheckBox x:Name="UpdatesEnableCheckBox" Content="Enable Updates" HorizontalAlignment="Left" Margin="26,80,0,0" VerticalAlignment="Top" ClickMode="Press"/>
                    <CheckBox x:Name="Updates1903CheckBox" Content="" HorizontalAlignment="Left" Margin="394,189,0,0" VerticalAlignment="Top" IsEnabled="False"/>
                    <CheckBox x:Name="Updates1809CheckBox" Content="" HorizontalAlignment="Left" Margin="472,189,0,0" VerticalAlignment="Top" IsEnabled="False"/>
                    <CheckBox x:Name="Updates1803CheckBox" Content="" HorizontalAlignment="Left" Margin="544,189,0,0" VerticalAlignment="Top" IsEnabled="False"/>
                    <CheckBox x:Name="Updates1709CheckBox" Content="" HorizontalAlignment="Left" Margin="613,189,0,0" VerticalAlignment="Top" IsEnabled="False"/>
                    <Button x:Name="UpdatesDownloadNewButton" Content="Update" HorizontalAlignment="Left" Margin="626,241,0,0" VerticalAlignment="Top" Width="75" IsEnabled="False"/>
                    <TextBlock HorizontalAlignment="Left" Margin="20,136,0,0" TextWrapping="Wrap" Text="Update OSD Update by using the button below. Updating OSD Update will require PowerShell to be restarted" VerticalAlignment="Top" Height="34" Width="321"/>
                    <TextBox x:Name="UpdatesOSDBCurrentVerTextBox" HorizontalAlignment="Left" Height="23" Margin="194,210,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120" IsEnabled="False"/>
                    <TextBlock HorizontalAlignment="Left" Margin="20,210,0,0" TextWrapping="Wrap" Text="Current Version of OSD Update:" VerticalAlignment="Top"/>
                    <TextBlock x:Name="UpdatesOSDBOutOfDateTextBlock" HorizontalAlignment="Left" Margin="20,283,0,0" TextWrapping="Wrap" Text="OSDBuilder is out of date. Please click &quot;Update OSDBuilder&quot; to update." VerticalAlignment="Top" RenderTransformOrigin="0.493,0.524" FontSize="20" Width="321" Visibility="Hidden" />
                    <TextBlock x:Name="UpdatesOSDBSupercededExistTextBlock" HorizontalAlignment="Left" Margin="394,283,0,0" TextWrapping="Wrap" Text="Superceded updates discovered. Please select the versions of Windows 10 you are supporting and click &quot;Update&quot;" VerticalAlignment="Top" FontSize="20" Visibility="Hidden"/>
                    <TextBlock x:Name="UpdatesOSDBClosePowerShellTextBlock" HorizontalAlignment="Left" Margin="387,28,0,0" TextWrapping="Wrap" Text="Please close all PowerShell windows, including WIM Witch, then relaunch app to continue" VerticalAlignment="Top" RenderTransformOrigin="0.493,0.524" FontSize="20" Width="321" Visibility="Hidden" />

                </Grid>
            </TabItem>
            <TabItem Header="Autopilot" Margin="-2,0,3,0" Width="100">
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
            <TabItem Header="Drivers" Height="20" Width="100">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="733*"/>
                    </Grid.ColumnDefinitions>
                    <TextBox x:Name="DriverDir1TextBox" HorizontalAlignment="Left" Height="25" Margin="26,144,0,0" TextWrapping="Wrap" Text="Select Driver Source Folder" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Label x:Name="DirverDirLabel" Content="Driver Source" HorizontalAlignment="Left" Height="25" Margin="26,114,0,0" VerticalAlignment="Top" Width="100"/>
                    <Button x:Name="DriverDir1Button" Content="Select" HorizontalAlignment="Left" Height="25" Margin="562,144,0,0" VerticalAlignment="Top" Width="75" IsEnabled="False"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Select the path to the driver source(s) that contains the drivers that will be injected." VerticalAlignment="Top" Height="42" Width="353"/>
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
            <TabItem Header ="App Removal" Height="20" Width="100">
                <Grid>
                    <TextBox x:Name="AppxTextBox" TextWrapping="Wrap" Text="Select the apps to remove..." Margin="21,85,252.2,22.8"/>
                    <TextBlock HorizontalAlignment="Left" Margin="21,65,0,0" TextWrapping="Wrap" Text="Selected app packages to remove:" VerticalAlignment="Top" Height="15" Width="194"/>
                    <CheckBox x:Name="AppxCheckBox" Content="Enable app removal" HorizontalAlignment="Left" Margin="21,33,0,0" VerticalAlignment="Top"/>
                    <Button x:Name="AppxButton" Content="Select" HorizontalAlignment="Left" Margin="202,33,0,0" VerticalAlignment="Top" Width="75"/>

                </Grid>

            </TabItem>

            <TabItem Header="Make It So" Height="20" Width="100">
                <Grid>
                    <Grid.ColumnDefinitions>

                        <ColumnDefinition Width="20*"/>
                        <ColumnDefinition Width="769*"/>

                    </Grid.ColumnDefinitions>
                    <Button x:Name="MISFolderButton" Content="Select" HorizontalAlignment="Left" Margin="430,155,0,0" VerticalAlignment="Top" Width="75" RenderTransformOrigin="0.39,-2.647" Grid.Column="1"/>
                    <TextBox x:Name="MISWimNameTextBox" HorizontalAlignment="Left" Height="25" Margin="5.508,85,0,0" TextWrapping="Wrap" Text="Enter Target WIM Name" VerticalAlignment="Top" Width="500" Grid.Column="1"/>
                    <TextBox x:Name="MISDriverTextBox" HorizontalAlignment="Left" Height="23" Margin="122,345,0,0" TextWrapping="Wrap" Text="Driver Y/N" VerticalAlignment="Top" Width="120" Grid.Column="1" IsEnabled="False"/>
                    <Label Content="Driver injection?" HorizontalAlignment="Left" Height="30" Margin="15,343,0,0" VerticalAlignment="Top" Width="101" Grid.Column="1"/>
                    <TextBox x:Name="MISJSONTextBox" HorizontalAlignment="Left" Height="23" Margin="122,374,0,0" TextWrapping="Wrap" Text="JSON Select Y/N" VerticalAlignment="Top" Width="120" Grid.Column="1" IsEnabled="False"/>
                    <Label Content="JSON injection?" HorizontalAlignment="Left" Margin="15,372,0,0" VerticalAlignment="Top" Width="102" Grid.Column="1"/>
                    <TextBox x:Name="MISWimFolderTextBox" HorizontalAlignment="Left" Height="23" Margin="5.508,119,0,0" TextWrapping="Wrap" Text="C:\WIMWitch\CompletedWIMs" VerticalAlignment="Top" Width="500" IsEnabled="False" Grid.Column="1"/>
                    <TextBlock HorizontalAlignment="Left" Margin="5.508,20,0,0" TextWrapping="Wrap" Text="Enter a name, and select a destination forlder, for the  image to be created. Once complete, and build parameters verified, Make it so!" VerticalAlignment="Top" Height="42" Width="353" Grid.Column="1"/>
                    <Button x:Name="MISMakeItSoButton" Content="Make it so!" HorizontalAlignment="Left" Margin="310,339,0,0" VerticalAlignment="Top" Width="353" Height="64" FontSize="24" Grid.Column="1"/>
                    <TextBox x:Name="MISMountTextBox" HorizontalAlignment="Left" Height="25" Margin="5,219,0,0" TextWrapping="Wrap" Text="C:\WIMWitch\Mount" VerticalAlignment="Top" Width="500" IsEnabled="False" Grid.Column="1"/>
                    <Label Content="Mount Path" HorizontalAlignment="Left" Margin="5,194,0,0" VerticalAlignment="Top" Height="25" Width="100" Grid.Column="1"/>
                    <Button x:Name="MISMountSelectButton" Content="Select" HorizontalAlignment="Left" Margin="430,255,0,0" VerticalAlignment="Top" Width="75" Height="25" Grid.Column="1"/>
                    <Label Content="Update injection?" Grid.Column="1" HorizontalAlignment="Left" Margin="15,311,0,0" VerticalAlignment="Top" Width="109"/>
                    <TextBox x:Name="MISUpdatesTextBox" Grid.Column="1" HorizontalAlignment="Left" Height="23" Margin="122,314,0,0" TextWrapping="Wrap" Text="Updates Y/N" VerticalAlignment="Top" Width="120" RenderTransformOrigin="0.171,0.142" IsEnabled="False"/>
                    <Label Content="App removal?" Grid.Column="1" HorizontalAlignment="Left" Margin="15,280,0,0" VerticalAlignment="Top" Width="109"/>
                    <TextBox x:Name="MISAppxTextBox" Grid.Column="1" HorizontalAlignment="Left" Height="23" Margin="122,283,0,0" TextWrapping="Wrap" Text="Updates Y/N" VerticalAlignment="Top" Width="120" RenderTransformOrigin="0.171,0.142" IsEnabled="False"/>

                </Grid>
            </TabItem>
            <TabItem x:Name="Logging" Header="Logging" Height="20" Width="100">
                <Grid>
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Logging" VerticalAlignment="Top" Height="42" Width="353" Grid.ColumnSpan="2"/>
                    <TextBox x:Name="LoggingTextBox" TextWrapping="Wrap" Text="TextBox" Margin="26,67,25.2,36.8" Grid.ColumnSpan="2"/>
                </Grid>
            </TabItem>
        </TabControl>

    </Grid>
</Window>


"@ 
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[xml]$XAML = $inputXML
#Read XAML
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
Try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
}
Catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties in your textboxes (PowerShell cannot process them)"
    throw
}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
  
$xaml.SelectNodes("//*[@Name]") | %{"trying item $($_.Name)";
    Try {Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    Catch{throw}
}
 
Function Get-FormVariables{
	If ($global:ReadmeDisplay -ne $true) {
		Write-Output "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true
	}
	#Write-Output "Found the following interactable elements from our form" -ForegroundColor Cyan
	Get-Variable WPF*
}
 
#Get-FormVariables


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
	Update-Log -Data "Mount directory selected" -Class Information
}

#Function to select Source WIM
Function SelectSourceWIM {

	$SourceWIM = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
		InitialDirectory = [Environment]::GetFolderPath('Desktop') 
		Filter = 'WIM (*.wim)|'
	}
	$null = $SourceWIM.ShowDialog()
	$WPFSourceWIMSelectWIMTextBox.text = $SourceWIM.FileName

	#Select the index
	$ImageFull = @(get-windowsimage -ImagePath $WPFSourceWIMSelectWIMTextBox.text)
	$a = $ImageFull | Out-GridView -Title "Choose an Image Index" -Passthru
	$IndexNumber = $a.ImageIndex
	#Write-Output $IndexNumber

	Try
	{
		#Gets WIM metadata to populate fields on the Source tab.
		$ImageInfo = get-windowsimage -ImagePath $WPFSourceWIMSelectWIMTextBox.text -index $IndexNumber -ErrorAction Stop
	}
	Catch
	{
		Update-Log -data $_.Exception.Message -class Error
		Update-Log -data "The WIM file selected may be borked. Try a different one" -Class Warning
		Return
	}
	$text = "WIM file selected: " + $SourceWIM.FileName
	Update-Log -data $text -Class Information
	#Update-Log -Data "WIM file selected -" -Class Information
	#Update-Log -data $SourceWIM.FileName -Class Information
	$ImageIndex = $IndexNumber


	$WPFSourceWIMImgDesTextBox.text = $ImageInfo.ImageDescription
	$WPFSourceWimVerTextBox.Text = $ImageInfo.Version
	$WPFSourceWimSPBuildTextBox.text = $ImageInfo.SPBuild
	$WPFSourceWimLangTextBox.text = $ImageInfo.Languages
	$WPFSourceWimIndexTextBox.text = $ImageIndex
	If ($ImageInfo.Architecture -eq 9) {
		$WPFSourceWimArchTextBox.text = 'x64'
	}
	Else{
		$WPFSourceWimArchTextBox.text = 'x86'
	}
}
 
#Function to Select JSON File
Function SelectJSONFile {

	$JSON = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
		InitialDirectory = [Environment]::GetFolderPath('Desktop') 
		Filter = 'JSON (*.JSON)|'
	}
	$null = $JSON.ShowDialog()
	$WPFJSONTextBox.Text = $JSON.FileName

	$text = "JSON file selected: " + $JSON.FileName

	Update-Log -Data $text -Class Information
	#Update-Log -data $JSON.FileName -Class Information
}

#Function to select the paths for the driver fields
Function SelectDriverSource($DriverTextBoxNumber) {
	#Write-Output $DriverTextBoxNumber
	Add-Type -AssemblyName System.Windows.Forms
	$browser = New-Object System.Windows.Forms.FolderBrowserDialog
	$browser.Description = "Select the Driver Source folder"
	$null = $browser.ShowDialog()
	$DriverDir = $browser.SelectedPath
	$DriverTextBoxNumber.Text = $DriverDir


	Update-Log -Data "Driver path selected: $DriverDir" -Class Information
}

#Function for the Make it So button
Function MakeItSo ($appx){

	#Check if new file name is valid, also append file extension if neccessary
	If ($WPFMISWimNameTextBox.Text -eq "")
	{
		$WPFLogging.Focus()
		Update-Log -Data "Enter a valid file name and then try again" -Class Error
		Return 
	}


	If ($WPFMISWimNameTextBox.Text -eq "Enter Target WIM Name")
	{
		$WPFLogging.Focus()
		Update-Log -Data "Enter a valid file name and then try again" -Class Error
		Return 
	}

	If ($WPFMISWimNameTextBox.Text -like "*.wim")
	{
		$WPFLogging.Focus()
		Update-Log -Data "New WIM name is valid" -Class Information
	}

	If($WPFMISWimNameTextBox.Text -notlike "*.wim")
	{
		$WPFLogging.Focus()
		$WPFMISWimNameTextBox.Text = $WPFMISWimNameTextBox.Text + ".wim"
		Update-Log -Data "Appending new file name with an extension" -Class Information
	}

	#check for working directory, make if does not exist, delete files if they exist
	$FolderExist = Test-Path C:\WIMWitch\Staging -PathType Any
	Update-Log -Data "Checking to see if the staging path exists..." -Class Information

	Try
	{
		If ($FolderExist = $False) {
			New-Item -ItemType Directory -Force -Path C:\WIMWitch\Staging -ErrorAction Stop
			Update-Log -Data "Path did not exist, but it does now :)" -Class Information -ErrorAction Stop}
		Else{
			Remove-Item –path c:\WIMWitch\Staging\* -Recurse -ErrorAction Stop
			Update-Log -Data "The path existed, and it has been purged." -Class Information -ErrorAction Stop}
	}
	Catch
	{
		Update-Log -data $_.Exception.Message -class Error
		Update-Log -data "Something is wrong with folder C:\WIMWitch\Staging. Try deleting manually if it exists" -Class Error
		Return
	}

	#Copy source WIM
	Update-Log -Data "Copying source WIM to the staging folder" -Class Information

	Try
	{
		Copy-Item $WPFSourceWIMSelectWIMTextBox.Text -Destination "C:\WIMWitch\Staging" -ErrorAction Stop
	}
	Catch
	{
		Update-Log -data $_.Exception.Message -class Error
		Update-Log -Data "The file couldn't be copied. No idea what happened" -class Error
		Return
	}

	Update-Log -Data "Source WIM has been copied to the source folder" -Class Information

	#Rename copied source WiM

	Try
	{
		$wimname = Get-Item -Path C:\WIMWitch\Staging\*.wim -ErrorAction Stop
		Rename-Item -Path $wimname -NewName $WPFMISWimNameTextBox.Text -ErrorAction Stop
		Update-Log -Data "Copied source WIM has been renamed" -Class Information
	}
	Catch
	{
		Update-Log -data $_.Exception.Message -class Error
		Update-Log -data "The copied source file couldn't be renamed. This shouldn't have happened." -Class Error
		Update-Log -data "Go delete the WIM from C:\WIMWitch\Staging\, then try again" -Class Error
		Return
	}

	#Remove the unwanted indexes
	Remove-Indexes

	#Mount the WIM File
	$wimname = Get-Item -Path C:\WIMWitch\Staging\*.wim
	Update-Log -Data "Mounting source WIM $wimname" -Class Information
	Update-Log -Data "to mount point:" -Class Information
	Update-Log -data $WPFMISMountTextBox.Text -Class Information

	Try
	{
	   #Write-Output $IndexNumber
		Mount-WindowsImage -Path $WPFMISMountTextBox.Text -ImagePath $wimname -Index 1 -ErrorAction Stop
	}
	Catch
	{
		Update-Log -data $_.Exception.Message -class Error
		Update-Log -data "The WIM couldn't be mounted. Make sure the mount directory is empty" -Class Error
		Update-Log -Data "and that it isn't an active mount point" -Class Error
		Return
	}



	#Inject Autopilot JSON file
	If ($WPFJSONEnableCheckBox.IsChecked -eq $true) {

		Update-Log -Data "Injecting JSON file" -Class Information

		Try
		{
			$autopilotdir = $WPFMISMountTextBox.Text + "\windows\Provisioning\Autopilot"
			Copy-Item $WPFJSONTextBox.Text -Destination $autopilotdir -ErrorAction Stop
		}
		Catch
		{
			Update-Log -data $_.Exception.Message -class Error
			Update-Log -data "JSON file couldn't be copied. Check to see if the correct SKU" -Class Error
			Update-Log -Data "of Windows has been selected" -Class Error
			Update-log -Data "The WIM is still mounted. You'll need to clean that up manually until" -Class Error
			Update-Log -data "I get around to handling that error more betterer" -Class Error
			Update-Log -data "- <3 Donna" -Class Error
			Return  
		}

	}
	Else{
		Update-Log -Data "JSON not selected. Skipping JSON Injection" -Class Information
	}

	#Inject Drivers
	If ($WPFDriverCheckBox.IsChecked -eq $true){

		DriverInjection -Folder $WPFDriverDir1TextBox.text
		DriverInjection -Folder $WPFDriverDir2TextBox.text
		DriverInjection -Folder $WPFDriverDir3TextBox.text
		DriverInjection -Folder $WPFDriverDir4TextBox.text
		DriverInjection -Folder $WPFDriverDir5TextBox.text
	}
	Else
	{
		Update-Log -Data "Drivers were not selected for injection. Skipping." -Class Information 
	}

	#Apply Updates
	If ($WPFUpdatesEnableCheckBox.IsChecked -eq $true){

		Apply-Updates -class "SSU" 
		Apply-Updates -class "LCU"
		Apply-Updates -class "AdobeSU"
		Apply-Updates -class "DotNet"
		Apply-Updates -class "DotNetCU"
	}
	Else
	{
		Update-Log -Data "Updates not enabled" -Class Information
	}

	#Remove AppX Packages
	If ($WPFAppxCheckBox.IsChecked -eq $true){
		Remove-Appx -array $appx
	}
	Else {
		Update-Log -Data "App removal not enabled" -Class Information
	}

	#Copy log to mounted WIM
	Try
	{
		Update-Log -Data "Attempting to copy log to mounted image" -Class Information 
		$mountlogdir = $WPFMISMountTextBox.Text + "\windows\"
		Copy-Item C:\WIMWitch\logging\WIMWitch.log -Destination $mountlogdir -ErrorAction Stop
		$CopyLogExist = Test-Path $mountlogdir\WIMWitch.log -PathType Leaf
		If ($CopyLogExist -eq $true) {Update-Log -Data "Log filed copied successfully" -Class Information}
	}
	Catch
	{
	   Update-Log -data $_.Exception.Message -class Error
	   Update-Log -data "Coudn't copy the log file to the mounted image." -class Error
	}

	#Dismount, commit, and move WIM

	Update-Log -Data "Dismounting WIM file, committing changes" -Class Information 
	Try
	{
		Dismount-WindowsImage -Path $WPFMISMountTextBox.Text -save -ErrorAction Stop
	}
	Catch
	{
		Update-Log -data $_.Exception.Message -class Error
		Update-Log -data "The WIM couldn't save. You will have to manually discard the" -Class Error
		Update-Log -data "mounted image manually" -Class Error
		Return
	}

	Update-Log -Data "WIM dismounted" -Class Information 

	Try
	{
		Move-Item -Path $wimname -Destination $WPFMISWimFolderTextBox.Text -ErrorAction Stop
	}
	Catch
	{
		Update-Log -data $_.Exception.Message -class Error
		Update-Log -data "The WIM couldn't be copied. You can still retrieve it from staging path." -Class Error
		Update-Log -data "The file will be deleted when the tool is rerun." -Class Error
		Return
	}
	Update-Log -Data "Moved saved WIM to target directory" -Class Information 

	#Copy log here
	Try
	{
		Update-Log -Data "Copying build log to target folder" -Class Information 
		Copy-Item -Path C:\WIMWitch\logging\WIMWitch.log -Destination $WPFMISWimFolderTextBox.Text -ErrorAction Stop
		$logold = $WPFMISWimFolderTextBox.Text + "\WIMWitch.log"
		$lognew = $WPFMISWimFolderTextBox.Text + "\" + $WPFMISWimNameTextBox.Text + ".log"
		Rename-Item $logold -NewName $lognew -Force -ErrorAction Stop
	}
	Catch
	{
		Update-Log -data $_.Exception.Message -class Error
		Update-Log -data "The log file couldn't be copied and renamed. You can still snag it from the source." -Class Error
		Update-Log -Data "Job's done." -Class Information 
		Return
	}
	Update-Log -Data "Job's done." -Class Information 
}

#Function to assign the target directory
Function SelectTargetDir {

	Add-Type -AssemblyName System.Windows.Forms
	$browser = New-Object System.Windows.Forms.FolderBrowserDialog
	$browser.Description = "Select the target folder"
	$null = $browser.ShowDialog()
	$TargetDir = $browser.SelectedPath
	$WPFMISWimFolderTextBox.text = $TargetDir #I SCREWED UP THIS VARIABLE
	Update-Log -Data "Target directory selected" -Class Information 
}

#Function to enable logging and folder check
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
            Write-Output $HostString -ForegroundColor Gray
            }
        'Warning'{
            Write-Output $HostString -ForegroundColor Yellow
            }
        'Error'{
            Write-Output $HostString -ForegroundColor Red
            }
        Default {}
    }
    $WPFLoggingTextBox.text = Get-Content -Path $Log -Delimiter "\n"
}

#Removes old log and creates all folders if does not exist
Function Set-Logging{

	#logging folder
	$FileExist = Test-Path -Path C:\WIMWitch\logging\WIMWitch.Log -PathType Leaf
	If ($FileExist -eq $False) {
		#Update-Log -data "Logging folder does not exist" -class Warning
		New-Item -ItemType Directory -Force -Path C:\WIMWitch\Logging |Out-Null
		New-Item -Path C:\WIMWitch\logging -Name "WIMWitch.log" -ItemType "file" -Value "***Logging Started***" |Out-Null
		#Update-Log -data "Logging folder and log created successfully" -Class Information 
	}
	Else{
		 Remove-Item -Path C:\WIMWitch\logging\WIMWitch.log
		 New-Item -Path C:\WIMWitch\logging -Name "WIMWitch.log" -ItemType "file" -Value "***Logging Started***"|Out-Null
		 #Update-Log -Data "Logging started successfully" -Class Information
	 }
	#$log = C:\WIMWitch\logging\WIMWitch.Log

	#updates folder
	$FileExist = Test-Path -Path C:\WIMWitch\updates #-PathType Leaf
	If ($FileExist -eq $False) {
		Update-Log -Data "Updates folder does not exist. Creating..." -Class Warning
		New-Item -ItemType Directory -Force -Path C:\WIMWitch\updates |Out-Null
		Update-Log -Data "Updates folder created" -Class Information
	}
	   
	If ($FileExist -eq $True){Update-Log -Data "Updates folder exists" -Class Information}

	#staging folder
	$FileExist = Test-Path -Path C:\WIMWitch\Staging #-PathType Leaf
	If ($FileExist -eq $False) {
		Update-Log -Data "Staging folder does not exist. Creating..." -Class Warning
		New-Item -ItemType Directory -Force -Path C:\WIMWitch\Staging |Out-Null
		Update-Log -Data "Staging folder created" -Class Information
	}

	If ($FileExist -eq $True){Update-Log -Data "Staging folder exists" -Class Information}

	#Mount folder
	$FileExist = Test-Path -Path C:\WIMWitch\Mount #-PathType Leaf
	If ($FileExist -eq $False) {
		Update-Log -Data "Mount folder does not exist. Creating..." -Class Warning
		New-Item -ItemType Directory -Force -Path C:\WIMWitch\Mount |Out-Null
		Update-Log -Data "Mount folder created" -Class Information
	}

	If ($FileExist -eq $True){Update-Log -Data "Mount folder exists" -Class Information}

	#Completed WIMs folder
	$FileExist = Test-Path -Path C:\WIMWitch\CompletedWIMs #-PathType Leaf
	If ($FileExist -eq $False) {
		Update-Log -Data "CompletedWIMs folder does not exist. Creating..." -Class Warning
		New-Item -ItemType Directory -Force -Path C:\WIMWitch\CompletedWIMs |Out-Null
		Update-Log -Data "CompletedWIMs folder created" -Class Information
	}

	If ($FileExist -eq $True){Update-Log -Data "CompletedWIMs folder exists" -Class Information}
}

#Function for apply a single driver into the mounted WIM
Function ApplyDriver($drivertoapply){
	Try{
	   Add-WindowsDriver -Path $WPFMISMountTextBox.Text -Driver $drivertoapply -ErrorAction Stop
	   Update-Log -Data "Applied $drivertoapply" -Class Information
	}
	Catch
	{
		Update-Log -Data "Couldn't apply $drivertoapply" -Class Warning
	}
}

#Function for injecting drivers into the mounted WIM
Function DriverInjection($Folder)
{
	 
	#This filters out invalid paths, such as the default value
	$testpath = Test-Path $folder -PathType Container
	If ($testpath -eq $false){Return}

	If ($testpath -eq $true){

		Update-Log -data "Applying drivers from $folder" -class Information

		Get-ChildItem $Folder -Recurse -Filter "*inf" | ForEach-Object {ApplyDriver $_.FullName}
		Update-Log -Data "Completed driver injection from $folder" -Class Information 
	}
}

#Function to retrieve OSDBuilder Version 
Function Get-OSDBInstallation{
	Update-Log -Data "Getting OSD Installation information" -Class Information
	Try
	{
		Import-Module -name OSDUpdate -ErrorAction Stop
	}
	Catch
	{
		$WPFUpdatesOSDBVersion.Text = "Not Installed"
		Update-Log -Data "OSD Update is not installed" -Class Warning
		Return
	}
	
	Try
	{
		$OSDBVersion = get-module -name OSDUpdate -ErrorAction Stop
		$WPFUpdatesOSDBVersion.Text = $OSDBVersion.Version
		$text = $osdbversion.version
		Update-Log -data "Installed version of OSD Update is $text" -Class Information
		Return
	}
	Catch
	{
		Update-Log -Data "Whatever you were hoping for, you didn’t get :)" -Class Error
		Return
	}
}

#Function to retrieve current OSDBuilder Version
Function Get-OSDBCurrentVer{
	Update-Log -Data "Checking for the most current OSD Update version available" -Class Information
	Try
	{
		$OSDBCurrentVer = find-module -name OSDUpdate -ErrorAction Stop
		$WPFUpdatesOSDBCurrentVerTextBox.Text = $OSDBCurrentVer.version
		$text = $OSDBCurrentVer.version
		Update-Log -data "$text is the most current version" -class Information
		Return
	}
	Catch
	{
		$WPFUpdatesOSDBCurrentVerTextBox.Text = "Network Error"
		Return
	}
}

#Function to update or install OSDBuilder
Function Update-OSDB{
	If ($WPFUpdatesOSDBVersion.Text -eq "Not Installed"){
		Update-Log -Data "Attempting to install and import OSD Update" -Class Information
		Try{
			Install-Module OSDUpdate -Force -ErrorAction Stop
			#Write-Output "Installed module"
			Update-Log -data "OSD Update module has been installed" -Class Information
			Import-Module -Name OSDUpdate -Force -ErrorAction Stop
			#Write-Output "Imported module"
			Update-Log -Data "OSD Update module has been imported" -Class Information
			Update-Log -Data "****************************************************************************" -Class Warning
			Update-Log -Data "Please close WIM Witch and all PowerShell windows, then rerun to continue..." -Class Warning
			Update-Log -Data "****************************************************************************" -Class Warning
			$WPFUpdatesOSDBClosePowerShellTextBlock.visibility = "Visible"
			Return
		}
		Catch
		{
			$WPFUpdatesOSDBVersion.Text = "Inst Fail"
			Update-Log -Data "Couldn't install OSD Update" -Class Error
			Update-Log -data $_.Exception.Message -class Error
			Return
		}
	}

	If ($WPFUpdatesOSDBVersion.Text -gt "1.0.0"){
		Update-Log "Attempting to update OSD Update" -class Information
		Try
		{
			Update-ModuleOSDUpdate -ErrorAction Stop
			Update-Log -Data "Updated OSD Update" -Class Information
			Update-Log -Data "****************************************************************************" -Class Warning
			Update-Log -Data "Please close WIM Witch and all PowerShell windows, then rerun to continue..." -Class Warning
			Update-Log -Data "****************************************************************************" -Class Warning
			$WPFUpdatesOSDBClosePowerShellTextBlock.visibility = "Visible"
			get-OSDBInstallation
			Return
		}
		Catch
		{
			$WPFUpdatesOSDBCurrentVerTextBox.Text = "OSDB Err"
			Return
		}
	}
}

#Function to check for superceded updates
Function Check-Superceded($action){
	Update-Log -Data "Checking WIM Witch Update store for superseded updates" -Class Information
	$path = "C:\WIMWitch\updates\"  #sets base path
	$Children = Get-ChildItem -Path $path  #query sub directories

    ForEach ($Children in $Children){
		$path1 = $path + $Children  
		$kids = Get-ChildItem -Path $path1
	 
		ForEach ($kids in $kids){
			$path2 = $path1 + '\' + $kids
			$sprout = get-childitem -path $path2
			
			ForEach ($sprout in $sprout) {
				$path3 = $path2 + '\' + $sprout
				$fileinfo = get-childitem -path $path3
				
				$StillCurrent = Get-OSDUpdate | Where-Object {$_.FileName -eq $fileinfo}
				If ($StillCurrent -eq $null){
					Update-Log -data "$fileinfo no longer current" -Class Warning
					If ($action -eq 'delete'){
						Update-Log -data "Deleting $path3" -class Warning
						remove-item -path $path3 -Recurse -Force
					}
					If ($action -eq 'audit'){
						#Write-Output "set variable"
						$WPFUpdatesOSDBSupercededExistTextBlock.Visibility = "Visible"

						Return
					}
				}   
				Else{
					Update-Log -data "$fileinfo is stil current" -Class Information
				}
			 }
		}
    }
}

#Function to compare OSDBuilder Versions
Function Compare-OSDBuilderVer{
	Update-Log -data "Comparing OSD Update module versions" -Class Information
	If ($WPFUpdatesOSDBVersion.Text -eq "Not Installed"){
		Return
	}
	If ($WPFUpdatesOSDBVersion.Text -eq $WPFUpdatesOSDBCurrentVerTextBox.Text){
		Update-Log -Data "OSD Update is up to date" -class Information
		Return
	}
	$WPFUpdatesOSDBOutOfDateTextBlock.Visibility = "Visible"
	Update-Log -Data "OSD Update appears to be out of date. Run the upgrade function from within WIM Witch to resolve" -class Warning

	Return
}

#Function to download new patches
Function Download-Patches($build){
	Update-Log -Data "Downloading SSU updates for Windows 10 $build" -Class Information
	Get-OSDUpdate | Where-Object {$_.UpdateOS -eq 'Windows 10' -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'SSU'} |Get-DownOSDUpdate -DownloadPath C:\WIMWitch\updates\$build\SSU
	Update-Log -Data "Downloading AdobeSU updates for Windows 10 $build" -Class Information
	Get-OSDUpdate | Where-Object {$_.UpdateOS -eq 'Windows 10' -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'AdobeSU'} |Get-DownOSDUpdate -DownloadPath C:\WIMWitch\updates\$build\AdobeSU
	Update-Log -Data "Downloading LCU updates for Windows 10 $build" -Class Information
	Get-OSDUpdate | Where-Object {$_.UpdateOS -eq 'Windows 10' -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'LCU'} |Get-DownOSDUpdate -DownloadPath C:\WIMWitch\updates\$build\LCU
	Update-Log -Data "Downloading .Net updates for Windows 10 $build" -Class Information
	Get-OSDUpdate | Where-Object {$_.UpdateOS -eq 'Windows 10' -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'DotNet'} |Get-DownOSDUpdate -DownloadPath C:\WIMWitch\updates\$build\DotNet
	Update-Log -Data "Downloading .Net CU updates for Windows 10 $build" -Class Information
	Get-OSDUpdate | Where-Object {$_.UpdateOS -eq 'Windows 10' -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'DotNetCU'} |Get-DownOSDUpdate -DownloadPath C:\WIMWitch\updates\$build\DotNetCU
	Update-Log -Data "Downloading completed for Windows 10 $build" -Class Information
}
 
#Function to remove superceded updates and initate new patch download
Function Update-PatchSource{

	Try{
		#Write-Output "starting purge"
		#Get-DownOSDBuilder -Superseded Remove -ErrorAction Stop
		#Update-Log -Data "Deleting superseded updates..." -Class Warning
		Check-Superceded -action delete -ErrorAction Stop
	} 
	Catch
	{
		Update-Log -Data "Updates not superceded" -Class Information
		Return
	}
	
	Update-Log -Data "attempting to start download function" -Class Information
	If ($WPFUpdates1903CheckBox.IsChecked -eq $true){Download-Patches -build 1903}
	If ($WPFUpdates1809CheckBox.IsChecked -eq $true){Download-Patches -build 1809}
	If ($WPFUpdates1803CheckBox.IsChecked -eq $true){Download-Patches -build 1803}
	If ($WPFUpdates1709CheckBox.IsChecked -eq $true){Download-Patches -build 1709}

}

#Function to apply updates to mounted WIM
Function Apply-Updates($class){

	#$Imageversion = Get-WindowsImage -ImagePath D:\Images\install.wim -Index 3

	$WPFSourceWimVerTextBox.text

	If ($WPFSourceWimVerTextBox.text -like "10.0.18362.*"){$buildnum = 1903}
	If ($WPFSourceWimVerTextBox.text -like "10.0.17763.*"){$buildnum = 1809}
	If ($WPFSourceWimVerTextBox.text -like "10.0.17134.*"){$buildnum = 1803}
	If ($WPFSourceWimVerTextBox.text -like "10.0.16299.*"){$buildnum = 1709}


	$path = 'C:\wimwitch\updates\' + $buildnum +'\' + $class + '\'
	$Children = Get-ChildItem -Path $path
	ForEach ($Children in $Children){
		$compound = $path+$Children
		Update-Log -Data "Applying $Children" -Class Information
		Add-WindowsPackage -path $WPFMISMountTextBox.Text -PackagePath $compound 
	}
}

#Function to select AppX packages to yank
Function Select-Appx{
	$appx1903 = @("Microsoft.BingWeather_4.25.20211.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.DesktopAppInstaller_2019.125.2243.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.GetHelp_10.1706.13331.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.Getstarted_7.3.20251.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.HEIFImageExtension_1.0.13472.0_x64__8wekyb3d8bbwe"
	"Microsoft.Messaging_2019.125.32.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.Microsoft3DViewer_5.1902.20012.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.MicrosoftOfficeHub_18.1901.1141.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.MicrosoftSolitaireCollection_4.2.11280.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.MicrosoftStickyNotes_3.1.53.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.MixedReality.Portal_2000.19010.1151.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.MSPaint_2019.213.1858.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.Office.OneNote_16001.11126.20076.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.OneConnect_5.1902.361.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.People_2019.123.2346.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.Print3D_3.3.311.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.ScreenSketch_2018.1214.231.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.SkypeApp_14.35.152.0_neutral_~_kzf8qxf38zg5c,"
	"Microsoft.StorePurchaseApp_11811.1001.1813.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.VP9VideoExtensions_1.0.13333.0_x64__8wekyb3d8bbwe"
	"Microsoft.Wallet_2.4.18324.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.WebMediaExtensions_1.0.13321.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.WebpImageExtension_1.0.12821.0_x64__8wekyb3d8bbwe"
	"Microsoft.Windows.Photos_2019.18114.19418.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.WindowsAlarms_2019.105.629.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.WindowsCalculator_2019.105.612.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.WindowsCamera_2018.826.78.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.windowscommunicationsapps_16005.11029.20108.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.WindowsFeedbackHub_2019.226.2324.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.WindowsMaps_2019.108.627.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.WindowsSoundRecorder_2019.105.618.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.WindowsStore_11811.1001.1813.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.Xbox.TCUI_1.23.28002.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.XboxApp_48.48.7001.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.XboxGameOverlay_1.32.17005.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.XboxGamingOverlay_2.26.14003.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.XboxIdentityProvider_12.50.6001.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.YourPhone_2018.1128.231.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.ZuneMusic_2019.18111.17311.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.ZuneVideo_2019.18111.17311.0_neutral_~_8wekyb3d8bbwe")
	$appx1809 = @(
	"Microsoft.BingWeather_4.25.12127.0_neutral_~_8wekyb3d8bbwe"                   
	"Microsoft.DesktopAppInstaller_2018.720.2137.0_neutral_~_8wekyb3d8bbwe"        
	"Microsoft.GetHelp_10.1706.10441.0_neutral_~_8wekyb3d8bbwe"                    
	"Microsoft.Getstarted_6.13.11581.0_neutral_~_8wekyb3d8bbwe"                    
	"Microsoft.HEIFImageExtension_1.0.11792.0_x64__8wekyb3d8bbwe"                  
	"Microsoft.Messaging_2018.727.1430.0_neutral_~_8wekyb3d8bbwe"                  
	"Microsoft.Microsoft3DViewer_4.1808.15012.0_neutral_~_8wekyb3d8bbwe"           
	"Microsoft.MicrosoftOfficeHub_2017.1219.520.0_neutral_~_8wekyb3d8bbwe"         
	"Microsoft.MicrosoftSolitaireCollection_4.1.5252.0_neutral_~_8wekyb3d8bbwe"    
	"Microsoft.MicrosoftStickyNotes_2.0.13.0_neutral_~_8wekyb3d8bbwe"              
	"Microsoft.MixedReality.Portal_2000.18081.1242.0_neutral_~_8wekyb3d8bbwe"      
	"Microsoft.MSPaint_4.1807.12027.0_neutral_~_8wekyb3d8bbwe"                     
	"Microsoft.Office.OneNote_16001.10228.20003.0_neutral_~_8wekyb3d8bbwe"         
	"Microsoft.OneConnect_5.1807.1991.0_neutral_~_8wekyb3d8bbwe"                   
	"Microsoft.People_2018.516.2011.0_neutral_~_8wekyb3d8bbwe"                     
	"Microsoft.Print3D_3.0.1521.0_neutral_~_8wekyb3d8bbwe"                         
	"Microsoft.ScreenSketch_2018.731.48.0_neutral_~_8wekyb3d8bbwe"                 
	"Microsoft.SkypeApp_14.26.95.0_neutral_~_kzf8qxf38zg5c"                        
	"Microsoft.StorePurchaseApp_11805.1001.813.0_neutral_~_8wekyb3d8bbwe"          
	"Microsoft.VP9VideoExtensions_1.0.12342.0_x64__8wekyb3d8bbwe"                  
	"Microsoft.Wallet_2.2.18179.0_neutral_~_8wekyb3d8bbwe"                         
	"Microsoft.WebMediaExtensions_1.0.12341.0_neutral_~_8wekyb3d8bbwe"             
	"Microsoft.WebpImageExtension_1.0.11551.0_x64__8wekyb3d8bbwe"                  
	"Microsoft.Windows.Photos_2018.18051.21218.0_neutral_~_8wekyb3d8bbwe"          
	"Microsoft.WindowsAlarms_2018.516.2059.0_neutral_~_8wekyb3d8bbwe"              
	"Microsoft.WindowsCalculator_2018.501.612.0_neutral_~_8wekyb3d8bbwe"           
	"Microsoft.WindowsCamera_2018.425.120.0_neutral_~_8wekyb3d8bbwe"               
	"Microsoft.windowscommunicationsapps_2015.9330.21365.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.WindowsFeedbackHub_2018.822.2.0_neutral_~_8wekyb3d8bbwe"            
	"Microsoft.WindowsMaps_2018.523.2143.0_neutral_~_8wekyb3d8bbwe"                
	"Microsoft.WindowsSoundRecorder_2018.713.2154.0_neutral_~_8wekyb3d8bbwe"       
	"Microsoft.WindowsStore_11805.1001.4913.0_neutral_~_8wekyb3d8bbwe"             
	"Microsoft.Xbox.TCUI_1.11.28003.0_neutral_~_8wekyb3d8bbwe"                     
	"Microsoft.XboxApp_41.41.18001.0_neutral_~_8wekyb3d8bbwe"                      
	"Microsoft.XboxGameOverlay_1.32.17005.0_neutral_~_8wekyb3d8bbwe"               
	"Microsoft.XboxGamingOverlay_2.20.22001.0_neutral_~_8wekyb3d8bbwe"             
	"Microsoft.XboxIdentityProvider_12.44.20001.0_neutral_~_8wekyb3d8bbwe"         
	"Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe"       
	"Microsoft.YourPhone_2018.727.2137.0_neutral_~_8wekyb3d8bbwe"                  
	"Microsoft.ZuneMusic_2019.18052.20211.0_neutral_~_8wekyb3d8bbwe"               
	"Microsoft.ZuneVideo_2019.18052.20211.0_neutral_~_8wekyb3d8bbwe" 
	  )
	$appx1803 = @( 
	"Microsoft.BingWeather_4.22.3254.0_neutral_~_8wekyb3d8bbwe"                    
	"Microsoft.DesktopAppInstaller_1.8.15011.0_neutral_~_8wekyb3d8bbwe"            
	"Microsoft.GetHelp_10.1706.10441.0_neutral_~_8wekyb3d8bbwe"                    
	"Microsoft.Getstarted_6.9.10602.0_neutral_~_8wekyb3d8bbwe"                     
	"Microsoft.Messaging_2018.222.2231.0_neutral_~_8wekyb3d8bbwe"                  
	"Microsoft.Microsoft3DViewer_2.1803.8022.0_neutral_~_8wekyb3d8bbwe"            
	"Microsoft.MicrosoftOfficeHub_2017.1219.520.0_neutral_~_8wekyb3d8bbwe"         
	"Microsoft.MicrosoftSolitaireCollection_4.0.1301.0_neutral_~_8wekyb3d8bbwe"    
	"Microsoft.MicrosoftStickyNotes_2.0.13.0_neutral_~_8wekyb3d8bbwe"              
	"Microsoft.MSPaint_3.1803.5027.0_neutral_~_8wekyb3d8bbwe"                      
	"Microsoft.Office.OneNote_2015.8827.20991.0_neutral_~_8wekyb3d8bbwe"           
	"Microsoft.OneConnect_4.1801.521.0_neutral_~_8wekyb3d8bbwe"                    
	"Microsoft.People_2018.215.110.0_neutral_~_8wekyb3d8bbwe"                      
	"Microsoft.Print3D_2.0.3621.0_neutral_~_8wekyb3d8bbwe"                         
	"Microsoft.SkypeApp_12.13.274.0_neutral_~_kzf8qxf38zg5c"                       
	"Microsoft.StorePurchaseApp_11712.1801.10024.0_neutral_~_8wekyb3d8bbwe"        
	"Microsoft.Wallet_2.1.18009.0_neutral_~_8wekyb3d8bbwe"                         
	"Microsoft.WebMediaExtensions_1.0.3102.0_neutral_~_8wekyb3d8bbwe"              
	"Microsoft.Windows.Photos_2018.18011.15918.0_neutral_~_8wekyb3d8bbwe"          
	"Microsoft.WindowsAlarms_2018.302.1846.0_neutral_~_8wekyb3d8bbwe"              
	"Microsoft.WindowsCalculator_2018.302.144.0_neutral_~_8wekyb3d8bbwe"           
	"Microsoft.WindowsCamera_2017.1117.80.0_neutral_~_8wekyb3d8bbwe"               
	"Microsoft.windowscommunicationsapps_2015.8827.22055.0_neutral_~_8wekyb3d8bbwe"
	"Microsoft.WindowsFeedbackHub_2018.302.2011.0_neutral_~_8wekyb3d8bbwe"         
	"Microsoft.WindowsMaps_2018.209.2206.0_neutral_~_8wekyb3d8bbwe"                
	"Microsoft.WindowsSoundRecorder_2018.302.1842.0_neutral_~_8wekyb3d8bbwe"       
	"Microsoft.WindowsStore_11712.1001.2313.0_neutral_~_8wekyb3d8bbwe"             
	"Microsoft.Xbox.TCUI_1.11.28003.0_neutral_~_8wekyb3d8bbwe"                     
	"Microsoft.XboxApp_38.38.14002.0_neutral_~_8wekyb3d8bbwe"                      
	"Microsoft.XboxGameOverlay_1.26.6001.0_neutral_~_8wekyb3d8bbwe"                
	"Microsoft.XboxGamingOverlay_1.15.1001.0_neutral_~_8wekyb3d8bbwe"              
	"Microsoft.XboxIdentityProvider_12.36.15002.0_neutral_~_8wekyb3d8bbwe"         
	"Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe"       
	"Microsoft.ZuneMusic_2019.17112.19011.0_neutral_~_8wekyb3d8bbwe"               
	"Microsoft.ZuneVideo_2019.17112.19011.0_neutral_~_8wekyb3d8bbwe" )
	$appx1709 = @( 
	"Microsoft.BingWeather_4.21.2492.0_neutral_~_8wekyb3d8bbwe",                    
	"Microsoft.DesktopAppInstaller_1.8.4001.0_neutral_~_8wekyb3d8bbwe",             
	"Microsoft.GetHelp_10.1706.1811.0_neutral_~_8wekyb3d8bbwe",                     
	"Microsoft.Getstarted_5.11.1641.0_neutral_~_8wekyb3d8bbwe",                     
	"Microsoft.Messaging_2017.815.2052.0_neutral_~_8wekyb3d8bbwe",                  
	"Microsoft.Microsoft3DViewer_1.1707.26019.0_neutral_~_8wekyb3d8bbwe",           
	"Microsoft.MicrosoftOfficeHub_2017.715.118.0_neutral_~_8wekyb3d8bbwe",          
	"Microsoft.MicrosoftSolitaireCollection_3.17.8162.0_neutral_~_8wekyb3d8bbwe",   
	"Microsoft.MicrosoftStickyNotes_1.8.2.0_neutral_~_8wekyb3d8bbwe",               
	"Microsoft.MSPaint_2.1709.4027.0_neutral_~_8wekyb3d8bbwe",                      
	"Microsoft.Office.OneNote_2015.8366.57611.0_neutral_~_8wekyb3d8bbwe",           
	"Microsoft.OneConnect_3.1708.2224.0_neutral_~_8wekyb3d8bbwe",                   
	"Microsoft.People_2017.823.2207.0_neutral_~_8wekyb3d8bbwe",                     
	"Microsoft.Print3D_1.0.2422.0_neutral_~_8wekyb3d8bbwe",                         
	"Microsoft.SkypeApp_11.18.596.0_neutral_~_kzf8qxf38zg5c",                       
	"Microsoft.StorePurchaseApp_11706.1707.7104.0_neutral_~_8wekyb3d8bbwe",         
	"Microsoft.Wallet_1.0.16328.0_neutral_~_8wekyb3d8bbwe",                         
	"Microsoft.Windows.Photos_2017.37071.16410.0_neutral_~_8wekyb3d8bbwe",          
	"Microsoft.WindowsAlarms_2017.828.2050.0_neutral_~_8wekyb3d8bbwe",              
	"Microsoft.WindowsCalculator_2017.828.2012.0_neutral_~_8wekyb3d8bbwe",          
	"Microsoft.WindowsCamera_2017.727.20.0_neutral_~_8wekyb3d8bbwe",                
	"Microsoft.windowscommunicationsapps_2015.8241.41275.0_neutral_~_8wekyb3d8bbwe",
	"Microsoft.WindowsFeedbackHub_1.1705.2121.0_neutral_~_8wekyb3d8bbwe",           
	"Microsoft.WindowsMaps_2017.814.2249.0_neutral_~_8wekyb3d8bbwe",                
	"Microsoft.WindowsSoundRecorder_2017.605.2103.0_neutral_~_8wekyb3d8bbwe",       
	"Microsoft.WindowsStore_11706.1002.94.0_neutral_~_8wekyb3d8bbwe",               
	"Microsoft.Xbox.TCUI_1.8.24001.0_neutral_~_8wekyb3d8bbwe",                      
	"Microsoft.XboxApp_31.32.16002.0_neutral_~_8wekyb3d8bbwe",                      
	"Microsoft.XboxGameOverlay_1.20.25002.0_neutral_~_8wekyb3d8bbwe",               
	"Microsoft.XboxIdentityProvider_2017.605.1240.0_neutral_~_8wekyb3d8bbwe",       
	"Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe",       
	"Microsoft.ZuneMusic_2019.17063.24021.0_neutral_~_8wekyb3d8bbwe",               
	"Microsoft.ZuneVideo_2019.17063.24021.0_neutral_~_8wekyb3d8bbwe" )

	If ($WPFSourceWimVerTextBox.text -like "10.0.18362.*"){$exappxs = Write-Output $appx1903 | out-gridview -passthru}
	If ($WPFSourceWimVerTextBox.text -like "10.0.17763.*"){$exappxs = Write-Output $appx1809 | out-gridview -passthru}
	If ($WPFSourceWimVerTextBox.text -like "10.0.17134.*"){$exappxs = Write-Output $appx1803 | out-gridview -passthru}
	If ($WPFSourceWimVerTextBox.text -like "10.0.16299.*"){$exappxs = Write-Output $appx1709 | out-gridview -passthru}

	If ($exappxs -eq $null){
		Update-Log -Data "No apps were selected" -Class Warning
		}
	If ($exappxs -ne $null){
		Update-Log -data "The following apps were selected for removal:" -Class Information
		Foreach ($exappx in $exappxs){
			Update-Log -Data $exappx -Class Information
		}

		$WPFAppxTextBox.Text = $exappxs
		Return $exappxs
	}
}

#Function to remove appx packages
Function Remove-Appx($array){
	$exappxs = $array

	ForEach ($exappx in $exappxs){
		Remove-AppxProvisionedPackage -Path $WPFMISMountTextBox.Text -PackageName $exappx 
		Update-Log -data "Removing $exappx" -Class Information
		#Write-Output "removing" $exappx "from the WIM"
	}
	Return
}

#Function to remove unwanted image indexes
Function Remove-Indexes{
	Update-Log -Data "Attempting to remove unwanted image indexes" -Class Information
	$wimname = Get-Item -Path C:\WIMWitch\Staging\*.wim
	Update-Log -Data "Found Image $wimname" -Class Information
	$IndexesAll = Get-WindowsImage -ImagePath $wimname | ForEach { $_.ImageName }
	$IndexSelected = $WPFSourceWIMImgDesTextBox.Text
	ForEach ($Index in $IndexesAll){
		Update-Log -data "$Index is being evaluated"
		If ($Index -eq $IndexSelected){
			Update-Log -Data "$Index is the index we want to keep. Skipping." -Class Information
		}
		Else{
			Update-Log -data "Deleting $Index from WIM" -Class Information
			Remove-WindowsImage -ImagePath $wimname -Name $Index -InformationAction SilentlyContinue
		}
	}
}

#===========================================================================
# Run commands to set values of files and variables, etc.
#===========================================================================
#Set the path and name for logging
$Log = "C:\WIMWitch\logging\WIMWitch.log"

Set-Logging #Clears out old logs from previous builds and checks for other folders
Get-OSDBInstallation #Sets OSDBuilder version info
Get-OSDBCurrentVer #Discovers current version of OSDBuilder
Compare-OSDBuilderVer #determines if an update of OSDBuilder can be applied
Check-Superceded #checks to see if superceded patches exist

Update-Log -data "Starting WIM Witch GUI" -class Information


#===========================================================================
# Set default values for certain variables
#===========================================================================

#Set the value of the JSON field in Make It So tab
$WPFMISJSONTextBox.Text = "False"

#Set the value of the Driver field in the Make It So tab
$WPFMISDriverTextBox.Text = "False"

#Set the value of the Updates field in the Make It So tab
$WPFMISUpdatesTextBox.Text = "False"

$WPFMISAppxTextBox.Text = "False"





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
#$WPFMISMakeItSoButton.Add_Click({MakeItSo}) 
$WPFMISMakeItSoButton.Add_Click({MakeItSo -appx $global:SelectedAppx}) 

#Update OSDBuilder Button
$WPFUpdateOSDBUpdateButton.Add_Click({Update-OSDB}) 

#Update patch source
$WPFUpdatesDownloadNewButton.Add_Click({Update-PatchSource})

#Logging window
$WPFLoggingTextBox.text = Get-Content -Path $Log -Delimiter "\n"

#Select Appx packages to remove
$WPFAppxButton.Add_Click({$global:SelectedAppx = Select-Appx})

#===========================================================================
# Section for Checkboxes to call functions
#===========================================================================

#Enable JSON Selection
$WPFJSONEnableCheckBox.Add_Click({
    If ($WPFJSONEnableCheckBox.IsChecked -eq $true){
        $WPFJSONButton.IsEnabled = $True
        $WPFMISJSONTextBox.Text = "True"
	}
	Else{
        $WPFJSONButton.IsEnabled = $False
        $WPFMISJSONTextBox.Text = "False"
	}
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
	Else{
        $WPFDriverDir1Button.IsEnabled = $False
        $WPFDriverDir2Button.IsEnabled = $False
        $WPFDriverDir3Button.IsEnabled = $False
        $WPFDriverDir4Button.IsEnabled = $False
        $WPFDriverDir5Button.IsEnabled = $False
        $WPFMISDriverTextBox.Text = "False"
	}
})

#Enable Updates Selection
$WPFUpdatesEnableCheckBox.Add_Click({
	If ($WPFUpdatesEnableCheckBox.IsChecked -eq $true){
		$WPFUpdateOSDBUpdateButton.IsEnabled = $True
		$WPFUpdatesDownloadNewButton.IsEnabled = $True
		$WPFUpdates1903CheckBox.IsEnabled = $True
		$WPFUpdates1809CheckBox.IsEnabled = $True
		$WPFUpdates1803CheckBox.IsEnabled = $True
		$WPFUpdates1709CheckBox.IsEnabled = $True
		$WPFUpdateOSDBUpdateButton.IsEnabled = $True
		$WPFMISUpdatesTextBox.Text = "True"
	}
	Else{
	   # $WPFUpdatesOSDBVersion.IsEnabled = $False
		$WPFUpdateOSDBUpdateButton.IsEnabled = $False
		$WPFUpdatesDownloadNewButton.IsEnabled = $False
		$WPFUpdates1903CheckBox.IsEnabled = $False
		$WPFUpdates1809CheckBox.IsEnabled = $False
		$WPFUpdates1803CheckBox.IsEnabled = $False
		$WPFUpdates1709CheckBox.IsEnabled = $False
		$WPFUpdateOSDBUpdateButton.IsEnabled = $False
		$WPFMISUpdatesTextBox.Text = "False"
	}
})

#Enable AppX Selection
$WPFAppxCheckBox.Add_Click({
    If ($WPFAppxCheckBox.IsChecked -eq $true){
        $WPFAppxButton.IsEnabled = $True
        $WPFMISAppxTextBox.Text = "True"
	}
	Else{
        $WPFAppxButton.IsEnabled = $False
	}
})
 

#===========================================================================

     


#===========================================================================
# Commands before forms load
#===========================================================================






#Write-Output "To show the form, run the following" -ForegroundColor Cyan
#'$Form.ShowDialog() | out-null'

#===========================================================================
# Shows the form
#===========================================================================


 $Form.ShowDialog() | out-null


