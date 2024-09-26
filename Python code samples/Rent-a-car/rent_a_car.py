# Test Programming in Python - Student: Luís Felipe Vidal Miguel (+2 colleagues)

# Create a program to simulate the system of a Rent-a-car company

# Function definitions

# imports

import beaupy
import json
from dataValidation import *
import datetime
from sys import exit
 
# define functions

'''
Mapping the variable "fstOp" to the corresponding list and filename.
'''
def mapList(fstOp):
    options = {
        0: {"list": listCliente, "filename": "rent_a_car/listcliente.json"},
        1: {"list": listAutomovel, "filename": "rent_a_car/listautomovel.json"},
        2: {"list": listBooking, "filename": "rent_a_car/listbooking.json"}
    }

    return {"list": options[fstOp]["list"], "filename": options[fstOp]["filename"]}

'''
Loads the initial content of the JSON files into the corresponding lists.
'''

def readJSON(fstOp):
    filename = mapList(fstOp)["filename"]

    try:
        with open(filename, 'r', encoding="utf-8") as f:
            data = json.load(f)
    except:
        print("\nError: Unable to write the file\n")
        return [] #an empty list
    else:
        return data

'''
Saves the changes of a list in the corresponding JSON file.
'''
def writeJSON(fstOp):
    # modes: r (read) a (append) w (write) t (text) b (binary)
    myList, filename = mapList(fstOp)["list"], mapList(fstOp)["filename"]
    try:
        with open(filename, 'w', encoding="utf-8") as f:
            json.dump(myList, f, indent=4, ensure_ascii=False)
    except:
        print("\nError: Unable to write the file\n")
    else:
        print(f"\nSuccess: the file {filename} was written successfully\n")
        
'''
Removes an element by changing the value of the "ativo" key to zero.
'''
def removeItem(fstOp, searchResult):
    myList = mapList(fstOp)["list"]
    for element in myList:
        if int(element.get("id", 1)) == int(searchResult.get('id', 1)):
            element["ativo"] = 0
            writeJSON(fstOp)  # Saves the updated list in the corresponding JSON file
            print(f"Element with ID {element['id']} removed successfully!\n")
            return
    print(f"Element not removed.")      

'''
Specific function to update the data of a booking. Automatically recalculates the number of days and the price.
'''
def updateBooking(fstOp, searchResult):

    id = searchResult['id']

    print("\nSelect the information you want to change.\n")
    updateOptions = ["Booking period", "Client ID", "Vehicle ID", "< Back", "x Exit"]
    option = beaupy.select(updateOptions, cursor='->', cursor_style='red', return_index=True)
    msg = f"Enter the new value for {updateOptions[option]}: "

    try:
        foundElements = False
        if datetime.datetime.strptime(searchResult.get('data_inicio', ''), '%Y-%m-%d').date() >= datetime.datetime.now().date():
            for element in listBooking:
                if int(element['id']) == int(id):
                    if option == 0:
                        newInitialDate, newEndDate = formatBookingDatesValidate('data_inicio', 'data_fim')
                        element['data_inicio'] = newInitialDate
                        element['data_fim'] = newEndDate
                        element['numeroDias'] = int(bookingDays(newInitialDate, newEndDate))
                    elif option == 1:
                        newClientId = formatBookingIdValidate('cliente_id', msg, listCliente)
                        element['cliente_id'] = newClientId
                    elif option == 2:
                        newAutoId = formatBookingIdValidate('automovel_id', msg, listAutomovel)
                        element['automovel_id'] = newAutoId
                    elif option == 3:
                        thirdMenu(fstOp, searchResult)
                    else: # Exit
                        print("\nSession closed.\n")
                        exit()

                    newNumberDays = element['numeroDias'] 
                    newAutoId = element['automovel_id']
                    newPrecoReservaOriginal = newNumberDays*float(getVehiclePrice(newAutoId))
                    newPrecoReserva = (1-float(applyDiscount(newNumberDays)))*newPrecoReservaOriginal
                    element['precoReserva'] = newPrecoReserva
                    print(f"\nUpdate successful.\n")
                    printBooking(element)
                    print(f"Original price: {newPrecoReservaOriginal} / Price with discount: {newPrecoReserva} ") if newNumberDays > 4 else print(f"Original price: {newPrecoReservaOriginal} / No discount on booking.")
                    writeJSON(fstOp)
                    foundElements = True
            if not foundElements:
                raise ValueError("The element was not updated.")
        else:
            print("\nError: Cannot change past bookings\n")
        
    except ValueError as e:
        print(e)

