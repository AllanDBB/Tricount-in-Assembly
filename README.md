[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/k5jHtnh6)
# Tricount in Assembly (NASM 32-bit)

This project is a **debt management system** developed in **Assembly (NASM 32-bit)** that operates in a console environment on LINUX. The program tracks debts between users with the minimum amount of movement, and it generates two linked lists on memory: one for users and one for debts. The logic is inspired by the [Tricount](https://www.tricount.com/)
, which is designed to handle and manage debts efficiently in group settings. The project was carried out as a project of the course of Computer Architecture, Technological Institute in Costa Rica (TEC).

## Project Overview

The program allows users to manage debt relations by creating and updating linked lists of **users** and **debts**. The user list contains information about each individual, including their **name**, **ID**, and **amount charged/debt**. The debt list holds the details of debts, including the **guarantor** (fiador), **debtor(s)**, **debt amount**, and **total debt**. 

### Data Structures

#### User Node
Each user is represented as a node in a linked list. The structure of a user node is:

```plaintext
[Size, ID, Name, Amount Charged/Debt, Next Pointer]
```
- **Size**: 4 bytes, the size of the debt node (always 4 in this implementation).
- **Guarantor Pointer**: 4 bytes, a pointer to the guarantor (fiador) user.
- **Debtor Pointer**: 4 bytes, a pointer to the debtor.
- **Debt Amount**: 4 bytes, the amount the debtor owes.
- **Total Debt**: 4 bytes, the total accumulated debt of the debtor.
- **Next Pointer**: 4 bytes, a pointer to the next debt node.
### Debt Node
Each debt is represented as a node in another linked list. The structure of a debt node is:
```plaintext
[Size, Guarantor Pointer, [Debtor Pointer, Debt Amount, ...], Total Debt, Next Pointer]
```
- Size: 4 bytes, the size of the debt node (always 4 in this implementation).
- Guarantor Pointer: 4 bytes, a pointer to the guarantor (fiador) user.
- Debtor Pointer: 4 bytes, a pointer to the debtor.
- Debt Amount: 4 bytes, the amount the debtor owes.
- Total Debt: 4 bytes, the total accumulated debt of the debtor.
- Next Pointer: 4 bytes, a pointer to the next debt node.
  
## Features

- **Debt Management**: Track and manage debts between users, minimizing the number of movements in the system.
- **Linked Lists**: Efficiently store users and debts in linked lists, providing a dynamic structure for adding and updating information.
- **Console Application**: The program operates via the console, with text-based input and output.

## Usage

1. **User Input**: The program will prompt for user input to add users and record debts between them.
2. **Linked List Creation**: The users and debts are stored in linked lists. The program dynamically manages memory to maintain these lists.
3. **Debt Calculations**: The program calculates the total debt and updates the lists based on user interactions.

### Example Workflow:
- Add users with unique IDs and names.
- Record debts between users.
- The program updates the linked list of debts and users accordingly.
- Display the debt details.

## Installation
1. Fork this repo.
   
2. Clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/debt-management-assembly.git

```
3. Execute the script in Linux
```
./build.sh
```

**Note:**  The project needs [NASM](https://www.nasm.us/) to compile.
