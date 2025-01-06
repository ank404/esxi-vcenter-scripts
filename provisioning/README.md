# Provisioning Scripts

This folder contains scripts for automating the provisioning of virtual machines and VLANs in VMware environments.

## Scripts

- **Add-VLAN_From_CSV.ps1**: Adds VLANs to a host using details from a CSV file.
- **Add-VLAN_Single_Host.ps1**: Adds a single VLAN to a specified host.
- **VMCreationDate.ps1**: Retrieves the creation date of virtual machines.

## Usage

Run the scripts in PowerShell. Ensure that VMware PowerCLI is installed and connected to your vCenter Server.

### Examples:
- To add VLANs from a CSV file:
  ```powershell
  .\Add-VLAN_From_CSV.ps1 -CSVPath "path-to-your-csv-file.csv"

