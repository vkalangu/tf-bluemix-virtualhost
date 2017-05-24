provider "ibmcloud" {
  ibmid                    = "${var.ibmid}"
  ibmid_password           = "${var.ibmidpw}"
  softlayer_account_number = "${var.slaccountnum}"
}

##############################################################################
# Variables
##############################################################################
# Required for the IBM Cloud provider
variable ibmid {
  type = "string"
  description = "Your IBM-ID."
}
# Required for the IBM Cloud provider
variable ibmidpw {
  type = "string"
  description = "The password for your IBM-ID."
}
# Required to target the correct SL account
variable slaccountnum {
  type = "string"
  description = "Your Softlayer account number."
}

variable "hostname" {
  description = "Hostname of the virtual instance (small flavor) to be deployed"
  default = "VJdebiansmall"
}

variable "public_ssh_key" {
  description = "Public SSH key used to connect to the virtual guest"
  default ="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmpNQZ5TByhh/X/J6aELebn+gt0u7gU0DTipw7BX+kbM9ZY6DbxxO719N2dngBaIXZg/WvHvU8SVgYiMvCkW7qHC6ZfmXKSSNekeRGI+Hls4UhHQP2oRg2gmjcG5pycUWk6UKi3egYfbW5d6Q0/ZVSmvNW3GClRSzN+V9UPBC4XeBhmWXW30QcHzj/nYHs+yKGGc2tfAKQa2ymVKdfwKZadUUU+o4MAqtfwBlZ86vSI5YNtPH7ETEkYRquSzijquFlf+MmgDXZWM9gIaPXrVUZLNgzK3ZbFVpqJaKxcXnqD7d36X97mjPyVoTj8vzBoZGk223Ir1M8+WpkNC/LQ3oii2sqroA8MF3ZNu+S3ntBk2S133XiWYbiooKNNfdZYYlNSKceyCmOLgNDD8ksWpozE1ov3dIezxvRqcds66vulGuJSl8Y+Rr8SqIVLJyFO/DFBCrfBb+Ka3FpvbLF5g2VVRFBm+OppjEWYOTbN3IQRmyRb+LuLaqQPKdby4puJ6fDxTVrWtCHBL4pv824xqjFLMLBns3zXa1buYzBgc9AWxXtMDZahwl/Z0tWzra2jnR0q0YoVMuDzr0ndybdIoNOYuplm2bJu4d/tLsn8Tc7URtcx8Br/9iK1b9ULWPLyIUdLnQVT1wlGU7zqrVYev3wzcU9g3rAgkVTGhFk8j7RCQ== vkalangu@in.ibm.com"
}

variable "datacenter" {
  description = "Softlayer datacenter where infrastructure resources will be deployed"
  default = "dal06"
}



# This will create a new SSH key that will show up under the \
# Devices>Manage>SSH Keys in the SoftLayer console.
resource "ibmcloud_infra_ssh_key" "vj_public_key" {
   label = "VJ Public Key1"
    public_key = "${var.public_ssh_key}"
}


# Create a new virtual guest using image "Debian"
resource "ibmcloud_infra_virtual_guest" "vj_debian_small_virtual_guest" {
    hostname = "${var.hostname}"
    os_reference_code = "DEBIAN_7_64"
    //os_reference_code = "DEBIAN_LATEST"
    //image_id = "990523"
    domain = "vj.in.ibm.com"
    datacenter = "${var.datacenter}"
    network_speed = 10
    hourly_billing = true
    private_network_only = false
    cores = 1
    memory = 1024
    disks = [25, 10, 20]
    user_metadata = "{\"value\":\"newvalue\"}"
    dedicated_acct_host_only = true
    local_disk = false
    ssh_key_ids = ["${ibmcloud_infra_ssh_key.vj_public_key.id}"]
}



data "ibmcloud_infra_ssh_key" "vj_query_ssh"{
    label = "VJ Public Key1"
    most_recent="true"
}

output "sshkeyLatest" {
	 value = "${data.ibmcloud_infra_ssh_key.vj_query_ssh.fingerprint}"
}

data "ibmcloud_infra_virtual_guest" "vj_query_vm" {
    hostname = "${var.hostname}"
    domain = "vj.in.ibm.com"
}

output "vmstatus" {
	 value = "${data.ibmcloud_infra_virtual_guest.vj_query_vm.status}"
}


