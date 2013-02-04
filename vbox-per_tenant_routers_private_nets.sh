#!/bin/bash
##################################################################################
#   Script to create and configure VirtualBox VMs for installing OpenStack.      #
##################################################################################

vm_original="zerada"
vm_1="controller-node"
vm_2="network-node"
vm_3="compute-node"

##################################################################################

set -e

vboxmanage hostonlyif create
vboxmanage hostonlyif create
vboxmanage hostonlyif create
vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.0.1 --netmask 255.255.255.0
vboxmanage hostonlyif ipconfig vboxnet1 --ip 7.7.7.7.1 --netmask 255.255.255.0
vboxmanage hostonlyif ipconfig vboxnet2 --ip 10.10.10.200 --netmask 255.255.255.0

vboxmanage clonevm ${vm_original} --mode machine --name ${vm_1} --register
vboxmanage modifyvm ${vm_1} --memory 2048 --cpus 2 --hwvirtex on --hwvirtexexcl on
vboxmanage modifyvm ${vm_1} --nic1 hostonly --hostonlyadapter1 vboxnet0
vboxmanage modifyvm ${vm_1} --nic2 hostonly --hostonlyadapter2 vboxnet1
vboxmanage modifyvm ${vm_1} --nic3 nat

vboxmanage createhd --filename "cinder" --size 10240 --format VDI
vboxmanage storageattach ${vm_1} --storagectl "SATA" --port 1 --device 0 --type hdd --medium "cinder.vdi"

vboxmanage clonevm ${vm_original} --mode machine --name ${vm_2} --register
vboxmanage modifyvm ${vm_2} --memory 2048 --cpus 2 --hwvirtex on --hwvirtexexcl on
vboxmanage modifyvm ${vm_2} --nic1 hostonly --hostonlyadapter1 vboxnet0
vboxmanage modifyvm ${vm_2} --nic2 hostonly --hostonlyadapter2 vboxnet2
vboxmanage modifyvm ${vm_2} --nic3 hostonly --hostonlyadapter3 vboxnet1
vboxmanage modifyvm ${vm_2} --nicpromisc3 allow-all
vboxmanage modifyvm ${vm_2} --nic4 nat

vboxmanage clonevm ${vm_original} --mode machine --name ${vm_3} --register
vboxmanage modifyvm ${vm_3} --memory 2048 --cpus 2 --hwvirtex on --hwvirtexexcl on
vboxmanage modifyvm ${vm_3} --nic1 hostonly --hostonlyadapter1 vboxnet0
vboxmanage modifyvm ${vm_3} --nic2 hostonly --hostonlyadapter2 vboxnet2
vboxmanage modifyvm ${vm_3} --nic3 nat

vboxmanage startvm ${vm_1}
vboxmanage startvm ${vm_2}
vboxmanage startvm ${vm_3}

