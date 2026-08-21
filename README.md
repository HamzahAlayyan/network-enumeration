# Network Enumeration Script

A comprehensive Bash script for automated network reconnaissance and enumeration. Designed for penetration testing, security assessments, and educational purposes.

## LEGAL DISCLAIMER

**This tool is for authorized security testing only.** Unauthorized network scanning is **illegal**. Only use on:
- Networks you own
- Networks with written permission to test
- Authorized lab environments

## What It Does

Combines multiple reconnaissance techniques:

**Ping Sweep** - Identifies live hosts on a network  
**Port Scanning** - Discover open ports and services using Nmap
**OS Detection** - Fingerprint operating systems  
**DNS Enumeration** - Resolve domain information  
**WHOIS Lookup** - Identify IP ownership and registration  
**Traceroute** - Map network path to target  
**SSL/TLS Analysis** - Certificate enumeration  
**Subnet Analysis** - Calculate network ranges  
**ARP Discovery** - Local network host discovery  

## Features

- **Comprehensive Scanning** - Multiple reconnaissance and enumeration techniques in one script
- **Colored Output** - Easily readable, color-coded results
- **Result Logging** - Automatically saves findings to a file
- **Error Handling** - Handles missing tools and network issues
- **Both Single Host and Network Range** - Supports IP, hostname, and CIDR notation

## Installation

**Requirements:**
- Bash 4.0+
- Linux/Unix system (Kali, Ubuntu, macOS, etc.)
- Nmap
- bind-utils (dig, nslookup)
- whois

**Quick Setup:**

```bash
# Clone the repository
git clone https://github.com/yourusername/network-enumeration.git
cd network-enumeration

# Make executable
chmod +x network_enumeration.sh

# (Optional) Install missing tools on Ubuntu/Debian
sudo apt-get install nmap whois dnsutils traceroute
```

## Usage

**Basic Syntax:**
```bash
./network_enumeration.sh <target>
```

**Examples:**

```bash
# Scan single host
./network_enumeration.sh 192.168.1.1

# Scan hostname
./network_enumeration.sh example.com

# Scan entire subnet
./network_enumeration.sh 192.168.1.0/24
```

## Example Output

```
==============================================
 Network Reconnaissance and Enumeration Tool v1.0
 Automated network reconnaissance and enumeration script
 Author: Hamzah Khaldun Alayyan
==============================================

[*] Checking dependencies
[+] nmap is installed
[+] ping is installed
[+] nslookup is installed
[+] whois is installed

[*] Validating target
[+] Target validated: 192.168.1.100

[*] Ping Sweep - Checking Live Hosts
[+] Host 192.168.1.100 is reachable

[*] Port Scanning - Identifying Open Common Ports
[i] Running Nmap port scan on 192.168.1.100...
Starting Nmap 7.92 ( https://nmap.org ) at Thu Jan 15 14:30:22 2024
Nmap scan report for 192.168.1.100
Host is up (0.00032s latency).

PORT      STATE SERVICE      VERSION
21/tcp    open  ftp          vsftpd 3.0.2
22/tcp    open  ssh          OpenSSH 7.4
80/tcp    open  http         Apache httpd 2.4.6
443/tcp   open  https        Apache httpd 2.4.6
3306/tcp  open  mysql        MySQL 5.7.20

[i] To perform a full port scan, run: nmap -sV -p- 192.168.1.100

[*] OS Detection & Service Version Detection
[i] Fingerprinting OS and services on 192.168.1.100...
Running: Linux 4.4 - 5.10
OS Details: Linux 4.15 - 5.10
[i] OS detection may be inaccurate, results are best guesses

[*] DNS Enumeration
[i] Resolving DNS records for 192.168.1.100...
[i] A Records:
Server:		192.168.1.1
Address:	192.168.1.1#53

Name:	192.168.1.100
Address: 192.168.1.100

[i] Reverse DNS Lookup:
100.1.168.192.in-addr.arpa	name = router.local.

[*] WHOIS Lookup - Ownership Information
[i] WHOIS information for IP 192.168.1.100:
netrange:      192.168.0.0 - 192.168.255.255
netname:       PRIVATE-ADDRESS-CBLK-RFC1918-RESERVED
nettype:       RESERVED
country:       US
comment:       This block is reserved for use in private networks

[*] Traceroute - Identifying Network Path to Target
[i] Tracing path to 192.168.1.100...
traceroute to 192.168.1.100 (192.168.1.100), 15 hops max, 60 byte packets
 1  gateway.local (192.168.1.1)  0.234 ms  0.198 ms  0.176 ms
 2  192.168.1.100 (192.168.1.100)  0.421 ms  0.398 ms  0.376 ms

[*] SSL/TLS Certificate Enumeration
[i] Checking SSL/TLS certificates for 192.168.1.100...
[+] HTTPS port 443 is open
subject=CN = 192.168.1.100
issuer=CN = 192.168.1.100
notBefore=Jan 15 10:30:22 2024 GMT
notAfter=Jan 14 10:30:22 2025 GMT

[*] Subnet Analysis
[i] Analyzing subnet information for 192.168.1.100:
Address:   192.168.1.100
Netmask:   255.255.255.0 = 24
Wildcard:  0.0.0.255
Network:   192.168.1.0/24
HostMin:   192.168.1.1
HostMax:   192.168.1.254
Hosts/Net: 254

[+] Results saved to ./enum_results/enum_20240115_143022.txt

════════════════════════════════════════════
[+] Enumeration Complete
════════════════════════════════════════════
Results saved to: ./enum_results/enum_20240115_143022.txt

Next Steps:
 1. Review findings very carefully
 2. Prioritize services by criticality
 3. Research known vulnerabilities for identified services
 4. Plan further penetration testing or security assessment based on findings

SECURITY REMINDER:
 - Only test networks you own or have written permission to test.
 - Document all findings and methodologies
 - Respect responsible disclosure practices
══════════════════════════════════════════════
```

