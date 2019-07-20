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
        <TabControl>
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
                    <Button x:Name="SourceWIMMountButton" Content="Mount" HorizontalAlignment="Left" Margin="129,336,0,0" VerticalAlignment="Top" Width="75"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Select the path to the driver source that contains the drivers that will be injected by DISM." VerticalAlignment="Top" Height="42" Width="353" Grid.ColumnSpan="2"/>
                    <Button x:Name="SourceWIMSelectButton" Content="Select" HorizontalAlignment="Left" Height="25" Margin="92.281,142,0,0" VerticalAlignment="Top" Width="75" Grid.Column="1"/>
                    <TextBox x:Name="SourceWimMountTextBox" HorizontalAlignment="Left" Height="25" Margin="21,369,0,0" TextWrapping="Wrap" Text="Select Mount Path" VerticalAlignment="Top" Width="500" IsEnabled="False" Grid.ColumnSpan="2"/>
                    <Label x:Name="MountLabel" Content="Mount Path" HorizontalAlignment="Left" Margin="21,331,0,0" VerticalAlignment="Top" Height="25" Width="100"/>
                    <Button x:Name="SourceWimMountSelectButton" Content="Select" HorizontalAlignment="Left" Margin="87.281,407,0,0" VerticalAlignment="Top" Width="75" Height="25" Grid.Column="1"/>
                    <Button x:Name="SourceWIMDismountButton" Content="Dismount!" HorizontalAlignment="Left" Margin="230,336,0,0" VerticalAlignment="Top" Width="75"/>
                    <TextBox x:Name="SourceWIMImgDesTextBox" HorizontalAlignment="Left" Height="23" Margin="94,155,0,0" TextWrapping="Wrap" Text="ImageDescription" VerticalAlignment="Top" Width="225"/>
                    <TextBox x:Name="SourceWimArchTextBox" HorizontalAlignment="Left" Height="23" Margin="94,183,0,0" TextWrapping="Wrap" Text="Architecture" VerticalAlignment="Top" Width="225"/>
                    <TextBox x:Name="SourceWimVerTextBox" HorizontalAlignment="Left" Height="23" Margin="94,211,0,0" TextWrapping="Wrap" Text="Version" VerticalAlignment="Top" Width="225"/>
                    <TextBox x:Name="SourceWimSPBuildTextBox" HorizontalAlignment="Left" Height="23" Margin="94,239,0,0" TextWrapping="Wrap" Text="SPBuild" VerticalAlignment="Top" Width="225"/>
                    <TextBox x:Name="SourceWimLangTextBox" HorizontalAlignment="Left" Height="23" Margin="94,267,0,0" TextWrapping="Wrap" Text="Languages" VerticalAlignment="Top" Width="225"/>
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
                    <Button x:Name="JSONButton" Content="Select" HorizontalAlignment="Left" Height="25" Margin="451,193,0,0" VerticalAlignment="Top" Width="75"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Select a JSON file for use in deploying Autopilot systems. The file will be copied to processing folder during the build" VerticalAlignment="Top" Height="42" Width="353"/>
                    <CheckBox x:Name="JSONEnableCheckBox" Content="Enable Autopilot " HorizontalAlignment="Left" Margin="26,80,0,0" VerticalAlignment="Top"/>

                </Grid>
            </TabItem>
            <TabItem Header="Drivers" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="75">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="733*"/>
                    </Grid.ColumnDefinitions>
                    <TextBox x:Name="DriverDir1TextBox" HorizontalAlignment="Left" Height="25" Margin="26,144,0,0" TextWrapping="Wrap" Text="Select Driver Source Folder" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Label x:Name="DirverDirLabel" Content="Driver Source" HorizontalAlignment="Left" Height="25" Margin="26,114,0,0" VerticalAlignment="Top" Width="100"/>
                    <Button x:Name="DriverDirButton" Content="Select" HorizontalAlignment="Left" Height="25" Margin="562,144,0,0" VerticalAlignment="Top" Width="75"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Select the path to the driver source that contains the drivers that will be injected by DISM." VerticalAlignment="Top" Height="42" Width="353"/>
                    <CheckBox x:Name="DriverCheckBox" Content="Enable Driver Injection" HorizontalAlignment="Left" Margin="26,80,0,0" VerticalAlignment="Top"/>
                    <TextBox x:Name="DriverDir2TextBox" HorizontalAlignment="Left" Height="25" Margin="26,189,0,0" TextWrapping="Wrap" Text="Select Driver Source Folder" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Button x:Name="DriverDir2Button" Content="Select" HorizontalAlignment="Left" Height="25" Margin="562,189,0,0" VerticalAlignment="Top" Width="75"/>
                    <TextBox x:Name="DriverDir3TextBox" HorizontalAlignment="Left" Height="25" Margin="26,234,0,0" TextWrapping="Wrap" Text="Select Driver Source Folder" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Button x:Name="DriverDir3Button" Content="Select" HorizontalAlignment="Left" Height="25" Margin="562,234,0,0" VerticalAlignment="Top" Width="75"/>
                    <TextBox x:Name="DriverDir4TextBox" HorizontalAlignment="Left" Height="25" Margin="26,281,0,0" TextWrapping="Wrap" Text="Select Driver Source Folder" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Button x:Name="DriverDir4Button" Content="Select" HorizontalAlignment="Left" Height="25" Margin="562,281,0,0" VerticalAlignment="Top" Width="75"/>
                    <TextBox x:Name="DriverDir5TextBox" HorizontalAlignment="Left" Height="25" Margin="26,328,0,0" TextWrapping="Wrap" Text="Select Driver Source Folder" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
                    <Button x:Name="DriverDir5Button" Content="Select" HorizontalAlignment="Left" Height="25" Margin="562,328,0,0" VerticalAlignment="Top" Width="75"/>

                </Grid>
            </TabItem>
            <TabItem Header="Make It So" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="75">
                <Grid>
                    <Grid.ColumnDefinitions>

                        <ColumnDefinition Width="20*"/>
                        <ColumnDefinition Width="769*"/>

                    </Grid.ColumnDefinitions>
                    <Button x:Name="MISFolderButton" Content="Button" HorizontalAlignment="Left" Margin="430.508,155,0,0" VerticalAlignment="Top" Width="75" RenderTransformOrigin="0.39,-2.647" Grid.Column="1"/>
                    <TextBox x:Name="MISWimNameTextBox" HorizontalAlignment="Left" Height="25" Margin="5.508,85,0,0" TextWrapping="Wrap" Text="New WIM Name" VerticalAlignment="Top" Width="500" IsEnabled="False" Grid.Column="1"/>
                    <TextBox x:Name="MISDriverTextBox" HorizontalAlignment="Left" Height="23" Margin="104.508,183,0,0" TextWrapping="Wrap" Text="Driver Y/N" VerticalAlignment="Top" Width="120" Grid.Column="1"/>
                    <Label Content="Drivers Selected?" HorizontalAlignment="Left" Height="30" Margin="1.508,183,0,0" VerticalAlignment="Top" Width="101" Grid.Column="1"/>
                    <TextBox x:Name="MISJSONTextBox" HorizontalAlignment="Left" Height="23" Margin="104.508,214,0,0" TextWrapping="Wrap" Text="JSON Select Y/N" VerticalAlignment="Top" Width="120" Grid.Column="1"/>
                    <Label Content="JSON Selected?" HorizontalAlignment="Left" Margin="1.508,211,0,0" VerticalAlignment="Top" Width="102" Grid.Column="1"/>
                    <TextBox x:Name="MISWimFolderTextBox" HorizontalAlignment="Left" Height="23" Margin="5.508,119,0,0" TextWrapping="Wrap" Text="New WIM Folder" VerticalAlignment="Top" Width="500" IsEnabled="False" Grid.Column="1"/>
                    <TextBlock HorizontalAlignment="Left" Margin="5.508,20,0,0" TextWrapping="Wrap" Text="Enter a name, and select a destination forlder, for the  image to be created. Once complete, and build parameters verified, Make it so!" VerticalAlignment="Top" Height="42" Width="353" Grid.Column="1"/>
                    <Button x:Name="MISMakeItSoButton" Content="Make it so!" HorizontalAlignment="Left" Margin="5.508,336,0,0" VerticalAlignment="Top" Width="353" Height="64" FontSize="24" Grid.Column="1"/>
                    <Label Content="Image Mounted?" HorizontalAlignment="Left" Margin="1.508,242,0,0" VerticalAlignment="Top" Width="102" Grid.Column="1"/>
                    <TextBox x:Name="MISMountedTextBox" HorizontalAlignment="Left" Height="23" Margin="104.508,245,0,0" TextWrapping="Wrap" Text="Mounted Y/N" VerticalAlignment="Top" Width="120" Grid.Column="1"/>
                </Grid>
            </TabItem>
            <TabItem x:Name="Logging" Header="Logging" HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="75">
                <Grid>
                    <Grid.ColumnDefinitions>

                    </Grid.ColumnDefinitions>
                    <ListBox x:Name="LoggingListBox" HorizontalAlignment="Left" Height="365" Margin="25,61,0,-6.2" VerticalAlignment="Top" Width="743" Grid.ColumnSpan="2"/>
                    <TextBlock HorizontalAlignment="Left" Margin="26,20,0,0" TextWrapping="Wrap" Text="Log rolls downstairs, alone or in pairs, rolls over your neighbor's dog. It fits on your back. It's great for a snack It's Log, Log, Log!" VerticalAlignment="Top" Height="42" Width="353" Grid.ColumnSpan="2"/>

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
# Functions for Buttons
#===========================================================================

