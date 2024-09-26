# AWS RE/START - Cloud Computing and Network Administration
## Introduction to Programming - PL02

# Student: Luís Felipe Vidal Miguel (+2 colleagues)

---

### Objectives
- Solve a problem using lists, dictionaries, and JSON files.

### WORK PROPOSAL
The project aims to implement an operational management module for a Rent-a-car. Create a Python project according to the following instructions:

1. The Rent-a-car has a fleet of cars represented by the `listAutomovel`. This list should store dictionaries with the following keys: `id`, `matricula`, `marca`, `modelo`, `cor`, `portas`, `precoDiario`, `cilindrada`, and `potencia`.
2. Clients should be registered in the `listCliente`. This list should store dictionaries with the following keys: `id`, `nome`, `nif`, `dataNascimento`, `telefone`, and `email`. Note: `telefone` and `email` must be unique.
3. Reservations should be registered in the `listBooking`. This list should store dictionaries with the following keys: `data_inicio`, `data_fim`, `cliente_id`, `automovel_id`, `precoReserva`, and `numeroDias`.

Important Note: `id` represents a unique number to identify a dictionary, just like `NIF` represents a unique taxpayer number for a person.

**Example of records in the lists:**
- **Cliente**: `{1, "João", 221099811, "12-12-2000", 912384448, "joaofranscisco20938@gmail.com"}`
- **Automóvel**: `{4, "AA-44-PP", "Seat", "Ibiza", "Preto", 5, 29.32, 1200, 75}`
- **Booking**: `{'2023-11-27', '2023-12-02', 1, 4, 175.92, 6}`

As you can see, the Booking refers to the car = 4 (`AA-44-PP`) and the Client = 1 (`João`).

4. Each list must be loaded with data from JSON files or a database: `listcliente.json`, `listautomovel.json`, and `listbooking.json`.
5. When the program starts, all data should be loaded into the respective lists.
6. As records (or changes) are made, they should be registered in the file.
7. Add a functional menu to the program that clearly identifies each functionality. To make the program more “navigable,” install the Beaupy library.
8. Manage the three lists: the program should allow listing, adding, updating, and removing records.
9. Clients can benefit from discounts depending on the total rental days: up to 4 days 0%, 5 to 8 days 15%, more than 8 days 25%.

### FUNCTIONS TO IMPLEMENT
1. List management.
2. Listing of Clients and Cars.
3. Listing future Bookings in the format: Booking start date: XXXX | end date: YYYY (XXX days) Client: Name Car: Brand - Plate Total: YYY €
4. Car search: by plate. It should return the car data and a list of its last 5 rentals.
5. Client search: by NIF. It should return the client data and a list of their last 5 rentals.

### ADDITIONAL INFORMATION
- Groups of up to 3 members.
- Add comments and use functions to build the features.

### SUBMISSION
At the beginning of the code, register the names of the program's authors as comments. Submit the files (compressed) on Teams by May 13, 2024. All group members must submit the work.

### EVALUATION CRITERIA
1. Load JSON files into lists ................................................................................ **7%**
2. Write lists to files ...................................................................................... **7%**
3. Menu construction ......................................................................................... **15%**
4. List management ........................................................................................... **25%**
5. Listing of Cars and Clients ............................................................................... **10%**
6. Booking listing ........................................................................................... **10%**
7. Apply discount to Booking ................................................................................. **5%**
8. Perform searches .......................................................................................... **11%**
9. Programming style (correct use of loops, lists, etc.) and use of comments ................................. **5%**
10. Add BEAUPY ............................................................................................... **5%**