## What Each Module Does

### Ping Sweep
Tests if hosts are online using ICMP packets, useful for:
- Identifying active targets
- Network baseline assessment
- Firewall analysis (ICMP filtering)

### Port Scanning
Uses Nmap to identify open ports and running services, which shows:
- Service discovery
- Version detection
- Vulnerability assessment starting point

### OS Detection
Fingerprints operating systems based on network behavior, used for:
- Understanding target infrastructure
- Identifying mismatched/unpatched systems
- Planning OS-specific assessments

### DNS Enumeration
Resolves hostnames, A records, reverse DNS, shows:
- DNS infrastructure
- Virtual hosting
- Subdomain information

### WHOIS Lookup
Identifies IP and domain ownership, shows:
- Organization information
- Registered contact details
- Network assignment details

### Traceroute
Maps the network path to the target which reveals:
- Intermediate hops
- Network topology
- Firewall/proxy presence

### SSL/TLS Analysis
Examines HTTPS certificates, which extracts:
- Certificate issuer and subject
- Validity dates
- Potential certificate mismatches

### Subnet Analysis
Calculates network information which helps with:
- Understanding network ranges
- CIDR planning
- Subnet hierarchy

## Real-World Application

This script reflects techniques used in legitimate penetration testing:
- **Reconnaissance Phase** - First step of authorized security assessments
- **Network Mapping** - Understanding target infrastructure
- **Service Discovery** - Identifying potential vulnerabilities
- **Vulnerability Assessment** - Foundation for targeted testing

During my penetration testing internship at A-Secure, these enumeration techniques were fundamental to every engagement. This script automates the most common reconnaissance tasks, before moving
to the next step.

## Results Storage

Results are automatically saved to:
```
./enum_results/enum_YYYYMMDD_HHMMSS.txt
```

Each scan creates a timestamped file containing:
- Target information
- Nmap comprehensive scan results
- Identified open ports
- Service versions

## Advanced Usage

**Faster scan (common ports only):**
```bash
./network_enumeration.sh 192.168.1.0/24
```

**Manual Nmap for comprehensive results:**
```bash
# All ports with service detection
nmap -sV -p- -O 192.168.1.100

# Aggressive scan (use with permission)
nmap -A -T4 192.168.1.100

# UDP scan
nmap -sU -p 53,161,162 192.168.1.100
```

## Troubleshooting

**"command not found: nmap"**
```bash
# Ubuntu/Debian
sudo apt-get install nmap

# macOS
brew install nmap
```

**"Permission denied" on ports < 1024**
```bash
# Some scanning requires root
sudo ./network_enumeration.sh 192.168.1.100
```

**Script won't run?**
```bash
# Make sure it's executable
chmod +x network_enumeration.sh
```

## Security Considerations

**Legal Usage Only** - Only test networks you own or have written permission to test  
**Documentation** - Keep records of all testing and results  
**Responsible Disclosure** - If you find vulnerabilities, report them properly  
**Network Load** - Large scans can impact network performance  
**Stealth Considerations** - These scans generate significant network traffic and will be logged and detected 

## Limitations

- **Not an Exploit Tool** - Discovers open services but does not exploit them
- **Firewall/IDS Evasion** - Basic scans, easily detected by IDS or Firewalls
- **Accuracy** - OS detection is often inaccurate, use as an estimate only
- **Network Dependent** - Requires network connectivity and appropriate permissions
- **Rate Limiting** - Some networks rate-limit or block excessive scanning

## Ethical Hacking Context

This tool demonstrates understanding of:
- Network fundamentals (IP, DNS, TCP/IP)
- Reconnaissance methodology
- Common penetration testing techniques
- Security assessment workflows
- Responsible disclosure practices

## Author

Hamzah Khaldun Alayyan  
[LinkedIn](www.linkedin.com/in/hamzah-alayyan-12b078334) | [GitHub](https://github.com/HamzahAlayyan)

---

**Reminder:** Please use this tool ethically and legally.
