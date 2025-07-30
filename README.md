# Automated Splunk Detection & Response Lab

This project automates the creation of a complete security lab environment for detection engineering and attack simulation. With a single command, it deploys two virtual machines: a fully configured Splunk server and a Windows Server Active Directory Domain Controller hardened with advanced logging and security tools.

This lab is designed for security professionals, detection engineers, and blue teamers who want a repeatable and consistent environment to test, validate, and develop security alerts. This project was heavily inspired by the official [Splunk Attack Range](https://github.com/splunk/attack_range).

---

## About The Project

The goal of this project is to provide a hands-on lab that mirrors a real-world enterprise environment, allowing you to:
* **Automate Infrastructure**: Use Infrastructure as Code (IaC) principles with Vagrant and Ansible to build the entire lab from scratch.
* **Harden Endpoints**: Automatically deploy and configure advanced logging sources on a Windows Domain Controller, including Sysmon, PowerShell Script Block & Module Logging, and Advanced Windows Audit Policies.
* **Simulate Attacks**: Use the pre-installed Atomic Red Team framework to safely execute adversary techniques based on the MITRE ATT&CK framework.
* **Engineer Detections**: Forward all logs to a central Splunk instance to practice writing, testing, and validating security alerts (correlation searches).

### Key Technologies Used:
* [**Vagrant**](https://www.vagrantup.com/): For creating and managing the virtual machines.
* [**Ansible**](https://www.ansible.com/): For configuration management and automation.
* [**Splunk Enterprise**](https://www.splunk.com/): For log aggregation, searching, and alerting.
* [**Active Directory**](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview): The target for our monitoring and attack simulations.
* [**Sysmon**](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon): For deep endpoint visibility. This lab uses the excellent modular configuration from Olaf Hartong's [sysmon-modular](https://github.com/olafhartong/sysmon-modular) project.
* [**Atomic Red Team**](https://atomicredteam.io/): For attack simulation.

---

## Getting Started

Follow these steps to get your detection lab up and running.

### Prerequisites

You will need the following software installed on your machine:
* [Git](https://git-scm.com/downloads)
* [Vagrant](https://www.vagrantup.com/downloads)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (or another Vagrant-supported provider)
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### Manual Downloads

Before running `vagrant up`, you must download the following files and place them in the `installers/` directory at the root of this project:

* **Splunk Add-on for Windows**: Download from [Splunkbase](https://splunkbase.splunk.com/app/742).
* **Splunk Add-on for Microsoft Sysmon**: Download from [Splunkbase](https://splunkbase.splunk.com/app/1914).
* **Splunk App for SOAR Export**: Download from [Splunkbase](https://splunkbase.splunk.com/app/5359).
* **Sysmon**: Download the `Sysmon.zip` file from [Microsoft Sysinternals](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon).

### Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/thekibiru03/splunk-ad-lab.git](https://github.com/thekibiru03/splunk-ad-lab.git)
    cd splunk-ad-lab
    ```

2.  **Install Ansible Collections:**
    This project requires specific Ansible collections for Windows management. Install them using the included requirements file:
    ```bash
    ansible-galaxy collection install -r ansible/collections/requirements.yml -p ansible/collections
    ```

3.  **Deploy the Lab:**
    This single command will create and provision both virtual machines. This process will take a significant amount of time (20-40 minutes) as it downloads and installs all the necessary software.
    ```bash
    vagrant up
    ```

---

## Usage

Once the `vagrant up` command has finished successfully, your lab is ready.

### Accessing the Lab Components:

* **Splunk Server:**
    * **URL:** `http://192.168.56.10:8000`
    * **Username:** `admin`
    * **Password:** `changeme` (as defined in the `Vagrantfile`)

* **Windows Domain Controller:**
    * You can access the server via RDP using the credentials for the `vagrant` user.
    * **IP Address:** `192.168.56.20`
    * **Username:** `vagrant`
    * **Password:** `vagrant`

### Running an Attack Simulation

1.  Log in to the Windows DC via RDP.
2.  Open a PowerShell window. The Atomic Red Team module will be imported automatically.
3.  Run a test. For example, to simulate a common discovery technique (T1082 - System Information Discovery), run:
    ```powershell
    Invoke-AtomicTest T1082
    ```
4.  Go to your Splunk search interface and look for the logs! You can start with a simple search:
    ```spl
    index=win sourcetype="XmlWinEventLog:Security" EventCode=4688
    ```

---

## Project Structure

This project uses Ansible to automate the configuration of the lab. The playbooks are organized as follows:

* **`ansible/playbooks/setup_splunk_server.yml`**: The master playbook for the Splunk server. It calls the individual `splunk_tasks_*.yml` files.
* **`ansible/playbooks/setup_windows_dc.yml`**: The master playbook for the Windows Domain Controller. It calls the individual `dc_tasks_*.yml` files.
* **`ansible/roles/`**: Contains Ansible roles for more complex, reusable configurations (e.g., `windows_dc_setup`).
* **`ansible/files/`**: Contains static configuration files like `inputs.conf`.

---

## Future Plans: Automated Response with SOAR

The next phase of this project is to build a full detection and response loop by adding a Security Orchestration, Automation, and Response (SOAR) server to the lab.

The planned workflow is:
1.  **Detection**: An Atomic Red Team test generates logs on the Domain Controller.
2.  **Alerting**: Splunk ingests the logs and a correlation search fires a high-fidelity alert.
3.  **Orchestration**: The Splunk alert is sent to a SOAR platform (e.g., Splunk SOAR).
4.  **Automated Response**: The SOAR platform triggers a playbook that connects back to the Domain Controller and automatically performs a remediation action, such as disabling a compromised user account.

