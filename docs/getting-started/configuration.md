# Configuration Guide

After installing the **KaspaAPI Module**, follow this guide to configure it for your environment and use its powerful commands for blockchain analysis.

---

## Setting Up API References

1. **Interactive Configuration with Invoke-KasMenu**:
   - Run the following command to launch the interactive menu:

     ```powershell
     Invoke-KasMenu
     ```

   - This menu will guide you through setting up the API references for:
     - **Kaspa Explorer API**
     - **Kasplex Indexer API**
   - Follow the prompts to configure the URLs or use the default endpoints.

---

## Retrieving Token Holder Data

1. **Get Top 50 Holders**:
   - To fetch the top 50 holders for a token and save the results to a file, use:

     ```powershell
     Get-KasTop50 -ReturnAddressesOnly -Tick BKONAN -SelectPathToExport
     ```

   - This command:
     - Retrieves the top 50 holders for the token ticker `BKONAN`.
     - Allows you to select a file path to export the results.

2. **Store Addresses for Further Analysis**:
   - Import the saved addresses into a variable for further operations:

     ```powershell
     $addresses = Import-KasAddressPool
     ```

   - This variable will store the imported addresses for subsequent searches and analyses.

---

## Starting a Blockchain Analysis Job

1. **Run Start-KasTest**:
   - Use the following command to start a test with the addresses you’ve stored:

     ```powershell
     Start-KasTest -Addresses $addresses -Tick "konan" -AppenedUniqueAddresses `
                   -AppendTickHolders -Verbose -MaxJobs 4 `
                   -ModulePath "modules\path\Modules\KaspaAPI\KaspaAPI.psd1"
     ```

   - Command Breakdown:
     - **`-Addresses`**: Specifies the list of addresses to analyze.
     - **`-Tick`**: The token ticker to analyze (`"konan"` in this example).
     - **`-AppenedUniqueAddresses`**: Appends unique addresses to the results.
     - **`-AppendTickHolders`**: Appends token holder details to the results.
     - **`-Verbose`**: Provides detailed output during execution.
     - **`-MaxJobs`**: Limits the number of concurrent jobs (set to `4` here).
     - **`-ModulePath`**: Path to the module’s `.psd1` file for dependencies.

---

## Viewing Results

1. **Results Directory**:
   - By default, results are saved in directories created for the specified ticker.
   - On a Windows system, the results can be found at:

     ```
     C:\Users\YourUser\AppData\Local\KaspaAPI
     ```

   - Navigate to this directory to review the generated files.

2. **Exported Files**:
   - Look for the following files based on your operations:
     - Token holder snapshots.
     - Unique address lists.
     - Detailed blockchain analysis reports.

---

## Example Workflow

Here’s an example workflow to get started with the **KaspaAPI Module**:

1. **Set Up API References**:

   ```powershell
   Invoke-KasMenu
