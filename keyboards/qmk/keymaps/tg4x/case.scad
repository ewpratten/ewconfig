// Filler plate for the TG4X

// Keyboard dimensions
KBD_WIDTH = 255;
KBD_HEIGHT = 84;

// Global cutout sizing
CUTOUT_DEPTH = 20;

// Used to automatically render each half to a different STL file
ENABLE_HALVES = [ true, true ];

module place_standoff_holes(x = 5, y = 5) {
  linear_extrude(height = CUTOUT_DEPTH) {
    // Left
    translate([ 62, 0, 0 ]) square([ x, y ]);
    // Middle
    translate([ 125, 0, 0 ]) square([ x, y ]);
    // Right
    translate([ 188, 0, 0 ]) square([ x, y ]);
  }
}

// Used to slice the model into halves for printing
difference() {
  // Model
  difference() {
    // The fill shape
    union() {
      // Keyboard bounds
      cube([ KBD_WIDTH, KBD_HEIGHT, 3 ]);

      // Walls
      union() {
        // Right wall
        translate([ KBD_WIDTH - 3, 0, 0 ]) cube([ 3, KBD_HEIGHT, 11 ]);
        // Top wall
        translate([ 0, KBD_HEIGHT - 4, 0 ]) cube([ KBD_WIDTH, 4, 11 ]);
        // Left wall
        translate([ 0, 0, 0 ]) cube([ 4, KBD_HEIGHT, 11 ]);
        // Front wall
        difference() {
          translate([ 0, 0, 0 ]) cube([ KBD_WIDTH, 3, 11 ]);
          translate([ KBD_WIDTH / 2, 0, 0 ]) cube([ 35, 10, 20 ]);
        }
      }
    }

    // Cut out the standoff holes
    union() {
      // Corner cuts
      linear_extrude(height = CUTOUT_DEPTH) {
        // Top left
        translate([ 0, 79, 0 ]) square([ 5, 5 ]);
        // Bottom left
        translate([ 0, 0, 0 ]) square([ 5, 5 ]);
        // Top right
        translate([ 250, 79, 0 ]) square([  5, 5 ]);
        // Bottom right
        translate([ 250, 0, 0 ]) square([  5, 5]);
      }

      // Centeral standoff holes
      translate([ 0, 80, 0 ]) place_standoff_holes();
      translate([ 0, 40, 0 ]) place_standoff_holes(y = 5);
      translate([ 0, 0, 0 ]) place_standoff_holes();
    }

    // Cut out a space for the controller
    translate([ 0, 22, 0 ]) cube([ 45, 21, CUTOUT_DEPTH ]);

    // Removal of unnecessary material
    union() {
      // Section 1
      union() {
        translate([ 10, 10, 0 ]) cube([ 45, 25, 10 ]);
        translate([ 10, KBD_HEIGHT - 10 - 25, 0 ]) cube([ 45, 25, 10 ]);
      }
      // Section 2
      union() {
        translate([ 72, 10, 0 ]) cube([ 48, 25, 10 ]);
        translate([ 72, KBD_HEIGHT - 10 - 25, 0 ]) cube([ 48, 25, 10 ]);
      }
      // Section 3
      union() {
        translate([ 135, 10, 0 ]) cube([ 45, 25, 10 ]);
        translate([ 135, KBD_HEIGHT - 10 - 25, 0 ]) cube([ 45, 25, 10 ]);
      }
      // Section 4
      union() {
        translate([ 197, 10, 0 ]) cube([ 48, 25, 10 ]);
        translate([ 197, KBD_HEIGHT - 10 - 25, 0 ]) cube([ 48, 25, 10 ]);
      }
    }
  }

  // Slicing functionality
  if (!ENABLE_HALVES[0]) {
    translate([ 0, 0, 0 ]) cube([ KBD_WIDTH / 2, KBD_HEIGHT, 30 ]);
  }
  if (!ENABLE_HALVES[1]) {
    translate([ KBD_WIDTH / 2, 0, 0 ]) cube([ KBD_WIDTH / 2, KBD_HEIGHT, 30 ]);
  }
}