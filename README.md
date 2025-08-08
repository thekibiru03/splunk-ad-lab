# Automated Splunk Detection & Response Lab

This project automates the creation of a complete security lab environment for detection engineering and attack simulation. With a single command, it deploys **three virtual machines**: a fully configured Splunk server, a Windows Server Active Directory Domain Controller with advanced logging, and a Splunk SOAR server for automated response capabilities.

This lab is designed for security professionals, detection engineers, and blue teamers who want a repeatable and consistent environment to test, validate, and develop security alerts with automated response workflows. This project was heavily inspired by the official [Splunk Attack Range](https://github.com/splunk/attack_range).

This project aims to assist professionals who might not have resources to run multi VM  or cloud based detection engineering setups with a practical way to sharpen their skills with a setup that can be deployed on a host with 16GB RAM and 8 CPU cores.

![Lab Architecture](https://img.shields.io/badge/VMs-3-blue) ![Oracle Linux](https://img.shields.io/badge/OS-Oracle%20Linux%209-red) ![Windows Server](https://img.shields.io/badge/OS-Windows%20Server%202016-blue) ![License](https://img.shields.io/badge/license-MIT-green)

---

## 🏗️ Architecture Overview

The lab consists of three interconnected virtual machines:

```
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│   Splunk Server     │    │   Windows DC        │    │   Splunk SOAR       │
│   (Oracle Linux 9) │◄───┤   (Server 2016)     ├───►│   (Oracle Linux 9)  │
│   192.168.56.10     │    │   192.168.56.20     │    │   192.168.56.30     │
│   Port: 8000, 8089  │    │   Domain: BLANC.local│   │   Port: 8443        │
└─────────────────────┘    └─────────────────────┘    └─────────────────────┘
```

---

## ✨ Features

### 🔍 **Detection Capabilities**
* **Advanced Logging**: Sysmon with modular configuration, PowerShell Script Block & Module Logging, and comprehensive Windows Audit Policies
* **Log Aggregation**: Centralized log collection in Splunk Enterprise with custom indexes
* **Pre-configured Apps**: Splunk Add-ons for Windows and Sysmon ready for immediate use

### 🎯 **Attack Simulation** 
* **Atomic Red Team**: Pre-installed framework for MITRE ATT&CK technique simulation
* **Test Users**: Auto-generated realistic Active Directory accounts for testing
* **Disabled Defender**: Clean environment for unhindered attack simulations

### 🤖 **Automated Response**
* **Splunk SOAR Integration**: Complete detection-to-response workflow automation
* **Pre-installed Apps**: Essential SOAR apps including Windows Remote Management, Active Directory, and threat intelligence connectors

### 🏗️ **Infrastructure as Code**
* **One Command Deploy**: Complete lab setup with `vagrant up`
* **Repeatable Builds**: Consistent environment creation every time
* **Version Controlled**: All configurations managed through Git

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following software installed:

| Software | Version | Download Link |
|----------|---------|---------------|
| Git | Latest | [Download](https://git-scm.com/downloads) |
| Vagrant | 2.4.0+ | [Download](https://www.vagrantup.com/downloads) |
| VirtualBox | 7.0+ | [Download](https://www.virtualbox.org/wiki/Downloads) |
| VirtualBox Extensions | 6.2+ | [Download](https://www.virtualbox.org/wiki/Downloads) |
| Ansible | 2.17+ | [Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) |

**System Requirements:**
- **RAM**: 16GB and above recommended
- **CPU**: 8+ cores recommended  
- **Disk Space**: 100GB free space
- **Network**: Internet connection for initial downloads

**Note:** You can add the images used by vagrant before deployment by running `vagrant box add generic/oracle9` to get the Oracle Linux 9 box and `vagrant box add peru/windows-server-2016-standard-x64-eval` to get the Windows box. 

This would make your installation quicker if these boxes are already on your system.

### Required Downloads

Before running the lab, download these files and place them in the `installers/` directory:

| File | Source | Purpose |
|------|--------|---------|
| `Splunk_TA_windows.zip` | [Splunkbase](https://splunkbase.splunk.com/app/742) | Windows log collection |
| `splunk-add-on-for-sysmon_403.tgz` | [Splunkbase](https://splunkbase.splunk.com/app/1914) | Sysmon log processing |
| `splunk-app-for-soar-export_4326.tgz` | [Splunkbase](https://splunkbase.splunk.com/app/5359) | SOAR integration |
| `Sysmon.zip` | [Microsoft Sysinternals](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon) | Endpoint monitoring |
| `sysmonconfig.xml` | [sysmon-modular](https://github.com/olafhartong/sysmon-modular) | Sysmon configuration |
| `splunk_soar-unpriv-6.4.1.361-bea76553-el9-x86_64.tgz` | [Splunk SOAR](https://www.splunk.com/en_us/download/splunk-soar.html) | SOAR platform |

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/thekibiru03/splunk-ad-lab.git
   cd splunk-ad-lab
   ```

2. **Install Ansible Collections and pywinrm:**
   ```bash
   ansible-galaxy collection install community.windows
   ansible-galaxy collection install microsoft.ad
   ansible-galaxy collection install ansible.windows
   pip install pywinrm
   ```

3. **Deploy the Lab:**
   ```bash
   # Deploy all three VMs (recommended)
   vagrant up --provision
   
   # Or deploy individual components
   vagrant up splunk_server_ol --provision
   vagrant up windows_server_dc  --provision
   vagrant up soar_server --provision
   ```

   **⏱️ Expected Deployment Time:** 30-60 minutes depending on your internet connection and hardware.

4. **Destroy the Lab (if you want to start over):**
   ```bash
   # Destroy all three VMs
   vagrant destroy 
   # Or deploy individual components
   vagrant destroy splunk_server_ol
   vagrant destroy windows_server_dc  
   vagrant destroy soar_server
   ```

---

## 🎯 Usage

### Access

Once deployment is complete, access your lab components:

#### 🔍 **Splunk Enterprise**
- **URL:** http://192.168.56.10:8000
- **Username:** `admin`
- **Password:** `changeme`
- **Indexes:** `win` for Windows Event Logs, `sysmon` for Sysmon logs, `powershell` for PowerShell Logs

#### 🖥️ **Windows Domain Controller** 
- **IP:** 192.168.56.20
- **Username:** `vagrant` 
- **Password:** `vagrant`
- **Domain:** `BLANC.local`
- **Access:** RDP connection

#### 🤖 **Splunk SOAR**
- **URL:** https://192.168.56.30:8443
- **Username:** `soar_local_admin`
- **Password:** `password` (change on first login)
- **Purpose:** Security orchestration and automated response

### 🎮 Running Attack Simulations

1. **Connect to Windows DC via RDP**
2. **Open PowerShell** (Atomic Red Team module auto-loads)
3. **Run a test:**

For example, to simulate a common discovery technique (T1082 - System Information Discovery)
   ```powershell
   # List available tests
   Invoke-AtomicTest T1082 -ShowDetailsBrief
   
   # Execute a test
   Invoke-AtomicTest T1082
   
   # Clean up after test
   Invoke-AtomicTest T1082 -Cleanup
   ```

4. **Analyze in Splunk:**
   ```spl
   # Search for process creation events
   index=win sourcetype="XmlWinEventLog:Security" EventCode=4688
   
   # Search for Sysmon events
   index=sysmon sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational"
   
   # Search for PowerShell activity
   index=powershell sourcetype="XmlWinEventLog:Microsoft-Windows-PowerShell/Operational"
   ```

### 🔄 Detection-to-Response Workflow

The lab supports a complete detection and response loop:

1. **🎯 Attack Simulation:** Execute Atomic Red Team tests
2. **📊 Log Ingestion:** Events flow to Splunk via Universal Forwarder  
3. **🚨 Detection:** Correlation searches identify suspicious activity
4. **🤖 Automated Response:** SOAR playbooks execute remediation actions
5. **📈 Analysis:** Review response effectiveness and tune detections

---

## 📁 Project Structure

```
splunk-ad-lab/
├── Vagrantfile                     # VM definitions and configuration
├── ansible/
│   ├── playbooks/                  # Automation playbooks
│   │   ├── setup_splunk_server.yml
│   │   ├── setup_windows_dc.yml
│   │   └── setup_soar_server.yml
│   ├── roles/                      # Reusable configuration roles
│   ├── scripts/                    # PowerShell and utility scripts
│   └── inventory.ini              # Ansible inventory
├── installers/                     # Required software downloads (see above)
└── README.md
```
* **`ansible/playbooks/setup_splunk_server.yml`**: The master playbook for the Splunk server. It calls the individual `splunk_tasks_*.yml` files.
* **`ansible/playbooks/setup_windows_dc.yml`**: The master playbook for the Windows Domain Controller. It calls the individual `dc_tasks_*.yml` files.
* **`ansible/roles/`**: Contains Ansible roles for more complex, reusable configurations (e.g., `windows_dc_setup`).
* **`ansible/files/`**: Contains static configuration files like `inputs.conf`.

### Key Components

| Component | Purpose | Technology Stack |
|-----------|---------|------------------|
| **Vagrant** | VM provisioning and management | VirtualBox provider |
| **Ansible** | Configuration management and automation | Python-based IaC |
| **Splunk Enterprise** | SIEM and log analysis platform | Universal Forwarder for log collection |
| **Active Directory** | Authentication and target environment | Windows Server 2016 |
| **Sysmon** | Advanced endpoint monitoring | Modular configuration |
| **Atomic Red Team** | Adversary technique simulation | PowerShell-based framework |
| **Splunk SOAR** | Security orchestration platform | Phantom playbooks |

---

## 🔧 Customization

### Modify Network Configuration
Edit the `Vagrantfile` to change IP addresses:
```ruby
splunk_server_ip = "192.168.56.10"     # Splunk Server
# Windows DC: 192.168.56.20
# SOAR Server: 192.168.56.30
```

### Add Custom Sysmon Configuration
Replace `installers/sysmonconfig.xml` with your preferred configuration from:
- [Sysmon Modular](https://github.com/olafhartong/sysmon-modular)
- [SwiftOnSecurity](https://github.com/SwiftOnSecurity/sysmon-config)

### Customize Test Users
The project uses a customized version of an excellent PowerShell script from [Tyler Applebaum](https://gist.github.com/tylerapplebaum/d692d9d2e1335b8b111927c8292c5dac) to create realistic looking Active Directory users using [Random User API](https://randomuser.me/)

You can modify `ansible/scripts/Add-TestUsers.ps1` parameters:
- Number of users: `-NumUsers 15`
- Company name: `-CompanyName "Your Org"`
- Nationalities: `-Nationalities "us,gb,ca"`

---

## 🛠️ Troubleshooting

### Common Issues

**Problem:** `vagrant up` fails with VirtualBox errors
- **Solution:** Ensure VirtualBox version compatibility and virtualization is enabled in BIOS

**Problem:** Windows DC doesn't join domain after reboot
- **Solution:** Wait 2-3 minutes for AD services to fully initialize, then re-run provisioning

**Problem:** Splunk Universal Forwarder not connecting
- **Solution:** Check Windows Firewall settings and verify receiving port 9997 is open

**Problem:** SOAR server not accessible
- **Solution:** Verify firewall rules allow port 8443 and check service status

### Debug Commands

```bash
# Check VM status
vagrant status

# SSH into Splunk server
vagrant ssh splunk_server_ol

# View Ansible logs
ANSIBLE_VERBOSE=True vagrant provision

# Restart specific VM
vagrant reload windows_server_dc
```

---

## 🔮 Future Enhancements

### Planned Features
- **Purple Team Automation**: Automated red team vs blue team exercises  
- **Bare Metal Deployment**: Deployment option using Terraform on Tier on hypervisor e.g Proxmox, VMWare
- **Splunk Enterprise - SOAR connection**: Automate connecting these two components
- **Advanced Threat Hunting**: Pre-built hunting queries and dashboards
- **SOAR Playbooks**: Prebuilt SOAR Playbooks
- **AI Features**: Connection with LLMs to add human-form context to SOAR Cases

### Current Limitations
- **Single Host Only**: Designed for single-machine deployment
- **Windows Server 2016**: Consider upgrade to Server 2019/2022
- **Manual App Installation**: Some Splunk apps require manual installation
- **Basic SOAR Playbooks**: Limited pre-built automation workflows

---

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Development Setup
```bash
# Install development dependencies
pip install ansible-lint yamllint
ansible-galaxy collection install community.general

# Run syntax checks
ansible-lint ansible/playbooks/
yamllint ansible/
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **[Splunk Attack Range](https://github.com/splunk/attack_range)** - Primary inspiration
- **[Atomic Red Team](https://atomicredteam.io/)** - Attack simulation framework
- **[Sysmon Modular](https://github.com/olafhartong/sysmon-modular)** - Excellent Sysmon configuration
- **[Tyler Applebaum](https://gist.github.com/tylerapplebaum/d692d9d2e1335b8b111927c8292c5dac)** - Handy PowerShell script to populat AD users
- **[Detection Lab](https://detectionlab.network/)** - Reference architecture
- **Community Contributors** - Thank you for your feedback and improvements!

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/thekibiru03/splunk-ad-lab/issues)
- **Discussions**: [GitHub Discussions](https://github.com/thekibiru03/splunk-ad-lab/discussions)
- **Documentation**: [Wiki](https://github.com/thekibiru03/splunk-ad-lab/wiki)

---

**⭐ If this project helped you, please give it a star! It helps others discover the lab.**