#Funtion to select mounting directory
Function SelectMountDir {

Add-Type -AssemblyName System.Windows.Forms
$browser = New-Object System.Windows.Forms.FolderBrowserDialog
$browser.Description = "Select the mount folder"
$null = $browser.ShowDialog()
$MountDir = $browser.SelectedPath
$WPFMountBox.text = $MountDir

}

#Function to select Source WIM
Function SelectSourceWIM {

$SourceWIM = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'WIM (*.wim)|'
}
$null = $SourceWIM.ShowDialog()
$WPFSourceWimTextBox.text = $SourceWIM.FileName
}
 
#Function to Select JSON File

Function SelectJSONFile {

$JSON = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'JSON (*.JSON)|'
}
$null = $JSON.ShowDialog()
$WPFJSONTextBox.Text = $JSON.FileName
}

Function SelectDriverSource {

Add-Type -AssemblyName System.Windows.Forms
$browser = New-Object System.Windows.Forms.FolderBrowserDialog
$browser.Description = "Select the Driver Source folder"
$null = $browser.ShowDialog()
$DriverDir = $browser.SelectedPath
$WPFDriverDirTextBox.Text = $DriverDir
}

Function MakeItSo {

Copy-Item $SourceWIM.FileName -Destination "D:\WIMWorking"
Rename-Item -Path D:\WIMWorking\install.wim -NewName in_process.wim
Mount-WindowsImage -Path $MountDir -ImagePath D:\WIMWorking\in_process.wim -Index 1
Copy-Item $JSON.FileName -Destination "D:\mount\windows\Provisioning\Autopilot"
Dism /Image:$MountDir /Add-Driver /Driver:$DriverDir /Recurse
Dismount-WindowsImage -Path $MountDir -save
Rename-Item -Path D:\WIMWorking\in_process.wim -NewName complete.wim
}

