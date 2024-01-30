#include QMK_KEYBOARD_H

// Combo magic
#include "combos.c"

// Layer definitions
enum ferris_layers {
  // _HOME,
  // _QWERTY,
  _MODMAK,
  // _NUMERIC,
  // _UTILITY,
  // _MACROS,
  // _RAINBOW,
};

// Shorthands
#define LD_TERM LGUI(KC_ENT)
#define CC_QUIT LGUI(LSFT(KC_Q))
#define CC_COMM LCTL(KC_SLSH)
#define CC_FMT LCTL(LSFT(KC_I))

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

  // [_HOME] = LAYOUT(
  //   KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,        KC_NO, KC_NO, KC_NO, KC_NO, KC_BSPC,
  //   KC_A,  KC_R,  KC_S,  KC_T,  KC_D,         KC_H,  KC_N,  KC_E,  KC_I,  KC_O,
  //   KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
  //                      KC_LSFT, KC_LCTL,      KC_SPACE, KC_NO
  // ),

  // [_QWERTY] = LAYOUT(
  //   KC_Q, KC_W, KC_E, KC_R, KC_T,        KC_Y, KC_U, KC_I, KC_O, KC_P,
  //   KC_A, KC_S, KC_D, KC_F, KC_G,        KC_H, KC_J, KC_K, KC_L, KC_SCLN,
  //   KC_Z, KC_X, KC_C, KC_V, KC_B,        KC_N, KC_M, KC_COMM, KC_DOT, KC_NO,
  //                  KC_LCTL, KC_SPACE,    KC_SPACE, KC_LSFT
  // )

  [_MODMAK] = LAYOUT(
    KC_Q, KC_W,    KC_F,    KC_P,    KC_G,            KC_J,      KC_L,  KC_U,    KC_Y,   KC_BSPC,
    KC_A, KC_R,    KC_S,    KC_T,    KC_D,            KC_H,      KC_N,  KC_E,    KC_I,   KC_O,
    KC_LCTL, KC_Z, KC_X,    KC_C,    KC_V,            KC_B,      KC_M,  KC_K, KC_COMM, KC_DOT,
                          KC_LSFT, KC_LCTL,         KC_SPACE, KC_SPACE
                            // KC_LSFT, MO(_MACROS),         LT(_UTILITY, KC_SPACE), LT(_NUMERIC, KC_SPACE)
  ),

  // [_NUMERIC] = LAYOUT(
  //   KC_F1,    KC_F2,  KC_F3,  KC_F4,  KC_F5,   /**/    KC_F6,    KC_F7,  KC_F8,  KC_F9,  KC_F10,
  //   KC_1,     KC_2,   KC_3,   KC_4,   KC_5,    /**/    KC_6,     KC_7,   KC_8,   KC_9,   KC_0,
  //   KC_LALT,  KC_NO,  KC_NO,  KC_NO,  TO(_MODMAK),   /**/    KC_LGUI,  KC_EQL,  KC_MINS,  KC_F11, KC_F12,
  //                        KC_LSFT,   KC_LCTL,   /**/    KC_NO,    KC_NO
  // ),

  // [_UTILITY] = LAYOUT(
  //   KC_Q, KC_VOLD, KC_VOLU, KC_NO, KC_PSCR,    /**/    LD_TERM,  KC_HOME,   KC_PGUP,  KC_PGDN,  KC_DEL,
  //   KC_MPRV, KC_MPLY, KC_MNXT, KC_NO, KC_TAB,     /**/    KC_LEFT,  KC_DOWN,  KC_UP,    KC_RIGHT, KC_END,
  //   KC_NO, KC_NO, KC_NO, CC_FMT, CC_COMM,      /**/    KC_QUOTE, KC_SLSH, KC_LBRC, KC_RBRC,  KC_BSLS,
  //                   KC_LSFT,   KC_LCTL,     /**/    KC_NO, KC_LGUI
  // ),

  // [_MACROS] = LAYOUT(
  //   KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,        KC_NO, KC_NO, KC_NO, KC_NO, TO(_RAINBOW),
  //   KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
  //   KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
  //                        KC_NO, KC_NO,        KC_NO, KC_NO
  // ),

  // [_RAINBOW] = LAYOUT(
  //   KC_ESC, KC_Q, KC_W, KC_E, KC_5,        TO(_MODMAK), KC_NO, KC_NO, KC_NO, KC_NO,
  //   KC_LSFT, KC_A, KC_S, KC_D, KC_G,       KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
  //   KC_LCTL, KC_Z, KC_X, KC_C, KC_V,       KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
  //                    KC_SPACE, KC_X,       KC_NO, KC_NO
  // )
};
// clang-format on

/** THIS IS FOR CREATING A NEW KEYMAP **
  [_UNSET_] = LAYOUT(
    KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
    KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
    KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
                         KC_NO, KC_NO,        KC_NO, KC_NO
  )
*/

// Overrides for the tapping terms.
uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  // Space cadet needs to be much slower than my default
  // case SC_LSPO:
  // case SC_LCPO:
  //   return 200;
  // case LT(_NUMERIC, KC_SPACE):
  //   return 1000;
  default:
    return TAPPING_TERM;
  }
}
