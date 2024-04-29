VM_NAME=numbatdesktop

install:
	sed 's/%VM_NAME%/'${VM_NAME}'/g;s,%ISO_PATH%,'$$PWD/ubuntu-24.04-desktop-amd64.iso',g' vm-with-cdrom.xml.in > vm-with-cdrom.xml
	sudo virsh define vm-with-cdrom.xml
	sudo qemu-img create -f qcow2 /var/lib/libvirt/images/${VM_NAME}.qcow2 25G
	sudo virsh start ${VM_NAME}

boot_from_disk:
	sudo virsh undefine ${VM_NAME}
	sed 's/%VM_NAME%/'${VM_NAME}'/g' vm-no-cdrom.xml.in > vm-no-cdrom.xml
	sudo virsh define vm-no-cdrom.xml
	sudo virsh start ${VM_NAME}

clean:
	sudo virsh destroy ${VM_NAME}
	sudo virsh undefine ${VM_NAME}
	sudo rm /var/lib/libvirt/images/${VM_NAME}.qcow2

.PHONY: install eject_cdrom clean
