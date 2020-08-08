build {

    sources = [
        "source.vagrant.centos-8"
    ]

    provisioner "shell" {
        execute_command = "echo ${var.ssh_password} | {{ .Vars }} sudo -S -E sh '{{ .Path }}'"
        inline = [
            "yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
            "yum update -y",
            "yum install -y jq",
            "yum install -y wget",
            "yum install -y curl",
            "yum install -y git",
            "yum install -y unzip"
        ]
        inline_shebang = "/bin/sh -x"
        skip_clean = true
    }

}