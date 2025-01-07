# Maintenance Scripts

This folder contains PowerCLI scripts for performing essential maintenance tasks in VMware environments. Each script is designed to address specific maintenance needs, helping to optimize and manage resources effectively.

## Scripts Overview

1. **Add port.ps1**
   - **Purpose**: Adds a new port group to a distributed virtual switch in your vSphere environment.
   - **Usage**: Execute this script to provision new network configurations efficiently.
   - **Input**: Switch name, VLAN ID, port group name.
   - **Example**:
     ```powershell
     .\Add-port.ps1 -SwitchName "vSwitch0" -VLANID 100 -PortGroupName "PG-Web"
     ```

2. **Compute.ps1**
   - **Purpose**: Performs resource management tasks related to compute clusters, such as adjustments or calculations for capacity planning.
   - **Usage**: Ideal for ensuring compute resources are optimally allocated.
   - **Example**:
     ```powershell
     .\Compute.ps1 -ClusterName "Compute-Cluster"
     ```

3. **Datastore.ps1**
   - **Purpose**: Retrieves detailed information about datastores, including provisioned, free, and used space.
   - **Usage**: Use this script to monitor datastore health and usage.
   - **Example**:
     ```powershell
     .\Datastore.ps1 -DatastoreName "Datastore1"
     ```

## How to Run

- Ensure you have VMware PowerCLI installed.
- Connect to vCenter using `Connect-VIServer` before running these scripts.
- Customize parameters based on your environment needs.

## Notes

These scripts are meant to assist administrators in automating repetitive maintenance tasks, improving efficiency, and reducing errors.
