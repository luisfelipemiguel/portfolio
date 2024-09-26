# Test Programming in Python - Student: Luís Felipe Vidal Miguel

# Create a program to simulate the Euromillions draw

# Function definitions

"""
generateKey - this function generates random numbers for the Euromillions key and it has 3 parameters: 
count (amount of numbers to be generated), range_start and range_end (to define the interval)

"""

import random

def generateKey(count, range_start, range_end):
    elements = []
    for _ in range(count):
        while True:
            element = random.randint(range_start, range_end)
            if element not in elements:
                elements.append(element)
                break
    return elements


"""
countMatches - this function compares the numbers and stars chosen by the player 
with the numbers and stars that were drawn and counts the matches

"""

def countMatches(chosen, drawn):
    matches = 0
    for element in chosen:
        if element in drawn:
            matches += 1
    return matches


"""
inputValues - this function asks the player to enter values for numbers and stars 
and returns an error if the values are invalid, repeated or outside the defined range

"""

def inputValues(prompt, count, range_start, range_end):
    values = []
    for i in range(count):
        while True:
            value = input(f"{prompt} {i + 1}: ")
            if value.isdigit() and range_start <= int(value) <= range_end and int(value) not in values:
                values.append(int(value))
                break
            print(f"Please enter a valid number between {range_start} and {range_end} that hasn't been chosen before.")
    return values


"""
checkPrize - this function compares the tuple formed by the number of hits in numbers 
and stars with the tuples from the list of possible prizes

"""

def checkPrize(chosenKey, drawnKey):
    combination = tuple(countMatches(chosenKey[i], drawnKey[i]) for i in range(2))  # Compare chosen and drawn numbers and stars

    prizes = [
        ((5, 2), "JACKPOT! Congratulations, you matched all the numbers and stars! You won 50 million euros!"),
        ((5, 1), "Matched 5 numbers and 1 star! You won 10 million euros! "),
        ((5, 0), "Matched 5 numbers! You won 3 million euros!"),
        ((4, 2), "Matched 4 numbers and 2 stars! You won 1 million euros!"),
        ((4, 1), "Matched 4 numbers and 1 star! You won 500 thousand euros!"),
        ((3, 2), "Matched 3 numbers and 2 stars! You won 100 thousand euros!"),
        ((4, 0), "Matched 4 numbers! You won 50 thousand euros!"),
        ((2, 2), "Matched 2 numbers and 2 stars! You won 30 thousand euros!"),
        ((3, 1), "Matched 3 numbers and 1 star! You won 10 thousand euros!"),
        ((3, 0), "Matched 3 numbers! You won 2 thousand euros!"),
        ((1, 2), "Matched 1 number and 2 stars! You won 100 euros!"),
        ((2, 1), "Matched 2 numbers and 1 star! You won 50 euros!"),
        ((2, 0), "Matched 2 numbers! You won 10 euros!")
    ]

    for prize in prizes:
        if combination == prize[0]:
            return prize[1]  # The function returns the message that corresponds to the prize, if the player wins.

    return "Not this time. Try again!"  # The function returns a closing message if the player doesn't win.


# Opening of the program and generation of a random key

print("\nWelcome to Euromillions!")

numbersEuro = generateKey(5, 1, 50)  # Generate 5 unique numbers between 1 and 50
starsEuro = generateKey(2, 1, 12)  # Generate 2 unique stars between 1 and 12

drawnKey = (numbersEuro, starsEuro)


# Asking the user to enter the key

print("\nPlease enter the numbers of your key (from 1 to 50):")
chosenNumbers = inputValues("Number", 5, 1, 50)

print("\nNow, enter the stars of your key (from 1 to 12):")
chosenStars = inputValues("Star", 2, 1, 12)

chosenKey = (chosenNumbers, chosenStars)


# Check prize

prizeMessage = checkPrize(chosenKey, drawnKey)

print("\nChosen Key:", (sorted(chosenKey[0]), sorted(chosenKey[1])))
print("Drawn Key:", (sorted(drawnKey[0]), sorted(drawnKey[1])))
print(f"{prizeMessage}\n")