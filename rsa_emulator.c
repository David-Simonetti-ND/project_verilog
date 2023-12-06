#include <stdio.h>

// size of internal storage registers 
typedef unsigned short uint16;
// size of input data
typedef unsigned char byte;

// hardcoded public key parameters
const uint16 n = 3233;
const uint16 e = 17;
// hardcoded private key parameter
const uint16 d = 413;

// encrypt input byte
uint16 encrypt(byte input_data) {
    // to encrypt input_data, we perform (input_data ^ e) % n
    // this will result in an overflow most of the time, 
    // so we decompose the computation into multiplying 
    // input_data by itself e times, taking the modulo base n
    // between every multiplication
    // see https://stackoverflow.com/questions/16204639/calculating-large-powers-with-modulus
    // for a more indepth explanation
    // temp is 32 bits because any smaller size would potentially cause overflow issues
    unsigned int temp = input_data;
    for (int i = 1; i < e; i++) {
        temp = (temp * input_data) % n;
    }
    return temp;
}

byte decrypt(uint16 encrypted_data) {
    // same as above, instead computing (input_data ^ d) % n 
    unsigned int temp = encrypted_data;
    for (int i = 1; i < d; i++) {
        temp = (temp * encrypted_data) % n;
    }
    return temp;
}

uint16 mock_fsm(byte input_data) {
    // input_data is an 8 bit input wire
    // FSM states
    enum states {
        WAITING,
        INITIALIZE,
        MULTIPLY,
        MODULO,
        DONE,
    };
    // public key constants - would be verilog parameters
    const uint16 N = n;
    const uint16 E = e;

    // 3 bit register holding the current state
    int current_state = WAITING;
    // 1 bit input signal that tells us the current input data is ready to be processed
    int input_data_ready = 1;
    // 32 bit intermediate register to hold temporary computations
    unsigned int arithmetic_temp;
    // how many more multiplication cycles are left to perform
    uint16 iterations_left;

    // 12 bit output wire containing encrypted data
    uint16 encypted_out;
    // 1 bit output wire signalling when data is ready to be read
    int output_ready;
    WAITING:
        // while the input data is not ready to be processed, do nothing
        // otherwise, grab the data and go to initalize
        if (!input_data_ready) 
            goto WAITING;
        else
            current_state = INITIALIZE;
            goto INITIALIZE;
    INITIALIZE:
        // set up the temporary register 
        // and the register tracking the number of iterations left  
        arithmetic_temp = input_data;
        iterations_left = E - 1;
        goto MULTIPLY;
    MULTIPLY:
        // if we have no iterations left, the data is ready
        // otherwise, perform a multiplication step
        if (iterations_left == 0)
            goto DONE;
        else {
            arithmetic_temp = arithmetic_temp * input_data;
            iterations_left = iterations_left - 1;
            goto MODULO;
        }
    MODULO:
        // perform modulo step
        arithmetic_temp = arithmetic_temp % N;
        goto MULTIPLY;
    DONE:
        // signal that the encryption is complete
        output_ready = 1;
        // output the encrypted data
        encypted_out = arithmetic_temp;
        // below is commented out for the sake of the mockup
        //goto WAITING; 
        return encypted_out;
}

int main() {
    // check that the encryption is correct for all possible input values (0-255)
    for (byte i = 0; i < 255; i++) {
        uint16 encrypt_result = encrypt(i);
        byte decrypt_result = decrypt(encrypt_result);
        printf("%d %d %d\n", i, encrypt_result, decrypt_result);
        if (decrypt_result != i) {
            printf("Error in algorithm");
            return 1;
        }
    }
    // check that the encryption is correct using the mocked up fsm
    for (byte i = 0; i < 255; i++) {
        uint16 encrypt_result = mock_fsm(i);
        byte decrypt_result = decrypt(encrypt_result);
        printf("%d %d %d\n", i, encrypt_result, decrypt_result);
        if (decrypt_result != i) {
            printf("Error in FSM");
            return 1;
        }
    }
}