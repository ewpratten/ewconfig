#! /usr/bin/env python3
import argparse
import sys
import subprocess
from datetime import datetime
from typing import List, Optional

try:
    import timeago
except ImportError:
    print(
        "Required dependency missing. Install by running: pip3 install timeago",
        file=sys.stderr,
    )
    sys.exit(1)


def get_name_for_client(
    pubkey: str, endpoint: str, allowed_ips: List[str], dns_server: Optional[str] = None
) -> str:
    # Build the dig command prefix
    dig_cmd_pfx = ["dig"]
    if dns_server:
        dig_cmd_pfx.append(f"@{dns_server}")

    # Search through the allowed ips for addresses with reverse dns
    for ip in allowed_ips:
        ip = ip.split("/")[0]
        try:
            name = subprocess.check_output(dig_cmd_pfx + ["-x", ip, "+short"]).decode(
                "utf-8"
            )
            name = name.strip()
            if name != "":
                return name[:-1]
        except subprocess.CalledProcessError:
            pass

    # Check the endpoint for reverse dns
    try:
        name = subprocess.check_output(dig_cmd_pfx + ["-x", endpoint, "+short"]).decode(
            "utf-8"
        )
        name = name.strip()
        if name != "":
            return name[:-1]
    except subprocess.CalledProcessError:
        pass

    # If all else fails, return the first 8 characters of the public key followed by ...
    return pubkey[:8] + "..."


def main() -> int:
    # Handle program arguments
    ap = argparse.ArgumentParser(
        prog="wg-handshakes", description="List the recency of WireGuard handshakes"
    )
    ap.add_argument(
        "--interface", "-i", help="The WireGuard interface to use", default="all"
    )
    ap.add_argument(
        "--no-sudo", help="Do not use sudo when running commands", action="store_true"
    )
    ap.add_argument(
        "--dns-server", "-d", help="Override the DNS server to use for RDNS lookups"
    )
    args = ap.parse_args()

    # Get the output of wg show
    cmd = ["wg", "show", args.interface, "dump"]
    if not args.no_sudo:
        cmd.insert(0, "sudo")
    output = subprocess.check_output(cmd).decode("utf-8")

    # For every line (client) except the first (this device)
    lines = output.split("\n")[1:]
    outputs = []
    for line in lines:
        # values are in TSV
        values = line.split("\t")

        # If the interface is `all`, ignore the first value
        if args.interface == "all":
            values = values[1:]

        # If the line is empty, skip it
        if len(values) == 0:
            continue

        # Get the client's public key
        pubkey = values[0]

        # Read the IPs of the client to guess its name
        allowed_ips = values[3].split(",")
        endpoint = values[2].split(":")[0]

        # Get the name of the client
        name = get_name_for_client(pubkey, endpoint, allowed_ips, args.dns_server)

        # Get the time of the last handshake
        last_handshake = datetime.fromtimestamp(int(values[4]))
        time_ago = (
            timeago.format(last_handshake, datetime.now())
            if values[4] != "0"
            else "Never"
        )

        outputs.append((name, last_handshake, time_ago))

    # Sort the outputs by time
    outputs.sort(key=lambda x: x[1], reverse=True)

    # Print the outputs
    for output in outputs:
        print(f"{output[0]}: {output[2]}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
