
#include <conio.h> // For _getch()
#include <iostream> // For console input/output
#include <string> // For string manipulation
#include <vector> // For using vectors
#include <iomanip> // For setting output format
#include <fstream> // For file operations   
#include <windows.h> // For Windows-specific console functions
#include <clocale> // For setting locale
#include <limits> // For numeric limits
#include <variant> // For using std::variant
#include <cmath> // For using std::abs
#include "include/nlohmann/json.hpp" // For JSON handling

using namespace std; // Using standard namespace
using json = nlohmann::json; // Using nlohmann::json for JSON handling


// Constants to determine maximum number of clients and movements

const int MAX_CLIENTS = 100;
const int MAX_MOVES = 500;


// Data structures (arrays) to hold client and movement information

string clientNames[MAX_CLIENTS];
variant<int, double> clientData[MAX_CLIENTS][4];
variant<int, double> movements[MAX_MOVES][4];

#undef max // Avoid conflict with std::max in order to use std::abs


// Global variables to keep track of the number of clients and movements

int clientCount = 0; // Number of clients registered
int moveCount = 0; // Number of movements recorded
int loggedInID = -1; // Initialize the variable to -1 to indicate no user is logged in
bool isAdmin = false; // Flag to check if the logged-in user is an admin


// Function to print currency values with two decimal places

void printCurrency(double value) {
    cout << fixed << setprecision(2) << value;
}


// Function to confirm an action with the user

bool confirmAction(const string& msg) {
    char response;
    cout << msg << " (Y/N): ";
    cin >> response;
	cin.ignore(numeric_limits<streamsize>::max(), '\n');
    return response == 'Y' || response == 'y';
}


// Function to verify if the NIF exists in the system

bool isNifDuplicate(int nif, int currentClientIndex = -1) {
	for (int i = 1; i < clientCount; ++i) { // Skip the first client (admin)
		if (i == currentClientIndex) continue; // Skip the current client
        try {
            if (get<int>(clientData[i][2]) == nif) { // NIF matches another client
				return true; // Duplicate found
            }
        }
        catch (const bad_variant_access& e) { // wrong type stored in variant
            cerr << "Warning: Error accessing NIF of client ID " << i << ": " << e.what() << endl;
        }
    }
	return false; // No duplicates found
}


// Validates the NIF input

bool getValidNIF(int& nif, bool checkDuplicate = true) {
    string nifInput; // Temporary string to hold the raw user input
    cout << "NIF (9 digits): "; // Prompt on the console
    getline(cin, nifInput); // Read an entire line from standard input

    // Trim surrounding whitespace (leading + trailing)
    nifInput.erase(0, nifInput.find_first_not_of(" \t\n\r\f\v")); // Remove leading whitespace
    nifInput.erase(nifInput.find_last_not_of(" \t\n\r\f\v") + 1); // Remove trailing whitespace

    // Basic format check: exactly 9 digits, nothing else
    if (nifInput.length() != 9 || // Must be 9 characters
        nifInput.find_first_not_of("0123456789") != string::npos) { // All must be digits
        cout << "Invalid NIF. It must contain exactly 9 numeric digits.\n";
        return false; // Reject malformed input
    }

    // Convert to integer and perform additional checks
    try {
        nif = stoi(nifInput); // Convert the validated string to an int

		if (checkDuplicate && isNifDuplicate(nif)) { // Check for duplicates
            cout << "NIF already registered.\n";
            return false; // Duplicate found (invalid)
        }

        return true; // All validations succeeded
    }
    catch (const invalid_argument& e) { // stoi threw: string wasn’t a valid number
        cout << "Invalid NIF value.\n";
        return false;
    }
    catch (const out_of_range& e) { // stoi threw: number doesn’t fit in an int
        cout << "NIF value out of range.\n";
        return false;
    }
}


// Searches for a client by their NIF and returns their index, or -1 if not found

int findClientByNIF(int nif) {
    for (int i = 1; i < clientCount; i++) {
        try {
            if (get<int>(clientData[i][2]) == nif) return i; // Return index if NIF matches
        }
		catch (const bad_variant_access& e) { // Handle cases where the variant type is incorrect
            cerr << "Warning: Error accessing NIF of client ID " << i << " during search: " << e.what() << endl;
        }
    }
    return -1; // Not found
}


// Saves all client and movement data to a JSON file

void saveToFile() {
    json j;
	j["clients"] = json::array(); // Array to hold client data

    for (int i = 0; i < clientCount; i++) {
        try {
			j["clients"].push_back({ // Client data
				{"id", get<int>(clientData[i][0])}, // Client ID
				{"pin", get<int>(clientData[i][1])}, // Client PIN
				{"nif", get<int>(clientData[i][2])}, // Client NIF
				{"balance", get<double>(clientData[i][3])}, // Client balance
                {"name", clientNames[i]}
                });
        }
        catch (const bad_variant_access& e) {
            cerr << "Error preparing data for client ID " << i << " to save: " << e.what() << endl;
        }
    }

	j["movements"] = json::array(); // Array to hold movement data
    for (int i = 0; i < moveCount; i++) {
        try {
			j["movements"].push_back({ // Movement data
				{"type", get<int>(movements[i][0])}, // Movement type
				{"amount", get<double>(movements[i][1])}, // Movement amount
				{"from", get<int>(movements[i][2])}, // Sender ID
				{"to", get<int>(movements[i][3])} // Receiver ID
                });
        }
        catch (const bad_variant_access& e) {
            cerr << "Error preparing data for movement " << i << " to save: " << e.what() << endl;
        }
    }

    ofstream file("database.json", ios::binary | ios::trunc);
    if (file.is_open()) {
        unsigned char bom[] = { 0xEF, 0xBB, 0xBF }; // Add UTF-8 BOM
        file.write(reinterpret_cast<char*>(bom), sizeof(bom));
        file << j.dump(4); // Pretty-print JSON with indent of 4 spaces
        file.close();
    }
    else {
        cerr << "Critical Error: Failed to open 'database.json' for writing.\n";
    }
}

