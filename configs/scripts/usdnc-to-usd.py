#! /usr/bin/env -S hython-latest -I
import argparse
import sys
from pxr import Usd
from pathlib import Path


def main() -> int:
    # Handle program arguments
    ap = argparse.ArgumentParser(
        prog="usdnc-to-usd", description="Convert USDNC files to USD"
    )
    ap.add_argument("input", help="Input file", type=Path)
    ap.add_argument(
        "--output",
        "-o",
        help="Output file. Defaults to the input file with a new extension.",
        type=Path,
        default=None,
    )
    ap.add_argument(
        "--format",
        "-f",
        help="Output format. Defaults to usda.",
        type=str,
        default="usda",
        choices=["usda", "usdc"],
    )
    args = ap.parse_args()
    
    # Read the input file
    print(f"Opening stage from: {args.input}")
    stage = Usd.Stage.Open(args.input.as_posix())
    
    # Determine the output file
    if not args.output:
        args.output = args.input.with_suffix(f".{args.format}")
        
    # Write the output file
    print(f"Writing stage to: {args.output}")
    stage.Export(args.output.as_posix())

    return 0


if __name__ == "__main__":
    sys.exit(main())
