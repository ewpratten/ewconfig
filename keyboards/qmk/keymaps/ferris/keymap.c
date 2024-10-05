#include QMK_KEYBOARD_H

// Shorthands
#define _____ KC_NO

// Combo magic
#include "combos.c"

// Layer definitions
enum ferris_layers {
  _TYPING
};


// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [_TYPING] = LAYOUT(
    _____, _____,    _____,    _____,    _____,            _____,      _____,  _____,    _____,   KC_BSPC,
    KC_A, KC_R,    KC_S,    KC_T,    _____,            _____,      KC_N,  KC_E,    KC_I,   KC_O,
    _____, _____, _____,    _____,    _____,            _____,      _____,  _____, _____, _____,
                          KC_LSFT, KC_LCMD,         KC_SPACE, KC_SPACE
  )
};
// clang-format on

