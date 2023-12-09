# GF180 RSA Encryption Project

Authors: David Simonetti, Thomas Mercurio, Brooke Mackey
Email:  dsimone2@nd.edu, tmercuri@nd.edu, bmackey@nd.edu
Push Date: 12/9/2023

CSE 30342 - Digital Integrated Circuits - University of Notre Dame

Goal: Our project performs an RSA encryption of an 8-byte input. 

## Encryption Process

1) Generate the Public Key

There are two elements of the public key:
    - n: the product of two prime numbers
        - We used p = 53 and q = 61 where n = p * q = 3233.
    - e
        - To find e...
            - Compute the Carmichael's Totient Function of the product as λ(n) = lcm(p − 1, q − 1).
                - λ(n) = lcm(p − 1, q − 1) = λ(3233) = lcm(53 − 1, 61 − 1) = 780
            - Choose any number 2 < e < 780 that is coprime to 780.
                - We used e = 17.

2) Generate the Private Key
    - d: the private key is used to decrypt the encrypted data
        - To find d...
            - Compute the modular multiplicative inverse of e (mod λ(n)) = 17 (mod λ(3233)).
            - d = 413 because 1 = (17 * 413) mod 780

3) Encryption Function

The encryption function for the input data (x) and encrypted output (y) is `y = x^e mod n`.

4) Decryption Function

The encryption function for the input data (x) and encrypted output (y) is `y = x^d mod n`.

## Our Project

In order to perform RSA encryption, we have have a 5 state finite state machine (FSM), and two additional states allow a user to change the values of n and e. Based on the input_data_type, a user can choose which operation they would like to perform.

The finite state machine in the controller to perform the encryption is as follows:

State 1: WAITING

    - In the waiting state, the FSM will only transition out of the state when an operation is chosen by the user.
    - If the input_data_type is 1 (DATA_INPUT), the FSM will transition to INITIALIZE to begin the encryption process.
    - If the input_data_type is 2 (E_INPUT), the FSM will transition to UPDATE_E.
    - If the input_data_type is 3 (N_INPUT), the FSM will transition to UPDATE_N.

State 2: INITIALIZE

    - The initialize flag is set to 1, which signals to the datapath to store the data input, initialize a temporary value to x to help calculate x^e, and initialize iterations_left to e.
    - If is_init_done, which checks if the number of iterations left is equal to e, is true, then the FSM will transition to MULTIPLY.
        - When the number of iterations left is equal to e, this means that the encryption process is at the very start because the multiply operation will be performed e times to get the value x^e.
    - If not, then the FSM will remain in the INITIALIZE state.

State 3: MULTIPLY

    - If is_multiplication_done, which checks if the number of iterations left is equal to 1, is true, then the FSM will transition to DONE.
    - If not, then the flag en_multiply is set to 1, which signals to the datapath to multiply the temporary variable by x again, and the FSM will transition to MODULO.

State 4: MODULO

    - The en_modulo flag is set to 1, which signals to the datapath to mod the temporary variable by n, and the FSM transitions to MULTIPLY.

State 5: DONE

    - The done flag is set to 1, which signals to the datapath to store the temporary variable in the output variable, and the FSM transitions to WAITING.

State 6: UPDATE_E

    - The update_e flag is set to 1, which signals to the datapath to store the input in the e variable, and the FSM transitions to WAITING.

State 7: UPDATE_N

    - The update_n flag is set to 1, which signals to the datapath to store the input in the n variable, and the FSM transitions to WAITING.

## Setup

The tutorials for setting up this flow...

1) Setting up the EFabless Environment - https://github.com/mmorri22/cse30342/blob/main/Resources/Final%20Project%20-%20Setup.ipynb

2) Running through the Project, including how to map the Verilog to user_proj_example.v, and how to map the user_proj_example module to the user_project_wrapper. Finally, the student learns how to push the project to the EFabless GitHub repository, and how to perform MPW and Tapeout Checks - https://github.com/mmorri22/cse30342/blob/main/Resources/Final%20Project%20-%20Implementation.ipynb