Import-Module ActiveDirectory
 
Get-ADComputer -SearchBase 'OU=<ouname>,dc=<org>,dc=com' -Filter '*'  | Select -Exp name | Add-Content </output_path>.txt


$computername = Get-Content </output_path>.txt
$collection = @()
foreach ($computer in $computername)
{
$results = @{"ComputerName" = $computer}
$admins = Gwmi win32_groupuser –computer $computer   
$admins = $admins |? {$_.groupcomponent –like '*"Administrators"'}  
  
$admins |% {  
$_.partcomponent –match “.+Name\=(.+)$” > $nul  
$results["admin"]= $matches[1].trim('"')  
New-Object -TypeName PSObject -Property $results -OutVariable res
$collection+= $res
} 
}$collection | Export-csv -Path <output_path_1>.csv -Delimiter ',' -NoTypeInformation
