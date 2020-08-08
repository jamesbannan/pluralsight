source "vagrant" "centos-8" {
    
    source_path = "bento/centos-8"
    provider = "vmware_desktop"

    communicator = "ssh"
    ssh_port = 22
    ssh_username = var.ssh_user
    ssh_password = var.ssh_password

    add_force = true
    
    output_dir = var.output_path

}