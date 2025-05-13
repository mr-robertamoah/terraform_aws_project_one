locals {
    tags = {
        Environment = "dev"
        Owner = "Robert Amoah"
        Project = "AWS Terraform Project One" 
        Module = "Security"
    }

    prefix = "${var.project_name}-${var.environment}"

    everyWhere = {
        cidr_block = "0.0.0.0/0"
    }

    ip = trimspace(data.http.my_ip.response_body)

    ip_octets = split(".", local.ip)

    myIp = {
        cidr_block = "${local.ip_octets[0]}.${local.ip_octets[1]}.0.0/24"
    }
}
