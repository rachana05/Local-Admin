Import-Module ActiveDirectory
 
Get-ADComputer -SearchBase 'OU=<ouname>,dc=<org>,dc=com' -Filter '*'  | Select -Exp name | Add-Content </output_path>.txt


$computername = Get-Content </output_path>.txt
$collection = @()
foreach ($computer in $computername)
{
$results = @{"ComputerName" = $computer}
$local_admin = Gwmi win32_groupuser –computer $computer   
$local_admin = $local_admin |? {$_.groupcomponent –like '*"Administrators"'}  
  
$admins |% {  
$_.partcomponent –match “.+Name\=(.+)$” > $nul  
$results["admin"]= $matches[1].trim('"')  
New-Object -TypeName PSObject -Property $results -OutVariable res
$collection+= $res
}  
}$collection | Out-File <output_path_1>.csv