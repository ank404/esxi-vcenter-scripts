# ESXi and vCenter PowerShell Scripts

A collection of PowerShell scripts designed for managing, monitoring, and automating tasks in VMware ESXi and vCenter Server environments.

## Repository Structure

The repository is organized into the following categories:

- **[provisioning/](provisioning/)**: Scripts for creating virtual machines, VLANs, and other provisioning tasks.
- **[monitoring/](monitoring/)**: Scripts for monitoring ESXi/vCenter environments and gathering performance data.
- **[maintenance/](maintenance/)**: Scripts for managing hosts, datastores, and network configurations.
- **[reporting/](reporting/)**: Scripts for generating various reports about your VMware environment.
- **[utilities/](utilities/)**: Miscellaneous scripts for utility and administrative purposes.

## Prerequisites

Before using the scripts, ensure you meet the following requirements:

- **PowerShell**: All scripts are written for PowerShell.
- **VMware PowerCLI**: Installed and configured. [Download VMware PowerCLI here](https://developer.vmware.com/powercli/).
- **Permissions**: Ensure you have appropriate access to your vCenter Server or ESXi host.

## Usage Instructions

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/esxi-vcenter-scripts.git
   ```
2. Navigate to the directory containing the script you want to run:
   ```sh
   cd esxi-vcenter-scripts/provisioning
   ```
3. Run the script in PowerShell:
   ```powershell
   .\scriptname.ps1
   ```

## Examples

- To add VLANs from a CSV file:
   ```powershell
   .\Add-VLAN_From_CSV.ps1 -CSVPath "path-to-your-csv-file.csv"
   ```
- To gather IOPS data:
   ```powershell
   .\GatherIOPS.ps1
   ```