# Network Reconnaissance and Enumeration Script

A concise Bash script for automated network reconnaissance and enumeration. Designed for penetration testing, security assessments, lab exercises and educational purposes.

**LEGAL DISCLAIMER:** Running this script on networks you do not own/have permission to test is illegal.

## Features

**Ping Sweep** - Host discovery and availability checking  
**Port Scanning** - Identify open ports and services using Nmap 
**OS Detection** - Operating system and service version fingerprinting  
**DNS Enumeration** - Domain name and reverse DNS resolution  
**WHOIS Lookup** - IP/domain ownership and registration info  
**Traceroute** - Network path mapping to target  
**SSL/TLS Analysis** - Certificate information extraction  
**Subnet Analysis** - Network range and CIDR calculations  
**ARP Discovery** - Local network host enumeration  
**Timestamped Reporting** - Automated scan result logging  

## Installation

**Requirements:**
- Bash 4.0+
- Linux/Unix
- Nmap
- whois
- dnsutils

Additional:
- traceroute
- arp-scan
- ipcalc
- openssl

```bash
git clone https://github.com/HamzahAlayyan/network-enumeration.git
cd network-enumeration
chmod +x Networkscan.sh

# Install dependencies (Ubuntu/Debian)
sudo apt-get install nmap whois dnsutils traceroute arp-scan ipcalc
```

## Usage

```bash
# Single host
./Networkscan.sh 192.168.1.1

# Network range (CIDR)
./Networkscan.sh 192.168.1.0/24

# Domain name
./Networkscan.sh example.com
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
[+] CIDR notation detected: 192.168.1.0/24
[+] Target validated: 192.168.1.0/24

[*] Ping Sweep - Checking Live Hosts
[+] Results will be saved to: ./enum_results/enum_20240115_143022.txt

[*] Ping Sweep - Checking Live Hosts
192.168.1.1
192.168.1.100

[*] Port Scanning - Identifying Open Common Ports
[i] Running Nmap port scan on 192.168.1.0/24...

[*] OS Detection & Service Version Detection
[i] Fingerprinting OS and services on 192.168.1.0/24...

[*] DNS Enumeration
[i] Resolving DNS records for 192.168.1.0/24...

[*] WHOIS Lookup - Ownership Information
[i] WHOIS information for domain 192.168.1.0/24:
netrange:      192.168.0.0 - 192.168.255.255
netname:       PRIVATE-ADDRESS-CBLK-RFC1918-RESERVED

[*] Traceroute - Identifying Network Path to Target
[i] Tracing path to 192.168.1.0/24...

[*] SSL/TLS Certificate Enumeration
[i] Checking SSL/TLS certificates for 192.168.1.0/24...

[*] Subnet Analysis
[i] Analyzing subnet information for 192.168.1.0/24...

[*] Local Network Discovery - ARP Scanning
[i] Discovering hosts on the local network...
[i] Running ARP scan on local network...

════════════════════════════════════════════
[+] Enumeration Complete
════════════════════════════════════════════
Results saved to: ./enum_results/enum_20240115_143022.txt

Next Steps:
 1. Review findings very carefully
 2. Prioritize services by criticality
 3. Research known vulnerabilities for identified services
 4. Plan further penetration testing based on findings

SECURITY REMINDER:
 • Only test networks you own or have written permission to test
 • Document all findings and methodologies
 • Respect responsible disclosure practices
════════════════════════════════════════════
```

## Modules

| Module | Purpose |
|--------|---------|
| **Ping Sweep** | Identify live hosts using ICMP packets |
| **Port Scanning** | Discover open ports and services |
| **OS Detection** | Fingerprint OS and service versions |
| **DNS Enumeration** | Resolve hostnames and records |
| **WHOIS** | Check IP/domain ownership |
| **Traceroute** | Map network path to target |
| **SSL/TLS** | Extract certificate information |
| **Subnet Analysis** | Calculate network ranges |
| **ARP Discovery** | Find hosts on local network |

## Reconnaissance Methodology

This script automates reconnaissance, the (first phase) of **authorized** penetration testing:

1. **Information Gathering** - Collect data about the target
2. **Network Mapping** - Understand infrastructure and topology
3. **Service Enumeration** - Identify running services and versions
4. **Vulnerability Research** - Assess known vulnerabilities (manual follow-up)

## Results Storage

Timestamped reports saved to: `./enum_results/enum_YYYYMMDD_HHMMSS.txt`

Includes:
- Nmap scan results
- Open ports and service versions
- DNS records and WHOIS information
- SSL/TLS certificate details
- Subnet calculations

## Advanced Usage

```bash
# Full port scan (all 65535 ports)
nmap -sV -p- -O 192.168.1.1

# Aggressive scan (more detection, more traffic)
nmap -A -T4 192.168.1.1

# UDP service scanning
nmap -sU -p 53,161,162 192.168.1.1

# Output to file
nmap -sV -oN output.txt 192.168.1.1
```

## Limitations

- **Reconnaissance only** - Does not exploit vulnerabilities, strictly a reconnaissance tool
- **Easily detected** - Generates significant network traffic and logs
- **OS detection accuracy** - Results are close estimates
- **Network dependent** - Requires connectivity and permissions
- **Rate limiting** - Some networks block excessive scanning

## Security Considerations

**Only test authorized targets** - Legal liability is real  
**Document everything** - Keep methodology and findings records  
**Responsible disclosure** - Report vulnerabilities through proper channels  
**Be aware of IDS/IPS** - Monitoring systems will detect scans  
**Consider business impact** - Large scans can affect network performance  

## Code Organization

```
UTILITY FUNCTIONS
    print_*() - Output formatting
    check_command() - Dependency checking
    validate_ip() - Input validation
    validate_target() - Target validation

ENUMERATION FUNCTIONS
    enum_ping_sweep()
    enum_port_scan()
    enum_os_detection()
    enum_traceroute()
    enum_dns_lookup()
    enum_whois()
    enum_subnet_analysis()
    enum_ssl_tls()
    enum_local_network()

REPORTING FUNCTIONS
    setup_output() - Initialize output
    save_results() - Log findings
    print_summary() - Results summary

MAIN EXECUTION
    main() - Orchestrate workflow
```

## Troubleshooting

**Missing Nmap:**
```bash
# Ubuntu/Debian
sudo apt-get install nmap

# macOS
brew install nmap
```

**Permission denied (requires root for some operations):**
```bash
sudo ./Networkscan.sh 192.168.1.1
```

**Script won't run:**
```bash
chmod +x Networkscan.sh
```

## Author

**Hamzah Khaldun Alayyan**  
BSc Computer Science (Cyber Security), Newcastle University  
CompTIA Security+, INE eJPT Certified  

---

**Remember:** Please use this tool legally and ethically. Failure to do so is a crime.
