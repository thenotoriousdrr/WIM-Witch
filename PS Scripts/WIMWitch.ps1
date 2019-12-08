#===========================================================================
# WIM Witch 
#===========================================================================
#
# Written and maintained by: Donna Ryan
# Twitter: @TheNotoriousDRR
# www.TheNotoriousDRR.com
# www.SCConfigMgr.com
#
# Current WIM Witch Doc:
# https://www.scconfigmgr.com/2019/10/04/wim-witch-a-gui-driven-solution-for-image-customization/
#
#===========================================================================
#
# WIM Witch is a GUI driven tool used to update and customize Windows
# Image (WIM) files. It can also create WIM configuration templates and
# apply them either with the GUI or programatically for bulk creation.
#
# It currently supports the following functions:
#
# -Selecting the individual index to import
# -Autopilot for existing devices 
# -Retrieve Autopilot deployment profiles from Intune
# -Multi path driver importation
# -Injection of updates from a self maintained local update cache
# -Save and Load Configuration Templates
# -Removal of AppX Modern Apps
# -Create batch jobs for image catalog updating
# -importing WIM and .Net binaries from an ISO file
# -injecting .Net 3.5 binaries into image
#
#===========================================================================
# Version 1.3.0
#
# -Added patching support for Server 2016 LTSB and Server 2019 LTSB
# -Modified command line parameters for easier usage and to support Server
# -Depricated Supersedense from command line functionality
# -Downloading updates performs a supersedense check against that particular
#     OS only. Previously all OS's were checked.
# -OneDrive update downloaded with any Win10 build
# -Apply OneDrive update to WIM - Win10 only
# -Fixed Import ISO field with side scrolling ability
# -Server Core updates skip Adobe updates as they are not applicable
# 
#===========================================================================
# Version 1.2.3
#
# -Added Win10 1909 support. Includes .Net 3.5, patch selection, commandline
#
#===========================================================================
# Version 1.2.2
#
# -Fixed bug around version display
#
#===========================================================================
# Version 1.2.1
#
# -Changed version variable to stop upgrade loop
# -Added "force" parameter to rename step in backup function. 
#
#===========================================================================
# Version 1.2
#
# -Added update function to make upgrading WIM Witch easy
# -Added backup function for previous WIM Witch script for DR purposes
# -Modified variable to support Server SKUs
#
#===========================================================================
# Version 1.1.4
#
# -Fixed bug that prevented CLI functionality 
# -Removed pre-RTM notes
#
#===========================================================================
# Version 1.1.3
#
# -Added export function (optimization) to shrink final WIM file
#
#===========================================================================
# Version 1.1.2
#
# -Add functionality to prevent installation of WIM Witch files in the 
#    PowerShell script repository folder. This was done to support "install-script"
# -Add SCConfigMgr icon to replace stock PowerShell icon.
#
#
#===========================================================================
# Version 1.1.1
# 
# -Fixed a typo that caused the skype app to not be uninstalled on 1903
#    Credit @AndyUpperton for finding the bug :)
#===========================================================================
# Version 1.1
# 
# -Fixed OSDSUS upgrade issue by having separate OSDSUS upgrade
# -Fixed a fat-fingering
#
#===========================================================================
# Version 1.0
#
# -Minor bug fixes
# -Removed useless logging tab
# -added color scheme
# -Removed step to update OSDSUS as OSDUpdate updats OSDSUS as a dependent package
# -Removed requirement to check enable updates to perform update maintenance.
#
#===========================================================================
#
#============================================================================================================
Param( 
   [parameter(mandatory = $false, HelpMessage = "enable auto")] 
    #[ValidateSet("yes")] 
    [switch]$auto,

    [parameter(mandatory = $false, HelpMessage = "config file")] 
    [string]$autofile,

    [parameter(mandatory = $false, HelpMessage = "config path")] 
    #[ValidateSet("$PSScriptRoot\configs")]
    [string]$autopath,

    #[parameter(mandatory = $false, HelpMessage = "Superseded updates")] 
    #[ValidateSet("audit", "delete")] 
    #[string]$Superseded,

    [parameter(mandatory = $false, HelpMessage = "Update Modules")] 
    #[ValidateSet("update")] 
    #$OSDSUS,
    [Switch]$UpdatePoShModules,

    [parameter(mandatory = $false, HelpMessage = "Enable Downloading Updates")] 
    #[ValidateSet("yes")] 
    #$updates 
    [switch]$DownloadUpdates,
  
    [parameter(mandatory = $false, HelpMessage = "Win10 Version")] 
    [ValidateSet("all", "1709", "1803", "1809", "1903", "1909")] 
    #$DownUpdates,
    [string]$Win10Version = "none",

    [parameter(mandatory = $false, HelpMessage = "Windows Server 2016?")] 
    [switch]$Server2016,

    [parameter(mandatory = $false, HelpMessage = "Windows Server 2019?")] 
    [switch]$Server2019

    #[parameter(mandatory = $false, HelpMessage = "enable auto")] 
    #[ValidateSet("yes")] 
    #$auto,

    #[parameter(mandatory = $false, HelpMessage = "config file")] 
    #$autofile,

    #[parameter(mandatory = $false, HelpMessage = "config path")] 
    ##[ValidateSet("$PSScriptRoot\configs")]
    #$autopath,

    #[parameter(mandatory = $false, HelpMessage = "Superseded updates")] 
    #[ValidateSet("audit", "delete")] 
    #$Superseded,

    #[parameter(mandatory = $false, HelpMessage = "Superseded updates")] 
    #[ValidateSet("update")] 
    #$OSDSUS,

    ##[parameter(mandatory=$false,HelpMessage="Superseded updates")] 
    ##[ValidateSet("download")] 
    ##$newupdates,

    #[parameter(mandatory = $false, HelpMessage = "Superseded updates")] 
    #[ValidateSet("all", "1709", "1803", "1809", "1903", "1909")] 
    #$DownUpdates,

    #[parameter(mandatory = $false, HelpMessage = "Superseded updates")] 
    #[ValidateSet("yes")] 
    #$updates 
)

$WWScriptVer = "1.3.0"

