import datetime
import re

'''
Validates if there is content in the user's input (different from space). 
This function returns False and an error message if the user does not write anything in the input; otherwise, it returns True and an empty string.
'''
def isEmptyValidation(key, value):
    # Checks if the value is empty or contains only whitespace
    if not value.strip():
        return False, f"The value for '{key.capitalize()}' cannot be blank."
    return True, ""

'''
Compares the Client ID and the Vehicle ID with the Booking ID list to prevent the user from adding a booking with unregistered clients and vehicles.
This function returns False and an error message if there are no ClientID or VehicleID; otherwise, it returns True and an empty string.
'''
def matchBookingID(key, value, myList):
    for element in myList:
        if  element.get("ativo", 0) == 1 and element.get("id", 1) == int(value):
            return True, "" 
    return False, f"There is no '{key.capitalize()}' with that ID."

'''
Validates if the added date is in the format YYYY-MM-DD and transforms the string into a date.
This function returns False and an error message if the date is in the wrong format; otherwise, it returns True and the date in the date() format.
'''
def validateDateFormat(value):
    try:
        dateValue = datetime.datetime.strptime(value, '%Y-%m-%d').date()
        return True, dateValue
    except ValueError:
        return False, "The date must be in the format YYYY-MM-DD."   

'''
Validates if there are already keys with the added value (nif, phone, email, and license plate).
This function returns False and an error message if a value is already added; otherwise, it returns True and an empty string.
'''
def isUniqueValue(key, value, myList): # nif, phone, email, license plate
    for element in myList:
        if value.upper() == str(element[key]).upper() and element['ativo'] == 1:
            return False, f"We found a '{key.capitalize()}' with this information."
    return True, ""

'''
Validates if the added license plate is in the format XX-XX-XX.
This function returns the license plate in uppercase if it is in the correct format; if not, it prints an error message and requests a license plate again.
It was used to validate user input when searching for bookings by the vehicle's license plate.
'''
def plateFormat(key):
    while True:
        value = input("\nEnter the license plate of the sought vehicle.\n")
        isNotEmptyResult, isNotEmptyMessage = isEmptyValidation(key, value)
        if isNotEmptyResult:
            if not re.match(r'^[A-Z0-9]{2}-[A-Z0-9]{2}-[A-Z0-9]{2}$', value.upper()):
                print("The license plate must have exactly 6 alphanumeric characters in the format [XX-XX-XX].") 
                continue
            return value.upper()
        else:
            print(isNotEmptyMessage)

'''
Validates if the entered ID is an integer.
This function returns an integer if it is in the correct format; if not, it prints an error message and requests a license plate again.
It was used to validate user input when searching for bookings by booking ID.
'''
def isDigit(key, msg):
    while True:
        value = input(msg)
        isNotEmptyResult, isNotEmptyMessage = isEmptyValidation(key, value)
        if isNotEmptyResult:
            if not value.isdigit():
                    print(f"The '{key.capitalize()}' must be an integer.")
                    continue
            return int(value)
        else:
            print(isNotEmptyMessage) 

'''
Validates if the entered ID contains 9 digits.
This function returns an integer with 9 digits if it is in the correct format; if not, it prints an error message and requests a license plate again.
It was used to validate user input when searching for bookings by client NIF.
'''
def isNineDigit(key, msg):
    while True:
        value = input(msg)
        isNotEmptyResult, isNotEmptyMessage = isEmptyValidation(key, value)
        if isNotEmptyResult:
            if not (value.isdigit() and len(value) == 9):
                print(f"The '{key.capitalize()}' must contain exactly 9 numeric digits.")
                continue
            return int(value)
        else:
            print(isNotEmptyMessage) 

'''
Validation of user entries for the listClient, separated by keys.
    - name: checks if it is a string
    - nif and phone: checks if they have 9 digits and are unique keys
    - date of birth: checks the date format
    - email: checks the email format and if it is a unique key
'''
def formatClientDataValidate(key, msg, myList=None):
    while True:
        value = input(msg)
        isNotEmptyResult, isNotEmptyMessage = isEmptyValidation(key, value)
        if isNotEmptyResult:
            if key == 'nome':
                if not isinstance(value, str):
                    print("The name must be a string.")
                    continue
                if not any(char.isdigit() for char in value):
                    return value
                else:
                    print("The name cannot contain numbers.")
                                
            elif key in ['nif', 'telefone']:
                uniqueValueResult, uniqueValueMessage = isUniqueValue(key, value, myList)
                if uniqueValueResult: # it is unique
                    if not (value.isdigit() and len(value) == 9):
                        print(f"The '{key.capitalize()}' must contain exactly 9 numeric digits.")
                        continue
                    return int(value)
                else:
                    print(uniqueValueMessage) 
            
            elif key == 'dataNascimento':
                dateFormatResult, dateFormatMessage = validateDateFormat(value)
                if dateFormatResult:    
                    return value
                else:
                    print(dateFormatMessage)
            
            elif key == 'email':
                uniqueValueResult, uniqueValueMessage = isUniqueValue(key, value, myList)
                if uniqueValueResult: # it is unique
                    if not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', value.lower()):
                        print("Incorrect format! The email must be in the format email@example.xx.")
                        continue
                    return value
                else:
                    print(uniqueValueMessage)
        else:
            print(isNotEmptyMessage)

