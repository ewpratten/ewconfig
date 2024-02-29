# Override the default bootloader since I am using a non-standard MCU
BOOTLOADER = qmk-dfu

# Enable bootloader keys
BOOTMAGIC_ENABLE = yes

# Set up chording support
FORCE_NKRO = yes
COMBO_ENABLE = yes