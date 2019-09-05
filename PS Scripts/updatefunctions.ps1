

Function Download-Updates($build){
Get-OSDUpdate | Where-Object {$_.UpdateOS -eq 'Windows 10' -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'SSU'} |Get-DownOSDUpdate -DownloadPath C:\WIMWitch\updates\$build\SSU
Get-OSDUpdate | Where-Object {$_.UpdateOS -eq 'Windows 10' -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'AdobeSU'} |Get-DownOSDUpdate -DownloadPath C:\WIMWitch\updates\$build\AdobeSU
Get-OSDUpdate | Where-Object {$_.UpdateOS -eq 'Windows 10' -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'LCU'} |Get-DownOSDUpdate -DownloadPath C:\WIMWitch\updates\$build\LCU
Get-OSDUpdate | Where-Object {$_.UpdateOS -eq 'Windows 10' -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'DotNet'} |Get-DownOSDUpdate -DownloadPath C:\WIMWitch\updates\$build\DotNet
Get-OSDUpdate | Where-Object {$_.UpdateOS -eq 'Windows 10' -and $_.UpdateArch -eq 'x64' -and $_.UpdateBuild -eq $build -and $_.UpdateGroup -eq 'DotNetCU'} |Get-DownOSDUpdate -DownloadPath C:\WIMWitch\updates\$build\DotNetCU
}


Function Apply-Updates($build,$class,$mountdir){

$path = 'C:\wimwitch\updates\' + $build +'\' + $class + '\'
$Children = Get-ChildItem -Path $path
foreach ($Children in $Children){
$compound = $path+$Children
Add-WindowsPackage -path $mountdir -PackagePath $compound 
}

}

Function Check-Superseded($action){

$path = "C:\WIMWitch\updates\"  #sets base path
$Children = Get-ChildItem -Path $path  #query sub directories

foreach ($Children in $Children){
    $path1 = $path + $Children  
    $kids = Get-ChildItem -Path $path1
  
 
    foreach ($kids in $kids){
        $path2 = $path1 + '\' + $kids
        $sprout = get-childitem -path $path2
        
        foreach ($sprout in $sprout) {
            $path3 = $path2 + '\' + $sprout
            $fileinfo = get-childitem -path $path3
            
            $StillCurrent = Get-OSDUpdate | Where-Object {$_.FileName -eq $fileinfo}
            If ($StillCurrent -eq $null){
                write-host $fileinfo "no longer current"
                if ($action -eq 'delete'){
                    Write-Host "Deleting" $path3
                    remove-item -path $path3 -Recurse -Force}
                if ($action -eq 'audit'){
                    write-host "set variable"
                    Return}
                 }   
            else{
                write-host $fileinfo "is stil current"
                }    
             }
        }
    }
}
