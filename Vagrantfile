# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # --- Shared Configuration for all VMs ---
  splunk_admin_password = "changeme"
  splunk_server_ip = "192.168.56.10"
  splunk_receiving_port = 9997

  # --- Oracle Linux Splunk Server VM ---
  config.vm.define "splunk_server_ol" do |splunk_server|
    splunk_server.vm.box = "generic/oracle9"
    splunk_server.vm.hostname = "splunk-server"
    splunk_server.vm.provider "virtualbox" do |vb|
      vb.memory = "2560"
      vb.cpus = "2"
      vb.name = "Splunk-Enterprise-OracleLinux9"
    end
    splunk_server.vm.network "private_network", ip: splunk_server_ip
    splunk_server.vm.network "forwarded_port", guest: 8000, host: 8000
    splunk_server.vm.network "forwarded_port", guest: 8089, host: 8089
    splunk_server.vm.synced_folder "installers/", "/vagrant_installers"
    splunk_server.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/playbooks/setup_splunk_server.yml"
      ansible.inventory_path = "ansible/inventory.ini"
      ansible.config_file = "ansible/ansible.cfg"
      ansible.limit = "splunk-server"
      ansible.extra_vars = {
        splunk_admin_password: splunk_admin_password,
        splunk_server_ip: splunk_server_ip,
        splunk_receiving_port: splunk_receiving_port,
        splunk_tgz_filename: "splunk-9.4.3-linux-amd64.tgz",
        splunk_tgz_url: "https://download.splunk.com/products/splunk/releases/9.4.3/linux/splunk-9.4.3-237ebbd22314-linux-amd64.tgz",
        ta_windows_zip_filename: "Splunk_TA_windows.zip",
        ta_windows_app_name: "Splunk_TA_windows",
        soar_app_filename: "splunk-app-for-soar-export_4326.tgz",
        soar_app_name: "phantom"
      }
    end
  end

  # --- Windows Server Domain Controller VM ---
  config.vm.define "windows_server_dc" do |windows_dc|
    windows_dc.vm.box = "peru/windows-server-2016-standard-x64-eval"
    windows_dc.vm.hostname = "windows-dc"
    windows_dc.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "2"
      vb.name = "Windows-Server-DC-BLANC"
    end
    windows_dc.vm.communicator = "winrm"
    windows_dc.winrm.username = "vagrant"
    windows_dc.winrm.password = "vagrant"
    windows_dc.vm.network "private_network", ip: "192.168.56.20"
    windows_dc.vm.synced_folder "installers/", "C:/vagrant_installers"

    # Force WinRM configuration to allow plaintext connections
    # windows_dc.vm.provision "shell", inline: <<-SHELL
    #   winrm quickconfig -q
    #   winrm set winrm/config/service/auth '@{Basic="true"}'
    #   winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    #   netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
    # SHELL

    windows_dc.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/playbooks/setup_windows_dc.yml"
      ansible.inventory_path = "ansible/inventory.ini"
      ansible.limit = "windows-dc"
      ansible.config_file = "ansible/ansible.cfg"
      ansible.extra_vars = {
        win_admin_password: "vagrant",
        ad_domain_name: "BLANC.local",
        ad_dsrm_password: "AD_DSRM_Secure_Password_4_Lab!", # DSRM password 
        splunk_server_ip: splunk_server_ip,
        splunk_receiving_port: splunk_receiving_port,
        splunk_forwarder_msi_filename: "splunkforwarder-9.4.3-237ebbd22314-windows-x64.msi",
        sysmon_zip_filename: "Sysmon.zip",
        sysmon_config_xml_filename: "sysmonconfig.xml",
        sysmon_install_dir: "C:\\Sysmon",
        ta_windows_zip_filename: "Splunk_TA_windows.zip", 
        ta_sysmon_zip_filename: "splunk-add-on-for-sysmon_403.tgz"
      }
    end
  end
  # --- Splunk SOAR Server VM ---
  config.vm.define "soar_server" do |soar_server|
    soar_server.vm.box = "generic/oracle9"
    soar_server.vm.hostname = "soar-server"
    soar_server.vm.provider "virtualbox" do |vb|
      vb.memory = "2560"
      vb.cpus = "2"
      vb.name = "Splunk-SOAR-OracleLinux9"
    end
    soar_server.vm.network "private_network", ip: "192.168.56.30"
    soar_server.vm.network "forwarded_port", guest: 8443, host: 8443
    soar_server.vm.synced_folder "installers/", "/vagrant_installers"

    # --- Provisioner 1: Configure the SOAR server itself ---
    soar_server.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/playbooks/setup_soar_server.yml"
      ansible.inventory_path = "ansible/inventory.ini"
      ansible.config_file = "ansible/ansible.cfg"
      ansible.limit = "soar-server"
      ansible.extra_vars = {
        soar_installer_filename: "splunk_soar-unpriv-6.4.1.361-bea76553-el9-x86_64.tgz"
      }
    end

    # --- Provisioner 2: Configure the Splunk-to-SOAR Connection ---
    # This runs AFTER the SOAR server is up and targets the Splunk server.
    soar_server.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/playbooks/configure_splunk_soar_connection.yml"
      ansible.inventory_path = "ansible/inventory.ini"
      ansible.config_file = "ansible/ansible.cfg"
      # IMPORTANT: Limit this playbook run to the splunk_server
      ansible.limit = "splunk-server"
    end
  end
end