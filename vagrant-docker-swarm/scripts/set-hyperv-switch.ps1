# See: https://www.thomasmaurer.ch/2016/01/change-hyper-v-vm-switch-of-virtual-machines-using-powershell/
$node=$args[0]
write-host "setting NATSwitch to to $node"

Get-VM "$node" | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "NATSwitch"