// Loads client and movement data from the JSON file
void loadFromFile() {
	ifstream file("database.json");
    if (!file.is_open()) {
        cout << "Info: 'database.json' not found. A new one will be created.\n";
        clientCount = 0;
        moveCount = 0;
        clientData[0][0] = 0;
        clientData[0][1] = 1234;
        clientData[0][2] = 0;
        clientData[0][3] = 0.0;
        clientNames[0] = "Admin";
        clientCount = 1;
        cout << "Admin initialized with PIN 1234.\n";
        saveToFile();
        return;
    }

    json j;
    try {
        char bom_check[3];
        file.read(bom_check, 3);
        if (!(static_cast<unsigned char>(bom_check[0]) == 0xEF &&
            static_cast<unsigned char>(bom_check[1]) == 0xBB &&
            static_cast<unsigned char>(bom_check[2]) == 0xBF)) {
            file.seekg(0, ios::beg); // No BOM detected, rewind
        }
        file >> j;
    }
    catch (const json::parse_error& e) {
        cerr << "Critical Error reading/parsing JSON: " << e.what() << " at position " << e.byte << "\n";
        cerr << "'database.json' may be corrupted. The program cannot continue safely.\n";
        file.close();
        exit(1);
    }
    catch (const exception& e) {
        cerr << "General critical error reading file: " << e.what() << "\n";
        file.close();
        exit(1);
    }
    file.close();

    clientCount = 0;
    moveCount = 0;

    // Load clients
    if (j.contains("clients") && j["clients"].is_array()) {
        for (const auto& c : j["clients"]) {
            if (clientCount >= MAX_CLIENTS) {
                cerr << "Warning: Maximum number of clients (" << MAX_CLIENTS << ") reached while loading. Some clients may not have been loaded.\n";
                break;
            }
            if (!c.is_object()) {
                cerr << "Warning: Invalid client entry in JSON (not an object).\n";
                continue;
            }

            int id = c.value("id", -1);
            int pin = c.value("pin", -1);
            int nif = c.value("nif", -1);
            double balance = c.value("balance", 0.0);
            string name = c.value("name", "");

            if (id < 0 || pin < 0 || (id > 0 && nif <= 0) || name.empty()) {
                cerr << "Warning: Invalid data for client in JSON (ID: " << id << "). Client ignored.\n";
                continue;
            }

            if (id > 0 && isNifDuplicate(nif, clientCount)) {
                cerr << "Warning: Duplicate NIF (" << nif << ") found in JSON for ID " << id << ". Client ignored.\n";
                continue;
            }

			clientData[clientCount][0] = id; // ID
			clientData[clientCount][1] = pin; // PIN
			clientData[clientCount][2] = nif; // NIF
			clientData[clientCount][3] = round(balance * 100.0) / 100.0; // Balance
			clientNames[clientCount] = name; // Name
			clientCount++; // Increment client count
        }
    }
    else {
        cout << "Info: 'clients' section not found or invalid in JSON. Only Admin may be available.\n";
    }

	// Ensure at least the admin exists if no clients were loaded
    if (clientCount == 0) {
        clientData[0][0] = 0;
        clientData[0][1] = 1234;
        clientData[0][2] = 0;
        clientData[0][3] = 0.0;
        clientNames[0] = "Admin";
        clientCount = 1;
        cout << "Admin (re)initialized with PIN 1234.\n";
    }

    // Load movements
    if (j.contains("movements") && j["movements"].is_array()) {
        for (const auto& m : j["movements"]) {
            if (moveCount >= MAX_MOVES) {
                cerr << "Warning: Maximum number of movements (" << MAX_MOVES << ") reached while loading.\n";
                break;
            }
            if (!m.is_object()) {
                cerr << "Warning: Invalid movement entry in JSON (not an object).\n";
                continue;
            }

            int type = m.value("type", -1);
            double amount = m.value("amount", -1.0);
            int from = m.value("from", -1);
            int to = m.value("to", -1);

            if (type < 1 || type > 3 || amount < 0.0 || from < 0 || to < 0) {
                cerr << "Warning: Invalid data for movement in JSON. Movement ignored.\n";
                continue;
            }

            movements[moveCount][0] = type;
            movements[moveCount][1] = round(amount * 100.0) / 100.0;
            movements[moveCount][2] = from;
            movements[moveCount][3] = to;
            moveCount++;
        }
    }
    else {
        cout << "Info: 'movements' section not found or invalid in JSON.\n";
    }

    cout << "Data loaded. Clients: " << clientCount - 1 << ", Movements: " << moveCount << "\n";
}


