#include QMK_KEYBOARD_H


#define MAKE_COMBO_INPUTS(name, inputs...) const uint16_t PROGMEM combo_inputs_##name[] = {inputs, COMBO_END};


// Combo tokens. These are used to identify combos for later processing if needed.
enum combos {
    // Combo that uses both pinky fingers to produce an <enter> keypress
    COMBO_PINKY_ENTER,
    // Combo that uses both ring fingers to produce a <backspace> keypress
    // COMBO_RING_BACKSPC,
    // Combo that uses the ring fingers to send a semicolon
    COMBO_RING_SCLN,
    // Copbo that uses the pinky fingers to send escape
    COMBO_PINKY_ESC,

    // ASETNIOP
    ASETNIOP_AE_Q,
    ASETNIOP_RA_W,
    ASETNIOP_RE_Z,
    ASETNIOP_SA_X,
    ASETNIOP_SR_F,
    ASETNIOP_TA_P,
    ASETNIOP_TR_C,
    ASETNIOP_TS_D,
    ASETNIOP_TN_B,
    ASETNIOP_TE_V,
    ASETNIOP_TI_G,
    ASETNIOP_NA_J,
    ASETNIOP_NR_K,
    ASETNIOP_NS_M,
    ASETNIOP_NE_H,
    ASETNIOP_NO_L,
    ASETNIOP_EI_U,
    ASETNIOP_IN_Y,
};

// Define all the input combinations needed for the combos
MAKE_COMBO_INPUTS(COMBO_PINKY_ENTER, KC_A, KC_O)
MAKE_COMBO_INPUTS(COMBO_RING_SCLN, KC_R, KC_I)
MAKE_COMBO_INPUTS(COMBO_PINKY_ESC, KC_Q, KC_BSPC)
// MAKE_COMBO_INPUTS(COMBO_RING_BACKSPC, KC_R, KC_I)
MAKE_COMBO_INPUTS(ASETNIOP_AE_Q, KC_A, KC_E)
MAKE_COMBO_INPUTS(ASETNIOP_RA_W, KC_R, KC_A)
MAKE_COMBO_INPUTS(ASETNIOP_RE_Z, KC_R, KC_E)
MAKE_COMBO_INPUTS(ASETNIOP_SA_X, KC_S, KC_A)
MAKE_COMBO_INPUTS(ASETNIOP_SR_F, KC_S, KC_R)
MAKE_COMBO_INPUTS(ASETNIOP_TA_P, KC_T, KC_A)
MAKE_COMBO_INPUTS(ASETNIOP_TR_C, KC_T, KC_R)
MAKE_COMBO_INPUTS(ASETNIOP_TS_D, KC_T, KC_S)
MAKE_COMBO_INPUTS(ASETNIOP_TN_B, KC_T, KC_N)
MAKE_COMBO_INPUTS(ASETNIOP_TE_V, KC_T, KC_E)
MAKE_COMBO_INPUTS(ASETNIOP_TI_G, KC_T, KC_I)
MAKE_COMBO_INPUTS(ASETNIOP_NA_J, KC_N, KC_A)
MAKE_COMBO_INPUTS(ASETNIOP_NR_K, KC_N, KC_R)
MAKE_COMBO_INPUTS(ASETNIOP_NS_M, KC_N, KC_S)
MAKE_COMBO_INPUTS(ASETNIOP_NE_H, KC_N, KC_E)
MAKE_COMBO_INPUTS(ASETNIOP_NO_L, KC_N, KC_O)
MAKE_COMBO_INPUTS(ASETNIOP_EI_U, KC_E, KC_I)
MAKE_COMBO_INPUTS(ASETNIOP_IN_Y, KC_I, KC_N)

// Map everything together
combo_t key_combos[COMBO_COUNT] = {
    [COMBO_PINKY_ENTER] = COMBO(combo_inputs_COMBO_PINKY_ENTER, KC_ENT),
    [COMBO_RING_SCLN] = COMBO(combo_inputs_COMBO_RING_SCLN, KC_SCLN),
    [COMBO_PINKY_ESC] = COMBO(combo_inputs_COMBO_PINKY_ESC, KC_ESC),
    // [COMBO_RING_BACKSPC] = COMBO(combo_inputs_COMBO_RING_BACKSPC, KC_BSPC),
    [ASETNIOP_AE_Q] = COMBO(combo_inputs_ASETNIOP_AE_Q, KC_Q),
    [ASETNIOP_RA_W] = COMBO(combo_inputs_ASETNIOP_RA_W, KC_W),
    [ASETNIOP_RE_Z] = COMBO(combo_inputs_ASETNIOP_RE_Z, KC_Z),
    [ASETNIOP_SA_X] = COMBO(combo_inputs_ASETNIOP_SA_X, KC_X),
    [ASETNIOP_SR_F] = COMBO(combo_inputs_ASETNIOP_SR_F, KC_F),
    [ASETNIOP_TA_P] = COMBO(combo_inputs_ASETNIOP_TA_P, KC_P),
    [ASETNIOP_TR_C] = COMBO(combo_inputs_ASETNIOP_TR_C, KC_C),
    [ASETNIOP_TS_D] = COMBO(combo_inputs_ASETNIOP_TS_D, KC_D),
    [ASETNIOP_TN_B] = COMBO(combo_inputs_ASETNIOP_TN_B, KC_B),
    [ASETNIOP_TE_V] = COMBO(combo_inputs_ASETNIOP_TE_V, KC_V),
    [ASETNIOP_TI_G] = COMBO(combo_inputs_ASETNIOP_TI_G, KC_G),
    [ASETNIOP_NA_J] = COMBO(combo_inputs_ASETNIOP_NA_J, KC_J),
    [ASETNIOP_NR_K] = COMBO(combo_inputs_ASETNIOP_NR_K, KC_K),
    [ASETNIOP_NS_M] = COMBO(combo_inputs_ASETNIOP_NS_M, KC_M),
    [ASETNIOP_NE_H] = COMBO(combo_inputs_ASETNIOP_NE_H, KC_H),
    [ASETNIOP_NO_L] = COMBO(combo_inputs_ASETNIOP_NO_L, KC_L),
    [ASETNIOP_EI_U] = COMBO(combo_inputs_ASETNIOP_EI_U, KC_U),
    [ASETNIOP_IN_Y] = COMBO(combo_inputs_ASETNIOP_IN_Y, KC_Y),
};