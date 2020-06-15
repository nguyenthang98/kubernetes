# See: https://www.thomasmaurer.ch/2016/01/change-hyper-v-vm-switch-of-virtual-machines-using-powershell/
$worker_number=$args[0]
write-host "setting NATSwitch to to worker-$worker_number"

Get-VM "hyperv-worker-$worker_number" | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "NATSwitch"
