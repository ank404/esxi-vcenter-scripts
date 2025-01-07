# Utility Scripts

This folder contains miscellaneous PowerCLI scripts designed to assist with specific administrative tasks in VMware environments. These scripts provide functionality that doesn’t fall under standard categories but is essential for efficient management.

## Scripts Overview

1. **Get-VLAN_List.ps1**
   - **Purpose**: Retrieves and displays a list of VLANs configured across your environment, including associated details like VLAN ID and names.
   - **Usage**: Useful for auditing network configurations.
   - **Example**:
     ```powershell
     .\Get-VLAN_List.ps1 -OutputPath "C:\Reports\VLANList.csv"
     ```

2. **viewpermission.ps1**
   - **Purpose**: Displays the permissions of a specified vSphere user, helping administrators verify and manage access rights.
   - **Usage**: Ideal for user access reviews and security audits.
   - **Example**:
     ```powershell
     .\viewpermission.ps1 -UserName "administrator@vsphere.local"
     ```

## How to Run

- Ensure VMware PowerCLI is installed and connected to your vCenter Server with `Connect-VIServer`.
- Provide necessary parameters as required by the scripts.

## Notes

- Scripts in this folder serve as utilities to simplify routine administrative tasks.
- Outputs can often be saved in CSV format for further analysis or documentation.
