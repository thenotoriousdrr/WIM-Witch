#===========================================================================
# WIM Witch 
#===========================================================================
#
# Written and maintained by: Donna Ryan
# Twitter: @TheNotoriousDRR
# www.TheNotoriousDRR.com
# www.SCConfigMgr.com
#
# Current WIM Witch Doc (v1.3.0):
# https://www.scconfigmgr.com/2019/12/08/wim-witch-v1-3-0-server-support-onedrive-and-command-line/ 
#
# Previous WIM Witch Doc (v1.0):
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

#============================================================================================================
Param( 
   [parameter(mandatory = $false, HelpMessage = "enable auto")] 
   [switch]$auto,

    [parameter(mandatory = $false, HelpMessage = "config file")] 
    [string]$autofile,

    [parameter(mandatory = $false, HelpMessage = "config path")] 
    [string]$autopath,

    [parameter(mandatory = $false, HelpMessage = "Update Modules")] 
    [Switch]$UpdatePoShModules,

    [parameter(mandatory = $false, HelpMessage = "Enable Downloading Updates")] 
    [switch]$DownloadUpdates,
  
    [parameter(mandatory = $false, HelpMessage = "Win10 Version")] 
    [ValidateSet("all", "1709", "1803", "1809", "1903", "1909")] 
    [string]$Win10Version = "none",

    [parameter(mandatory = $false, HelpMessage = "Windows Server 2016?")] 
    [switch]$Server2016,

    [parameter(mandatory = $false, HelpMessage = "Windows Server 2019?")] 
    [switch]$Server2019

 )

$WWScriptVer = "2.0.0"

$inputXML = @"
<Window x:Class="WIM_Witch_Tabbed.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WIM_Witch_Tabbed"
        mc:Ignorable="d"
        Title="WIM Witch - v2.0.0 - Beta" Height="500" Width="925" Background="#FF610536">
    <Grid>
        <TabControl x:Name="TabControl" Margin="0,0,0.2,-0.2" Background="#FFACACAC" BorderBrush="#FF610536" >
            <TabItem Header="Import" Height="20" Width="100">
                <Grid>
                    <TextBox x:Name="ImportISOTextBox" HorizontalAlignment="Left" Height="42" Margin="26,85,0,0" Text="ISO to import from..." VerticalAlignment="Top" Width="500" IsEnabled="False" HorizontalScrollBarVisibility="Visible"/>
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
                    <TextBlock HorizontalAlignment="Left" Margin="20,142,0,0" TextWrapping="Wrap" Text="Update OSDeploy modules by using the button below. Updating will require PowerShell to be restarted." VerticalAlignment="Top" Height="34" Width="321"/>
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
                    <TextBox x:Name="JSONTextBoxSavePath" HorizontalAlignment="Left" Height="23" Margin="26,345,0,0" TextWrapping="Wrap" Text="$PSScriptRoot\Autopilot" VerticalAlignment="Top" Width="499" IsEnabled="False"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,275,0,0" TextWrapping="Wrap" Text="To download a new Autopilot profile from Intune, click select to choose the folder to save the file to. Then click Retrieve Profile." VerticalAlignment="Top" Height="48" Width="331"/>
                    <TextBlock HorizontalAlignment="Left" Margin="27,328,0,0" TextWrapping="Wrap" Text="Path to save file:" VerticalAlignment="Top"/>
                    <Button x:Name="JSONButtonSavePath" Content="Select" HorizontalAlignment="Left" Margin="450,373,0,0" VerticalAlignment="Top" Width="75"/>
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
            <TabItem x:Name="LoggingTab" Header="Logging" Height="20" Width="100" IsSelected="True">
                <Grid>
                    <Grid>
                        <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Timber!" VerticalAlignment="Top" Height="42" Width="353" Grid.ColumnSpan="2"/>
                        <ListBox x:Name="ListBox" HorizontalAlignment="Left" Height="372" Margin="26,45,0,0" VerticalAlignment="Top" Width="860"/>
                    </Grid>
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

    function install-WWFunctions {}

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

#Load the function script
if ((Test-Path "$PSScriptRoot\Scripts\WW_Functions.ps1" -PathType Leaf) -eq $true){. "$PSScriptRoot\scripts\WW_Functions.ps1"  }


#===========================================================================
# Run commands to set values of files and variables, etc.
#===========================================================================

#calls fuction to display the opening text blurb
display-openingtext
check-install 
#Set the path and name for logging
$Log = "$PSScriptRoot\logging\WIMWitch.log"

Set-Logging #Clears out old logs from previous builds and checks for other folders

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
$WPFMISMakeItSoButton.Add_Click( { 
    $WPFTabControl.Items[8].IsSelected = $true
    MakeItSo -appx $global:SelectedAppx }) 

#Update OSDBuilder Button
$WPFUpdateOSDBUpdateButton.Add_Click( {
        update-OSDB
        Update-OSDSUS 
    }) 

#Update patch source
$WPFUpdatesDownloadNewButton.Add_Click( { update-patchsource })

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
if (($auto -eq $true) -and ($autofile -ne "")) { 
    run-configfile -filename $autofile
    display-closingtext
    exit 0
}

if (($auto -eq $true) -and ($autopath -ne "")) {
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

