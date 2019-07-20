#Your XAML goes here :)
$inputXML = @"
<Window x:Name="Window" x:Class="WimWitch.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WimWitch"
        mc:Ignorable="d"
        Title="WIM Witch" Height="450" Width="800">
	<Grid>
		<Grid.ColumnDefinitions>
			<ColumnDefinition Width="733*"/>
		</Grid.ColumnDefinitions>
		<TextBox x:Name="MountBox" HorizontalAlignment="Left" Height="25" Margin="124,91,0,0" TextWrapping="Wrap" Text="Select Mount Path" VerticalAlignment="Top" Width="500" IsEnabled="False"/>
		<Label x:Name="MountLabel" Content="Mount Path" HorizontalAlignment="Left" Margin="26,91,0,0" VerticalAlignment="Top" Grid.ColumnSpan="3" Height="25" Width="100"/>
		<Button x:Name="MountButton" Content="Select" HorizontalAlignment="Left" Margin="638,90,0,0" VerticalAlignment="Top" Width="75" Height="25"/>
		<TextBox x:Name="SourceWimTextBox" HorizontalAlignment="Left" Height="25" Margin="124,142,0,0" TextWrapping="Wrap" Text="Select Source WIM" VerticalAlignment="Top" Width="500" RenderTransformOrigin="1.294,0.414"/>
		<Label x:Name="SourceWIMLabel" Content="Source WIM" HorizontalAlignment="Left" Height="25" Margin="26,142,0,0" VerticalAlignment="Top" Width="100"/>
		<Button x:Name="SourceWIMButton" Content="Select" HorizontalAlignment="Left" Height="25" Margin="638,142,0,0" VerticalAlignment="Top" Width="75"/>
		<TextBox x:Name="JSONTextBox" HorizontalAlignment="Left" Height="25" Margin="124,187,0,0" TextWrapping="Wrap" Text="Select JSON File" VerticalAlignment="Top" Width="500"/>
		<Label x:Name="JSONLabel" Content="Source JSON" HorizontalAlignment="Left" Height="25" Margin="26,188,0,0" VerticalAlignment="Top" Width="100"/>
		<Button x:Name="JSONButton" Content="Select" HorizontalAlignment="Left" Height="25" Margin="638,188,0,0" VerticalAlignment="Top" Width="75"/>
		<TextBox x:Name="DriverDirTextBox" HorizontalAlignment="Left" Height="25" Margin="124,239,0,0" TextWrapping="Wrap" Text="Select Driver Source" VerticalAlignment="Top" Width="500"/>
		<Label x:Name="DirverDirLabel" Content="Driver Source" HorizontalAlignment="Left" Height="25" Margin="26,240,0,0" VerticalAlignment="Top" Width="100"/>
		<Button x:Name="DriverDirButton" Content="Select" HorizontalAlignment="Left" Height="25" Margin="638,239,0,0" VerticalAlignment="Top" Width="75" RenderTransformOrigin="0.428,2.053"/>
		<Button x:Name="MakeItSoButton" Content="Make it so!" HorizontalAlignment="Left" Height="31" Margin="138,327,0,0" VerticalAlignment="Top" Width="98" RenderTransformOrigin="0.577,0.557"/>
		<Button x:Name="CloseButton" Content="Close" HorizontalAlignment="Left" Height="31" Margin="274,327,0,0" VerticalAlignment="Top" Width="102"/>

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

$WPFSourceWIMButton.Add_Click({SelectSourceWIM}) #Source WIM File Button

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
#write-host "To show the form, run the following" -ForegroundColor Cyan
#'$Form.ShowDialog() | out-null'
 
 $Form.ShowDialog() | out-null
 



 #===========================================================================
 # Scratch pad below
 #===========================================================================

 # Get-WindowsImage -ImagePath install.wim -Index 1
#  This will list the relevant info 