'''
Allows the user to select which key of the found element they want to update.
'''
def updateItem(fstOp, searchResult):
    
    # Create a list with the keys of the element
    updateOptions = [f"{key} - {value}" for key, value in searchResult.items() if key != 'id' and key != 'ativo']

    id = searchResult['id']
    
    print("\nSelect the information you want to change.\n")
    itemToBeUpdated = beaupy.select(updateOptions, cursor='->', cursor_style='red')
    keyToBeUpdated = itemToBeUpdated.split()[0]
    msg = f"Enter the new value for {keyToBeUpdated}: "
    myList = mapList(fstOp)["list"]

    try:
        foundElements = False
        for element in myList:
            if int(element['id']) == int(id):
                if fstOp == 0:
                    relatedValue = formatClientDataValidate(keyToBeUpdated, msg, myList)
                elif fstOp == 1:
                    relatedValue = formatAutoDataValidate(keyToBeUpdated, msg, myList)

                element[f"{keyToBeUpdated}"] = relatedValue
                print(f"\nThe field {keyToBeUpdated} was updated successfully.\n")
                writeJSON(fstOp)
                foundElements = True
        if not foundElements:
            raise ValueError("The element was not updated.")
        
    except ValueError as e:
        print(e)

'''
After a successful search, allows the user to choose between updating or removing an element.
'''
def thirdMenu(fstOp, searchResult):  
    while True:        
        print(f"\nSelect the desired option:\n")
        mgmtList2 = ["Update", "Remove", "< Back", "x Exit"]
        op = beaupy.select(mgmtList2, cursor='->', cursor_style='red', return_index=True)
        if op == 0: # Update
            if fstOp in [0, 1]:
                updateItem(fstOp, searchResult)
            else:
                updateBooking(fstOp, searchResult)
        elif op == 1: # Remove
            removeItem(fstOp, searchResult)
            secondMenu(fstOp)     
        elif op == 2: # Back
            secondMenu(fstOp)
        else: # Exit
            print("\nSession closed.\n")
            exit()

'''
Specific function to search for clients by NIF. If a client is found, a list with a single element is returned
so that the user can confirm their choice by pressing "enter".
'''
def searchClient():
    nif = isNineDigit('nif', "\nEnter the NIF of the client being searched.\n")

    foundClient = []
    
    for element in listCliente:
        if element.get("ativo", 0) == 1 and int(element.get("nif", 3)) == nif:
            foundClient.append(element)       

    if not foundClient:
        print("\nError: Client not found.")
        return None

    print(f"\nThe following client was found with the NIF {nif}.\n") 
    opClient = beaupy.select(foundClient, cursor='->', cursor_style='red', return_index=True)
    return foundClient[opClient]

'''
Specific function to search for cars by license plate. If a vehicle is found, a
list with a single element is returned so the user can confirm their choice by pressing the "enter" key.
'''
def searchAuto():
    matricula = plateFormat('matricula')

    foundAuto = []
    
    for element in listAutomovel:
        if element.get("ativo", 0) == 1 and element.get("matricula", 2) == matricula:
            foundAuto.append(element)       

    if not foundAuto:
        print("\nError: Vehicle not found.")
        return None

    print(f"\nThe following vehicle was found with the license plate {matricula}.\n") 
    opAuto = beaupy.select(foundAuto, cursor='->', cursor_style='red', return_index=True)
    return foundAuto[opAuto]

