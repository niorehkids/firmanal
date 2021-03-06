#!/bin/bash

set -e
set -u

if [ -e ../../configure.sh ]; then
    source ../../configure.sh
elif [ -e ../configure.sh ]; then
    source ../configure.sh
elif [ -e ./configure.sh ]; then
    source ./configure.sh
else
    echo "Error: Could not find 'configure.sh'!"
    exit 1
fi

if check_number $1; then
    echo "Usage: run.mipsel-debug.sh <image ID>"
    exit 1
fi
IID=${1}

WORK_DIR=`get_vm ${IID}`
IMAGE=`get_fs ${IID}`
KERNEL=`get_kernel "mipsel"`

qemu-system-mipsel -m 256 -M malta -kernel ${KERNEL} -drive if=ide,format=raw,file=${IMAGE} -append "firmadyne.syscall=1 root=/dev/sda1 console=ttyS0 nandsim.parts=64,64,64,64,64,64,64,64,64,64 rdinit=/firmadyne/preInit.sh rw debug ignore_loglevel print-fatal-signals=1" -nographic -net nic,vlan=0 -net socket,vlan=0,listen=:2000 -net nic,vlan=1 -net socket,vlan=1,listen=:2001 -net nic,vlan=2 -net socket,vlan=2,listen=:2002 -net nic,vlan=3 -net socket,vlan=3,listen=:2003
