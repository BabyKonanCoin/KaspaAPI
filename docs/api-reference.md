# API Reference

The **KaspaAPI Module** integrates with two primary APIs to provide robust blockchain data access and analysis:

- **Kaspa Explorer API** for general blockchain data.
- **Kasplex Indexer API** for advanced token and holder analysis.

Below, you’ll find an overview of these APIs, their key features, and usage guidance.

---

## 1. Kaspa Explorer API

### Purpose

The **Kaspa Explorer API** allows access to the core blockchain features of Kaspa, such as blocks, transactions, and network data.

### Features

- **Blocks**: Retrieve details about individual blocks, including their hashes, timestamps, and transaction counts.
- **Transactions**: Fetch information about specific transactions using transaction hashes.
- **Address Data**: Query balances and transaction history for specific wallet addresses.

### Official Documentation
👉 [Kaspa Explorer API Documentation](https://api.kaspa.org/docs)

---

## 2. Kasplex Indexer API

### Purpose

The **Kasplex Indexer API** enables deeper analysis of blockchain activity, focusing on token transfers, holder data, and snapshots.

### Features

- **Holder Snapshots**: Retrieve current holder distributions for tokens.
- **Token Activity**: Query transactions and transfer details for KRC20 tokens.
- **Custom Indexing**: Perform advanced queries to extract specific data.

### Official Documentation

👉 [Kasplex Indexer API Documentation](https://docs.kasplex.org/tools-and-reference/kasplex-indexer-api)

---

## Integrating APIs with KaspaAPI Module

The **KaspaAPI Module** simplifies interaction with these APIs using built-in PowerShell cmdlets. Below are examples of how to utilize them:

1. **Query Blockchain Data**:
   - Retrieve transaction details with `Get-KasTx`.
   - Fetch holder snapshots using `Get-KasTop50`.

2. **Analyze Token Activity**:
   - Use `Start-KasBlockTxKrc20` to track token transfers.
   - Explore address data with `Import-KasAddressPool`.

3. **Save Snapshots**:
   - Save token holder distributions for analysis using a combination of cmdlets.

---

## Best Practices for API Use

- **Avoid Overloading the APIs**:
  - Use appropriate delays between requests.
  - Cache results locally when possible.

- **Error Handling**:
  - Anticipate timeouts or errors by using PowerShell’s `try-catch` mechanism.

- **Follow API Guidelines**:
  - Always adhere to the API providers’ usage terms.

---

## Additional Resources

- **Kaspa Explorer API**: [https://api.kaspa.org/docs](https://api.kaspa.org/docs)
- **Kasplex Indexer API**: [https://docs.kasplex.org/tools-and-reference/kasplex-indexer-api](https://docs.kasplex.org/tools-and-reference/kasplex-indexer-api)

---

## Disclaimer

By using the KaspaAPI Module, users agree to the following:

1. **Third-Party APIs**:
   - The module relies on third-party APIs and their availability, functionality, and data accuracy cannot be guaranteed.

2. **Responsibility**:
   - Users are responsible for complying with the terms of service of these APIs.

3. **Liability**:
   - The KaspaAPI Module maintainers are not liable for issues arising from API usage or changes.

---
