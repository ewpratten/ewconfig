#pragma once

// Tapdance settings
#define TAPPING_TERM 50
#define TAPPING_TERM_PER_KEY
#define RETRO_TAPPING // https://docs.qmk.fm/#/tap_hold?id=retro-tapping

// Space cadet on control key
#define LCPO_KEYS KC_LCTL, KC_LSFT, KC_0

// // Force constant-speed controls for mouse movement
// #define MK_3_SPEED
// #define MK_MOMENTARY_ACCEL

// // Override the mode-2 speed
// #define MK_C_OFFSET_1 4 // Defaut: 4

// Bootloader settings
#define BOOTMAGIC_LITE_ROW 0
#define BOOTMAGIC_LITE_COLUMN 0

// Chording config
#define FORCE_NKRO
// #define COMBO_COUNT 3
#define COMBO_COUNT 21

// Settings for enabling experiments
#define ENABLE_ASETNIOP