'''
Searches the Booking database for the ID entered by the user and returns a reservation,
if the ID exists and the value of the "ativo" key is equal to 1.
'''
def searchBooking():
    bookingId = isDigit('id', "\nEnter the ID of the reservation sought: ")
    
    foundBooking = []
    
    for element in listBooking:
        if element.get("ativo", 0) == 1 and int(element.get("id", 1)) == bookingId:
            foundBooking.append(element)       

    if not foundBooking:
        print("\nError: Reservation not found.")
        return None

    print(f"\nThe following reservation was found with the ID {bookingId}.\n") 
    opBk = beaupy.select(foundBooking, cursor='->', cursor_style='red', return_index=True)
    return foundBooking[opBk]

'''
Specific function to assist in the insertion of clients.
Requests inputs for the non-automatic keys ("id" and "ativo") of "listCliente".
'''
def insertClient():
    print("\nInsert Client\n")
    nome = formatClientDataValidate('nome', "Name: ")
    nif = formatClientDataValidate('nif', "NIF: ", listCliente)
    dataNascimento = formatClientDataValidate('dataNascimento', "Date of Birth [yyyy-mm-dd]: ")
    telefone = formatClientDataValidate('telefone', "Phone: ", listCliente)
    email = formatClientDataValidate('email', "Email: ", listCliente)
    return {"nome": nome, "nif": nif, "dataNascimento": dataNascimento, "telefone": telefone, "email": email}

'''
Specific function to assist in the insertion of cars.
Requests inputs for the non-automatic keys ("id" and "ativo") of "listAutomovel".
'''
def insertAuto():
    print("\nInsert Vehicle\n")
    matricula = formatAutoDataValidate('matricula', "License Plate [XX-XX-XX]: ", listAutomovel)
    marca = formatAutoDataValidate('marca', "Brand: ")
    modelo = formatAutoDataValidate('modelo',"Model: ")
    cor = formatAutoDataValidate('cor', "Color: ")
    portas = formatAutoDataValidate('portas', "Doors: ", None, 1, 10)
    precoDiario = formatAutoDataValidate('precoDiario', "Daily Price: ", None, 0)
    cilindrada = formatAutoDataValidate('cilindrada', "Cubic Capacity: ", None, 1, 9999)
    potencia = formatAutoDataValidate('potencia', "Power: ", None, 1, 999)
    return {"matricula": matricula, "marca": marca, "modelo": modelo, "cor": cor, "portas": portas, "precoDiario": precoDiario, "cilindrada": cilindrada, "potencia": potencia}

'''
Calculates the discount for reservations that meet the requirements. 
'''
def applyDiscount(numeroDias):
    discount = 0
    if 5 <= int(numeroDias) <= 8:
        discount = 0.15
    elif int(numeroDias) > 8:
        discount = 0.25
    else:
        print("Reservation without discount.")
    return discount

'''
Calculates the duration of the reservation for the "insertBooking" function. Returns "1" for reservations that start and
end on the same day.
'''
def bookingDays(startDate, endDate):
    start = datetime.datetime.strptime(startDate, '%Y-%m-%d')
    end = datetime.datetime.strptime(endDate, '%Y-%m-%d')
    delta = end - start
    return abs(delta.days) if abs(delta.days) != 0 else 1

'''
Iterates through "listAutomovel" and returns the daily price of the vehicle with the "id" inputted by
the user in the "insertBooking" function.
'''
def getVehiclePrice(vehicleID):
    
    dailyPrice = None
   
    for element in listAutomovel:
        if int(element['id']) == int(vehicleID):  # Converting to integer if necessary
            dailyPrice = element['precoDiario']
            return dailyPrice
    
    else:
        print("Error: Could not find the daily price of the vehicle.")

'''
Specific function to assist in the insertion of reservations. Requests inputs for the non-automatic keys ("id" and "ativo") of "listBooking"
and automatically returns the original price of the reservation and the price with discount, if any.
'''
def insertBooking():
    print("\nInsert Reservation\n")
    dataInicio, dataFim = formatBookingDatesValidate('data_inicio', 'data_fim')
    clienteId = formatBookingIdValidate('cliente_id', "Client ID: ", listCliente)
    automovelId = formatBookingIdValidate('automovel_id', "Vehicle ID: ", listAutomovel)
    numeroDias = int(bookingDays(dataInicio, dataFim))
    precoReservaOriginal = numeroDias*float(getVehiclePrice(automovelId))
    precoReserva = (1-float(applyDiscount(numeroDias)))*precoReservaOriginal
    print(f"Original price: {precoReservaOriginal} / Price with discount: {precoReserva} ") if numeroDias > 4 else print(f"Original price: {precoReservaOriginal} / Reservation without discount.")
    return {"data_inicio": dataInicio, "data_fim": dataFim, "cliente_id": clienteId, "automovel_id": automovelId, "precoReserva": precoReserva, "numeroDias": numeroDias}

