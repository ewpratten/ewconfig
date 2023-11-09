// Pull in the QMK lib
#include QMK_KEYBOARD_H

/* Trickery to make VSCode happy */
#include <stdint.h>
#define _____ KC_NO
#define _PASS KC_TRNS

/* Layer Definitions */
// clang-format off
enum tg4x_layers {
    QWERTY,
    NUMERIC,
    ACTIONS,
};
// clang-format on

/* Layers */
// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

    // QWERTY
    [QWERTY] = LAYOUT(
        KC_ESC,  KC_Q, KC_W, KC_E, KC_R, KC_T, KC_Y, KC_U, KC_I,    KC_O,   KC_P,    KC_DEL,     KC_BSPC,
        KC_TAB,  KC_A, KC_S, KC_D, KC_F, KC_G, KC_H, KC_J, KC_K,    KC_L,   KC_SCLN, KC_ENT,
        KC_LSFT, KC_Z, KC_X, KC_C, KC_V, KC_B, KC_N, KC_M, KC_COMM, KC_DOT, KC_RSFT, MO(NUMERIC),
        KC_LCTL, KC_LALT, KC_LGUI, KC_SPACE, KC_SPACE, MO(ACTIONS), _____, _____, _____
    ),

    // NUMERIC
    [NUMERIC] = LAYOUT(
        KC_GRV, KC_F1, KC_F2, KC_F3, KC_F4, KC_F5,    KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11, KC_F12,
        KC_1,   KC_2,  KC_3,  KC_4,  KC_5,  KC_6,     KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS, KC_EQL,
        _PASS,  _____, _____, _____, _____, KC_QUOTE, KC_SLSH, KC_LBRC, KC_RBRC, KC_BSLS, _____,   _____,
        _PASS, _PASS, _PASS, KC_SPACE, KC_SPACE, _____, _____, _____, _____
    ),

    // ACTIONS
    [ACTIONS] = LAYOUT(
        _____,   KC_VOLD, KC_VOLU, KC_MUTE, _____, _____,   _____,   KC_PGUP, _____, KC_PGDN,  KC_PSCR, KC_SCRL, KC_PAUS,
        KC_CAPS, KC_MPRV, KC_MPLY, KC_MNXT, _____, _____,   KC_LEFT, KC_DOWN, KC_UP, KC_RIGHT, KC_INS,  _____,
        _PASS,   RGB_TOG, _____,   _____,   _____, KC_HOME, KC_END,  _____,   _____, _____,    _PASS,   _____,
        _PASS, _PASS, _PASS, KC_SPACE, KC_SPACE, _____, _____, _____, _____
    ),

};
// clang-format on