#Your XAML goes here :)
$inputXML = @"
<Window x:Class="WIM_Witch_Tabbed.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WIM_Witch_Tabbed"
        mc:Ignorable="d"
        Title="WIM Witch - v1.3.0" Height="500" Width="825" Background="#FF610536">
    <Grid>
        <TabControl Margin="0,0,0.2,-0.2" Background="#FFACACAC" BorderBrush="#FF610536" >
            <TabItem Header="Import" Height="20" Width="100">
                <Grid>
                    <TextBox x:Name="ImportISOTextBox" HorizontalAlignment="Left" Height="42" Margin="26,85,0,0" Text="ISO to import from..." VerticalAlignment="Top" Width="500" IsEnabled="True" HorizontalScrollBarVisibility="Visible"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,56,0,0" TextWrapping="Wrap" Text="Select a Windows 10 ISO:" VerticalAlignment="Top" Height="26" Width="353"/>
                    <Button x:Name="ImportImportSelectButton" Content="Select" HorizontalAlignment="Left" Margin="451,135,0,0" VerticalAlignment="Top" Width="75"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,159,0,0" TextWrapping="Wrap" Text="Select the item(s) to import:" VerticalAlignment="Top" Width="263"/>
                    <CheckBox x:Name="ImportWIMCheckBox" Content="Install.wim" HorizontalAlignment="Left" Margin="44,191,0,0" VerticalAlignment="Top"/>
                    <CheckBox x:Name="ImportDotNetCheckBox" Content=".Net Binaries" HorizontalAlignment="Left" Margin="44,211,0,0" VerticalAlignment="Top"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,268,0,0" TextWrapping="Wrap" Text="New name for the imported WIM:" VerticalAlignment="Top" Width="311"/>
                    <TextBox x:Name="ImportNewNameTextBox" HorizontalAlignment="Left" Height="23" Margin="26,289,0,0" TextWrapping="Wrap" Text="Name for the imported WIM" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Button x:Name="ImportImportButton" Content="Import" HorizontalAlignment="Left" Margin="451,354,0,0" VerticalAlignment="Top" Width="75" IsEnabled="False"/>
                </Grid>
            </TabItem>
            <TabItem Header="Source WIM" Margin="0" Width="100">
                <Grid>
                    <TextBox x:Name="SourceWIMSelectWIMTextBox" HorizontalAlignment="Left" Height="25" Margin="26,98,0,0" TextWrapping="Wrap" Text="Select WIM File" VerticalAlignment="Top" Width="500" IsEnabled="False" Grid.ColumnSpan="2"/>
                    <Label Content="Source Wim " HorizontalAlignment="Left" Height="25" Margin="26,70,0,0" VerticalAlignment="Top" Width="100"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Select the WIM file, and then Edition, that will serve as the base for the custom WIM." VerticalAlignment="Top" Height="42" Width="353" Grid.ColumnSpan="2"/>
                    <Button x:Name="SourceWIMSelectButton" Content="Select" HorizontalAlignment="Left" Height="25" Margin="450,142,0,0" VerticalAlignment="Top" Width="75"/>
                    <TextBox x:Name="SourceWIMImgDesTextBox" HorizontalAlignment="Left" Height="23" Margin="94,155,0,0" TextWrapping="Wrap" Text="ImageDescription" VerticalAlignment="Top" Width="339" IsEnabled="False"/>
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
                    <TextBlock HorizontalAlignment="Left" Margin="91,196,0,0" TextWrapping="Wrap" Text="Installed version " VerticalAlignment="Top"/>
                    <TextBox x:Name="UpdatesOSDBVersion" HorizontalAlignment="Left" Height="23" Margin="91,218,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120" IsEnabled="False"/>
                    <Button x:Name="UpdateOSDBUpdateButton" Content="Install / Update" HorizontalAlignment="Left" Margin="218,291,0,0" VerticalAlignment="Top" Width="120"/>
                    <TextBlock HorizontalAlignment="Left" Height="42" Margin="435,118,0,0" TextWrapping="Wrap" Text="Select which versions of Windows to download current patches for. Downloading will also purge superseded updates." VerticalAlignment="Top" Width="335"/>
                    <TextBlock HorizontalAlignment="Left" Margin="20,28,0,0" TextWrapping="Wrap" Text="Click the check box to enable updates for the selected WIM file. WIM Witch will automatically determine the correct version to apply. Updates must have been downloaded prior to making it so." VerticalAlignment="Top" Height="47" Width="353"/>
                    <CheckBox x:Name="UpdatesEnableCheckBox" Content="Enable Updates" HorizontalAlignment="Left" Margin="26,90,0,0" VerticalAlignment="Top" ClickMode="Press"/>
                    <CheckBox x:Name="UpdatesW10_1903" Content="1903" HorizontalAlignment="Left" Margin="535,193,0,0" VerticalAlignment="Top" IsEnabled="False"/>
                    <CheckBox x:Name="UpdatesW10_1809" Content="1809" HorizontalAlignment="Left" Margin="594,193,0,0" VerticalAlignment="Top" IsEnabled="False"/>
                    <CheckBox x:Name="UpdatesW10_1803" Content="1803" HorizontalAlignment="Left" Margin="652,193,0,0" VerticalAlignment="Top" IsEnabled="False"/>
                    <CheckBox x:Name="UpdatesW10_1709" Content="1709" HorizontalAlignment="Left" Margin="707,193,0,0" VerticalAlignment="Top" IsEnabled="False"/>
                    <Button x:Name="UpdatesDownloadNewButton" Content="Download" HorizontalAlignment="Left" Margin="680,268,0,0" VerticalAlignment="Top" Width="75"/>
                    <TextBlock HorizontalAlignment="Left" Margin="20,142,0,0" TextWrapping="Wrap" Text="Update OSDeploy modules by using the button below. Updating the modules will require PowerShell to be restarted" VerticalAlignment="Top" Height="34" Width="321"/>
                    <TextBox x:Name="UpdatesOSDBCurrentVerTextBox" HorizontalAlignment="Left" Height="23" Margin="218,217,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120" IsEnabled="False"/>
                    <TextBlock HorizontalAlignment="Left" Margin="218,196,0,0" TextWrapping="Wrap" Text="Current Version" VerticalAlignment="Top"/>
                    <TextBlock x:Name="UpdatesOSDBOutOfDateTextBlock" HorizontalAlignment="Left" Margin="20,315,0,0" TextWrapping="Wrap" Text="A software update module is out of date. Please click the &quot;Install / Update&quot; button to update it." VerticalAlignment="Top" RenderTransformOrigin="0.493,0.524" FontSize="20" Width="321" Visibility="Hidden" />
                    <TextBlock x:Name="UpdatesOSDBSupercededExistTextBlock" HorizontalAlignment="Left" Margin="417,303,0,0" TextWrapping="Wrap" Text="Superceded updates discovered. Please select the versions of Windows 10 you are supporting and click &quot;Update&quot;" VerticalAlignment="Top" FontSize="20" Width="375" Visibility="Hidden"/>
                    <TextBlock x:Name="UpdatesOSDBClosePowerShellTextBlock" HorizontalAlignment="Left" Margin="435,28,0,0" TextWrapping="Wrap" Text="Please close all PowerShell windows, including WIM Witch, then relaunch app to continue" VerticalAlignment="Top" RenderTransformOrigin="0.493,0.524" FontSize="20" Width="321" Visibility="Hidden"/>
                    <TextBlock HorizontalAlignment="Left" Margin="24,218,0,0" TextWrapping="Wrap" Text="OSDUpdate" VerticalAlignment="Top"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,255,0,0" TextWrapping="Wrap" Text="OSDSUS" VerticalAlignment="Top"/>
                    <TextBox x:Name="UpdatesOSDSUSVersion" HorizontalAlignment="Left" Height="23" Margin="91,251,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120" IsEnabled="False"/>
                    <TextBox x:Name="UpdatesOSDSUSCurrentVerTextBox" HorizontalAlignment="Left" Height="23" Margin="218,251,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120" IsEnabled="False"/>
                    <CheckBox x:Name="UpdatesW10Main" Content="Windows 10" HorizontalAlignment="Left" Margin="450,167,0,0" VerticalAlignment="Top"/>
                    <CheckBox x:Name="UpdatesS2016" Content="Windows Server 2016" HorizontalAlignment="Left" Margin="594,217,0,0" VerticalAlignment="Top"/>
                    <CheckBox x:Name="UpdatesS2019" Content="Windows Server 2019" HorizontalAlignment="Left" Margin="448,217,0,0" VerticalAlignment="Top"/>
                    <CheckBox x:Name="UpdatesW10_1909" Content="1909" HorizontalAlignment="Left" Margin="478,193,0,0" VerticalAlignment="Top" IsEnabled="False"/>
                </Grid>
            </TabItem>
            <TabItem x:Name="AutopilotTab" Header="Autopilot" Width="100">
                <Grid>
                    <TextBox x:Name="JSONTextBox" HorizontalAlignment="Left" Height="25" Margin="26,130,0,0" TextWrapping="Wrap" Text="Select JSON File" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Label x:Name="JSONLabel" Content="Source JSON" HorizontalAlignment="Left" Height="25" Margin="26,104,0,0" VerticalAlignment="Top" Width="100"/>
                    <Button x:Name="JSONButton" Content="Select" HorizontalAlignment="Left" Height="25" Margin="451,165,0,0" VerticalAlignment="Top" Width="75" IsEnabled="False"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Select a JSON file for use in deploying Autopilot systems. The file will be copied to processing folder during the build" VerticalAlignment="Top" Height="42" Width="353"/>
                    <CheckBox x:Name="JSONEnableCheckBox" Content="Enable Autopilot " HorizontalAlignment="Left" Margin="26,80,0,0" VerticalAlignment="Top" ClickMode="Press"/>
                    <TextBox x:Name="ZtdCorrelationId" HorizontalAlignment="Left" Height="23" Margin="129,176,0,0" TextWrapping="Wrap" Text="Select JSON File..." VerticalAlignment="Top" Width="236" IsEnabled="False"/>
                    <TextBox x:Name="CloudAssignedTenantDomain" HorizontalAlignment="Left" Height="23" Margin="129,204,0,0" TextWrapping="Wrap" Text="Select JSON File..." VerticalAlignment="Top" Width="236" IsEnabled="False"/>
                    <TextBox x:Name="Comment_File" HorizontalAlignment="Left" Height="23" Margin="129,232,0,0" TextWrapping="Wrap" Text="Select JSON File..." VerticalAlignment="Top" Width="236" IsEnabled="False"/>
                    <TextBlock HorizontalAlignment="Left" Margin="24,178,0,0" TextWrapping="Wrap" Text="ZTD ID#" VerticalAlignment="Top"/>
                    <TextBlock HorizontalAlignment="Left" Margin="24,204,0,0" TextWrapping="Wrap" Text="Tenant Name" VerticalAlignment="Top"/>
                    <TextBlock HorizontalAlignment="Left" Margin="24,233,0,0" TextWrapping="Wrap" Text="Deployment Profile" VerticalAlignment="Top"/>
                    <TextBox x:Name="JSONTextBoxSavePath" HorizontalAlignment="Left" Height="23" Margin="26,375,0,0" TextWrapping="Wrap" Text="$PSScriptRoot\Autopilot" VerticalAlignment="Top" Width="499" IsEnabled="False"/>
                    <TextBox x:Name="JSONTextBoxAADID" HorizontalAlignment="Left" Height="23" Margin="27,331,0,0" TextWrapping="Wrap" Text="User ID for Intune authentication" VerticalAlignment="Top" Width="499"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,275,0,0" TextWrapping="Wrap" Text="To download a new Autopilot profile from Intune, provide an AAD user name and a path to save the file" VerticalAlignment="Top" Height="36" Width="331"/>
                    <TextBlock HorizontalAlignment="Left" Margin="27,312,0,0" TextWrapping="Wrap" Text="User ID:" VerticalAlignment="Top"/>
                    <TextBlock HorizontalAlignment="Left" Margin="27,358,0,0" TextWrapping="Wrap" Text="Path to save file:" VerticalAlignment="Top"/>
                    <Button x:Name="JSONButtonSavePath" Content="Select" HorizontalAlignment="Left" Margin="450,403,0,0" VerticalAlignment="Top" Width="75"/>
                    <Button x:Name="JSONButtonRetrieve" Content="Retrieve Profile" HorizontalAlignment="Left" Margin="382,275,0,0" VerticalAlignment="Top" Width="130"/>
                </Grid>
            </TabItem>
            <TabItem Header="Drivers" Height="20" Width="100">
                <Grid>
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
            <TabItem x:Name="AppTab" Header ="App Removal" Height="20" Width="100">
                <Grid>
                    <TextBox x:Name="AppxTextBox" TextWrapping="Wrap" Text="Select the apps to remove..." Margin="21,85,252.2,22.8" VerticalScrollBarVisibility="Visible"/>
                    <TextBlock HorizontalAlignment="Left" Margin="21,65,0,0" TextWrapping="Wrap" Text="Selected app packages to remove:" VerticalAlignment="Top" Height="15" Width="194"/>
                    <CheckBox x:Name="AppxCheckBox" Content="Enable app removal" HorizontalAlignment="Left" Margin="21,33,0,0" VerticalAlignment="Top"/>
                    <Button x:Name="AppxButton" Content="Select" HorizontalAlignment="Left" Margin="202,33,0,0" VerticalAlignment="Top" Width="75"/>
                </Grid>
            </TabItem>
             <TabItem Header="Make It So" Height="20" Width="100">
                <Grid>
                    <Button x:Name="MISFolderButton" Content="Select" HorizontalAlignment="Left" Margin="444,155,0,0" VerticalAlignment="Top" Width="75" RenderTransformOrigin="0.39,-2.647"/>
                    <TextBox x:Name="MISWimNameTextBox" HorizontalAlignment="Left" Height="25" Margin="20,85,0,0" TextWrapping="Wrap" Text="Enter Target WIM Name" VerticalAlignment="Top" Width="500"/>
                    <TextBox x:Name="MISDriverTextBox" HorizontalAlignment="Left" Height="23" Margin="136,345,0,0" TextWrapping="Wrap" Text="Driver Y/N" VerticalAlignment="Top" Width="120" IsEnabled="False"/>
                    <Label Content="Driver injection?" HorizontalAlignment="Left" Height="30" Margin="29,343,0,0" VerticalAlignment="Top" Width="101"/>
                    <TextBox x:Name="MISJSONTextBox" HorizontalAlignment="Left" Height="23" Margin="136,374,0,0" TextWrapping="Wrap" Text="JSON Select Y/N" VerticalAlignment="Top" Width="120" IsEnabled="False"/>
                    <Label Content="JSON injection?" HorizontalAlignment="Left" Margin="29,372,0,0" VerticalAlignment="Top" Width="102"/>
                    <TextBox x:Name="MISWimFolderTextBox" HorizontalAlignment="Left" Height="23" Margin="20,119,0,0" TextWrapping="Wrap" Text="$PSScriptRoot\CompletedWIMs" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <TextBlock HorizontalAlignment="Left" Margin="20,20,0,0" TextWrapping="Wrap" Text="Enter a name, and select a destination forlder, for the  image to be created. Once complete, and build parameters verified, click &quot;Make it so!&quot; to start the build." VerticalAlignment="Top" Height="60" Width="353"/>
                    <Button x:Name="MISMakeItSoButton" Content="Make it so!" HorizontalAlignment="Left" Margin="400,20,0,0" VerticalAlignment="Top" Width="120" Height="29" FontSize="16"/>
                    <TextBox x:Name="MISMountTextBox" HorizontalAlignment="Left" Height="25" Margin="19,219,0,0" TextWrapping="Wrap" Text="$PSScriptRoot\Mount" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Label Content="Mount Path" HorizontalAlignment="Left" Margin="19,194,0,0" VerticalAlignment="Top" Height="25" Width="100"/>
                    <Button x:Name="MISMountSelectButton" Content="Select" HorizontalAlignment="Left" Margin="444,255,0,0" VerticalAlignment="Top" Width="75" Height="25"/>
                    <Label Content="Update injection?" HorizontalAlignment="Left" Margin="29,311,0,0" VerticalAlignment="Top" Width="109"/>
                    <TextBox x:Name="MISUpdatesTextBox" HorizontalAlignment="Left" Height="23" Margin="136,314,0,0" TextWrapping="Wrap" Text="Updates Y/N" VerticalAlignment="Top" Width="120" RenderTransformOrigin="0.171,0.142" IsEnabled="False"/>
                    <Label Content="App removal?" HorizontalAlignment="Left" Margin="29,280,0,0" VerticalAlignment="Top" Width="109"/>
                    <TextBox x:Name="MISAppxTextBox" HorizontalAlignment="Left" Height="23" Margin="136,283,0,0" TextWrapping="Wrap" Text="Updates Y/N" VerticalAlignment="Top" Width="120" RenderTransformOrigin="0.171,0.142" IsEnabled="False"/>
                    <CheckBox x:Name="MISDotNetCheckBox" Content="Inject .Net 3.5" HorizontalAlignment="Left" Margin="306,317,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold"/>
                    <TextBlock HorizontalAlignment="Left" Margin="306,282,0,0" TextWrapping="Wrap" Text=".Net 3.5 binaries must be imported from an ISO. They are not downloaded." VerticalAlignment="Top" Height="35" Width="260"/>
                    <CheckBox x:Name="MISOneDriveCheckBox" Content="Update OneDrive client" HorizontalAlignment="Left" Margin="306,379,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold"/>
                    <TextBlock HorizontalAlignment="Left" Margin="306,345,0,0" TextWrapping="Wrap" Text="Current OneDrive installer is downloaded with Win10 updates." VerticalAlignment="Top" Height="34" Width="260"/>
                </Grid>
            </TabItem>


            <TabItem Header="Save/Load" Height="20" Width="100">
                <Grid>
                    <TextBox x:Name="SLSaveFileName" HorizontalAlignment="Left" Height="25" Margin="26,85,0,0" TextWrapping="Wrap" Text="Name for saved configuration..." VerticalAlignment="Top" Width="500"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,38,0,0" TextWrapping="Wrap" Text="Provide a name for the saved configuration" VerticalAlignment="Top" Height="42" Width="353"/>
                    <Button x:Name="SLSaveButton" Content="Save" HorizontalAlignment="Left" Margin="451,127,0,0" VerticalAlignment="Top" Width="75"/>
                    <Border BorderBrush="Black" BorderThickness="1" HorizontalAlignment="Left" Height="1" Margin="0,216,0,0" VerticalAlignment="Top" Width="785"/>
                    <TextBox x:Name="SLLoadTextBox" HorizontalAlignment="Left" Height="23" Margin="26,308,0,0" TextWrapping="Wrap" Text="Select configuration file to load" VerticalAlignment="Top" Width="500"/>
                    <Button x:Name="SLLoadButton" Content="Load" HorizontalAlignment="Left" Margin="451,351,0,0" VerticalAlignment="Top" Width="75"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,279,0,0" TextWrapping="Wrap" Text="Select configuration file to load" VerticalAlignment="Top" Width="353"/>
                </Grid>
            </TabItem>
        </TabControl>
    </Grid>
    <Window.TaskbarItemInfo>
        <TaskbarItemInfo/>
    </Window.TaskbarItemInfo>
</Window>
"@ 
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[xml]$XAML = $inputXML
#Read XAML
 
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
try {
    $Form = [Windows.Markup.XamlReader]::Load( $reader )
}
catch {
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties in your textboxes (PowerShell cannot process them)"
    throw
}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
  
$xaml.SelectNodes("//*[@Name]") | % { "trying item $($_.Name)" | out-null;
    try { Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop }
    catch { throw }
}

#Section to do the icon magic
###################################################
$base64 = "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"
# Create a streaming image by streaming the base64 string to a bitmap streamsource
$bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$bitmap.BeginInit()
$bitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($base64)
$bitmap.EndInit()
$bitmap.Freeze()

# This is the icon in the upper left hand corner of the app
$form.Icon = $bitmap
# This is the toolbar icon and description
$form.TaskbarItemInfo.Overlay = $bitmap
$form.TaskbarItemInfo.Description = "WIM Witch - $wwscirptver"
###################################################



 
Function Get-FormVariables {
    if ($global:ReadmeDisplay -ne $true) { Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow; $global:ReadmeDisplay = $true }
    #write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
    get-variable WPF*
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
    $WPFMISMountTextBox.text = $MountDir 
    check-mountpath -path $WPFMISMountTextBox.text
    update-log -Data "Mount directory selected" -Class Information
}

#Function to select Source WIM
Function SelectSourceWIM {

    $SourceWIM = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        #InitialDirectory = [Environment]::GetFolderPath('Desktop') 
        InitialDirectory = "$PSScriptRoot\imports\wim"
        Filter           = 'WIM (*.wim)|'
    }
    $null = $SourceWIM.ShowDialog()
    $WPFSourceWIMSelectWIMTextBox.text = $SourceWIM.FileName


    if ($SourceWIM.FileName -notlike "*.wim") {
        update-log -Data "A WIM file not selected. Please select a valid file to continue." -Class Warning
        return
    }
    #Select the index
    $ImageFull = @(get-windowsimage -ImagePath $WPFSourceWIMSelectWIMTextBox.text)
    $a = $ImageFull | Out-GridView -Title "Choose an Image Index" -Passthru
    $IndexNumber = $a.ImageIndex
    #write-host $IndexNumber
    if ($indexnumber -eq $null) {
        update-log -Data "Index not selected. Reselect the WIM file to select an index" -Class Warning
        return
    }

    import-wiminfo -IndexNumber $IndexNumber
}

