# ESXi and vCenter PowerShell Scripts

A robust collection of PowerShell scripts designed to simplify and automate the management of VMware ESXi and vCenter Server environments. These scripts are tailored for system administrators looking to enhance efficiency, reduce manual effort, and maintain a high-performing virtual infrastructure.

---

## 📁 Repository Overview

This repository is structured into logical categories, making it easy to locate scripts based on their functionality. Each folder contains scripts targeting specific aspects of VMware infrastructure management:

### 1. **[maintenance/](maintenance/)**
   - **Purpose**: Essential scripts for maintaining VMware environments, focusing on hosts, datastores, and networking configurations.
   - **Key Scripts**:
     - `Add port.ps1`: Adds a port group to a distributed switch for streamlined network configuration.
     - `Compute.ps1`: Performs calculations or adjustments for cluster compute resources.
     - `Datastore.ps1`: Retrieves datastore details, including provisioned, used, and free space.

---

### 2. **[monitoring/](monitoring/)**
   - **Purpose**: Tools to monitor and gather performance metrics, helping administrators stay informed of their environment’s health.
   - **Key Scripts**:
     - `GatherIOPS.ps1`: Collects IOPS (Input/Output Operations Per Second) data for virtual machines.
     - `IOPS-Script.ps1`: Analyzes IOPS trends for storage performance tuning.
     - `Vcenter-Alert-Script.ps1`: Fetches and displays alerts from vCenter for proactive issue resolution.

---

### 3. **[provisioning/](provisioning/)**
   - **Purpose**: Automates provisioning tasks to reduce manual overhead and ensure consistent deployments.
   - **Key Scripts**:
     - `Add-VLAN_From_CSV.ps1`: Adds multiple VLANs to ESXi hosts using a CSV file.
     - `VMCreationDate.ps1`: Retrieves the creation dates of virtual machines for auditing purposes.

---

### 4. **[reporting/](reporting/)**
   - **Purpose**: Generates detailed reports for auditing, capacity planning, and performance reviews.
   - **Key Scripts**:
     - `Storage-Report.ps1`: Generates a detailed storage utilization report.
     - `VMReport.ps1`: Provides a comprehensive inventory report of virtual machines.
     - `Report_GIBL.ps1`: Creates customized reports based on specific user-defined parameters.

---

### 5. **[utilities/](utilities/)**
   - **Purpose**: Miscellaneous scripts that enhance administrative capabilities and simplify VMware management tasks.
   - **Key Scripts**:
     - `Get-VLAN_List.ps1`: Retrieves a complete list of configured VLANs for network audits.
     - `viewpermission.ps1`: Displays user permissions for security and access management.

---

## 🛠️ Prerequisites

Before running these scripts, ensure the following:

- **PowerShell**: Installed and configured on your system.
- **VMware PowerCLI**: Installed and set up. You can [download it here](https://developer.vmware.com/powercli/).
- **Permissions**: Adequate access to vCenter Server or ESXi hosts for the required operations.
- **Input Files**: For scripts requiring CSV inputs, ensure the files are correctly formatted.

---

## 🚀 Getting Started

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/yourusername/esxi-vcenter-scripts.git
   ```
2. Navigate to the desired folder:
   ```bash
   cd esxi-vcenter-scripts/<folder-name>
   ```
3. Execute the script in PowerShell, passing required parameters:
   ```powershell
   .\scriptname.ps1 -ParameterName ParameterValue
   ```

---

## 📚 Usage Examples

Here are a few examples to get you started:

- **Provision VLANs from a CSV file**:
   ```powershell
   .\Add-VLAN_From_CSV.ps1 -CSVPath "C:\Path\To\Your\VLANs.csv"
   ```
- **Collect IOPS data for a virtual machine**:
   ```powershell
   .\GatherIOPS.ps1 -VMName "VirtualMachine01"
   ```
- **Generate a storage utilization report**:
   ```powershell
   .\Storage-Report.ps1 -OutputPath "C:\Reports\StorageReport.csv"
   ```

---

## 💡 Notes

- All scripts are designed to be modular and customizable. Adjust parameters as needed to fit your environment.
- Use these scripts responsibly, particularly in production environments—test in a lab environment when possible.

---