// Handles the process of registering a new client

void registerClient() {

    cout << "\n--- Register Client ---\n\n";

	if (clientCount >= MAX_CLIENTS) { // Check if maximum client capacity is reached
        cout << "Maximum client capacity reached.\n";
        return;
    }

    string name;
    int pin;
    int nif = -1;
    double balance;

    cout << "Name: ";
    getline(cin, name); // Read full name input from the user

    if (name.empty()) {
        cout << "Name cannot be empty.\n";
        return;
    }

    string pinInput = "";
    char ch;

    cout << "PIN (4 digits): ";

    while (_kbhit()) {
        _getch(); // Clear any pre-pressed keys in the input buffer
    }

    // Read 4-digit PIN from user while masking input with '*'
    while (true) {
        ch = _getch();
        if (ch == '\r' || ch == '\n') {
            break; // Enter key pressed
        }
        if (ch == '\b' && !pinInput.empty()) {
            cout << "\b \b"; // Handle backspace: erase character visually and from string
            pinInput.pop_back();
        }
        else if (isdigit(ch) && pinInput.length() < 4) {
            pinInput += ch;
            cout << '*'; // Mask the digit
        }
    }

    cout << '\n';

    if (pinInput.length() != 4) {
        cout << "Invalid PIN. It must contain exactly 4 numeric digits.\n";
        return;
    }

    try {
        pin = stoi(pinInput); // Convert PIN string to integer
    }
    catch (...) {
        cout << "Internal error converting PIN.\n";
        return;
    }

    // Request and validate NIF (may check for duplicates)
    if (!getValidNIF(nif)) {
        return;
    }

    string balanceInput;
    cout << "Initial Balance: ";

    // Loop until a valid numeric and non-negative balance is entered
    while (true) {
        getline(cin, balanceInput);
		balanceInput.erase(0, balanceInput.find_first_not_of(" \t\n\r\f\v")); // Trim leading spaces
		balanceInput.erase(balanceInput.find_last_not_of(" \t\n\r\f\v") + 1); // Trim trailing spaces
        try {
            size_t processedChars;
            balance = stod(balanceInput, &processedChars); // Try converting input to double
            if (processedChars == balanceInput.length() && balance >= 0.0) {
                balance = round(balance * 100.0) / 100.0; // Round to 2 decimal places
                break;
            }
            else {
                cout << "Invalid or negative value. Try again: ";
            }
        }
        catch (...) {
            cout << "Invalid input. Please enter a numeric value: ";
        }
    }

    // Display entered data for confirmation
    cout << "\n-- Review Data --\n";
    cout << "Name: " << name << "\n";
    cout << "PIN: ****\n"; // Mask PIN display
    cout << "NIF: " << nif << "\n";
    cout << "Initial Balance: "; printCurrency(balance); cout << "\n";

    // Ask user to confirm registration
    if (!confirmAction("Confirm client registration?")) {
        cout << "Client registration canceled.\n";
        return;
    }

    // Store client data
    clientNames[clientCount] = name;
    clientData[clientCount][0] = clientCount; // ID
    clientData[clientCount][1] = pin;
    clientData[clientCount][2] = nif;
    clientData[clientCount][3] = balance;

    cout << "Client registered with ID: " << clientCount << "\n";
    clientCount++;

    saveToFile(); // Persist updated data to disk
}


// Reads a positive double value from user input with validation

bool readPositiveDouble(const string& prompt, double& value) {
    string input;
    cout << prompt;

    while (true) {
        getline(cin, input); // Read user input
        input.erase(0, input.find_first_not_of(" \t\n\r\f\v")); // Trim leading spaces
        input.erase(input.find_last_not_of(" \t\n\r\f\v") + 1); // Trim trailing spaces

        try {
            size_t processedChars;
            value = stod(input, &processedChars); // Convert to double

            // Check if all characters were valid and value is positive
            if (processedChars == input.length() && value > 0.0) {
                value = round(value * 100.0) / 100.0; // Round to 2 decimal places
				return true; // Valid input
            }
            else {
                cout << "Invalid amount. It must be a positive number. Try again: ";
            }
        }
        catch (...) {
            cout << "Invalid input. Please enter a positive numeric value: ";
        }
    }
}


// Reads a valid client ID from user input (must exist and not be admin) - not being used for now

bool readClientID(const string& prompt, int& id) {
    string input;
    cout << prompt;

    while (true) {
        getline(cin, input);
        input.erase(0, input.find_first_not_of(" \t\n\r\f\v"));
        input.erase(input.find_last_not_of(" \t\n\r\f\v") + 1);

        try {
            id = stoi(input); // Convert input to integer
            if (id > 0 && id < clientCount) {
                return true;
            }
            else {
                cout << "Invalid or non-existent client ID. Try again: ";
            }
        }
        catch (...) {
            cout << "Invalid input. Please enter a numeric ID: ";
        }
    }
}


// Allows a user or admin to deposit funds into a client's account

