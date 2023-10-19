#! /usr/bin/env python3
import os
import argparse
import sys
import re
import datetime
import subprocess
import tkinter as tk
from pathlib import Path

ALLOWED_INPUT_FORMATS = ["mp4"]
TIMESTAMP_FORMAT_RE = re.compile(r"^\d{2}:\d{2}:\d{2}$")
RENDER_MODES = ["Video + Audio", "Video Only", "Audio Only"]


def open_in_video_player(file: Path):
    os.system(f'xdg-open "{file}"')


def render(
    input_file: Path,
    output_file: Path,
    start_timestamp: str,
    end_timestamp: str,
    mode: str,
):
    # Construct the appropriate ffmpeg command
    ffmpeg_command = ["ffmpeg"]

    # Add the input file
    ffmpeg_command += ["-i", str(input_file)]

    # Add the start and end timestamps
    ffmpeg_command += ["-ss", start_timestamp]
    ffmpeg_command += ["-to", end_timestamp]

    # Add the mode
    if mode == "Video + Audio":
        ffmpeg_command += ["-c", "copy"]
    elif mode == "Video Only":
        ffmpeg_command += ["-c", "copy"]
        ffmpeg_command += ["-an"]
    elif mode == "Audio Only":
        ffmpeg_command += ["-vn"]

    # Add the output file
    ffmpeg_command += [str(output_file)]

    # Run the command. Open in a new terminal window
    subprocess.call(ffmpeg_command)


def do_preview(input_file: Path, start_timestamp: str, end_timestamp: str, mode: str):
    # Start by rendering to a tempfile with the same extension as the input file
    temp_file = Path("/tmp") / f"{input_file.stem}_trimmed{input_file.suffix}"
    temp_file.unlink(missing_ok=True)
    render(input_file, temp_file, start_timestamp, end_timestamp, mode)

    # Display the temp file in a video player
    open_in_video_player(temp_file)


def do_render(input_file: Path, start_timestamp: str, end_timestamp: str, mode: str):
    # Create the new file beside the old one
    start_time_str = start_timestamp.replace(":", ".")
    end_time_str = end_timestamp.replace(":", ".")
    file_suffix = ".mp3" if mode == "Audio Only" else input_file.suffix
    output_file = (
        input_file.parent
        / f"{input_file.stem}_trimmed_{start_time_str}_{end_time_str}_render{file_suffix}"
    )
    output_file.unlink(missing_ok=True)

    # Call the render function
    render(input_file, output_file, start_timestamp, end_timestamp, mode)
    
    # Copy the timestamp metadata from the original file (force overwrite)
    subprocess.call(["ffmpeg", "-i", str(input_file), "-i", str(output_file), "-map_metadata", "0", "-map", "0", "-map", "1", "-c", "copy", "-y", str(output_file)])
    
    # Set the file timestamp to the same as the original file
    subprocess.call(["touch", "-r", str(input_file), str(output_file)])