'''
Specific function for formatting the printout of clients.
'''
def printClient(client):
    print(f"""
    ID: {client['id']}, Name: {client['nome']}, NIF: {client['nif']}, Date of Birth: {client['dataNascimento']},
    Phone: {client['telefone']}, Email: {client['email']}
    -------------------------
    """)

'''
Specific function for formatting the printout of vehicles.
'''
def printAuto(auto):
    print(f"""
    ID: {auto['id']}, License Plate: {auto['matricula']}, Brand: {auto['marca']}, Model: {auto['modelo']}
    Color: {auto['cor']}, Doors: {auto['portas']}, "cubic capacity": {auto['cilindrada']}, "power": {auto['potencia']}
    
    Price/Day: {auto['precoDiario']}€ 
    -------------------------
    """)

'''
Returns the name of the client of a certain reservation when the "printBooking" function is executed.
'''
def getClientName(booking):
    
    clientName = None

    for element in listCliente:
        if element.get("ativo", 0) == 1 and int(element.get("id", 1)) == int(booking.get("cliente_id", 4)):
            clientName = element.get("nome", 2)
            return clientName 
    else:
        print("Error: check the client ID.")

'''
Returns the brand and license plate of the vehicle of a certain reservation when the "printBooking" function is executed.
'''
def getAutoInfo(booking):
    
    autoBrand = None
    autoPlate = None

    for element in listAutomovel:
        if element.get("ativo", 0) == 1 and int(element.get("id", 1)) == int(booking.get("automovel_id", 4)):
            autoBrand = element.get("marca", 3)
            autoPlate = element.get("matricula", 2)
            return autoBrand, autoPlate 
    else:
        print("Error: check the vehicle ID.")

'''
Specific function for formatting the printout of reservations.
'''
def printBooking(booking):

    clientName = getClientName(booking)
    autoBrand, autoPlate = getAutoInfo(booking)

    print(f"""
    ID: {booking['id']}
    Start Date: {booking['data_inicio']} | End Date: {booking['data_fim']} ({booking['numeroDias']} day(s))
    Client: {clientName}
    Vehicle: {autoBrand} - License Plate: {autoPlate}
    
    Total: {booking['precoReserva']}€ | Number of days: {booking['numeroDias']}
    -------------------------
    """)

'''
Maps the main options of the program to the specific functions of each database
through the "fstOp" parameter highlighted in "firstMenu".
'''
def mapSearch(fstOp, option, otherParameter=None):
    
    functionMap = {
        0: (searchClient, printClient, insertClient),
        1: (searchAuto, printAuto, insertAuto),
        2: (searchBooking, printBooking, insertBooking)
    }

    if fstOp in functionMap:
        # Passes the "otherParameter" if it exists - it can be a client, a car, or a booking
        keys = functionMap[fstOp][option]() if otherParameter is None else functionMap[fstOp][option](otherParameter)
        return keys
    else:
        print("Invalid main operator!")

'''
Presents the user with temporal filtering options when interacting only with the Bookings database.
'''
def printBookingMenu():
    while True:
        print(f"\nSelect the desired option:\n")
        mgmtList3 = ["All bookings", "Future bookings", "Past bookings", "< Back", "x Exit"]
        op = beaupy.select(mgmtList3, cursor='->', cursor_style='red', return_index=True)
              
        if op == 0: # List all bookings
            print("\n-------------------------------------\n>>> Listing all bookings:\n-------------------------------------\n")
            for element in listBooking:
                if element.get('ativo', 0) == 1:
                    printBooking(element)
        elif op == 1: # List only future bookings
            print("\n-------------------------------------\n>>> Listing future bookings:\n-------------------------------------\n")
            for element in listBooking:
                if element.get('ativo', 0) == 1 and datetime.datetime.strptime(element.get('data_inicio', ''), '%Y-%m-%d').date() > datetime.datetime.now().date():
                    printBooking(element)
        elif op == 2: # List only past bookings
            print("\n-------------------------------------\n>>> Listing past bookings:\n-------------------------------------\n")
            for element in listBooking:
                if element.get('ativo', 0) == 1 and datetime.datetime.strptime(element.get('data_inicio', ''), '%Y-%m-%d').date() <= datetime.datetime.now().date():
                    printBooking(element)
        elif op == 3: # Back
            secondMenu(2)
        else: # Exit
            print("\nSession ended.\n")
            exit()