function import-wiminfo($IndexNumber) {
    Update-Log -Data "Importing Source WIM Info" -Class Information
    try {
        #Gets WIM metadata to populate fields on the Source tab.
        $ImageInfo = get-windowsimage -ImagePath $WPFSourceWIMSelectWIMTextBox.text -index $IndexNumber -ErrorAction Stop
    }
    catch {
        Update-Log -data $_.Exception.Message -class Error
        Update-Log -data "The WIM file selected may be borked. Try a different one" -Class Warning
        Return
    }
    $text = "WIM file selected: " + $SourceWIM.FileName
    Update-Log -data $text -Class Information
#    $text = "Edition selected: " + $ImageInfo.ImageDescription
    $text = "Edition selected: " + $ImageInfo.ImageName

    Update-Log -data $text -Class Information
    $ImageIndex = $IndexNumber


 #   $WPFSourceWIMImgDesTextBox.text = $ImageInfo.ImageDescription
    $WPFSourceWIMImgDesTextBox.text = $ImageInfo.ImageName
    $WPFSourceWimVerTextBox.Text = $ImageInfo.Version
    $WPFSourceWimSPBuildTextBox.text = $ImageInfo.SPBuild
    $WPFSourceWimLangTextBox.text = $ImageInfo.Languages
    $WPFSourceWimIndexTextBox.text = $ImageIndex
    if ($ImageInfo.Architecture -eq 9) {
        $WPFSourceWimArchTextBox.text = 'x64'
    }
    Else {
        $WPFSourceWimArchTextBox.text = 'x86'
    }
   if ($WPFSourceWIMImgDesTextBox.text -like "Windows Server*"){ 
        $WPFJSONEnableCheckBox.IsChecked = $False
        $WPFAppxCheckBox.IsChecked = $False
        $WPFAppTab.IsEnabled = $False
        $WPFAutopilotTab.IsEnabled = $False
        $WPFMISAppxTextBox.text = "False"
        $WPFMISJSONTextBox.text = "False"
        $WPFMISOneDriveCheckBox.IsChecked = $False
        $WPFMISOneDriveCheckBox.IsEnabled = $False
        }
      Else{
        $WPFAppTab.IsEnabled = $True
        $WPFAutopilotTab.IsEnabled = $True
        $WPFMISOneDriveCheckBox.IsEnabled = $True
        }

}

 
#Function to Select JSON File
Function SelectJSONFile {

    $JSON = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = [Environment]::GetFolderPath('Desktop') 
        Filter           = 'JSON (*.JSON)|'
    }
    $null = $JSON.ShowDialog()
    $WPFJSONTextBox.Text = $JSON.FileName

    $text = "JSON file selected: " + $JSON.FileName
    update-log -Data $text -Class Information
    Parse-JSON -file $JSON.FileName

}

#Function to parse the JSON file for user valuable info
Function Parse-JSON($file) {
    try {
        Update-Log -Data "Attempting to parse JSON file..." -Class Information
        $autopilotinfo = Get-Content $WPFJSONTextBox.Text | ConvertFrom-Json
        Update-Log -Data "Successfully parsed JSON file" -Class Information
        $WPFZtdCorrelationId.Text = $autopilotinfo.ZtdCorrelationId
        $WPFCloudAssignedTenantDomain.Text = $autopilotinfo.CloudAssignedTenantDomain
        $WPFComment_File.text = $autopilotinfo.Comment_File

    }
    catch {
        $WPFZtdCorrelationId.Text = "Bad file. Try Again."
        $WPFCloudAssignedTenantDomain.Text = "Bad file. Try Again."
        $WPFComment_File.text = "Bad file. Try Again."
        Update-Log -Data "Failed to parse JSON file. Try another"
        return

    }
}

#Function to select the paths for the driver fields
Function SelectDriverSource($DriverTextBoxNumber) {
    #write-host $DriverTextBoxNumber
    Add-Type -AssemblyName System.Windows.Forms
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $browser.Description = "Select the Driver Source folder"
    $null = $browser.ShowDialog()
    $DriverDir = $browser.SelectedPath
    $DriverTextBoxNumber.Text = $DriverDir


    update-log -Data "Driver path selected: $DriverDir" -Class Information
}

