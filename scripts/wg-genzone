#! /usr/bin/env python3
import argparse
import sys
import subprocess
import ipaddress
import json
from typing import Optional, List, Tuple, Union
from dataclasses import dataclass


@dataclass
class PeerMetadata:
    host: str
    namespace: Optional[str] = None


def get_interface_config(interface: str, sudo: bool = False) -> Optional[str]:
    # Execute wg-quick to get the interface config
    try:
        cmd = ["wg-quick", "strip", interface]
        if sudo:
            cmd.insert(0, "sudo")
        output = subprocess.check_output(cmd, text=True)
    except subprocess.CalledProcessError as e:
        print(f"Error executing wg-quick: {e}", file=sys.stderr)
        return None

    return output


def get_addr_maps(
    config: str,
) -> List[
    Tuple[PeerMetadata, List[Union[ipaddress.IPv4Address, ipaddress.IPv6Address]]]
]:
    # Split into lines
    lines = config.splitlines()

    # Read until the first peer definition
    while lines and not lines[0].startswith("[Peer]"):
        lines.pop(0)

    # Read the peer definitions
    output = []
    while len(lines) > 0:
        # Read the peer definition
        peer_line = lines.pop(0).split("#")

        # Skip peers without metadata
        if len(peer_line) == 1 or peer_line[1].strip() == "":
            while len(lines) > 0 and not lines[0].startswith("[Peer]"):
                lines.pop(0)
            continue

        # The metadata is JSON
        metadata = json.loads(peer_line[1])
        metadata = PeerMetadata(host=metadata["host"], namespace=metadata.get("ns"))

        # Skim through everything until the next peer definition ( or EOF ) in search of allowed ips
        allowed_ips = []
        while len(lines) > 0 and not lines[0].startswith("[Peer]"):
            # If this is an allowed ip line, parse it
            if lines[0].startswith("AllowedIPs"):
                allowed_ips_line = lines[0].split("#")[0]
                allowed_ips.extend(
                    [
                        ipaddress.ip_network(addr.strip())
                        for addr in (allowed_ips_line.split("=")[1].strip()).split(",")
                    ]
                )

            # Pop the line
            lines.pop(0)

        # Find any ips that are a /32 (ipv4) or /128 (ipv6)
        addresses = []
        for allowed_ip in allowed_ips:
            if (
                isinstance(allowed_ip, ipaddress.IPv4Network)
                and allowed_ip.prefixlen == 32
            ):
                addresses.append(allowed_ip.network_address)
            elif (
                isinstance(allowed_ip, ipaddress.IPv6Network)
                and allowed_ip.prefixlen == 128
            ):
                addresses.append(allowed_ip.network_address)

        # Build the output
        output.append((metadata, addresses))

    return output


def main() -> int:
    # Handle program arguments
    ap = argparse.ArgumentParser(
        prog="wg-genzone",
        description="Generates a DNS zone file for a WireGuard interface",
    )
    ap.add_argument("interface", help="The name of the WireGuard interface")
    ap.add_argument("--zone", help="The name of the zone to generate", required=True)
    ap.add_argument(
        "--no-sudo", action="store_true", help="Do not use sudo to execute wg-quick"
    )
    ap.add_argument("--ttl", help="The TTL to use for the zone", default=60)
    args = ap.parse_args()

    # Read the interface config
    config = get_interface_config(args.interface, sudo=not args.no_sudo)
    if not config:
        return 1

    # Get a mapping of metadata to addresses
    addr_maps = get_addr_maps(config)
    
    # Convert to a zone file
    print(f"$ORIGIN {args.zone}.")
    print(f"$TTL {args.ttl}")
    print(f"@ IN SOA ns.{args.zone}. noc.ewpratten.com. 1 3600 600 86400 60")
    
    # Add the hosts
    for metadata, addresses in addr_maps:
        # Build the host's address
        host = metadata.host
        if metadata.namespace:
            host = f"{host}.{metadata.namespace}"
        host = f"{host}.{args.zone}"
        
        # Add forward and reverse records
        for address in addresses:
            if isinstance(address, ipaddress.IPv4Address):
                print(f"{host}. IN A {address}")
                print(f"{address.reverse_pointer}. IN PTR {host}.")
            elif isinstance(address, ipaddress.IPv6Address):
                print(f"{host}. IN AAAA {address}")
                print(f"{address.reverse_pointer}. IN PTR {host}.")
    
    
    return 0


if __name__ == "__main__":
    sys.exit(main())
