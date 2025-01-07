# Reporting Scripts

This folder contains PowerCLI scripts for generating reports in VMware environments. These reports provide insights into infrastructure usage and health, aiding in decision-making and auditing.

## Scripts Overview

1. **Storage-Report.ps1**
   - **Purpose**: Generates a detailed storage utilization report, including information on free, used, and provisioned space across datastores.
   - **Usage**: Use this script to monitor storage capacity and plan upgrades or optimizations.
   - **Example**:
     ```powershell
     .\Storage-Report.ps1 -OutputPath "C:\Reports\StorageReport.csv"
     ```

2. **VMReport.ps1**
   - **Purpose**: Creates a comprehensive report on virtual machines, including details such as name, CPU, memory, storage, and power state.
   - **Usage**: Ideal for inventory management and capacity planning.
   - **Example**:
     ```powershell
     .\VMReport.ps1 -OutputPath "C:\Reports\VMReport.csv"
     ```

3. **Report_GIBL.ps1**
   - **Purpose**: Generates a custom report based on specific data points requested by the user.
   - **Usage**: Useful for tailored reporting needs.
   - **Example**:
     ```powershell
     .\Report_GIBL.ps1 -Parameters "CustomSettings.json"
     ```

## How to Run

- Ensure VMware PowerCLI is installed and connected to your vCenter Server using `Connect-VIServer`.
- Provide necessary output paths or input parameters as specified for each script.

## Notes

- Reports are typically generated in CSV format for easy integration with other tools.
- Customize script parameters to match your reporting requirements.