void deposit() {
	cout << "\n--- Deposits (" << (isAdmin ? "Admin" : clientNames[loggedInID]) << ") ---\n\n"; // Checks if user is admin or not

	int targetID = -1; // Initialize targetID to -1
    int nif;
    cout << "NIF to deposit into: ";

	if (!getValidNIF(nif, false)) return; // Calls the function getValidNIF without duplicate check or it would return an error because the NIF exists already
    targetID = findClientByNIF(nif);

    if (targetID == -1) {
        cout << "Client with NIF " << nif << " not found.\n";
        return;
    }

    double amount;
	if (!readPositiveDouble("Deposit amount: ", amount)) return; // If the function readPositiveDouble returns false, it means the user input was invalid, then it returns (because the if condition is true)

    try {
        string targetName = clientNames[targetID];
        cout << "Confirm deposit of "; printCurrency(amount);
        cout << " to " << targetName << " (NIF: " << nif << ")?";

        if (!confirmAction("")) {
            cout << "Deposit canceled.\n";
            return;
        }

		double currentBalance = get<double>(clientData[targetID][3]); // Get current balance
		clientData[targetID][3] = currentBalance + amount; // Update balance

		// Record the movement
        if (moveCount < MAX_MOVES) {
            movements[moveCount][0] = 1; // Deposit type
            movements[moveCount][1] = amount;
            movements[moveCount][2] = loggedInID;
            movements[moveCount][3] = targetID;
            moveCount++;
        }
        else {
            cout << "Warning: Movement record limit reached.\n";
        }

        cout << "Deposit of "; printCurrency(amount);
        cout << " successfully made to " << targetName << " (NIF: " << nif << ").\n";

        if (isAdmin || loggedInID == targetID) {
            cout << "New balance: "; printCurrency(get<double>(clientData[targetID][3])); cout << "\n";
        }

        saveToFile();
    }
    catch (const bad_variant_access& e) {
        cerr << "Internal error accessing data for client ID " << targetID << ": " << e.what() << endl;
        cout << "Deposit failed due to internal error.\n";
    }
    catch (const out_of_range& oor) {
        cerr << "Error: Invalid client ID (" << targetID << ") when attempting deposit.\n";
    }
}


// Allows a user to withdraw funds from his own account

void withdraw() {
	cout << "\n--- Withdrawals (" << (isAdmin ? "Admin" : clientNames[loggedInID]) << ") ---\n\n"; // Checks if user is admin or not

	int targetID = -1; // Initialize targetID to -1
	int nif = -1; // Initialize NIF to -1

	if (isAdmin) { // Admin can specify the client
        cout << "Client NIF to withdraw from: ";
		if (!getValidNIF(nif, false)) return; // Get NIF without duplicate check
		targetID = findClientByNIF(nif); // Calls the function to find the client by NIF
        if (targetID == -1) {
            cout << "Client with NIF " << nif << " not found.\n";
            return;
        }
    }
	else { // User can only withdraw from their own account
		targetID = loggedInID; // Because the client can only withdraw from his own account
        if (targetID <= 0 || targetID >= clientCount) {
            cout << "Error: Invalid user ID.\n";
            return;
        }
        try {
			nif = get<int>(clientData[targetID][2]); // Get NIF from logged user
        }
        catch (const bad_variant_access& e) {
            cerr << "Error accessing NIF for current user: " << e.what() << endl;
            return;
        }
        cout << "Withdrawal from your account (NIF: " << nif << ")\n";
    }

    double amount;
    if (!readPositiveDouble("Withdrawal amount: ", amount)) return;

    try {
		double currentBalance = get<double>(clientData[targetID][3]); // Get current balance
		string targetName = clientNames[targetID]; // Get client name

		if (amount > currentBalance) { // Check if the amount is greater than the current balance
            cout << "Insufficient funds. " << targetName
                << " only has "; printCurrency(currentBalance); cout << " available.\n";
            return;
        }

        cout << "Confirm withdrawal of "; printCurrency(amount);
        cout << " from " << targetName << " (NIF: " << nif << ")?";

        if (!confirmAction("")) {
            cout << "Withdrawal canceled.\n";
            return;
        }

		clientData[targetID][3] = currentBalance - amount; // Update balance

		// Record the movement
        if (moveCount < MAX_MOVES) {
            movements[moveCount][0] = 2; // Withdrawal type
            movements[moveCount][1] = amount;
            movements[moveCount][2] = targetID;
            movements[moveCount][3] = targetID;
            moveCount++;
        }
        else {
            cout << "Warning: Movement record limit reached.\n";
        }

        cout << "Withdrawal of "; printCurrency(amount);
        cout << " successfully made from " << targetName << " (NIF: " << nif << ").\n";
        cout << "Remaining balance: "; printCurrency(get<double>(clientData[targetID][3])); cout << "\n";

        saveToFile();
    }
    catch (const bad_variant_access& e) {
        cerr << "Internal error accessing data for client ID " << targetID << ": " << e.what() << endl;
        cout << "Withdrawal failed due to internal error.\n";
    }
    catch (const out_of_range& oor) {
        cerr << "Error: Invalid client ID (" << targetID << ") when attempting withdrawal.\n";
    }
}


// Transfers funds from one client to another (admin can specify both)