'''
Validation of user entries for the listAutomovel, separated by keys.
    - license plate: checks if it is in the correct format and if it is unique
    - brand and model: checks if they are alphanumeric
    - color: checks if it is a string and does not contain numbers
    - doors, engine displacement, and power: checks if they are integers and within the defined range
    - daily price: checks if the values are float and positive
'''
def formatAutoDataValidate(key, msg, myList=None, min=None, max=None):
    while True:
        value = input(msg)

        isNotEmptyResult, isNotEmptyMessage = isEmptyValidation(key, value)
        if isNotEmptyResult:
            if key == 'matricula':
                uniqueValueResult, uniqueValueMessage = isUniqueValue(key, value, myList)   
                if uniqueValueResult: # it is unique
                    if not re.match(r'^[A-Z0-9]{2}-[A-Z0-9]{2}-[A-Z0-9]{2}$', value.upper()):
                        print("The license plate must have exactly 6 alphanumeric characters in the format [XX-XX-XX].") 
                        continue
                    return value.upper()
                else:
                    print(uniqueValueMessage)
            
            elif key in ['marca', 'modelo']:
                 if not (isinstance(value, str) and value.isalnum()):
                    print(f"The '{key.capitalize()}' must be a string.")
                    continue
                 return value
            
            elif key == 'cor':
                if not (isinstance(value, str) and value.isalnum()):
                    print("The color must be a string.")
                    continue
                if not any(char.isdigit() for char in value):
                    return value
                else:
                    print("The color cannot contain numbers.")

            elif key in ['portas', 'cilindrada', 'potencia']:
                try:
                        value = int(value)
                except ValueError:
                        print(f"The entry for '{key.capitalize()}' must be an integer.")
                        continue   
                if not (min <= value <= max):
                    print(f"The number of '{key.capitalize()}' must be an integer between {min} and {max}.")
                    continue
                return value
            
            elif key == 'precoDiario':
                try:
                        value = float(value)
                except ValueError:
                        print(f"The entry for '{key.capitalize()}' must be a number.")
                        continue   
                if not (value >= min):
                    print(f"The daily price must be equal to or greater than 0.")
                    continue
                return value
        else:
            print(isNotEmptyMessage)

'''
Validation of user entries for dates in the listBooking, separated by keys.
    - Function used to validate the end date in relation to the start date. It also checks the date format.
'''
def validateDataFim(keyEnd, dataInicio):
    while True:
        dataFim = input("End Date [YYYY-MM-DD]: ")
        if keyEnd == 'data_fim':
                isNotEmptyResultEnd, isNotEmptyEndMessage = isEmptyValidation(keyEnd, dataFim)
                dateFormatEnd, dateFormatEndValue = validateDateFormat(dataFim)
                if isNotEmptyResultEnd:
                    if dateFormatEnd:
                        if dateFormatEndValue >= dataInicio:
                            return dateFormatEndValue
                        else:
                            print("The date must be equal to or later than the start date.")
                    else:
                        print(dateFormatEndValue)
                else:
                    print(isNotEmptyEndMessage)

'''
Validation of user entries for dates in the listBooking, separated by keys.
    - data_inicio: Checks if the start date is equal to or later than today.
    - data_fim: Checks if the end date is equal to or later than the start date, using a helper function to validate the end date.
'''
def formatBookingDatesValidate(keyInit, keyEnd):
    while True:   
        dataInicio = input("Start Date [YYYY-MM-DD]: ")
        isNotEmptyResultInit, isNotEmptyInitMessage = isEmptyValidation(keyInit, dataInicio)
        dateFormatInit, dateFormatInitValue = validateDateFormat(dataInicio)

        if keyInit in 'data_inicio':
            if isNotEmptyResultInit:
                if dateFormatInit:
                    if dateFormatInitValue >= datetime.date.today():   
                        dataFim = validateDataFim(keyEnd, dateFormatInitValue)
                        return str(dateFormatInitValue), str(dataFim)
                    else:
                        print("The date must be equal to or later than today.")
                else:
                    print(dateFormatInitValue)
            else:
                print(isNotEmptyInitMessage)

'''
Validation of user entries for IDs in the listBooking, separated by keys.
    - Compares the ID entered by the user for client_id and vehicle_id with the data saved in JSON to prevent bookings for non-existent clients or vehicles.
'''
def formatBookingIdValidate(key, msg, myList=None):
    while True:
        value = input(msg)

        isNotEmptyResult, isNotEmptyMessage = isEmptyValidation(key, value)
        if isNotEmptyResult:   
            if key == 'cliente_id' or key == 'automovel_id':
                matchId, matchIdMessage = matchBookingID(key, value, myList)
                if not value.isdigit():
                    print(f"The '{key.capitalize()}' must be an integer.")
                    continue
                if matchId:
                    return int(value)
                else: 
                    print(matchIdMessage)
                    continue       
        else:
            print(isNotEmptyMessage)