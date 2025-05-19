### ATEC - Specialist Technician in Cybersecurity
### Cybersecurity Integration Program 

# 5125_Introduction to Programming

# Student: Luis Felipe vidal Miguel

# Simple Banking System in C++

## Objective
Develop a C++ program that simulates a basic banking system, allowing the management of clients and their bank accounts through various functionalities such as deposits, withdrawals, transfers, as well as listings, searches, and statistics.

---

## Detailed Functionalities

### 1. Client Registration
* **Client Data:**
    * Client Code (Unique ID)
    * Full Name
    * Citizen Card Number
    * NIF (Tax Identification Number)
    * Initial Balance
* **Validations:**
    * Do not allow registration with duplicate NIFs.

### 2. Deposits
* The user will be able to make deposits into existing accounts.
* The deposited amount must be added to the client's current balance.

### 3. Withdrawals
* The user will be able to withdraw amounts.
* **Validations:**
    * There must be sufficient balance in the account for the operation.
* The balance must be updated after the operation.

### 4. Transfers
* Allow transferring an amount from one client to another.
* **Validations:**
    * Do not allow transfers to the client's own account (source account equals destination account).
    * Validate if the source client has sufficient balance for the transfer.

### 5. Client Listing
* Display all registered clients with their data (Code, Name, Citizen Card, NIF) and current balance.

### 6. Client Search
* Allow searching for clients by NIF.

### 7. Banking Statistics
* **Calculations and Displays:**
    * Total money in the bank (sum of all balances).
    * Average client balance.
    * Client with the highest balance.
    * Client with the lowest balance.
    * Quantity of clients with a balance greater than a specific amount (amount to be entered by the user).

---

## General Validations (Applicable to all operations)
* Prevent operations with non-existent clients (e.g., deposit, withdrawal, transfer to an ID or NIF that does not exist).
* Ensure that negative or zero values are not accepted for deposits or transfers.

---

## Preferred Requirements
* **Data Structure:** Use of **Vectors** to store client data.
* **Additional Data Structure (Optional):** **Matrices** can be used, for example, to store the transaction history between clients.
* **Modularization:** Implementation of **Functions** to modularize each operation (e.g., a function for deposit, another for withdrawal, etc.).
* **Interface:** Creation of **Menus** for navigation between the different functionalities of the program.

---