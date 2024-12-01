# Installation Guide

Welcome to the **KaspaAPI Module**! Follow this guide to install the module from GitHub and set it up in your PowerShell environment.

---

## Requirements

Before you begin, ensure your environment meets the following requirements:

- **PowerShell Version**: 5.1 or later.
- **Git**: Required to clone the repository.
- **Internet Access**: Needed to download the repository.

---

## Installation Steps

### Method 1: Install via GitHub

1. **Clone the Repository**:
   - Open your terminal (or PowerShell) and run the following command to clone the repository:

     ```powershell
     git clone https://github.com/BabyKonanCoin/KaspaAPI.git
     ```

2. **Navigate to the Module Folder**:
   - Change your directory to the location of the cloned repository:

     ```powershell
     cd KaspaAPI/KaspaAPI
     ```

3. **Import the Module**:
   - Import the module into your PowerShell session:

     ```powershell
     Import-Module .\KaspaAPI.psd1
     ```

4. **Verify the Installation**:
   - Check if the module is loaded by running:

     ```powershell
     Get-Module -Name KaspaAPI
     ```

### Method 2: Copy the Module to PowerShell Modules Folder

1. **Clone the Repository** (as shown above).

2. **Move the Module Folder**:
   - Copy the `KaspaAPI` folder (containing `KaspaAPI.psd1`) to your PowerShell modules directory:

     ```powershell
     $Destination = "$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules\KaspaAPI"
     Copy-Item -Path ".\KaspaAPI" -Destination $Destination -Recurse
     ```

3. **Import the Module**:
   - Import the module into your session:

     ```powershell
     Import-Module KaspaAPI
     ```

4. **Verify the Installation**:
   - Ensure the module is available globally:

     ```powershell
     Get-Module -ListAvailable -Name KaspaAPI
     ```

---

## Troubleshooting Installation

1. **Permission Issues**:
   - If you encounter permission errors, try running PowerShell as an administrator.

2. **Missing Dependencies**:
   - Ensure that you’ve installed all required dependencies for PowerShell and Git.

3. **Git Not Installed**:
   - If Git is not installed, download and install it from [https://git-scm.com/](https://git-scm.com/).

---

## Next Steps

Once installed, proceed to the [Configuration Guide](configuration.md) to set up the module for your workflow.

For more details, visit the [KaspaAPI GitHub Repository](https://github.com/BabyKonanCoin/KaspaAPI).
