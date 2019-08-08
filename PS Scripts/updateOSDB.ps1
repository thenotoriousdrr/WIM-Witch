#Put in check to see if OSBuilder exists. If it does, yank it
write-host "Finding new version"
$OSDBNew = find-module -name OSDBuilder #Get new version

write-host "finding existing version"
$OSDBCurrent = get-module -Name OSDBuilder #Get installed version


if ($OSDBNew.version -gt $OSDBCurrent.Version)
{
write-host "We need an updatin'"
OSDBuilder -Update
}
else
{write-host "nothing to do"}