def build_gui(input_file: Path) -> tk.Tk:
    # Build the GUI
    root = tk.Tk()
    root.title("Evan's Video Trimmer")
    # root.geometry("280x500")

    # Add a section title
    title = tk.Label(root, text="Input File")
    title.grid(row=0, column=0, columnspan=2)

    # Add a button to open the original file
    open_original_button = tk.Button(
        root,
        text="Open original file",
        command=lambda: open_in_video_player(input_file),
    )
    open_original_button.grid(row=2, column=0, columnspan=2, pady=2)

    # Add a horizontal separator
    separator = tk.Frame(height=2, bd=1, relief=tk.SUNKEN)
    separator.grid(row=3, column=0, columnspan=2, sticky=tk.W + tk.E, pady=2)

    # Add a section title
    title = tk.Label(root, text="Output Controls")
    title.grid(row=4, column=0, columnspan=2, pady=2)

    # Add an input field for start timestamp
    start_timestamp = tk.StringVar()
    start_timestamp.set("00:00:00")
    start_timestamp_label = tk.Label(root, text="Start Timestamp")
    start_timestamp_label.grid(row=5, column=0, sticky=tk.E)
    start_timestamp_input = tk.Entry(root, textvariable=start_timestamp)
    start_timestamp_input.grid(row=5, column=1)

    # Add an input field for end timestamp
    end_timestamp = tk.StringVar()
    end_timestamp.set("00:00:00")
    end_timestamp_label = tk.Label(root, text="End Timestamp")
    end_timestamp_label.grid(row=6, column=0, sticky=tk.E)
    end_timestamp_input = tk.Entry(root, textvariable=end_timestamp)
    end_timestamp_input.grid(row=6, column=1)

    # Add a "mode" dropdown
    mode = tk.StringVar()
    mode.set(RENDER_MODES[0])
    mode_label = tk.Label(root, text="Trim Mode")
    mode_label.grid(row=7, column=0, sticky=tk.E)
    mode_input = tk.OptionMenu(root, mode, *RENDER_MODES)
    mode_input.grid(row=7, column=1, sticky="we")

    # Add a horizontal separator
    separator = tk.Frame(height=2, bd=1, relief=tk.SUNKEN)
    separator.grid(row=8, column=0, columnspan=2, sticky=tk.W + tk.E, pady=2)

    # Function to pre-validate inputs
    def validate_inputs():
        # The start timestamp must be hh:mm:ss
        if not TIMESTAMP_FORMAT_RE.match(start_timestamp.get()):
            popup_error(
                "Start timestamp must be in hh:mm:ss format", quit_on_close=False
            )
            return False
        # The end timestamp must be hh:mm:ss
        if not TIMESTAMP_FORMAT_RE.match(end_timestamp.get()):
            popup_error("End timestamp must be in hh:mm:ss format", quit_on_close=False)
            return False
        # The end timestamp must be after the start timestamp
        start_time = datetime.datetime.strptime(start_timestamp.get(), "%H:%M:%S")
        end_time = datetime.datetime.strptime(end_timestamp.get(), "%H:%M:%S")
        if end_time <= start_time:
            popup_error(
                "End timestamp must be after start timestamp", quit_on_close=False
            )
            return False
        return True

    # Add a button to preview the output
    preview_button = tk.Button(
        root,
        text="Preview Output",
        command=lambda: do_preview(
            input_file, start_timestamp.get(), end_timestamp.get(), mode.get()
        )
        if validate_inputs()
        else None,
    )
    preview_button.grid(row=9, column=0, pady=2, sticky="we")

    # Add a button to render the output
    render_button = tk.Button(
        root,
        text="Render",
        command=lambda: do_render(
            input_file, start_timestamp.get(), end_timestamp.get(), mode.get()
        )
        if validate_inputs()
        else None,
    )
    render_button.grid(row=9, column=1, pady=2, sticky="we")

    return root


def popup_error(message: str, quit_on_close: bool = True):
    # Make a popup window
    popup = tk.Tk()
    popup.wm_title("Error")

    # Add a message
    label = tk.Label(popup, text=message)
    label.pack(side="top", fill="x", pady=10)

    # Add a button to close the popup
    button = tk.Button(popup, text="Okay", command=popup.destroy)
    button.pack()

    # Run the popup
    popup.mainloop()

    # Exit the program
    if quit_on_close:
        sys.exit(1)


def main() -> int:
    # Handle program arguments
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--file", help="File to open in Video Trimmer", type=str, required=False
    )
    args = ap.parse_args()

    # Read the file
    uncut_file = Path(args.file) if args.file else None
    if not uncut_file:
        # Try to read from env
        if "NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" not in os.environ:
            popup_error("No file selected")
            return 1
        uncut_file = Path(
            os.environ["NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"].splitlines()[0]
        )

    # Require one of the acceptable file types
    if uncut_file.suffix[1:].lower() not in ALLOWED_INPUT_FORMATS:
        popup_error(
            f"File type not supported: {uncut_file.suffix}\n"
            f"Supported types: {ALLOWED_INPUT_FORMATS}"
        )
        return 1

    # Build the GUI and run
    root = build_gui(uncut_file)
    root.mainloop()

    return 0


if __name__ == "__main__":
    sys.exit(main())
