
# Provisioning Scripts

This folder contains PowerCLI scripts designed to automate the provisioning of virtual machines and VLANs in VMware environments. These scripts streamline tasks that are repetitive or require consistent accuracy.

## Scripts Overview

1. **Add-VLAN_From_CSV.ps1**
   - **Purpose**: Automates the addition of VLANs to ESXi hosts using details provided in a CSV file.
   - **Usage**: Use this script to provision multiple VLANs efficiently across hosts.
   - **Input**: A CSV file containing VLAN IDs, names, and host details.
   - **Example**:
     ```powershell
     .\Add-VLAN_From_CSV.ps1 -CSVPath "C:\VLANs.csv"
     ```
   - **CSV Format**:
     ```
     HostName,VLANID,VLANName
     host01.local,100,Management
     host02.local,200,Production
     ```

2. **VMCreationDate.ps1**
   - **Purpose**: Retrieves the creation dates of virtual machines in the vCenter inventory.
   - **Usage**: Useful for auditing and tracking purposes.
   - **Example**:
     ```powershell
     .\VMCreationDate.ps1 -VMName "TestVM01"
     ```

## How to Run

- Install and configure VMware PowerCLI.
- Connect to your vCenter Server using `Connect-VIServer`.
- Prepare any required input files, such as CSVs, before running the scripts.

## Notes

- Always validate your CSV file format and data before running scripts to avoid errors.
- These scripts are designed to save time and reduce human errors in provisioning tasks.