void transfer() {
    cout << "\n--- Transfers (" << (isAdmin ? "Admin" : clientNames[loggedInID]) << ") ---\n\n"; // Checks if user is admin or not

    int fromNIF_int, toNIF_int;
    int fromID = -1, toID = -1;

	if (isAdmin) { // Admin can specify the sender
        cout << "Sender ";
		if (!getValidNIF(fromNIF_int, false)) return; // Get NIF without duplicate check
        fromID = findClientByNIF(fromNIF_int);
        if (fromID == -1) {
            cout << "Sender client with NIF " << fromNIF_int << " not found.\n";
            return;
        }
    }
    else { // User can only transfer from their own account
		fromID = loggedInID; // fromID is the logged-in user
        try {
            fromNIF_int = get<int>(clientData[fromID][2]);
            cout << "--- Transfer from your account (NIF: " << fromNIF_int << ") ---\n";
        }
        catch (const bad_variant_access& e) {
            cerr << "Error obtaining sender NIF (ID: " << fromID << "): " << e.what() << endl;
            return;
        }
    }

    cout << "Receiver ";
	if (!getValidNIF(toNIF_int, false)) return; // Get NIF without duplicate check
	toID = findClientByNIF(toNIF_int); // Calls the function to find the client by NIF

	if (toID == -1) { // If NIF is not found, print error message
        cout << "Receiver client with NIF " << toNIF_int << " not found.\n";
        return;
    }

	if (fromID == toID) { // Check if sender and receiver are the same
        cout << "Cannot transfer to the same account.\n";
        return;
    }

    double amount;
    if (!readPositiveDouble("Transfer amount: ", amount)) return;

    try {
		double fromBalance = get<double>(clientData[fromID][3]); // Get sender's current balance
		string fromName = clientNames[fromID]; // Get sender's name
		string toName = clientNames[toID]; // Get receiver's name

        if (amount > fromBalance) {
            cout << "Insufficient funds. " << fromName
                << " only has "; printCurrency(fromBalance); cout << " available.\n";
            return;
        }

        cout << "Confirm transfer of "; printCurrency(amount);
        cout << " from " << fromName << " (NIF: " << fromNIF_int << ")"
            << " to " << toName << " (NIF: " << toNIF_int << ")?";

        if (!confirmAction("")) {
            cout << "Transfer canceled.\n";
            return;
        }

        double toBalance = get<double>(clientData[toID][3]);
        clientData[fromID][3] = fromBalance - amount;
        clientData[toID][3] = toBalance + amount;

		// Record the movement
        if (moveCount < MAX_MOVES) {
            movements[moveCount][0] = 3; // Transfer type
            movements[moveCount][1] = amount;
            movements[moveCount][2] = fromID;
            movements[moveCount][3] = toID;
            moveCount++;
        }
        else {
            cout << "Warning: Movement record limit reached.\n";
        }

        cout << "Transfer of "; printCurrency(amount); cout << " successfully made.\n";
        cout << "New balance of " << fromName << ": "; printCurrency(get<double>(clientData[fromID][3])); cout << "\n";

        if (isAdmin) {
            cout << "New balance of " << toName << ": "; printCurrency(get<double>(clientData[toID][3])); cout << "\n";
        }

        saveToFile();
    }
    catch (const bad_variant_access& e) {
        cerr << "Internal error accessing data for clients (ID " << fromID << " or " << toID << "): " << e.what() << endl;
        cout << "Transfer failed due to internal error.\n";
    }
    catch (const out_of_range& oor) {
        cerr << "Error: Invalid client ID (" << fromID << " or " << toID << ") when attempting transfer.\n";
    }
}


// Lists all registered clients (excluding Admin) in a formatted table

void listClients() {

    cout << "\n--- Client List ---\n\n";

    // Print table headers
    cout << left << setw(8) << "ID"
        << left << setw(30) << "Name"
        << left << setw(15) << "NIF"
        << right << setw(20) << "Balance" << "\n";

    cout << setfill('-') << setw(73) << "" << setfill(' ') << "\n";

    bool hasClients = false;

    for (int i = 1; i < clientCount; i++) {
        try {
            // Display each client’s ID, name, NIF, and balance
            cout << left << setw(8) << get<int>(clientData[i][0])
                << left << setw(30) << clientNames[i]
                << left << setw(15) << get<int>(clientData[i][2])
                    << right << setw(20) << fixed << setprecision(2) << get<double>(clientData[i][3])
                    << "\n";
                hasClients = true;
        }
        catch (const bad_variant_access& e) {
            // Handle corrupted variant data
            cerr << "Error reading data for client ID " << i << ": " << e.what() << endl;
            cout << left << setw(8) << i
                << left << setw(30) << (clientNames[i].empty() ? "[Invalid Name]" : clientNames[i])
                << left << setw(35) << "[Error reading NIF/Balance data]" << "\n";
        }
        catch (const out_of_range& oor) {
            cerr << "Error: Index out of bounds when listing client " << i << endl;
        }
    }

	if (!hasClients) { // If no clients were found
        cout << "No clients registered (besides admin).\n";
    }

    cout << setfill('-') << setw(73) << "" << setfill(' ') << "\n";
}


// Searches for a client by their NIF and displays their data

