/*
 * Automated Nursing Alert System - PIC16F877A firmware
 * Compiler : Microchip XC8 (v3.10), MPLAB X IDE v6.35
 * Clock    : 20 MHz crystal (HS)
 *
 * Features: polled inputs, software debounce, software priority
 * resolution (Ward 10 highest), latched alert until nurse presses Clear.
 */

#pragma config FOSC = HS
#pragma config WDTE = OFF
#pragma config PWRTE = ON
#pragma config BOREN = ON
#pragma config LVP = OFF
#pragma config CPD = OFF
#pragma config WRT = OFF
#pragma config CP = OFF

#include <xc.h>
#include <stdint.h>

#define _XTAL_FREQ 20000000UL

// Pin definitions
#define BUZZER_PIN   PORTDbits.RD0   // Acoustic alarm (active-HIGH)
#define ALERT_LED    PORTDbits.RD1   // Visual alarm (active-HIGH)
#define CLEAR_BUTTON PORTAbits.RA2   // Nurse-side Clear button (active-HIGH)

void system_init(void);
uint8_t get_active_ward(void);

// Latch state (persists across loop iterations)
uint8_t latched_ward = 0;  // 0 = no active call, 1-10 = latched ward number
uint8_t call_active  = 0;  // 0 = idle, 1 = active call latched

void main(void) {
    system_init();

    while (1) {
        // 1. Clear button (active-HIGH when pressed)
        if (CLEAR_BUTTON == 1) {
            __delay_ms(20);                 // software debounce
            if (CLEAR_BUTTON == 1) {
                call_active  = 0;
                latched_ward = 0;
            }
        }

        // 2. Ward call switches
        uint8_t current_ward = get_active_ward();
        if (current_ward > 0) {
            __delay_ms(20);                 // software debounce
            current_ward = get_active_ward();
            if (current_ward > 0) {
                // Latch if idle, OR override if the new call has higher priority
                if (!call_active || current_ward > latched_ward) {
                    latched_ward = current_ward;
                    call_active  = 1;
                }
            }
        }

        // 3. Output stage (explicit byte write to PORTC)
        //    RC0-RC3 = BCD units digit (74LS47)
        //    RC4     = units display enable (74LS47 BI/RBO, 1 = on)
        //    RC5     = tens digit "1" segments (0 = lit, 1 = off)
        if (call_active) {
            if (latched_ward == 10) {
                PORTC = 0x10;                       // units "0", tens "1" -> "10"
            } else {
                PORTC = 0x30 | (latched_ward & 0x0F); // units 1-9, tens off
            }
            ALERT_LED = 1;
            BUZZER_PIN = 1;
        } else {
            PORTC = 0x20;                           // both digits blank
            ALERT_LED = 0;
            BUZZER_PIN = 0;
        }
    }
}

void system_init(void) {
    ADCON1 = 0x07;   // PORTA as digital I/O
    CMCON  = 0x07;   // disable analog comparators
    TRISB  = 0xFF;   // RB0-RB7 = SW1-SW8 inputs
    TRISA  = 0x07;   // RA0 = SW9, RA1 = SW10, RA2 = SW11 (Clear)
    TRISC  = 0x00;   // RC0-RC5 outputs
    TRISD  = 0xFC;   // RD0 (buzzer), RD1 (LED) outputs

    PORTC = 0x20;    // idle: tens off, units blanked
    BUZZER_PIN = 0;
    ALERT_LED  = 0;
}

// Priority-ordered input decoding (active-HIGH, Ward 10 highest)
uint8_t get_active_ward(void) {
    if      (PORTAbits.RA1 == 1) return 10;
    else if (PORTAbits.RA0 == 1) return 9;
    else if (PORTBbits.RB7 == 1) return 8;
    else if (PORTBbits.RB6 == 1) return 7;
    else if (PORTBbits.RB5 == 1) return 6;
    else if (PORTBbits.RB4 == 1) return 5;
    else if (PORTBbits.RB3 == 1) return 4;
    else if (PORTBbits.RB2 == 1) return 3;
    else if (PORTBbits.RB1 == 1) return 2;
    else if (PORTBbits.RB0 == 1) return 1;
    else return 0;
}