#===========================================================================
# Use this space to add code to the various form elements in your GUI
#===========================================================================

#===========================================================================
# Section for Buttons to call functions
#===========================================================================


$WPFCloseButton.Add_Click({$form.Close()}) #Close Button                                                                  

$WPFMountButton.Add_Click({SelectMountdir}) #Mount Dir Button

$WPFSourceWIMSelectButton.Add_Click({SelectSourceWIM}) #Source WIM File Button

$WPFJSONButton.Add_Click({SelectJSONFile}) #JSON File selection Button

$WPFDriverDirButton.Add_Click({SelectDriverSource}) #Driver Source Folder Button

$WPFMakeItSoButton.Add_Click({MakeItSo}) #Make it So Button, which builds the WIM file
     
#Reference 
 
#Adding items to a dropdown/combo box
    #$vmpicklistView.items.Add([pscustomobject]@{'VMName'=($_).Name;Status=$_.Status;Other="Yes"})
     
#Setting the text of a text box to the current PC name    
    #$WPFtextBox.Text = $env:COMPUTERNAME
     
#Adding code to a button, so that when clicked, it pings a system
# $WPFbutton.Add_Click({ Test-connection -count 1 -ComputerName $WPFtextBox.Text
# })
#===========================================================================
# Shows the form
#===========================================================================
write-host "To show the form, run the following" -ForegroundColor Cyan
'$Form.ShowDialog() | out-null'
 
# $Form.ShowDialog() | out-null
 



 #===========================================================================
 # Scratch pad below
 #===========================================================================

 # Get-WindowsImage -ImagePath install.wim -Index 1
#  This will list the relevant info 