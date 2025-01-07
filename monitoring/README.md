
# Monitoring Scripts

This folder contains PowerCLI scripts designed for monitoring VMware environments. These scripts help administrators collect performance metrics and identify potential issues through alerts and trends.

## Scripts Overview

1. **GatherIOPS.ps1**
   - **Purpose**: Collects IOPS (Input/Output Operations Per Second) data for virtual machines across your vSphere environment.
   - **Usage**: Use this script to monitor storage performance for troubleshooting and capacity planning.
   - **Example**:
     ```powershell
     .\GatherIOPS.ps1 -VMName "WebServer01"
     ```

2. **IOPS-Script.ps1**
   - **Purpose**: Analyzes IOPS data to identify trends and usage patterns over time.
   - **Usage**: Helpful for performance tuning and predicting future storage needs.
   - **Example**:
     ```powershell
     .\IOPS-Script.ps1 -TimeRange "LastWeek"
     ```

3. **Vcenter-Alert-Script.ps1**
   - **Purpose**: Fetches active alerts from vCenter Server to provide insights into the health of your VMware infrastructure.
   - **Usage**: Ideal for identifying and addressing issues proactively.
   - **Example**:
     ```powershell
     .\Vcenter-Alert-Script.ps1 -Severity "Critical"
     ```

## How to Run

- Install and configure VMware PowerCLI.
- Connect to your vCenter Server with `Connect-VIServer` before executing these scripts.
- Specify required parameters based on your monitoring objectives.

## Notes

These scripts are intended to assist with proactive monitoring and data-driven decision-making for VMware infrastructure.