#Function for the Make it So button
Function MakeItSo ($appx) {

    #Check if new file name is valid, also append file extension if neccessary

    ###Starting MIS Preflight###
    check-mountpath -path $WPFMISMountTextBox.Text -clean True

    if (($WPFMISWimNameTextBox.Text -eq "") -or ($WPFMISWimNameTextBox.Text -eq "Enter Target WIM Name")) {
        update-log -Data "Enter a valid file name and then try again" -Class Error
        return 
    }

   # if ($auto -ne "yes") {
     if ($auto -eq $false) {
        $checkresult = (check-name) 
        if ($checkresult -eq "stop") { return }
    }

   # if ($auto -eq "yes") {
   if ($auto -eq $true) {
        $checkresult = (check-name -conflict append)
        if ($checkresult -eq "stop") { return }
    }



    #check for working directory, make if does not exist, delete files if they exist
    $FolderExist = Test-Path $PSScriptRoot\Staging -PathType Any
    update-log -Data "Checking to see if the staging path exists..." -Class Information

    try {
        if ($FolderExist = $False) {
            New-Item -ItemType Directory -Force -Path $PSScriptRoot\Staging -ErrorAction Stop
            update-log -Data "Path did not exist, but it does now :)" -Class Information -ErrorAction Stop
        }
        Else {
            Remove-Item –path $PSScriptRoot\Staging\* -Recurse -ErrorAction Stop
            update-log -Data "The path existed, and it has been purged." -Class Information -ErrorAction Stop
        }
    }
    catch {
        Update-Log -data $_.Exception.Message -class Error
        Update-Log -data "Something is wrong with folder $PSScriptRoot\Staging. Try deleting manually if it exists" -Class Error
        return
    }

    if ($WPFJSONEnableCheckBox.IsChecked -eq $true) {
        Update-Log -Data "Validating existance of JSON file..." -Class Information
        $APJSONExists = (Test-Path $WPFJSONTextBox.Text)
        if ($APJSONExists -eq $true) { Update-Log -Data "JSON exists. Continuing..." -Class Information }
        else {
            Update-Log -Data "The Autopilot file could not be verified. Check it and try again." -Class Error
            return
        }

    }

    if ($WPFMISDotNetCheckBox.IsChecked -eq $true) {
        if ((check-dotnetexists) -eq $False) { return }
    }



    #####End of MIS Preflight###################################################################

    #Copy source WIM
    update-log -Data "Copying source WIM to the staging folder" -Class Information

    try {
        Copy-Item $WPFSourceWIMSelectWIMTextBox.Text -Destination "$PSScriptRoot\Staging" -ErrorAction Stop
    }
    catch {
        Update-Log -data $_.Exception.Message -class Error
        Update-Log -Data "The file couldn't be copied. No idea what happened" -class Error
        return
    }

    update-log -Data "Source WIM has been copied to the source folder" -Class Information

    #Rename copied source WiM

    try {
        $wimname = Get-Item -Path $PSScriptRoot\Staging\*.wim -ErrorAction Stop
        Rename-Item -Path $wimname -NewName $WPFMISWimNameTextBox.Text -ErrorAction Stop
        update-log -Data "Copied source WIM has been renamed" -Class Information
    }
    catch {
        Update-Log -data $_.Exception.Message -class Error
        Update-Log -data "The copied source file couldn't be renamed. This shouldn't have happened." -Class Error
        Update-Log -data "Go delete the WIM from $PSScriptRoot\Staging\, then try again" -Class Error
        return
    }

    #Remove the unwanted indexes
    remove-indexes

    #Mount the WIM File


    $wimname = Get-Item -Path $PSScriptRoot\Staging\*.wim
    update-log -Data "Mounting source WIM $wimname" -Class Information
    update-log -Data "to mount point:" -Class Information
    update-log -data $WPFMISMountTextBox.Text -Class Information

    try {
        #write-host $IndexNumber
         Mount-WindowsImage -Path $WPFMISMountTextBox.Text -ImagePath $wimname -Index 1 -ErrorAction Stop | Out-Null
         }
    catch {
        Update-Log -data $_.Exception.Message -class Error
        Update-Log -data "The WIM couldn't be mounted. Make sure the mount directory is empty" -Class Error
        Update-Log -Data "and that it isn't an active mount point" -Class Error
        return
    }

    #Inject .Net Binaries
    if ($WPFMISDotNetCheckBox.IsChecked -eq $true) { inject-dotnet }

    #Copy the current OneDrive installer
    if ($WPFMISOneDriveCheckBox.IsChecked -eq $true) {
        copy-onedrive
    }
    else{
        update-log -data "OneDrive agent update skipped as it was not selected" -Class Information
    }


    #Inject Autopilot JSON file
    if ($WPFJSONEnableCheckBox.IsChecked -eq $true) {

        update-log -Data "Injecting JSON file" -Class Information

        try {
            $autopilotdir = $WPFMISMountTextBox.Text + "\windows\Provisioning\Autopilot"
            Copy-Item $WPFJSONTextBox.Text -Destination $autopilotdir -ErrorAction Stop
        }
        catch {
            Update-Log -data $_.Exception.Message -class Error
            Update-Log -data "JSON file couldn't be copied. Check to see if the correct SKU" -Class Error
            Update-Log -Data "of Windows has been selected" -Class Error
            Update-log -Data "The WIM is still mounted. You'll need to clean that up manually until" -Class Error
            Update-Log -data "I get around to handling that error more betterer" -Class Error
            Update-Log -data "- <3 Donna" -Class Error
            return  
        }

    }
    else {
        update-log -Data "JSON not selected. Skipping JSON Injection" -Class Information
    }

    #Inject Drivers

    If ($WPFDriverCheckBox.IsChecked -eq $true) {

        DriverInjection -Folder $WPFDriverDir1TextBox.text
        DriverInjection -Folder $WPFDriverDir2TextBox.text
        DriverInjection -Folder $WPFDriverDir3TextBox.text
        DriverInjection -Folder $WPFDriverDir4TextBox.text
        DriverInjection -Folder $WPFDriverDir5TextBox.text
    }
    Else {
        update-log -Data "Drivers were not selected for injection. Skipping." -Class Information 
    }

    #Apply Updates
    If ($WPFUpdatesEnableCheckBox.IsChecked -eq $true) {

        Apply-Updates -class "SSU" 
        Apply-Updates -class "LCU"
        Apply-Updates -class "AdobeSU"
        Apply-Updates -class "DotNet"
        Apply-Updates -class "DotNetCU"
    }
    Else {
        Update-Log -Data "Updates not enabled" -Class Information
    }

    #Remove AppX Packages
    if ($WPFAppxCheckBox.IsChecked -eq $true) { remove-appx -array $appx }
    Else {
        Update-Log -Data "App removal not enabled" -Class Information
    }

    #Copy log to mounted WIM
    try {
        update-log -Data "Attempting to copy log to mounted image" -Class Information 
        $mountlogdir = $WPFMISMountTextBox.Text + "\windows\"
        Copy-Item $PSScriptRoot\logging\WIMWitch.log -Destination $mountlogdir -ErrorAction Stop
        $CopyLogExist = Test-Path $mountlogdir\WIMWitch.log -PathType Leaf
        if ($CopyLogExist -eq $true) { update-log -Data "Log filed copied successfully" -Class Information }
    }
    catch {
        Update-Log -data $_.Exception.Message -class Error
        update-log -data "Coudn't copy the log file to the mounted image." -class Error
    }

    #Dismount, commit, and move WIM

    update-log -Data "Dismounting WIM file, committing changes" -Class Information 
    try {
        Dismount-WindowsImage -Path $WPFMISMountTextBox.Text -save -ErrorAction Stop | Out-Null
    }
    catch {
        Update-Log -data $_.Exception.Message -class Error
        Update-Log -data "The WIM couldn't save. You will have to manually discard the" -Class Error
        Update-Log -data "mounted image manually" -Class Error
        return
    }

    update-log -Data "WIM dismounted" -Class Information 

    try {
        #Move-Item -Path $wimname -Destination $WPFMISWimFolderTextBox.Text -ErrorAction Stop
        update-log -Data "Exporting WIM file" -Class Information
        Export-WindowsImage -SourceImagePath $wimname -SourceIndex 1 -DestinationImagePath ($WPFMISWimFolderTextBox.Text + '\' + $WPFMISWimNameTextBox.Text) -DestinationName ('WW - ' + $WPFSourceWIMImgDesTextBox.text) |Out-Null
    }
    catch {
        Update-Log -data $_.Exception.Message -class Error
        Update-Log -data "The WIM couldn't be exported. You can still retrieve it from staging path." -Class Error
        Update-Log -data "The file will be deleted when the tool is rerun." -Class Error
        return
    }
    update-log -Data "WIM successfully exported to target folder" -Class Information 


    #Copy log here
    try {
        update-log -Data "Copying build log to target folder" -Class Information 
        Copy-Item -Path $PSScriptRoot\logging\WIMWitch.log -Destination $WPFMISWimFolderTextBox.Text -ErrorAction Stop
        $logold = $WPFMISWimFolderTextBox.Text + "\WIMWitch.log"
        $lognew = $WPFMISWimFolderTextBox.Text + "\" + $WPFMISWimNameTextBox.Text + ".log"
        #Put log detection code here
        if ((test-path -Path $lognew) -eq $true) {
            Update-Log -Data "A preexisting log file contains the same name. Renaming old log..." -Class Warning
            replace-name -file $lognew -extension ".log"
        }
     

        #Put log detection code here
 
        Rename-Item $logold -NewName $lognew -Force -ErrorAction Stop
        Update-Log -Data "Log copied successfully" -Class Information
    }
    catch {
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

#Function to enable logging and folder check
Function Update-Log {
    Param(
        [Parameter(
            Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [string]$Data,

        [Parameter(
            Mandatory = $false, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [string]$Solution = $Solution,

        [Parameter(
            Mandatory = $false, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1
        )]
        [validateset('Information', 'Warning', 'Error')]
        [string]$Class = "Information"

    )
    
    $global:ScriptLogFilePath = $Log
    $LogString = "$(Get-Date) $Class  -  $Data"
    $HostString = "$(Get-Date) $Class  -  $Data"

    
    Add-Content -Path $Log -Value $LogString
    switch ($Class) {
        'Information' {
            Write-Host $HostString -ForegroundColor Gray
        }
        'Warning' {
            Write-Host $HostString -ForegroundColor Yellow
        }
        'Error' {
            Write-Host $HostString -ForegroundColor Red
        }
        Default { }
    }
    #The below line is for a logging tab that was removed. If it gets put back in, reenable the line
    #  $WPFLoggingTextBox.text = Get-Content -Path $Log -Delimiter "\n"
}

#Removes old log and creates all folders if does not exist
Function Set-Logging {

    #logging folder
    $FileExist = Test-Path -Path $PSScriptRoot\logging\WIMWitch.Log -PathType Leaf
    if ($FileExist -eq $False) {
        #update-log -data "Logging folder does not exist" -class Warning
        New-Item -ItemType Directory -Force -Path $PSScriptRoot\Logging | Out-Null
        New-Item -Path $PSScriptRoot\logging -Name "WIMWitch.log" -ItemType "file" -Value "***Logging Started***" | Out-Null
        #update-log -data "Logging folder and log created successfully" -Class Information 
    }
    Else {
        Remove-Item -Path $PSScriptRoot\logging\WIMWitch.log
        New-Item -Path $PSScriptRoot\logging -Name "WIMWitch.log" -ItemType "file" -Value "***Logging Started***" | Out-Null
        #Update-Log -Data "Logging started successfully" -Class Information
    }
   

    #updates folder
    $FileExist = Test-Path -Path $PSScriptRoot\updates #-PathType Leaf
    if ($FileExist -eq $False) {
        Update-Log -Data "Updates folder does not exist. Creating..." -Class Warning
        New-Item -ItemType Directory -Force -Path $PSScriptRoot\updates | Out-Null
        Update-Log -Data "Updates folder created" -Class Information
    }
   
    if ($FileExist -eq $True) { Update-Log -Data "Updates folder exists" -Class Information }

    #staging folder
    $FileExist = Test-Path -Path $PSScriptRoot\Staging #-PathType Leaf
    if ($FileExist -eq $False) {
        Update-Log -Data "Staging folder does not exist. Creating..." -Class Warning
        New-Item -ItemType Directory -Force -Path $PSScriptRoot\Staging | Out-Null
        Update-Log -Data "Staging folder created" -Class Information
    }

    if ($FileExist -eq $True) { Update-Log -Data "Staging folder exists" -Class Information }

    #Mount folder
    $FileExist = Test-Path -Path $PSScriptRoot\Mount #-PathType Leaf
    if ($FileExist -eq $False) {
        Update-Log -Data "Mount folder does not exist. Creating..." -Class Warning
        New-Item -ItemType Directory -Force -Path $PSScriptRoot\Mount | Out-Null
        Update-Log -Data "Mount folder created" -Class Information
    }

    if ($FileExist -eq $True) { Update-Log -Data "Mount folder exists" -Class Information }

    #Completed WIMs folder
    $FileExist = Test-Path -Path $PSScriptRoot\CompletedWIMs #-PathType Leaf
    if ($FileExist -eq $False) {
        Update-Log -Data "CompletedWIMs folder does not exist. Creating..." -Class Warning
        New-Item -ItemType Directory -Force -Path $PSScriptRoot\CompletedWIMs | Out-Null
        Update-Log -Data "CompletedWIMs folder created" -Class Information
    }

    if ($FileExist -eq $True) { Update-Log -Data "CompletedWIMs folder exists" -Class Information }

    #Configurations XML folder
    $FileExist = Test-Path -Path $PSScriptRoot\Configs #-PathType Leaf
    if ($FileExist -eq $False) {
        Update-Log -Data "Configs folder does not exist. Creating..." -Class Warning
        New-Item -ItemType Directory -Force -Path $PSScriptRoot\Configs | Out-Null
        Update-Log -Data "Configs folder created" -Class Information
    }

    if ($FileExist -eq $True) { Update-Log -Data "Configs folder exists" -Class Information }

}

#Function for injecting drivers into the mounted WIM
Function DriverInjection($Folder) {

    Function ApplyDriver($drivertoapply) {
        try {
            add-windowsdriver -Path $WPFMISMountTextBox.Text -Driver $drivertoapply -ErrorAction Stop | Out-Null
            Update-Log -Data "Applied $drivertoapply" -Class Information
        }
        catch {
            update-log -Data "Couldn't apply $drivertoapply" -Class Warning
        }

    }
 
    #This filters out invalid paths, such as the default value
    $testpath = Test-Path $folder -PathType Container
    If ($testpath -eq $false) { return }

    If ($testpath -eq $true) {

        update-log -data "Applying drivers from $folder" -class Information

        Get-ChildItem $Folder -Recurse -Filter "*inf" | ForEach-Object { applydriver $_.FullName }
        update-log -Data "Completed driver injection from $folder" -Class Information 
    }
}

#Function to retrieve OSDUpdate Version 
Function Get-OSDBInstallation {
    update-log -Data "Getting OSD Installation information" -Class Information
    try {
        Import-Module -name OSDUpdate -ErrorAction Stop
    }
    catch {
        $WPFUpdatesOSDBVersion.Text = "Not Installed"
        Update-Log -Data "OSD Update is not installed" -Class Warning
        Return
    }
    try {
        $OSDBVersion = get-module -name OSDUpdate -ErrorAction Stop
        $WPFUpdatesOSDBVersion.Text = $OSDBVersion.Version
        $text = $osdbversion.version
        Update-Log -data "Installed version of OSD Update is $text" -Class Information
        Return
    }
    catch {
        Update-Log -Data "Whatever you were hoping for, you didn’t get :)" -Class Error
        Return
    }
}

#Function to retrieve OSDSUS Version 
Function Get-OSDSUSInstallation {
    update-log -Data "Getting OSDSUS Installation information" -Class Information
    try {
        Import-Module -name OSDSUS -ErrorAction Stop
    }
    catch {
        $WPFUpdatesOSDSUSVersion.Text = "Not Installed"
        Update-Log -Data "OSDSUS is not installed" -Class Warning
        Return
    }
    try {
        $OSDSUSVersion = get-module -name OSDSUS -ErrorAction Stop
        $WPFUpdatesOSDSUSVersion.Text = $OSDSUSVersion.Version
        $text = $osdsusversion.version
        Update-Log -data "Installed version of OSDSUS is $text" -Class Information
        Return
    }
    catch {
        Update-Log -Data "Whatever you were hoping for, you didn’t get :)" -Class Error
        Return
    }
}

#Function to retrieve current OSDUpdate Version
Function Get-OSDBCurrentVer {
    Update-Log -Data "Checking for the most current OSDUpdate version available" -Class Information
    try {
        $OSDBCurrentVer = find-module -name OSDUpdate -ErrorAction Stop
        $WPFUpdatesOSDBCurrentVerTextBox.Text = $OSDBCurrentVer.version
        $text = $OSDBCurrentVer.version
        update-log -data "$text is the most current version" -class Information
        Return
    }
    catch {
        $WPFUpdatesOSDBCurrentVerTextBox.Text = "Network Error"
        Return
    }
}

#Function to retrieve current OSDUSUS Version
Function Get-OSDSUSCurrentVer {
    Update-Log -Data "Checking for the most current OSDSUS version available" -Class Information
    try {
        $OSDSUSCurrentVer = find-module -name OSDSUS -ErrorAction Stop
        $WPFUpdatesOSDSUSCurrentVerTextBox.Text = $OSDSUSCurrentVer.version
        $text = $OSDSUSCurrentVer.version
        update-log -data "$text is the most current version" -class Information
        Return
    }
    catch {
        $WPFUpdatesOSDSUSCurrentVerTextBox.Text = "Network Error"
        Return
    }
}

#Function to update or install OSDUpdate
Function update-OSDB {
    if ($WPFUpdatesOSDBVersion.Text -eq "Not Installed") {
        Update-Log -Data "Attempting to install and import OSD Update" -Class Information
        try {
            Install-Module OSDUpdate -Force -ErrorAction Stop
            #Write-Host "Installed module"
            Update-Log -data "OSD Update module has been installed" -Class Information
            Import-Module -Name OSDUpdate -Force -ErrorAction Stop
            #Write-Host "Imported module"
            Update-Log -Data "OSD Update module has been imported" -Class Information
            Update-Log -Data "****************************************************************************" -Class Warning
            Update-Log -Data "Please close WIM Witch and all PowerShell windows, then rerun to continue..." -Class Warning
            Update-Log -Data "****************************************************************************" -Class Warning
            $WPFUpdatesOSDBClosePowerShellTextBlock.visibility = "Visible"
            Return
        }
        catch {
            $WPFUpdatesOSDBVersion.Text = "Inst Fail"
            Update-Log -Data "Couldn't install OSD Update" -Class Error
            Update-Log -data $_.Exception.Message -class Error
            Return
        }
    }

    If ($WPFUpdatesOSDBVersion.Text -gt "1.0.0") {
        Update-Log -data "Attempting to update OSD Update" -class Information
        try {
            Update-ModuleOSDUpdate -ErrorAction Stop
            Update-Log -Data "Updated OSD Update" -Class Information
            Update-Log -Data "****************************************************************************" -Class Warning
            Update-Log -Data "Please close WIM Witch and all PowerShell windows, then rerun to continue..." -Class Warning
            Update-Log -Data "****************************************************************************" -Class Warning
            $WPFUpdatesOSDBClosePowerShellTextBlock.visibility = "Visible"
            get-OSDBInstallation
            return
        }
        catch {
            $WPFUpdatesOSDBCurrentVerTextBox.Text = "OSDB Err"
            Return
        }
    }
}

#Function to update or install OSDSUS
Function update-OSDSUS {
    if ($WPFUpdatesOSDSUSVersion.Text -eq "Not Installed") {
        Update-Log -Data "Attempting to install and import OSDSUS" -Class Information
        try {
            Install-Module OSDUpdate -Force -ErrorAction Stop
            #Write-Host "Installed module"
            Update-Log -data "OSDSUS module has been installed" -Class Information
            Import-Module -Name OSDUpdate -Force -ErrorAction Stop
            #Write-Host "Imported module"
            Update-Log -Data "OSDSUS module has been imported" -Class Information
            Update-Log -Data "****************************************************************************" -Class Warning
            Update-Log -Data "Please close WIM Witch and all PowerShell windows, then rerun to continue..." -Class Warning
            Update-Log -Data "****************************************************************************" -Class Warning
            $WPFUpdatesOSDBClosePowerShellTextBlock.visibility = "Visible"
            Return
        }
        catch {
            $WPFUpdatesOSDSUSVersion.Text = "Inst Fail"
            Update-Log -Data "Couldn't install OSDSUS" -Class Error
            Update-Log -data $_.Exception.Message -class Error
            Return
        }
    }

    If ($WPFUpdatesOSDSUSVersion.Text -gt "1.0.0") {
        Update-Log -data "Attempting to update OSDSUS" -class Information
        try {
            uninstall-module -Name osdsus -AllVersions -force
            install-module -name osdsus -force
           # Update-OSDSUS -ErrorAction Stop
            Update-Log -Data "Updated OSDSUS" -Class Information
            Update-Log -Data "****************************************************************************" -Class Warning
            Update-Log -Data "Please close WIM Witch and all PowerShell windows, then rerun to continue..." -Class Warning
            Update-Log -Data "****************************************************************************" -Class Warning
            $WPFUpdatesOSDBClosePowerShellTextBlock.visibility = "Visible"
            get-OSDSUSInstallation
            return
        }
        catch {
            $WPFUpdatesOSDSUSCurrentVerTextBox.Text = "OSDSUS Err"
            Return
        }
    }
}

#Function to compare OSDBuilder Versions
Function compare-OSDBuilderVer {
    Update-Log -data "Comparing OSD Update module versions" -Class Information
    if ($WPFUpdatesOSDBVersion.Text -eq "Not Installed") {
        Return
    }
    If ($WPFUpdatesOSDBVersion.Text -eq $WPFUpdatesOSDBCurrentVerTextBox.Text) {
        Update-Log -Data "OSD Update is up to date" -class Information
        Return
    }
    $WPFUpdatesOSDBOutOfDateTextBlock.Visibility = "Visible"
    Update-Log -Data "OSD Update appears to be out of date. Run the upgrade function from within WIM Witch to resolve" -class Warning

    Return
}

#Function to compare OSDSUS Versions
Function compare-OSDSUSVer {
    Update-Log -data "Comparing OSDSUS module versions" -Class Information
    if ($WPFUpdatesOSDSUSVersion.Text -eq "Not Installed") {
        Return
    }
    If ($WPFUpdatesOSDSUSVersion.Text -eq $WPFUpdatesOSDSUSCurrentVerTextBox.Text) {
        Update-Log -Data "OSDSUS is up to date" -class Information
        Return
    }
    $WPFUpdatesOSDBOutOfDateTextBlock.Visibility = "Visible"
    Update-Log -Data "OSDSUS appears to be out of date. Run the upgrade function from within WIM Witch to resolve" -class Warning

    Return
}

#Function to check for superceded updates
Function check-superceded($action, $OS, $Build) {
    Update-Log -Data "Checking WIM Witch Update store for superseded updates" -Class Information
    $path = $PSScriptRoot + '\updates\' + $OS + '\' + $Build + '\' #sets base path

    if ((Test-Path -Path $path) -eq $false){
        update-log -Data "No updates found, likely not yet downloaded. Skipping supersedense check..." -Class Warning
        return}

    $Children = Get-ChildItem -Path $path  #query sub directories

    foreach ($Children in $Children) {
        $path1 = $path + $Children  
        $sprout = Get-ChildItem -Path $path1
 
      #  foreach ($kids in $kids) {
      #      $path2 = $path1 + '\' + $kids
      #      $sprout = get-childitem -path $path2
        
            foreach ($sprout in $sprout) {
                $path3 = $path1 + '\' + $sprout
                $fileinfo = get-childitem -path $path3
                foreach ($file in $fileinfo){
                    $StillCurrent = Get-OSDUpdate | Where-Object { $_.FileName -eq $file }   
                    If ($StillCurrent -eq $null) {
                       update-log -data "$file no longer current" -Class Warning
                       if ($action -eq 'delete') {
                            Update-Log -data "Deleting $path3" -class Warning
                            remove-item -path $path3 -Recurse -Force
                        }
                    if ($action -eq 'audit') {
                        #write-host "set variable"
                        $WPFUpdatesOSDBSupercededExistTextBlock.Visibility = "Visible"

                        Return
                    }
                    }   
                     else {
                    Update-Log -data "$file is stil current" -Class Information
                }    
                 }
            }
            }
        Update-Log -data "Supersedense check complete." -Class Information
    }

#Function to download new patches
Function download-patches($build,$OS) {
    Update-Log -Data "Downloading SSU updates for $OS $build" -Class Information
    Get-OSDUpdate | Where-Object { $_.UpdateOS -eq $OS -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'SSU' } | Get-DownOSDUpdate -DownloadPath $PSScriptRoot\updates\$OS\$build\SSU
    Update-Log -Data "Downloading AdobeSU updates for $OS $build" -Class Information
    Get-OSDUpdate | Where-Object { $_.UpdateOS -eq $OS -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'AdobeSU' } | Get-DownOSDUpdate -DownloadPath $PSScriptRoot\updates\$OS\$build\AdobeSU
    Update-Log -Data "Downloading LCU updates for $OS $build" -Class Information
    Get-OSDUpdate | Where-Object { $_.UpdateOS -eq $OS -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'LCU' } | Get-DownOSDUpdate -DownloadPath $PSScriptRoot\updates\$OS\$build\LCU
    Update-Log -Data "Downloading .Net updates for $OS $build" -Class Information
    Get-OSDUpdate | Where-Object { $_.UpdateOS -eq $OS -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'DotNet' } | Get-DownOSDUpdate -DownloadPath $PSScriptRoot\updates\$OS\$build\DotNet
    Update-Log -Data "Downloading .Net CU updates for $OS $build" -Class Information
    Get-OSDUpdate | Where-Object { $_.UpdateOS -eq $OS -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'DotNetCU' } | Get-DownOSDUpdate -DownloadPath $PSScriptRoot\updates\$OS\$build\DotNetCU
    Update-Log -Data "Downloading completed for $OS $build" -Class Information
}
 
#Function to remove superceded updates and initate new patch download
Function update-patchsource {



    #try {
        #write-host "starting purge"
        #Get-DownOSDBuilder -Superseded Remove -ErrorAction Stop
        #Update-Log -Data "Deleting superseded updates..." -Class Warning
    #    Check-Superceded -action delete -ErrorAction Stop
    #} 
    #catch {
    #    Update-Log -Data "Updates not superceded" -Class Information
    #    Return
    #}
    Update-Log -Data "attempting to start download function" -Class Information
  #  If ($WPFUpdates1909CheckBox.IsChecked -eq $true) { download-patches -build 1909 }
  #  If ($WPFUpdates1903CheckBox.IsChecked -eq $true) { download-patches -build 1903 }
  #  If ($WPFUpdates1809CheckBox.IsChecked -eq $true) { download-patches -build 1809 }
  #  If ($WPFUpdates1803CheckBox.IsChecked -eq $true) { download-patches -build 1803 }
  #  If ($WPFUpdates1709CheckBox.IsChecked -eq $true) { download-patches -build 1709 }

  
if ($WPFUpdatesW10Main.IsChecked -eq $true){
    if ($WPFUpdatesW10_1909.IsChecked -eq $true){
        check-superceded -action delete -build 1909 -OS "Windows 10"
        download-patches -build 1909 -OS "Windows 10"}
    if ($WPFUpdatesW10_1903.IsChecked -eq $true){
        check-superceded -action delete -build 1903 -OS "Windows 10"
        download-patches -build 1903 -OS "Windows 10"}
    if ($WPFUpdatesW10_1809.IsChecked -eq $true){
        check-superceded -action delete -build 1809 -OS "Windows 10"
        download-patches -build 1809 -OS "Windows 10"}
    if ($WPFUpdatesW10_1803.IsChecked -eq $true){
        check-superceded -action delete -build 1803 -OS "Windows 10"
        download-patches -build 1803 -OS "Windows 10"}
    if ($WPFUpdatesW10_1709.IsChecked -eq $true){
        check-superceded -action delete -build 1709 -OS "Windows 10"
        download-patches -build 1709 -OS "Windows 10"}
    download-onedrive
    }

if ($WPFUpdatesS2019.IsChecked -eq $true){
    check-superceded -action delete -build 1809 -OS "Windows Server 2019"
    download-patches -build 1809 -OS "Windows Server 2019"}
if ($WPFUpdatesS2016.IsChecked -eq $true){
    check-superceded -action delete -build 1607 -OS "Windows Server 2016"
    download-patches -build 1607 -OS "Windows Server 2016"}

}

#Function to apply updates to mounted WIM
Function Apply-Updates($class) {
   if (($class -eq 'AdobeSU') -and ($WPFSourceWIMImgDesTextBox.text -like "Windows Server 20*") -and ($WPFSourceWIMImgDesTextBox.text -notlike "*(Desktop Experience)")){
    update-log -Data "Skipping Adobe updates for Server Core build" -Class Information
    return}
   
    If ($WPFSourceWIMImgDesTextBox.text -like "Windows Server 2016*"){$OS = "Windows Server 2016"}
    If ($WPFSourceWIMImgDesTextBox.text -like "Windows Server 2019*"){$OS = "Windows Server 2019"}
    If ($WPFSourceWIMImgDesTextBox.text -like "Windows 10*"){$OS = "Windows 10"}

    If ($WPFSourceWimVerTextBox.text -like "10.0.14393.*") { $buildnum = 1607 }
    If ($WPFSourceWimVerTextBox.text -like "10.0.17763.*") { $buildnum = 1809 }
    If ($WPFSourceWimVerTextBox.text -like "10.0.17134.*") { $buildnum = 1803 }
    If ($WPFSourceWimVerTextBox.text -like "10.0.16299.*") { $buildnum = 1709 }
    #If ($WPFSourceWimVerTextBox.text -like "10.0.18362.*") { $buildnum = 1903 }

    If ($WPFSourceWimVerTextBox.text -like "10.0.18362.*") { 
        $mountdir = $WPFMISMountTextBox.Text
        reg LOAD HKLM\OFFLINE $mountdir\Windows\System32\Config\SOFTWARE | Out-Null
        $regvalues = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\OFFLINE\Microsoft\Windows NT\CurrentVersion\" )
        $buildnum = $regvalues.ReleaseId
        reg UNLOAD HKLM\OFFLINE | Out-Null}


    
    $path = $PSScriptRoot + '\updates\' + $OS + '\' + $buildnum + '\' + $class + '\'
    $Children = Get-ChildItem -Path $path
    foreach ($Children in $Children) {
        $compound = $path + $Children
        update-log -Data "Applying $Children" -Class Information
        Add-WindowsPackage -path $WPFMISMountTextBox.Text -PackagePath $compound | Out-Null
    }

}

#Function to select AppX packages to yank
Function Select-Appx {
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
        "Microsoft.SkypeApp_14.35.152.0_neutral_~_kzf8qxf38zg5c"
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

    If ($WPFSourceWimVerTextBox.text -like "10.0.18362.*") { $exappxs = write-output $appx1903 | out-gridview -title "Select apps to remove" -passthru }
    If ($WPFSourceWimVerTextBox.text -like "10.0.17763.*") { $exappxs = write-output $appx1809 | out-gridview -title "Select apps to remove" -passthru }
    If ($WPFSourceWimVerTextBox.text -like "10.0.17134.*") { $exappxs = write-output $appx1803 | out-gridview -title "Select apps to remove" -passthru }
    If ($WPFSourceWimVerTextBox.text -like "10.0.16299.*") { $exappxs = write-output $appx1709 | out-gridview -title "Select apps to remove" -passthru }

    if ($exappxs -eq $null) {
        Update-Log -Data "No apps were selected" -Class Warning
    }
    if ($exappxs -ne $null) {
        Update-Log -data "The following apps were selected for removal:" -Class Information
        Foreach ($exappx in $exappxs) {
            Update-Log -Data $exappx -Class Information
        }

        $WPFAppxTextBox.Text = $exappxs
        return $exappxs
    }
}

#Function to remove appx packages
function remove-appx($array) {
    $exappxs = $array
    update-log -data "Starting AppX removal" -class Information
    foreach ($exappx in $exappxs) {
        Remove-AppxProvisionedPackage -Path $WPFMISMountTextBox.Text -PackageName $exappx | Out-Null
        update-log -data "Removing $exappx" -Class Information
    }
    return
}

#Function to remove unwanted image indexes
Function remove-indexes {
    Update-Log -Data "Attempting to remove unwanted image indexes" -Class Information
    $wimname = Get-Item -Path $PSScriptRoot\Staging\*.wim
    Update-Log -Data "Found Image $wimname" -Class Information
    $IndexesAll = Get-WindowsImage -ImagePath $wimname | foreach { $_.ImageName }
    $IndexSelected = $WPFSourceWIMImgDesTextBox.Text
    foreach ($Index in $IndexesAll) {
        Update-Log -data "$Index is being evaluated"
        If ($Index -eq $IndexSelected) {
            Update-Log -Data "$Index is the index we want to keep. Skipping." -Class Information | Out-Null
        }
        else {
            update-log -data "Deleting $Index from WIM" -Class Information
            Remove-WindowsImage -ImagePath $wimname -Name $Index -InformationAction SilentlyContinue | Out-Null

        }
    }
}

#Function to select which folder to save Autopilot JSON file to
Function SelectNewJSONDir {

    Add-Type -AssemblyName System.Windows.Forms
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $browser.Description = "Select the folder to save JSON"
    $null = $browser.ShowDialog()
    $SaveDir = $browser.SelectedPath
    $WPFJSONTextBoxSavePath.text = $SaveDir 
    $text = "Autopilot profile save path selected: $SaveDir" 
    update-log -Data $text -Class Information
}

#Function to retrieve autopilot profile from intune
function get-WWAutopilotProfile ($login, $path) {
    Update-Log -data "Checking dependencies for Autopilot profile retrieval..." -Class Information

    try {
        Import-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -ErrorAction Stop
        Update-Log -Data "NuGet is installed" -Class Information
    }
    catch {
        Update-Log -data "NuGet is not installed. Installing now..." -Class Warning
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Update-Log -data "NuGet is now installed" -Class Information
    }

    try {

        Import-Module -name AzureAD -ErrorAction Stop
        Update-Log -data "AzureAD Module is installed" -Class Information
    }
    catch {
        Update-Log -data "AzureAD Module is not installed. Installing now..." -Class Warning
        Install-Module AzureAD -Force
        Update-Log -data "AzureAD is now installed" -class Information
    }

    try {

        Import-Module -Name WindowsAutopilotIntune -ErrorAction Stop
        Update-Log -data "WindowsAutopilotIntune module is installed" -Class Information
    }
    catch {

        Update-Log -data "WindowsAutopilotIntune module is not installed. Installing now..." -Class Warning
        Install-Module WindowsAutopilotIntune -Force
        update-log -data "WindowsAutopilotIntune module is now installed." -class Information
    }


    Update-Log -data "Connecting to Intune..." -Class Information
    Connect-AutopilotIntune -user $login | out-null
    Update-Log -data "Connected to Intune" -Class Information

    Update-Log -data "Retrieving profile..." -Class Information
    Get-AutoPilotProfile | Out-GridView -title "Select Autopilot profile" -PassThru | ConvertTo-AutoPilotConfigurationJSON | Out-File $path\AutopilotConfigurationFile.json -Encoding ASCII
    $text = $path + "\AutopilotConfigurationFile.json"
    Update-Log -data "Profile successfully created at $text" -Class Information


}

#Function to save current configuration
function save-config($filename) {

    $CurrentConfig = @{
        SourcePath       = $WPFSourceWIMSelectWIMTextBox.text
        SourceIndex      = $WPFSourceWimIndexTextBox.text
        SourceEdition    = $WPFSourceWIMImgDesTextBox.text
        UpdatesEnabled   = $WPFUpdatesEnableCheckBox.IsChecked
        AutopilotEnabled = $WPFJSONEnableCheckBox.IsChecked
        AutopilotPath    = $WPFJSONTextBox.text
        DriversEnabled   = $WPFDriverCheckBox.IsChecked
        DriverPath1      = $WPFDriverDir1TextBox.text
        DriverPath2      = $WPFDriverDir2TextBox.text
        DriverPath3      = $WPFDriverDir3TextBox.text
        DriverPath4      = $WPFDriverDir4TextBox.text
        DriverPath5      = $WPFDriverDir5TextBox.text
        AppxIsEnabled    = $WPFAppxCheckBox.IsChecked
        AppxSelected     = $WPFAppxTextBox.Text
        WIMName          = $WPFMISWimNameTextBox.text
        WIMPath          = $WPFMISWimFolderTextBox.text
        MountPath        = $WPFMISMountTextBox.text
        DotNetEnabled    = $WPFMISDotNetCheckBox.IsChecked
        OneDriveEnabled  = $WPFMISOneDriveCheckBox.IsChecked
    }

    Update-Log -data "Saving configuration file $filename" -Class Information
    try {
        $CurrentConfig | Export-Clixml -Path $PSScriptRoot\Configs\$filename -ErrorAction Stop
        update-log -data "file saved" -Class Information
    }
    catch {
        Update-Log -data "Couldn't save file" -Class Error 
    }

}

#Function to import configurations from file
function load-config($filename) {
    update-log -data "Importing config from $filename" -Class Information
    try {
        $settings = Import-Clixml -Path $filename -ErrorAction Stop
        update-log -data "Config file read..." -Class Information
        $WPFSourceWIMSelectWIMTextBox.text = $settings.SourcePath
        $WPFSourceWimIndexTextBox.text = $settings.SourceIndex
        $WPFSourceWIMImgDesTextBox.text = $settings.SourceEdition
        $WPFUpdatesEnableCheckBox.IsChecked = $settings.UpdatesEnabled
        $WPFJSONEnableCheckBox.IsChecked = $settings.AutopilotEnabled
        $WPFJSONTextBox.text = $settings.AutopilotPath 
        $WPFDriverCheckBox.IsChecked = $settings.DriversEnabled
        $WPFDriverDir1TextBox.text = $settings.DriverPath1
        $WPFDriverDir2TextBox.text = $settings.DriverPath2
        $WPFDriverDir3TextBox.text = $settings.DriverPath3
        $WPFDriverDir4TextBox.text = $settings.DriverPath4
        $WPFDriverDir5TextBox.text = $settings.DriverPath5
        $WPFAppxCheckBox.IsChecked = $settings.AppxIsEnabled
        $WPFAppxTextBox.text = $settings.AppxSelected -split " "
        $WPFMISWimNameTextBox.text = $settings.WIMName
        $WPFMISWimFolderTextBox.text = $settings.WIMPath
        $WPFMISMountTextBox.text = $settings.MountPath
        $global:SelectedAppx = $settings.AppxSelected -split " "
        $WPFMISDotNetCheckBox.IsChecked = $settings.DotNetEnabled
        $WPFMISOneDriveCheckBox.IsChecked = $settings.OneDriveEnabled


        update-log -data "Configration set" -class Information

        import-wiminfo -IndexNumber $WPFSourceWimIndexTextBox.text

        if ($WPFJSONEnableCheckBox.IsChecked -eq $true) {
            #Update-Log -data "Parsing Autopilot JSON file" -Class Information
            Parse-JSON -file $WPFJSONTextBox.text 
        }

        reset-MISCheckBox
        Update-Log -data "Config file loaded successfully" -Class Information
    }

    catch
    { update-log -data "Could not import from $filename" -Class Error }

}

#Function to select configuration file
Function select-config {
    $SourceXML = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = "$PSScriptRoot\Configs"
        #InitialDirectory = [Environment]::GetFolderPath('Desktop') 
        Filter           = 'XML (*.XML)|'
    }
    $null = $SourceXML.ShowDialog()
    $WPFSLLoadTextBox.text = $SourceXML.FileName
    load-config -filename $WPFSLLoadTextBox.text
}

#Function to reset reminder values from check boxes on the MIS tab when loading a config
function reset-MISCheckBox {
    update-log -data "Refreshing MIS Values..." -class Information

    If ($WPFJSONEnableCheckBox.IsChecked -eq $true) {
        $WPFJSONButton.IsEnabled = $True
        $WPFMISJSONTextBox.Text = "True"
    }
    If ($WPFDriverCheckBox.IsChecked -eq $true) {
        $WPFDriverDir1Button.IsEnabled = $True
        $WPFDriverDir2Button.IsEnabled = $True
        $WPFDriverDir3Button.IsEnabled = $True
        $WPFDriverDir4Button.IsEnabled = $True
        $WPFDriverDir5Button.IsEnabled = $True
        $WPFMISDriverTextBox.Text = "True"
    }
    If ($WPFUpdatesEnableCheckBox.IsChecked -eq $true) {
       # $WPFUpdateOSDBUpdateButton.IsEnabled = $True
       # $WPFUpdatesDownloadNewButton.IsEnabled = $True
       # $WPFUpdates1903CheckBox.IsEnabled = $True
       # $WPFUpdates1809CheckBox.IsEnabled = $True
       # $WPFUpdates1803CheckBox.IsEnabled = $True
       # $WPFUpdates1709CheckBox.IsEnabled = $True
       # $WPFUpdateOSDBUpdateButton.IsEnabled = $True
        $WPFMISUpdatesTextBox.Text = "True"
    }
    If ($WPFAppxCheckBox.IsChecked -eq $true) {
        $WPFAppxButton.IsEnabled = $True
        $WPFMISAppxTextBox.Text = "True"
    }
}

#Function to run WIM Witch from a config file
function run-configfile($filename) {
    Update-Log -Data "Loading the config file: $filename" -Class Information
    load-config -filename $filename 
    Update-Log -Data "Starting auto mode with the config file $filename" -Class Information
    MakeItSo -appx $global:SelectedAppx 
}

#Function to display text on closing of the script or wpf window
function display-closingtext {
    #Before you start bitching about write-host, write-output doesn't work with the exiting function. Suggestions are welcome.
    Write-Host " " 
    Write-Host "##########################################################"
    Write-Host " "
    Write-Host "Thank you for using WIM Witch. If you have any questions,"
    Write-Host "comments, or suggestions, please reach out to me!"
    Write-Host " "
    Write-Host "-Donna Ryan" 
    Write-Host " "
    Write-Host "twitter: @TheNotoriousDRR"
    Write-Host "www.SCConfigMgr.com"
    Write-Host "www.TheNotoriousDRR.com"
    Write-Host " "
    Write-Host "##########################################################"
}

#Function to display opening text
function display-openingtext {
    cls
    Write-Output "##########################################################"
    Write-Output " "
    Write-Output "             ***** Starting WIM Witch *****"
    Write-Output "                      version $WWScriptVer"
    Write-Output " "
    Write-Output "##########################################################"
    Write-Output " "
}

#Function to check suitability of the proposed mount point folder
function check-mountpath {
    param(
        [parameter(mandatory = $true, HelpMessage = "mount path")] 
        $path,

        [parameter(mandatory = $false, HelpMessage = "clear out the crapola")] 
        [ValidateSet($true)]
        $clean
    )


    $IsMountPoint = $null
    $HasFiles = $null
    $currentmounts = get-windowsimage -Mounted

    foreach ($currentmount in $currentmounts) {
        if ($currentmount.path -eq $path) { $IsMountPoint = $true } 
    }
  
    if ($IsMountPoint -eq $null) {
        if ( (Get-ChildItem $path | Measure-Object).Count -gt 0) {
            $HasFiles = $true
        }
    }

    if ($HasFiles -eq $true) {
        Update-Log -Data "Folder is not empty" -Class Warning
        if ($clean -eq $true) {
            try {
                Update-Log -Data "Cleaning folder..." -Class Warning
                Remove-Item -Path $path\* -Recurse -Force -ErrorAction Stop
                Update-Log -Data "$path cleared" -Class Warning
            }
        
            catch {
                Update-Log -Data "Couldn't delete contents of $path" -Class Error
                Update-Log -Data "Select a different folder to continue." -Class Error
                return
            }
        }
    }

    if ($IsMountPoint -eq $true) {
        Update-Log -Data "$path is currently a mount point" -Class Warning
        if (($IsMountPoint -eq $true) -and ($clean -eq $true)) {
          
            try {
                Update-Log -Data "Attempting to dismount image from mount point" -Class Warning
                Dismount-WindowsImage -Path $path -Discard | Out-Null -ErrorAction Stop
                $IsMountPoint = $null
                Update-Log -Data "Dismounting was successful" -Class Warning
            }   
            
            catch {
                Update-Log -Data "Couldn't completely dismount the folder. Ensure" -Class Error
                update-log -data "all connections to the path are closed, then try again" -Class Error
                return
            }
        }
    }
    if (($IsMountPoint -eq $null) -and ($HasFiles -eq $null)) { Update-Log -Data "$path is suitable for mounting" -Class Information }
}

#Function to check the name of the target file and remediate if necessary
function check-name {
    Param( 
        [parameter(mandatory = $false, HelpMessage = "what to do")] 
        [ValidateSet("stop", "append", "backup", "overwrite")] 
        $conflict = "stop"
    )

    If ($WPFMISWimNameTextBox.Text -like "*.wim") {
        #$WPFLogging.Focus()
        #update-log -Data "New WIM name is valid" -Class Information
    }

    If ($WPFMISWimNameTextBox.Text -notlike "*.wim") {

        $WPFMISWimNameTextBox.Text = $WPFMISWimNameTextBox.Text + ".wim"
        update-log -Data "Appending new file name with an extension" -Class Information
    }

    $WIMpath = $WPFMISWimFolderTextBox.text + "\" + $WPFMISWimNameTextBox.Text
    $FileCheck = Test-Path -Path $WIMpath


    #append,overwrite,stop

    if ($FileCheck -eq $false) { update-log -data "Target WIM file name not in use. Continuing..." -class Information }
    else {
        if ($conflict -eq "append") {
            $renamestatus = (replace-name -file $WIMpath -extension ".wim")
            if ($renamestatus -eq "stop") { return "stop" }
        }
        if ($conflict -eq "overwrite") {
            Write-Host "overwrite action"
            return
        }
        if ($conflict -eq "stop") {
            $string = $WPFMISWimNameTextBox.Text + " already exists. Rename the target WIM and try again"
            update-log -Data $string -Class Warning
            return "stop"
        }
    }
    update-log -Data "New WIM name is valid" -Class Information
}

#Function to rename existing target wim file if the target WIM name already exists
function replace-name($file, $extension) {
    $text = "Renaming existing " + $extension + " file..."
    Update-Log -Data $text -Class Warning
    $filename = (Split-Path -leaf $file)
    $dateinfo = (get-item -Path $file).LastWriteTime -replace (" ", "_") -replace ("/", "_") -replace (":", "_")
    $filename = $filename -replace ($extension, "")
    $filename = $filename + $dateinfo + $extension
    try {
        rename-Item -Path $file -NewName $filename -ErrorAction Stop
        $text = $file + " has been renamed to " + $filename
        Update-Log -Data $text -Class Warning    
    }
    catch {
        Update-Log -data "Couldn't rename file. Stopping..." -force -Class Error
        return "stop"
    }
} 

#Function to see if the folder WIM Witch was started in is an installation folder. If not, prompt for installation
function check-install {

    function select-installfolder {
        $installselect = New-Object System.Windows.Forms.FolderBrowserDialog
        $installselect.Description = "Select the installation folder"
        $null = $installselect.ShowDialog()

        if ($installselect.SelectedPath -eq "") {
            write-output "User Cancelled or invalid entry"
            exit 0
        }

        return $installselect.SelectedPath
    }

    function install-wimwitch {
        Write-Output "Would you like to install WIM Witch here?"
        $yesno = Read-Host -Prompt "(Y/N)"
        Write-Output $yesno
        if (($yesno -ne "Y") -and ($yesno -ne "N")) {
            Write-Output "Invalid entry, try again."
            install-wimwitch
        }

        if (($yesno -eq "y") -and ($PSScriptRoot -notlike "*WindowsPowerShell\Scripts*")){
            foreach ($subfolder in $subfolders) {
                New-Item -Path $subfolder -ItemType Directory | Out-Null
                Write-Output "Created folder: $subfolder"
            }
        }
        if (($yesno -eq "y") -and ($PSScriptRoot -like "*WindowsPowerShell\Scripts*")){
            Write-Output " "
            write-output "You cannot install WIM Witch in the script repository folder."
            Write-Output "Also, you probably shouldn't install this in My Downloads, or My Desktop"
            write-output "Please select another folder"
            $yesno = "n"

        }
        if ($yesno -eq "n") {
            Write-Output "Select an installation folder"
            $installpath = select-installfolder
            
            if ($installpath -like "*WindowsPowerShell\Scripts*"){
                Write-Output "You cannot install WIM Witch in the script repository folder"
                Write-Output "Exiting installer. Please try again"
                exit 0
                }

            Write-Output "Installing WIM Witch in: $installpath"
            Copy-Item -Path $MyInvocation.ScriptName -Destination $installpath -Force
            Write-Output "WIM Witch script copied to installation path"
            Set-Location -Path $installpath
            #Set-Location -path $installpath
            foreach ($subfolder in $subfolders) {

                if ((Test-Path -Path "$subfolder") -eq $true) { Write-Host "$subfolder exists" }
                if ((Test-Path -Path "$subfolder") -eq $false) {
                    New-Item -Path $subfolder -ItemType Directory | out-null
                    Write-Output "Created folder: $subfolder"
                } 
            }
                
            #Set-Location $PSScriptRoot
            Write-Output "============================================="
            Write-Output "WIM Witch has been installed to $installpath"
            Write-Output "Start WIM witch from that folder to continue."
            Write-Output " "
            Write-Output "Exiting..."
            break
        }
  
    }

    $subfolders = @(
        "CompletedWIMs"
        "Configs"      
        "drivers"      
        "jobs"         
        "logging"      
        "Mount"        
        "Staging"      
        "updates"
        "imports"
        "imports\WIM"
        "imports\DotNet"
        "Autopilot"
        "backup" 
    )
    if ((Get-WmiObject win32_operatingsystem).version -like '10.0.*') { Write-Output "WIM Witch is running on a supported OS" }
    else {
        Write-Output "Current OS not supported"
        Write-Output "Please run WIM Witch on Windows 10 / Server 2016+"
        exit 0
    }
    
    $count = $null
    set-location -path $PSScriptRoot
    Write-Output "WIM Witch starting in $PSScriptRoot"
    Write-Output "Checking for installation status"
    foreach ($subfolder in $subfolders) {
        if ((Test-Path -Path .\$subfolder) -eq $true) { $count = $count + 1 }
    }

    if ($count -eq $null) {
        Write-Output "WIM Witch does not appear to be installed in this location."
        install-wimwitch
    }
    if ($count -ne $null) {
        Write-Output "WIM Witch is installed"
        Write-Output "Remediating for missing folders if they exist"
        foreach ($subfolder in $subfolders) {

            if ((Test-Path -Path "$subfolder") -eq $false) {
                New-Item -Path $subfolder -ItemType Directory | Out-Null
                Write-Output "Created folder: $subfolder"
            }
        }      
        write-output "Preflight complete. Starting WIM Witch"
    }
}

#Function to import WIM and .Net binaries from an iso file
function import-iso($file, $type, $newname) {

    function set-version($wimversion) {
        if ($wimversion -like '10.0.16299.*') { $version = "1709" }
        if ($wimversion -like '10.0.17134.*') { $version = "1803" }
        if ($wimversion -like '10.0.17763.*') { $version = "1809" }
        if ($wimversion -like '10.0.18362.*') { $version = "1903" }
        if ($wimversion -like '10.0.14393.*') { $version = "1607" }
        return $version
    }
    #Check to see if destination WIM already exists
    if (($type -eq "all") -or ($type -eq "wim")) {
        update-log -data "Checking to see if the destination WIM file exists..." -Class Information	
        #check to see if the new name for the imported WIM is valid
        if (($WPFImportNewNameTextBox.Text -eq "") -or ($WPFImportNewNameTextBox.Text -eq "Name for the imported WIM")) {
            update-log -Data "Enter a valid file name for the imported WIM and then try again" -Class Error
            return 
        }
        If ($newname -notlike "*.wim") {
            $newname = $newname + ".wim"
            update-log -Data "Appending new file name with an extension" -Class Information
        }
    
        if ((Test-Path -Path $PSScriptRoot\Imports\WIM\$newname) -eq $true) {
            Update-Log -Data "Destination WIM name already exists. Provide a new name and try again." -Class Error
            return
        }
        else {
            update-log -Data "Name appears to be good. Continuing..." -Class Information
        }
    }

    Update-Log -Data "Mounting ISO..." -Class Information
    $isomount = Mount-DiskImage -ImagePath $file -NoDriveLetter
    $iso = $isomount.devicepath
    $windowsver = Get-WindowsImage -ImagePath $iso\sources\install.wim -Index 1
    $version = set-version -wimversion $windowsver.version
    if ($version -eq 1903){
        $Vardate = (Get-Date -Year 2019 -Month 10 -Day 01)
        if ($windowsver.CreatedTime -gt $vardate){$version = 1909}
        }

    

    #Copy out WIM file
    if (($type -eq "all") -or ($type -eq "wim")) {
   
        #Copy out the WIM file from the selected ISO
        try {
            Update-Log -Data "Copying WIM file to the staging folder..." -Class Information	
            Copy-Item -Path $iso\sources\install.wim -Destination $PSScriptRoot\staging -Force -ErrorAction Stop
        }
        catch {
            Update-Log "Couldn't copy from the source" -Class Error
            return
        }
    
        #Change file attribute to normal
        Update-Log -Data "Setting file attribute of install.wim to Normal" -Class Information
        $attrib = Get-Item $PSScriptRoot\staging\install.wim
        $attrib.Attributes = 'Normal'
     
        #Rename install.wim to the new name
        try {
            $text = "Renaming install.wim to " + $newname
            Update-Log -Data $text -Class Information
            Rename-Item -Path $PSScriptRoot\Staging\install.wim -NewName $newname -ErrorAction Stop
        }
        catch {
            Update-Log -data "Couldn't rename the copied file. Most likely a weird permissions issues." -Class Error
            return
        }
    
        #Move the imported WIM to the imports folder
    
        try {
            Update-Log -data "Moving $newname to imports folder..." -Class Information
            Move-Item -Path $PSScriptRoot\Staging\$newname -Destination $PSScriptRoot\Imports\WIM -ErrorAction Stop
        }
        catch {
            Update-Log -Data "Couldn't move the new WIM to the staging folder." -Class Error
            return
        }

    }

    #Copy DotNet binaries
    if (($type -eq "all") -or ($type -eq "Dotnet")) {
        if ((Test-Path -Path $PSScriptRoot\Imports\DotNet\$version) -eq $false) {
            try {
                Update-Log -Data "Creating folders..." -Class Warning
                New-Item -Path $PSScriptRoot\Imports\DotNet\ -Name $version -ItemType Directory -ErrorAction stop | Out-Null 
            }
            catch {
                Update-Log -Data "Couldn't creating new folder in DotNet imports folder" -Class Error
                return
            }
        }


        try {
            Update-Log -Data "Copying .Net binaries..." -Class Information
            Copy-Item -Path $iso\sources\sxs\*netfx3* -Destination $PSScriptRoot\Imports\DotNet\$version -Force -ErrorAction Stop
        }
        catch {
            Update-Log -Data "Couldn't copy the .Net binaries" -Class Error
            return
        }
    }

    try {
        Update-Log -Data "Dismount!" -Class Information
        Dismount-DiskImage -ImagePath $file -ErrorAction Stop | Out-Null
    }
    catch {
        Update-Log -Data "Couldn't dismount the ISO. WIM Witch uses a file mount option that does not" -Class Error
        Update-Log -Data "provision a drive letter. Use the Dismount-DiskImage command to manaully dismount." -Class Error
    }
    update-log -data "Importing complete" -class Information
}

#function to select ISO for import
function select-iso {

    $SourceISO = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = [Environment]::GetFolderPath('Desktop') 
        Filter           = 'ISO (*.iso)|'
    }
    $null = $SourceISO.ShowDialog()
    $WPFImportISOTextBox.text = $SourceISO.FileName


    if ($SourceISO.FileName -notlike "*.iso") {
        update-log -Data "An ISO file not selected. Please select a valid file to continue." -Class Warning
        return
    }
    $text = $WPFImportISOTextBox.text + " selected as the ISO to import from"
    Update-Log -Data $text -class Information
}

#function to inject the .Net 3.5 binaries from the import folder
function inject-dotnet {

    #If ($WPFSourceWimVerTextBox.text -like "10.0.18362.*") { $buildnum = 1903 }
    If ($WPFSourceWimVerTextBox.text -like "10.0.17763.*") { $buildnum = 1809 }
    If ($WPFSourceWimVerTextBox.text -like "10.0.17134.*") { $buildnum = 1803 }
    If ($WPFSourceWimVerTextBox.text -like "10.0.16299.*") { $buildnum = 1709 }
    if ($WPFSourceWimVerTextBox.text -like "10.0.14393.*") { $buildnum = 1607 }

    If ($WPFSourceWimVerTextBox.text -like "10.0.18362.*") { 
        $mountdir = $WPFMISMountTextBox.Text
        reg LOAD HKLM\OFFLINE $mountdir\Windows\System32\Config\SOFTWARE | out-null #Fount it
        $regvalues = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\OFFLINE\Microsoft\Windows NT\CurrentVersion\" )
        $buildnum = $regvalues.ReleaseId
        reg UNLOAD HKLM\OFFLINE | out-null}#Found it

    $DotNetFiles = $PSScriptRoot + '\imports\DotNet\' + $buildnum

    try {
        $text = "Injecting .Net 3.5 binaries from " + $DotNetFiles
        Update-Log -Data $text -Class Information
        Add-WindowsPackage -PackagePath $DotNetFiles -Path $WPFMISMountTextBox.Text -ErrorAction Continue | Out-Null
    }
    catch {
        Update-Log -Data "Couldn't inject .Net Binaries" -Class Warning
        return
    } 
    Update-Log -Data ".Net 3.5 injection complete" -Class Information
}

#function to see if the .Net binaries for the select Win10 version exist
function check-dotnetexists {

    If ($WPFSourceWimVerTextBox.text -like "10.0.18362.*") { $buildnum = 1903 }
    If ($WPFSourceWimVerTextBox.text -like "10.0.17763.*") { $buildnum = 1809 }
    If ($WPFSourceWimVerTextBox.text -like "10.0.17134.*") { $buildnum = 1803 }
    If ($WPFSourceWimVerTextBox.text -like "10.0.16299.*") { $buildnum = 1709 }
    If ($WPFSourceWimVerTextBox.text -like "10.0.14393.*") { $buildnum = 1607 }
    
    $windowsver = (get-windowsimage -ImagePath $WPFSourceWIMSelectWIMTextBox.text -index 1)
   
        if ($buildnum -eq 1903){
            $Vardate = (Get-Date -Year 2019 -Month 10 -Day 01)
             #$Vardate is an arbitrary date that is before the 1909 creation date and after the
             #last 1903 release. It's hokey, but it works. - <3 Donna
            if ($windowsver.CreatedTime -gt $Vardate){$buildnum = 1909}
         }

     $DotNetFiles = $PSScriptRoot + '\imports\DotNet\' + $buildnum + '\'

    Test-Path -Path $DotNetFiles\* 
    if ((Test-Path -Path $DotNetFiles\*) -eq $false) {
        $text = ".Net 3.5 Binaries are not present for " + $buildnum
        update-log -Data $text -Class Warning
        update-log -data "Import .Net from an ISO or disable injection to continue" -Class Warning
        return $false
    }
}

#Function to check installed version of WIM Witch and update if available
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
           # Update-Log -Data "Calling script backup function..." -Class Information
            Backup-WIMWitch
 
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
            Write-Output "You'll want to upgrade at some point."
            Update-Log -Data "Upgrade to new version was declined" -Class Warning
            Update-Log -Data "Continuing to start WIM Witch..." -Class Warning
            }
  
    }
    
Update-Log -Data "The currently installed version of WIM Witch is $WWScriptVer" -Class Information
Update-Log -data "Checking for updates from PowerShell Gallery..." -Class Information


try{
    $WWCurrentVer = (Find-Script -Name "WIMWitch" -ErrorAction Stop).version 
    Update-Log -Data "The latest version from the Gallery is $WWCurrentVer" -Class Information
    }
catch{
    Update-Log -Data "Couldn't retreive script info from the PowerShell Gallery" -Class Warning
    Update-Log -data "Try rebooting the internet and trying again" -Class Warning
    Update-Log -data "Continuing on with loading WIM Witch..." -Class Warning
    return
    }


If (($WWCurrentVer -gt $WWScriptVer) -and ($auto -eq $false)){upgrade-wimwitch}
#If (($WWCurrentVer -gt $WWScriptVer) -and ($auto -ne "yes")){upgrade-wimwitch}

#if (($WWCurrentVer -gt $WWScriptVer) -and ($auto -eq "yes")){update-log -data "Skipping WIM Witch upgrade because she is in auto-mode. Please launch WIM Witch in GUI mode to update." -class warning} 
if (($WWCurrentVer -gt $WWScriptVer) -and ($auto -eq $true)){update-log -data "Skipping WIM Witch upgrade because she is in auto-mode. Please launch WIM Witch in GUI mode to update." -class warning} 


If ($WWCurrentVer -eq $WWScriptVer){Update-Log -data "WIM Witch is up to date. Starting WIM Witch" -Class Information}

If ($WWCurrentVer -lt $WWScriptVer){
    Update-Log -Data "The local copy of WIM Witch is more current that the most current" -class Warning
    Update-Log -Data "version available. Did you violate the Temporal Prime Directive?" -class Warning
    Update-Log -data "Starting WIM Witch anyway..." -class warning

    }

}

#Function to backup WIM Witch script file during upgrade
function Backup-WIMWitch{
Update-log -data "Backing up existing WIM Witch script..." -Class Information

$scriptname = split-path $MyInvocation.PSCommandPath -Leaf #Find local script name
Update-Log -data "The script to be backed up is: " -Class Information
Update-Log -data $MyInvocation.PSCommandPath -Class Information

try{
    Update-Log -data "Copy script to backup folder..." -Class Information
    Copy-Item -Path $scriptname -Destination $PSScriptRoot\backup -ErrorAction Stop
    Update-Log -Data "Successfully copied..." -Class Information
    }
catch{
    Update-Log -data "Couldn't copy the WIM Witch script. My guess is a permissions issue" -Class Error
    Update-Log -Data "Exiting out of an over abundance of caution" -Class Error
    exit
}

try {
    Update-Log -data "Renaming archived script..." -Class Information
    replace-name -file $PSScriptRoot\backup\$scriptname -extension ".ps1"
    Update-Log -data "Backup successfully renamed for archiving" -class Information
    }
catch {

    Update-Log -Data "Backed-up script couldn't be renamed. This isn't a critical error" -Class Warning
    Update-Log -Data "You may want to change it's name so it doesn't get overwritten." -Class Warning
    Update-Log -Data "Continuing with WIM Witch upgrade..." -Class Warning
    }
}

#Function to download current OneDrive client
#Most of this was stolen from David Segura @SeguraOSD
function download-onedrive{
    update-log -Data "Donwloading latest OneDrive agent installer..." -class Information
    $DownloadUrl = 'https://go.microsoft.com/fwlink/p/?LinkId=248256'
    $DownloadPath = "$PSScriptRoot\updates\OneDrive"
    $DownloadFile = 'OneDriveSetup.exe'

    if (!(Test-Path "$DownloadPath")) {New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null}
    Invoke-WebRequest -Uri $DownloadUrl -OutFile "$DownloadPath\$DownloadFile"
    if (Test-Path "$DownloadPath\$DownloadFile") {
        Update-Log -Data 'OneDrive Download Complete' -Class Information
        } else {
        Update-log -Data 'OneDrive could not be downloaded' -Class Error
    }
}

#function to copy new OneDrive client installer to mount path
function copy-onedrive{
  
    try{
    update-log -Data "Setting ACL on the original OneDriveSetup.exe file" -Class Information
    $user = $env:USERNAME
    $Acl = Get-Acl "$PSScriptRoot\mount\Windows\SysWOW64\OneDriveSetup.exe"
    $Ar = New-Object System.Security.AccessControl.FileSystemAccessRule($user, "FullControl", "Allow")
    $Acl.SetAccessRule($Ar)
    Set-Acl "$PSScriptRoot\mount\Windows\SysWOW64\OneDriveSetup.exe" $Acl -ErrorAction Stop |out-null
    update-log -Data "ACL successfully updated. Continuing..."
    }
    catch{
    Update-Log -data "Couldn't set the ACL on the original file" -Class Error
    return
    } 
    
    try{
    Update-Log -data "Copying updated OneDrive agent installer..." -Class Information
    copy-item "$PSScriptRoot\updates\OneDrive\OneDriveSetup.exe" -Destination "$PSScriptRoot\Mount\Windows\SysWOW64" -Force -ErrorAction Stop
    Update-Log -Data "OneDrive installer successfully copied." -Class Information
    }
    catch{
    Update-Log -data "Couldn't copy the OneDrive installer file." -class Error
    return
    }

}

#===========================================================================
# Run commands to set values of files and variables, etc.
#===========================================================================

#calls fuction to display the opening text blurb
display-openingtext
check-install
#Set the path and name for logging
$Log = "$PSScriptRoot\logging\WIMWitch.log"

Set-Logging #Clears out old logs from previous builds and checks for other folders

#The OSD Update functions. Disable the following four to increase start time. check-superced takes the longest - FYI
#===========================================================================
Check-WIMWitchVer #Checks installed version of WIM Witch and updates if selected
Get-OSDBInstallation #Sets OSDUpate version info
Get-OSDBCurrentVer #Discovers current version of OSDUpdate
compare-OSDBuilderVer #determines if an update of OSDUpdate can be applied

get-osdsusinstallation #Sets OSDSUS version info
Get-OSDSUSCurrentVer #Discovers current version of OSDSUS
compare-OSDSUSVer #determines if an update of OSDSUS can be applied

#Function download-patches($build,$OS)

if ($DownloadUpdates -eq $true) {

    If (($UpdatePoShModules -eq $true) -and ($WPFUpdatesOSDBOutOfDateTextBlock.Visibility -eq "Visible")) { 
        update-OSDB
        Update-OSDSUS 
    }
    
    #if ($Superseded -eq "audit") { check-superceded -action "audit" }
    #if ($Superseded -eq "delete") { check-superceded -action "delete" }

    
    if ($Server2016 -eq $true){
        check-superceded -action delete -OS "Windows Server 2016" -Build 1607
        download-patches -OS "Windows Server 2016" -build 1607}
    if ($Server2019 -eq $true){
        check-superceded -action delete -OS "Windows Server 2019" -Build 1809
        download-patches -OS "Windows Server 2019" -build 1809}

    if ($Win10Version -ne "none"){
        if (($Win10Version -eq "1709") -or ($Win10Version -eq "all")){
            check-superceded -action delete -OS "Windows 10" -Build 1709
            download-patches -OS "Windows 10" -build 1709}
        if (($Win10Version -eq "1803") -or ($Win10Version -eq "all")){
            check-superceded -action delete -OS "Windows 10" -Build 1803
            download-patches -OS "Windows 10" -build 1803}
        if (($Win10Version -eq "1809") -or ($Win10Version -eq "all")){
            check-superceded -action delete -OS "Windows 10" -Build 1809
            download-patches -OS "Windows 10" -build 1809}
        if (($Win10Version -eq "1903") -or ($Win10Version -eq "all")){
            check-superceded -action delete -OS "Windows 10" -Build 1903
            download-patches -OS "Windows 10" -build 1903}
        if (($Win10Version -eq "1909") -or ($Win10Version -eq "all")){
            check-superceded -action delete -OS "Windows 10" -Build 1909
            download-patches -OS "Windows 10" -build 1909}
        download-onedrive
     }

   # if ($DownUpdates -ne $null) {
   #     if (($DownUpdates -eq "1903") -or ($DownUpdates -eq "all")) { download-patches -build 1903 }
   #     if (($DownUpdates -eq "1809") -or ($DownUpdates -eq "all")) { download-patches -build 1809 }
   #     if (($DownUpdates -eq "1803") -or ($DownUpdates -eq "all")) { download-patches -build 1803 }
   #     if (($DownUpdates -eq "1709") -or ($DownUpdates -eq "all")) { download-patches -build 1709 }
   #     if (($DownUpdates -eq "1909") -or ($DownUpdates -eq "all")) { download-patches -build 1909 }
    }

    #check-superceded #checks to see if superceded patches exist
    

#===========================================================================




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

#$WPFAppTab.IsEnabled = $False

#===========================================================================
# Section for Buttons to call functions
#===========================================================================

#Mount Dir Button                                                    
$WPFMISMountSelectButton.Add_Click( { SelectMountdir }) 

#Source WIM File Button
$WPFSourceWIMSelectButton.Add_Click( { SelectSourceWIM }) 

#JSON File selection Button
$WPFJSONButton.Add_Click( { SelectJSONFile }) 

#Target Folder selection Button
$WPFMISFolderButton.Add_Click( { SelectTargetDir }) 

#Driver Directory Buttons
$WPFDriverDir1Button.Add_Click( { SelectDriverSource -DriverTextBoxNumber $WPFDriverDir1TextBox }) 
$WPFDriverDir2Button.Add_Click( { SelectDriverSource -DriverTextBoxNumber $WPFDriverDir2TextBox }) 
$WPFDriverDir3Button.Add_Click( { SelectDriverSource -DriverTextBoxNumber $WPFDriverDir3TextBox }) 
$WPFDriverDir4Button.Add_Click( { SelectDriverSource -DriverTextBoxNumber $WPFDriverDir4TextBox }) 
$WPFDriverDir5Button.Add_Click( { SelectDriverSource -DriverTextBoxNumber $WPFDriverDir5TextBox }) 

#Make it So Button, which builds the WIM file
#$WPFMISMakeItSoButton.Add_Click({MakeItSo}) 
$WPFMISMakeItSoButton.Add_Click( { MakeItSo -appx $global:SelectedAppx }) 

#Update OSDBuilder Button
$WPFUpdateOSDBUpdateButton.Add_Click( {
        update-OSDB
        Update-OSDSUS 
    }) 

#Update patch source
$WPFUpdatesDownloadNewButton.Add_Click( { update-patchsource })

#Logging window
#$WPFLoggingTextBox.text = Get-Content -Path $Log -Delimiter "\n"

#Select Appx packages to remove
$WPFAppxButton.Add_Click( { $global:SelectedAppx = Select-Appx })

#Select Autopilot path to save button
$WPFJSONButtonSavePath.Add_Click( { SelectNewJSONDir })

#retrieve autopilot profile from intune
$WPFJSONButtonRetrieve.Add_click( { get-wwautopilotprofile -login $WPFJSONTextBoxAADID.Text -path $WPFJSONTextBoxSavePath.Text })

#Button to save configuration file
$WPFSLSaveButton.Add_click( { save-config -filename $WPFSLSaveFileName.text })

#Button to load configuration file
$WPFSLLoadButton.Add_click( { select-config })

#Button to select ISO for importation
$WPFImportImportSelectButton.Add_click( { select-iso })

#Button to import content from iso
$WPFImportImportButton.Add_click( {
   
        if (($WPFImportDotNetCheckBox.IsChecked -eq $true) -and ($WPFImportWIMCheckBox.IsChecked -eq $true)) { import-iso -type all -file $WPFImportISOTextBox.text -newname $WPFImportNewNameTextBox.text }
        if (($WPFImportDotNetCheckBox.IsChecked -eq $true) -and ($WPFImportWIMCheckBox.IsChecked -eq $false)) { import-iso -type DotNet -file $WPFImportISOTextBox.text }
        if (($WPFImportDotNetCheckBox.IsChecked -eq $false) -and ($WPFImportWIMCheckBox.IsChecked -eq $true)) { import-iso -type wim -file $WPFImportISOTextBox.text -newname $WPFImportNewNameTextBox.text }

    })


#===========================================================================
# Section for Checkboxes to call functions
#===========================================================================

#Enable JSON Selection
$WPFJSONEnableCheckBox.Add_Click( {
        If ($WPFJSONEnableCheckBox.IsChecked -eq $true) {
            $WPFJSONButton.IsEnabled = $True
            $WPFMISJSONTextBox.Text = "True"
        }
        else {
            $WPFJSONButton.IsEnabled = $False
            $WPFMISJSONTextBox.Text = "False"
        }
    })
 
#Enable Driver Selection  
$WPFDriverCheckBox.Add_Click( {
        If ($WPFDriverCheckBox.IsChecked -eq $true) {
            $WPFDriverDir1Button.IsEnabled = $True
            $WPFDriverDir2Button.IsEnabled = $True
            $WPFDriverDir3Button.IsEnabled = $True
            $WPFDriverDir4Button.IsEnabled = $True
            $WPFDriverDir5Button.IsEnabled = $True
            $WPFMISDriverTextBox.Text = "True"
        }
        else {
            $WPFDriverDir1Button.IsEnabled = $False
            $WPFDriverDir2Button.IsEnabled = $False
            $WPFDriverDir3Button.IsEnabled = $False
            $WPFDriverDir4Button.IsEnabled = $False
            $WPFDriverDir5Button.IsEnabled = $False
            $WPFMISDriverTextBox.Text = "False"
        }
    })

#Enable Updates Selection
$WPFUpdatesEnableCheckBox.Add_Click( {
        If ($WPFUpdatesEnableCheckBox.IsChecked -eq $true) {
            # $WPFUpdateOSDBUpdateButton.IsEnabled = $True
            # $WPFUpdatesDownloadNewButton.IsEnabled = $True
            # $WPFUpdates1903CheckBox.IsEnabled = $True
            # $WPFUpdates1809CheckBox.IsEnabled = $True
            # $WPFUpdates1803CheckBox.IsEnabled = $True
            # $WPFUpdates1709CheckBox.IsEnabled = $True
            # $WPFUpdateOSDBUpdateButton.IsEnabled = $True
            $WPFMISUpdatesTextBox.Text = "True"
        }
        else {
            # $WPFUpdatesOSDBVersion.IsEnabled = $False
            #  $WPFUpdateOSDBUpdateButton.IsEnabled = $False
            #  $WPFUpdatesDownloadNewButton.IsEnabled = $False
            #  $WPFUpdates1903CheckBox.IsEnabled = $False
            #  $WPFUpdates1809CheckBox.IsEnabled = $False
            #  $WPFUpdates1803CheckBox.IsEnabled = $False
            #  $WPFUpdates1709CheckBox.IsEnabled = $False
            #  $WPFUpdateOSDBUpdateButton.IsEnabled = $False
            $WPFMISUpdatesTextBox.Text = "False"
        }
    })

#Enable AppX Selection
$WPFAppxCheckBox.Add_Click( {
        If ($WPFAppxCheckBox.IsChecked -eq $true) {
            $WPFAppxButton.IsEnabled = $True
            $WPFMISAppxTextBox.Text = "True"
        }
        else {
            $WPFAppxButton.IsEnabled = $False
        }
    })

#Enable install.wim selection in import
$WPFImportWIMCheckBox.Add_Click( {
        If ($WPFImportWIMCheckBox.IsChecked -eq $true) {
            $WPFImportNewNameTextBox.IsEnabled = $True
            $WPFImportImportButton.IsEnabled = $True
        }
        else {
            $WPFImportNewNameTextBox.IsEnabled = $False
            #$WPFImportImportButton.IsEnabled = $False
            if ($WPFImportDotNetCheckBox.IsChecked -eq $False) { $WPFImportImportButton.IsEnabled = $False }
        }
    })

#Enable .Net binaries selection in import
$WPFImportDotNetCheckBox.Add_Click( {
        If ($WPFImportDotNetCheckBox.IsChecked -eq $true) {
            $WPFImportImportButton.IsEnabled = $True
        }
        else {
            #$WPFImportImportButton.IsEnabled = $False
            if ($WPFImportWIMCheckBox.IsChecked -eq $False) { $WPFImportImportButton.IsEnabled = $False }
        }
    })

#Enable Win10 version selection
$WPFUpdatesW10Main.Add_Click( {
        If ($WPFUpdatesW10Main.IsChecked -eq $true) {
            $WPFUpdatesW10_1909.IsEnabled = $True
            $WPFUpdatesW10_1903.IsEnabled = $True
            $WPFUpdatesW10_1809.IsEnabled = $True
            $WPFUpdatesW10_1803.IsEnabled = $True
            $WPFUpdatesW10_1709.IsEnabled = $True
        }
        else {
            $WPFUpdatesW10_1909.IsEnabled = $False
            $WPFUpdatesW10_1903.IsEnabled = $False
            $WPFUpdatesW10_1809.IsEnabled = $False
            $WPFUpdatesW10_1803.IsEnabled = $False
            $WPFUpdatesW10_1709.IsEnabled = $False
           
        }
    })
 
#==========================================================
#Run WIM Witch below
#==========================================================

#Runs WIM Witch from a single file, bypassing the GUI
if (($auto -eq $true) -and ($autofile -ne $null)) {
    run-configfile -filename $autofile
    display-closingtext
    exit 0
}

if (($auto -eq $true) -and ($autopath -ne $null)) {
    Update-Log -data "Running batch job from config folder $autopath" -Class Information
    $files = Get-ChildItem -Path $autopath
    Update-Log -data "Setting batch job for the folling configs:" -Class Information
    foreach ($file in $files) { Update-Log -Data $file -Class Information }
    foreach ($file in $files) {
        $fullpath = $autopath + '\' + $file
        run-configfile -filename $fullpath
    }
    Update-Log -Data "Work complete" -Class Information
    display-closingtext
    exit 0
}

#Closing action for the WPF form
Register-ObjectEvent -InputObject $form -EventName Closed -Action ( { display-closingtext }) | Out-Null

#Start GUI 
update-log -data "Starting WIM Witch GUI" -class Information
$Form.ShowDialog() | out-null #This starts the GUI