void searchByNIF() {

    cout << "--- Search Client by NIF ---\n\n";

    int nif;
    string nifInput;

    cout << "NIF to search (9 digits): ";
    getline(cin, nifInput);

    // Trim whitespace
    nifInput.erase(0, nifInput.find_first_not_of(" \t\n\r\f\v"));
    nifInput.erase(nifInput.find_last_not_of(" \t\n\r\f\v") + 1);

    // Validate format
    if (nifInput.length() != 9 || nifInput.find_first_not_of("0123456789") != string::npos) {
        cout << "Invalid NIF format. It must contain exactly 9 numeric digits.\n";
        return;
    }

    try {
        nif = stoi(nifInput); // Convert to integer
    }
    catch (...) {
        cout << "Invalid NIF value.\n";
        return;
    }

	int id = findClientByNIF(nif); // Calls the function to find the client by NIF
    if (id == -1) {
        cout << "Client with NIF " << nif << " not found.\n";
        return;
    }

    try {
        // Display client information
        cout << "\n--- Client Found ---\n";
        cout << "ID : " << id << "\n";
        cout << "Name : " << clientNames[id] << "\n";
        cout << "NIF : " << get<int>(clientData[id][2]) << "\n";
        cout << "Balance : "; printCurrency(get<double>(clientData[id][3])); cout << "\n";
        cout << "-------------------------\n";
    }
    catch (const bad_variant_access& e) {
        cerr << "Error accessing data for found client (ID " << id << "): " << e.what() << endl;
    }
    catch (const out_of_range& oor) {
        cerr << "Error: Invalid client ID (" << id << ") after search.\n";
    }
}


// Calculates and displays statistics about registered clients

void statistics() {
    cout << "\n--- Bank Statistics ---\n";

	if (clientCount <= 1) { // If client count is equal to 1 (only admin exists)
        cout << "\nNot enough clients to calculate statistics.\n";
        return;
    }

    do {
		double totalBalance = 0.0; // Initialize total balance
		int richestClientID = -1, poorestClientID = -1; // Initialize richest and poorest client IDs
		double maxBalance = -1.0, minBalance = -1.0; // Initialize max and min balances
		int clientBaseCount = clientCount - 1; // Exclude admin from count

        for (int i = 1; i < clientCount; i++) {
            try {
				double balance = get<double>(clientData[i][3]); // Get balance for each client
				totalBalance += balance; // Update total balance

                // Identify richest and poorest clients
				if (richestClientID == -1 || balance > maxBalance) { // If client's balance is greater than max balance
					richestClientID = i; // Update richest client ID
					maxBalance = balance; // Update max balance
                }
				if (poorestClientID == -1 || balance < minBalance) { // If client's balance is less than min balance
					poorestClientID = i; // Update poorest client ID
					minBalance = balance; // Update min balance
                }
            }
            catch (const bad_variant_access& e) {
                cerr << "Warning: Error accessing balance for client ID " << i << ": " << e.what() << endl;
                clientBaseCount--;
            }
            catch (const out_of_range& oor) {
                cerr << "Error: Index out of bounds (" << i << ") in statistics.\n";
                clientBaseCount--;
            }
        }

        if (clientBaseCount <= 0) {
            cout << "No valid client data found for statistics.\n";
            return;
        }

		double averageBalance = totalBalance / clientBaseCount; // Calculate average balance

        cout << "\n";
        cout << "Number of Clients (excluding Admin): " << clientBaseCount << "\n";
        cout << "Total Balance in Bank : "; printCurrency(totalBalance); cout << "\n";
        cout << "Average Balance per Client : "; printCurrency(averageBalance); cout << "\n";

        try {
            cout << "Richest Client : " << clientNames[richestClientID]
                << " (ID: " << richestClientID << ") with "; printCurrency(maxBalance); cout << "\n";
                cout << "Poorest Client : " << clientNames[poorestClientID]
                    << " (ID: " << poorestClientID << ") with "; printCurrency(minBalance); cout << "\n";
        }
        catch (...) {
            cerr << "Error accessing data for richest/poorest client.\n";
        }

        // Ask user to define a threshold
        double threshold;
        string thresholdInput;
        cout << "Enter a balance threshold to count clients above it: ";

        while (true) {
            getline(cin, thresholdInput);
            thresholdInput.erase(0, thresholdInput.find_first_not_of(" \t\n\r\f\v"));
            thresholdInput.erase(thresholdInput.find_last_not_of(" \t\n\r\f\v") + 1);
            try {
                size_t processed;
                threshold = stod(thresholdInput, &processed);
                if (processed == thresholdInput.length()) break;
                else cout << "Invalid input. Enter a numeric value for the threshold: ";
            }
            catch (...) {
                cout << "Invalid input. Enter a numeric value for the threshold: ";
            }
        }

        int aboveThresholdCount = 0;
        for (int i = 1; i < clientCount; i++) {
            try {
				if (get<double>(clientData[i][3]) > threshold) { // Check if client's balance is above threshold
					aboveThresholdCount++; // Increment count
                }
            }
            catch (...) {} // Ignore invalid entries
        }

        cout << "Number of Clients with Balance > ";
        printCurrency(threshold); cout << ": " << aboveThresholdCount << "\n";
        cout << "-----------------------------\n";

	} while (confirmAction("Run statistics again?")); // Ask user if they want to run statistics again and while the bool is true it will loop
}


// Displays the history of all account movements (deposits, withdrawals, transfers)

