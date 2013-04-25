#!/bin/bash

VMNAME="spinrite"
PATH_TO_VMDK="$HOME/Desktop/hdd.vmdk"

existingVMs=$(VBoxManage list vms)

if [[ "$existingVMs" == *\"$VMNAME\"* ]]; then
    VBoxManage unregistervm $VMNAME --delete
fi

rm -rf $HOME/VirtualBox\ VMs/$VMNAME

if [[ -f $PATH_TO_VMDK ]]; then
    rm $PATH_TO_VMDK
fi

myusername=$(echo "$(whoami)")

diskutil list

read -e -p "Which of the above devices would you like to scan using Spinrite [/dev/disk1s1] ? " PART_NAME

if [[ $PART_NAME == "" ]]; then
    PART_NAME="/dev/disk1s1"
fi

if [[ ! -b $PART_NAME ]]; then
    echo "Unable to access device $PART_NAME"
    exit;
fi

DEVNAME=${PART_NAME%s*}

read -e -p "Where is your Spinrite ISO file located [~/Desktop/spinrite.iso ] ? " PATH_TO_SPIN_RITE

if [[ $PATH_TO_SPIN_RITE == "" ]]; then
    PATH_TO_SPIN_RITE="~/Desktop/spinrite.iso"
fi

PATH_TO_SPIN_RITE=`eval echo ${PATH_TO_SPIN_RITE//>}`

if [[ ! -f "$PATH_TO_SPIN_RITE"  ]]; then
    echo "Unable to find file $PATH_TO_SPIN_RITE"
    exit;
fi

fileExt="${PATH_TO_SPIN_RITE#*.}"

if [[ "$fileExt" != "iso" ]]; then
    echo "Have to use spinrite ISO file with an .iso extension"
    exit;
fi

sudo chown $myusername $DEVNAME
sudo chmod 777 $DEVNAME
sudo umount -fv $PART_NAME


sudo VBoxManage internalcommands createrawvmdk -filename $PATH_TO_VMDK  -rawdisk $DEVNAME &&
sudo chmod 777 $PATH_TO_VMDK &&
sudo umount -fv $PART_NAME

VBoxManage createvm --name $VMNAME --register &&
VBoxManage modifyvm $VMNAME --memory 128 &&
VBoxManage modifyvm $VMNAME --ostype Dos &&
VBoxManage storagectl $VMNAME --name "IDE Controller" --add ide &&
VBoxManage storageattach $VMNAME --storagectl "IDE Controller"  --port 1 --device 0 --type dvddrive --medium $PATH_TO_SPIN_RITE

if [[ $? != 0 ]]; then
    echo "Attaching spinrite ISO failed" $ret
    exit
fi

echo "Pausing 1s.."
sleep 1s
sudo umount -fv $PART_NAME
VBoxManage storageattach $VMNAME --storagectl "IDE Controller"  --port 0 --device 0 --type hdd --medium $PATH_TO_VMDK

if [[ $? != 0 ]]; then
     echo "Attaching virtual mapped HDD failed"
    exit
fi

echo "Pausing 5s.."
sleep 5s
sudo umount -fv $PART_NAME
VBoxManage startvm --type gui $VMNAME