'''
Generic search function that returns to the second menu if no results are found
or forwards to the third menu.

IMPORTANT: the "searchResult" variable determines which element will be updated or removed
'''
def searchItem(fstOp):
    print("\nSearch:\n")
    searchResult = mapSearch(fstOp, 0)
    if not searchResult:
        secondMenu(fstOp)
    else:
        thirdMenu(fstOp, searchResult)

'''
Generic function to print elements from lists.
'''
def printItem(fstOp):
    myList = mapList(fstOp)["list"]
    try:
        foundElements = False
        for element in myList:
            if element.get("ativo", 0) == 1:
                mapSearch(fstOp, 1, element)
            foundElements = True
        
        if not foundElements:
            raise ValueError("No active elements were found in the database.")
    
    except ValueError as e:
        print(e)

'''
Generic function to add elements to a list.
'''
def addItem(fstOp):
    # Gets the next ID from the list
    myList = mapList(fstOp)["list"]
    nextId = len(myList)+1

    keys = mapSearch(fstOp, 2)
    autoKeys = {'ativo': 1, 'id': nextId}  # Automatically defines the ID and the 'ativo' key
    autoKeys.update(keys)

    # Adds the updated element to the list
    myList.append(autoKeys)
     
    # Updates the corresponding JSON file of the list
    writeJSON(fstOp)
    print("Element successfully added!")

'''
According to the "searchCriteria" chosen in the "searchBookingOption" function, the program will iterate through the "listBooking"
looking for bookings that have the selected client or car ID. Subsequently, the list of found bookings is sorted by date.
'''
def sortAndFilterBookings(searchCriteria=None, foundElement=None):
    subList = []

    for element in listBooking:
        if element.get('ativo', 0) == 1:
            if searchCriteria == 0 and int(element.get('cliente_id', 4)) != int(foundElement.get('id', 1)):
                continue
            elif searchCriteria == 1 and int(element.get('automovel_id', 5)) != int(foundElement.get('id', 1)):
                continue
            subList.append(element)

    sortedBookings = sorted(subList, key=lambda x: datetime.datetime.strptime(x.get('data_inicio', ''), '%Y-%m-%d'), reverse=True)

    if not sortedBookings:
        return None
    
    return sortedBookings 

'''
According to the temporal filtering option chosen in the "bookingDateOps" function,
a different list will be printed.
'''
def listBookingsByDates(printOp, searchCriteria=None, foundElement=None):

    # Create a sub-list that is the filtered listBooking by client/car and sorted
    subList = sortAndFilterBookings(searchCriteria, foundElement)
    
    if subList is None: # If there are no bookings for the client or car, an error is returned
        print("\nError: No rentals found.\n")
        return

    # Create a list with future rentals from the subList, including the current day
    futureBookings = [element for element in subList if datetime.datetime.strptime(element.get('data_inicio', ''), '%Y-%m-%d').date() >= datetime.datetime.now().date()]

    # Create a list with past rentals from the subList
    pastBookings = [element for element in subList if datetime.datetime.strptime(element.get('data_inicio', ''), '%Y-%m-%d').date() < datetime.datetime.now().date()][:5]

    if printOp == 0:
        printingList = subList
    elif printOp == 1:
        printingList = futureBookings
    else:
        printingList = pastBookings

    if len(printingList) == 0:
        print("\nNo rentals found.\n")
    else:
        if printOp == 0:
            print(f"\n------------------------------------------------\n>>> Listing all rentals | Total: {len(subList)} \n------------------------------------------------\n")
        elif printOp == 1:
            print(f"\n------------------------------------------------\n>>> Listing future rentals | Total: {len(futureBookings)}\n------------------------------------------------\n")
        else:
            print(f"\n------------------------------------------------\n>>> Listing the last 5 rentals: | Total: {len(pastBookings)}\n------------------------------------------------\n")
        for element in printingList:            
            printBooking(element)