void displayMovements() {

    cout << "\n--- Movements History ---\n\n";

    // Print table header
    cout << left << setw(15) << "Type"
        << right << setw(15) << "Amount"
        << right << setw(15) << ""
        << left << setw(30) << " Sender (ID/Name)"
        << left << setw(30) << " Receiver (ID/Name)" << "\n";

    cout << setfill('-') << setw(90) << "" << setfill(' ') << "\n";

    if (moveCount == 0) {
        cout << "No movements recorded.\n";
        cout << setfill('-') << setw(90) << "" << setfill(' ') << "\n";
        return;
    }

    for (int i = 0; i < moveCount; i++) {
        try {
			int type = get<int>(movements[i][0]); // Movement type
            double amount = get<double>(movements[i][1]);
            int fromID = get<int>(movements[i][2]);
            int toID = get<int>(movements[i][3]);

            string typeDescription, fromInfo = "N/A", toInfo = "N/A";
            string fromName = (fromID >= 0 && fromID < clientCount) ? clientNames[fromID] : "[Invalid ID]";
            string toName = (toID >= 0 && toID < clientCount) ? clientNames[toID] : "[Invalid ID]";

            switch (type) {
            case 1: // Deposit
                typeDescription = "Deposit";
				fromInfo = (fromID == 0) ? " --- " : " " + to_string(fromID) + " | " + fromName; // If fromID is 0 (admin), show "---", else show ID and name
				toInfo = " " + to_string(toID) + " | " + toName; // Receiver ID and name
                break;
            case 2: // Withdrawal
                typeDescription = "Withdrawal";
				fromInfo = " " + to_string(fromID) + " | " + fromName; // From ID and name
				toInfo = " --- "; // Receiver is not applicable
                break;
            case 3: // Transfer
                typeDescription = "Transfer";
				fromInfo = " " + to_string(fromID) + " | " + fromName; // Sender ID and name
				toInfo = " " + to_string(toID) + " | " + toName; // Receiver ID and name
                break;
			default: // Default case for unknown type
                typeDescription = "Unknown";
                fromInfo = " " + to_string(fromID);
                toInfo = " " + to_string(toID);
                break;
            }

            // Print movement row
            cout << left << setw(15) << typeDescription
                << right << setw(15) << fixed << setprecision(2) << amount
                << right << setw(15) << ""
                << left << setw(30) << fromInfo
                << left << setw(30) << toInfo << "\n";
        }
        catch (const bad_variant_access& e) {
            cerr << "Error reading data for movement index " << i << ": " << e.what() << endl;
            cout << left << setw(15) << "[Read Error]"
                << right << setw(15) << "???"
                << left << setw(60) << " [Corrupted movement data]" << "\n";
        }
        catch (const out_of_range& oor) {
            cerr << "Error: Index out of bounds when accessing movement " << i << endl;
        }
    }

    cout << setfill('-') << setw(90) << "" << setfill(' ') << "\n";
}


// Clears the console screen depending on the operating system

void clearScreen() {
#ifdef _WIN32
    system("cls"); // Windows command
#else
    system("clear"); // Unix/Linux/MacOS command
#endif
}


// Displays the main menu

void menu() {
    int choice;
    do {
        cout << "\n--- Main Menu (" << (isAdmin ? "Admin" : clientNames[loggedInID]) << ") ---\n\n";

        // Show different options based on user type
        if (isAdmin) {
            cout << "1. Register Client\n";
            cout << "2. Deposit\n";
            cout << "3. Withdraw\n";
            cout << "4. Transfer\n";
            cout << "5. List Clients\n";
            cout << "6. Search Client by NIF\n";
            cout << "7. Statistics\n";
            cout << "8. Movement History\n";
            cout << "9. Logout\n";
            cout << "0. Exit Program\n";
        }
        else {
            cout << "1. View Balance\n";
            cout << "2. Deposit\n";
            cout << "3. Withdraw\n";
            cout << "4. Transfer\n";
            cout << "5. Personal Movement History\n";
            cout << "9. Logout\n";
            cout << "0. Exit Program\n";
        }

        cout << "Choice: ";
        string choiceInput;
        getline(cin, choiceInput);

        try {
			size_t processedChars; // Convert input to integer
            choice = stoi(choiceInput, &processedChars);
			if (processedChars != choiceInput.length()) { // Check if all characters were processed and if it matches the input length
                choice = -1; // Invalid characters detected
            }
        }
        catch (...) {
            choice = -1;
        }

        clearScreen();

		if (isAdmin) { // Admin menu options
            switch (choice) {
			case 1: registerClient(); break; // Register a new client and break the loop
            case 2: deposit(); break;
            case 3: withdraw(); break;
            case 4: transfer(); break;
            case 5: listClients(); break;
            case 6: searchByNIF(); break;
            case 7: statistics(); break;
            case 8: displayMovements(); break;
            case 9:
                loggedInID = -1;
                isAdmin = false;
                return;
            case 0:
                if (confirmAction("Are you sure you want to exit the program?")) {
                    cout << "Exiting...\n";
                    saveToFile();
                    exit(0);
                }
                break;
            default: cout << "Invalid option.\n";
            }
        }
		else { // User menu options
            switch (choice) {
            case 1:
                try {
                    cout << "--- Your Balance ---\n";
                    cout << "Current balance: ";
					printCurrency(get<double>(clientData[loggedInID][3])); // Print balance
                    cout << "\n-------------------\n";
                }
                catch (...) {
                    cerr << "Error accessing balance.\n";
                }
                break;
            case 2: deposit(); break;
            case 3: withdraw(); break;
            case 4: transfer(); break;
            case 5:
                cout << "\n--- Your Movement History ---\n";
				cout << "(Personal movement history filter functionality pending)\n"; // Placeholder for future implementation
                break;
            case 9:
                loggedInID = -1;
                isAdmin = false;
                cout << "\nLogout successful.\n\n";
                return;
            case 0:
                if (confirmAction("Are you sure you want to exit the program?")) {
                    cout << "Exiting...\n";
                    saveToFile();
                    exit(0);
                }
                break;
            default: cout << "Invalid option.\n";
            }
        }

		if (choice != 0 && choice != 9) { // If the choice is not to exit or logout
            cout << "\nPress Enter to continue...";
			cin.get(); // Wait for user input
			clearScreen(); // Clear the screen again
        }
    } while (true);
}


