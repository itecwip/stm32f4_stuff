/* -*- mode: ld-script; -*- */
/*
 * Linker script for MK20DX32VLF5
 */
MEMORY
{
/**
 * Our two-stage optimizing linker has trouble when the first link stage
 * runs out of space.  We artificially keep this size too large for now.
 * The overflow will be caught later.
 */
        loader_rom (rx) : ORIGIN = 0, LENGTH = 1M
        app_rom (rx) : ORIGIN = 3072, LENGTH = 1M
        ram (rwx) : ORIGIN = 0x20000000 - 8K / 2, LENGTH = 8K
}
/* common peripheral / misc data for K20 series MCUs */
_app_rom = ORIGIN(app_rom);
_eram = ORIGIN(ram) + LENGTH(ram);
/* PACK SECTIONS FIX .isr_vector = 0 */
/* PACK SECTIONS FIX .flash_config = 0x400 */
/* PACK SECTIONS IGNORE .pin_hooks.* */
/* peripherals */
FTFL_CONFIG = 0x00000400;
FlexRAM = 0x14000000;
FTFL = 0x40020000;
SPI0 = 0x4002c000;
CRC = 0x40032000;
PIT = 0x40037000;
FTM0 = 0x40038000;
FTM1 = 0x40039000;
ADC0 = 0x4003b000;
RTC = 0x4003d000;
VBAT = 0x4003e000;
LPTMR0 = 0x40040000;
TSI0 = 0x40045000;
SIM = 0x40047000;
PORTA = 0x40049000;
PORTB = 0x4004a000;
PORTC = 0x4004b000;
PORTD = 0x4004c000;
PORTE = 0x4004d000;
MCG = 0x40064000;
I2C0 = 0x40066000;
UART0 = 0x4006A000;
UART1 = 0x4006B000;
UART2 = 0x4006C080;
USB0 = 0x40072000;
CMP0 = 0x40073000;
CMP1 = 0x40073008;
VREF = 0x40074000;
LLWU = 0x4007c000;
PMC = 0x4007d000;
SMC = 0x4007e000;
RCM = 0x4007f000;
GPIOA = 0x400ff000;
GPIOB = 0x400ff040;
GPIOC = 0x400ff080;
GPIOD = 0x400ff0C0;
GPIOE = 0x400ff100;
NVIC = 0xe000e100;
SCB = 0xe000ed00;
REGION_ALIAS("rom", app_rom)
/* PACK SECTIONS IGNORE .ramtext.* */
OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
ENTRY(Reset_Handler)
/* Section Definitions */
SECTIONS
{
    .text :
    {
/*
 * pack-sections.rb will replace the following block
 * with sections packed and ordered according to the
 * positioning restrictions defined in the TARGET_LDSCRIPT.
 */
/* PACK SECTIONS START */
. = 0; KEEP(* (.isr_vector))
/tmp/ccjE77y2.ltrans0.ltrans.o (.text.pin_mode.constprop.5.4116)
/tmp/ccjE77y2.ltrans0.ltrans.o (.text.crit_exit.4192)
/tmp/ccjE77y2.ltrans0.ltrans.o (.text.timeout_schedule_wrap.5124.4198)
/tmp/ccjE77y2.ltrans0.ltrans.o (.text.timeout_reschedule.5128.4194)
/tmp/ccjE77y2.ltrans0.ltrans.o (.text.timeout_empty.5121.4200)
/tmp/ccjE77y2.ltrans0.ltrans.o (.text.timeout_update_time.5119.4203)
/tmp/ccjE77y2.ltrans0.ltrans.o (.text.LPT_Handler.4057)
/tmp/ccjE77y2.ltrans0.ltrans.o (.text.blink.4624.4024)
/tmp/ccjE77y2.ltrans0.ltrans.o (.text.__Default_Handler.4006.4205)
/tmp/ccjE77y2.ltrans0.ltrans.o (.text.startup.main)
/tmp/ccjE77y2.ltrans0.ltrans.o (.text.Default_Reset_Handler.4027)
/* PACK SECTIONS END */
    } > rom
.pin_hooks :
{
    pin_hooks_A = . ;
    *(SORT(.pin_hooks.PIN_PTA*))
    pin_hooks_A_end = . ;
    pin_hooks_B = . ;
    *(SORT(.pin_hooks.PIN_PTB*))
    pin_hooks_B_end = . ;
    pin_hooks_C = . ;
    *(SORT(.pin_hooks.PIN_PTC*))
    pin_hooks_C_end = . ;
    pin_hooks_D = . ;
    *(SORT(.pin_hooks.PIN_PTD*))
    pin_hooks_D_end = . ;
    KEEP(*(.pin_hooks.*))
} > rom
    .ARM.extab :
    {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > rom
    .ARM.exidx :
    {
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    } > rom
    . = ALIGN(4);
    _etext = .;
    /* The USB BDT has to be aligned to a 512 byte boundary */
    .usb_bdt (NOLOAD) :
    {
        . = ALIGN(512);
        _sbss = . ;
        *(.usb_bdt)
    } > ram
    /* .bss section which is used for uninitialized data */
    .bss (NOLOAD) :
    {
        *(SORT_BY_ALIGNMENT(.bss*) SORT_BY_ALIGNMENT(COMMON*))
        . = ALIGN(4);
        _ebss = . ;
    } > ram
    _sidata = LOADADDR(.data);
    .data : AT (_etext)
    {
        _sdata = .;
        *(SORT_BY_ALIGNMENT(.ramtext.*) SORT_BY_ALIGNMENT(.data*))
        . = ALIGN(4);
        _edata = . ;
    } > ram
    /* stack section */
    .co_stack (NOLOAD):
    {
        . = ALIGN(8);
        *(.co_stack .co_stack.*)
    } > ram
    . = ALIGN(4);
    _end = . ;
}