'''
Presents the temporal filtering options for the bookings of a specific client or car.
'''
def bookingDateOps(searchCriteria, foundElement=None):
    while True:
        printOptions = ["All rentals", "Future rentals", "Last 5 rentals", "< Back", "x Exit"]
        print("\nChoose the search criterion:\n")
        printOp = beaupy.select(printOptions, cursor='->', cursor_style='red', return_index=True)
        
        if printOp in [0, 1, 2]: # Any chosen temporal filtering leads to the "listBookingByDates" function
            listBookingsByDates(printOp, searchCriteria, foundElement)

        if printOp == 3: # Back
            searchBookingOption()
        elif printOp == 4: # Exit
            print("\nSession ended.\n")
            exit()

'''
Presents the booking search options: by NIF, car plate, or by booking ID.

IMPORTANT: the "searchCriteria" variable will determine the behavior of the subsequent functions.
'''
def searchBookingOption():
    while True:
        searchOptions = ["Client NIF", "Car plate", "Booking ID [update/remove]", "< Back", "x Exit"]
        print("\nChoose the search criterion:\n")
        searchCriteria = beaupy.select(searchOptions, cursor='->', cursor_style='red', return_index=True)
    
        if searchCriteria == 0: # Search by NIF
            client = searchClient()
            if client:
                bookingDateOps(searchCriteria, client)
        elif searchCriteria == 1: # Search by plate
            auto = searchAuto()
            if auto:
                bookingDateOps(searchCriteria, auto)
        elif searchCriteria == 2: # Search by booking ID
            searchItem(2)
        elif searchCriteria == 3:  # Back
            secondMenu(2)
        else: # Exit
            print("\nSession ended.\n")
            exit()

'''
Presents the options for interacting with the databases: search, list, or add elements.
'''
def secondMenu(fstOp):

    mgmtList1 = ["Clients", "Cars", "Bookings", "x Exit"]

    while True:
        print(f"\nManagement of {mgmtList1[fstOp]}:\n")
        mgmtList2 = ["Search", "List", "Add", "< Back", "x Exit"]
        secOp = beaupy.select(mgmtList2, cursor='->', cursor_style='red', return_index=True)
        
        if secOp == 0:
            if fstOp == 2: # If the user is interacting with the bookings database, they are taken to searchBookingOption
                searchBookingOption()
            else:
                searchItem(fstOp)
        elif secOp == 1:  
            if fstOp == 2: # If the user is interacting with the bookings database, they are taken to printBookingMenu
                printBookingMenu()
            else:
                printItem(fstOp)
        elif secOp == 2:
            addItem(fstOp)
        elif secOp == 3:  # Back
            firstMenu()
        else:
            print("\nSession ended.\n")
            exit()

'''
Starts the program and presents a menu for the user to choose which 
database they wish to interact with: Clients, Cars, or Bookings.

IMPORTANT: the "fstOp" variable determines which database the user will interact with.
'''                 
def firstMenu():
    while True:
        mgmtList1 = ["Clients", "Cars", "Bookings", "x Exit"]
        print("\nManagement of lists:\n")
        fstOp = beaupy.select(mgmtList1, cursor='->', cursor_style='red', return_index=True)
              
        if fstOp == 3:  # Exit
            print("\nSession ended.\n")
            exit()
        else:
            secondMenu(fstOp)

# globals

filenameCliente = "rent_a_car/listcliente.json"
filenameAutomovel = "rent_a_car/listautomovel.json"
filenameBooking = "rent_a_car/listbooking.json"

listCliente = []
listAutomovel = []
listBooking = []

# load initial content

listCliente = readJSON(0)
listAutomovel = readJSON(1)
listBooking = readJSON(2)
 
# menu

firstMenu()