// Reads a 4-digit PIN from the user while hiding input with asterisks

bool readHiddenPin(const string& prompt, int& pin) {
    string pinInput = "";
    char ch;
    cout << prompt;

    while (true) {
        ch = _getch(); // Read character without echo
        if (ch == '\r' || ch == '\n') break; // Enter pressed
        if (ch == '\b' && !pinInput.empty()) {
            cout << "\b \b";
            pinInput.pop_back();
        }
        else if (isdigit(ch) && pinInput.length() < 4) {
            pinInput += ch;
            cout << '*'; // Mask input
        }
    }

    cout << '\n';

    if (pinInput.length() != 4) {
        cout << "PIN must be exactly 4 digits.\n";
        return false;
    }

    try {
        pin = stoi(pinInput);
        return true;
    }
    catch (...) {
        cout << "Error processing PIN.\n";
        return false;
    }
}


// Validates login credentials for admin or user

bool validateLogin(int& userId, bool& isAdmin, const string& promptNIF, const string& promptPIN, bool requireNIF) {
    int nif = -1, pin = -1;

	if (requireNIF) { // If NIF is required, prompt for it
        cout << promptNIF;
		if (!getValidNIF(nif, false)) return false; // Get NIF without duplicate check
    }

	if (!readHiddenPin(promptPIN, pin)) return false; // If PIN is not valid, return false

	if (requireNIF) { // If NIF is required, find the client by NIF
        userId = findClientByNIF(nif);
        if (userId == -1) {
            cout << "NIF not found.\n";
            return false;
        }
    }
    else {
		userId = 0; // If NIF is not required, set userId to 0 (admin)
    }

    try {
		if (get<int>(clientData[userId][1]) == pin) { // Check if PIN matches
			isAdmin = (userId == 0); // Concise form to check if userId == 0 then isAdmin = true
            return true;
        }
        else {
            cout << "Invalid PIN.\n";
            return false;
        }
    }
    catch (const bad_variant_access& e) {
        cerr << "Error verifying PIN: " << e.what() << endl;
        return false;
    }
}


// Displays the login menu and handles user/admin login flow

void loginMenu() {
    int option = -1;

    do {
        clearScreen();
        cout << "==================\n";
        cout << "--- Login Menu ---\n";
        cout << "==================\n";
        cout << "1. Admin Login\n";
        cout << "2. User Login\n";
        cout << "0. Exit\n";
        cout << "Choice: ";

        string optionInput;
        getline(cin, optionInput);

        try {
            size_t processed;
            option = stoi(optionInput, &processed);
            if (processed != optionInput.length()) option = -1;
        }
        catch (...) {
            option = -1;
        }

		if (option == 1) { // Admin login
            if (validateLogin(loggedInID, isAdmin, "", "Admin PIN: ", false)) {
                cout << "\n=> Admin login successful!\n";
                menu();
            }
            else {
                cout << "\nPress Enter to try again...";
                cin.get();
            }
        }
		else if (option == 2) { // User login
            if (validateLogin(loggedInID, isAdmin, "User ", "User PIN: ", true)) {
                cout << "User login (" << clientNames[loggedInID] << ") successful!\n";
                menu();
            }
            else {
                cout << "\nPress Enter to try again...";
                cin.get();
            }
        }
        else if (option == 0) {
            if (confirmAction("Are you sure you want to exit?")) {
                cout << "Saving and exiting...\n";
                saveToFile();
                exit(0);
            }
        }
        else {
            cout << "Invalid option.\n";
            cout << "\nPress Enter to try again...";
            cin.get();
        }
    } while (true);
}


// Program entry point

int main() {
    if (setlocale(LC_ALL, "C") == nullptr) {
        cerr << "Warning: Could not set locale to \"C\"." << endl;
    }

#ifdef _WIN32
    // Set console encoding to UTF-8 on Windows
    if (!SetConsoleOutputCP(CP_UTF8)) {
        cerr << "Warning: Could not set console output code page to UTF-8." << endl;
    }
    if (!SetConsoleCP(CP_UTF8)) {
        cerr << "Warning: Could not set console input code page to UTF-8." << endl;
    }
#endif

    loadFromFile();   // Load existing data from JSON
    loginMenu();      // Start login flow
    return 0;
}



