#!/bin/bash

##############################################################################################
# Automated network reconnaissance and enumeration script
#
# Purpose: Automated network reconnaissance and enumeration
# Used in: Penetration testing, network security assessment, lab exercises
# Author: Hamzah Khaldun Alayyan
#
# LEGAL DISCLAIMER: Please only use this on networks you own or have valid permission to test.
# Unauthorized scanning is illegal.
##############################################################################################

set -e # Exit on error

# Color codes 
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No color

# All global variables
TARGET=""
OUTPUT_DIR="./enum_results"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="${OUTPUT_DIR}/enum_${TIMESTAMP}.txt"

##############################################################################################
# UTILITY FUNCTIONS
##############################################################################################

print_banner() {
    echo -e "${BLUE}"
    echo "=============================================="
    echo " Network Reconnaissance and Enumeration Tool v1.0"
    echo " Automated network reconnaissance and enumeration script"
    echo " Author: Hamzah Khaldun Alayyan"
    echo "=============================================="
    echo -e "${NC}"
}

print_section() {
    echo -e "\n${YELLOW}[*] $1${NC}"
}

print_success() {
    echo -e "${GREEN}[+] $1${NC}"
}

print_error() {
    echo -e "${RED}[-] $1${NC}"
}

print_info() {
    echo -e "${BLUE}[i] $1${NC}"
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_error "$1 is not installed. Please install it and try again."
        return 1
    fi
    return 0
}

validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0
    else
        return 1
    fi 
}

validate_target() {
    if ! validate_ip "$TARGET"; then
        # Try to resolve hostname 
        if ! host "$TARGET" &> /dev/null; then
            print_error "Invalid target: $TARGET. Please provide a valid IP address or hostname."
            return 1
        fi
    fi
    return 0
}

##############################################################################################
# ENUMERATION FUNCTIONS
##############################################################################################

enum_ping_sweep() {
    print_section "Ping Sweep - Checking Live Hosts"

    if [[ $TARGET == *"/"* ]]; then
        # For CIDR Notation 
        nmap -sn "$TARGET" 2>/dev/null | grep "Nmap scan report" | awk '{print $NF}' | sort
    else
        # For single host
        if ping -c 1 -W 1 "$TARGET" &> /dev/null; then
            print_success "Host $TARGET is reachable"
            echo "$TARGET" 
        else
            print_error "Host $TARGET is not reachable (or may have firewall blocking ICMP)"
        fi
    fi
}

enum_port_scan() {
    print_section "Port Scanning - Identifying Open Common Ports"
    print_info "Running Nmap port scan on $TARGET..."

    nmap -p 21,22,23,25,53,80,110,143,443,445,3306,3389,5432,5984,8080,8443 \
     -sV --open "$TARGET" 2>/dev/null

    print_info "To perform a full port scan, run: nmap -sV -p- $TARGET"
}

enum_os_detection() {
    print_section "OS Detection & Service Version Detection"
    print_info "Fingerprinting OS and services on $TARGET..."

    nmap -O -sV "$TARGET" 2>/dev/null | grep -E "Running|Nmap scan|Service|OS"

    print_info "OS detection may be inaccurate, results are best guesses"
}

enum_traceroute() {
    print_section "Traceroute - Identifying Network Path to Target"
    print_info "Tracing path to $TARGET..."

    if command -v traceroute &> /dev/null; then
        traceroute -m 15 "$TARGET" 2>/dev/null || print_error "Traceroute Failed"
    else
        print_error "traceroute is not installed. Please install it to perform traceroute."
    fi
}

enum_dns_lookup() {
    print_section "DNS Enumeration"
    print_info "Resolving DNS records for $TARGET..."

    # Will get A records
    print_info "A Records:"
    nslookup "$TARGET" 2>/dev/null | grep -A 5 "Name:" || echo "No A records found"

    # Try reverse DNS Lookup if target is IP address
    if validate_ip "$TARGET"; then
        print_info "Reverse DNS Lookup:"
        nslookup "$TARGET" 2>/dev/null | grep -E "name|addr" || echo "No reverse DNS records found"
    fi
}

enum_whois() {
    print_section "WHOIS Lookup - Ownership Information"

    if validate_ip "$TARGET"; then
        print_info "WHOIS information for IP $TARGET:"
        whois "$TARGET" 2>/dev/null | head -20 || print_error "whois command failed"
    else
        print_info "WHOIS information for domain $TARGET:"
        whois "$TARGET" 2>/dev/null | head -20 || print_error "whois command failed"
    fi
}

enum_subnet_analysis() {
    print_section "Subnet Analysis"
    
    if validate_ip "$TARGET"; then
        print_info "Analyzing subnet information for $TARGET:"

        # Basic subnet calculation (needs ipcalc)
        if command -v ipcalc &> /dev/null; then
            ipcalc "$TARGET" 2>/dev/null
        else
            print_info "Install 'ipcalc' for detailed subnet analysis: sudo apt install ipcalc"
        fi
    fi
}

enum_ssl_tls() {
    print_section "SSL/TLS Certificate Enumeration"
    print_info "Checking SSL/TLS certificates for $TARGET..."

    # This checks if port 443 is open
    if nmap -p 443 --open "$TARGET" 2>/dev/null | grep -q "443/tcp"; then
        print_success "HTTPS port 443 is open"

        if command -v openssl &> /dev/null; then
            echo | openssl s_client -connect "$TARGET:443" -servername "$TARGET" 2>/dev/null | \
            grep -E "subject=|issuer=|notBefore=|notAfter="
        else
            print_error "openssl not installed"
        fi
    else
        print_error "HTTPS (443) does not appear to be open" 
    fi
}

enum_local_network() {
    print_section "Local Network Enumeration"
    print_info "Discovering hosts on the local network..."

    # Get local IP and subnet
    if command -v ip &> /dev/null; then
        DEFAULT_GATEWAY=$(ip route | grep default | awk '{print $3}')
        print_info "Default gateway: $DEFAULT_GATEWAY"

        # ARP scan
        if command -v arp-scan &> /dev/null; then
            print_info "Running ARP scan on local network..."
            arp-scan --localnet 2>/dev/null | grep -E "^\d" || echo "No hosts found"
        else
            print_info "Please install 'arp-scan' for network discovery, type sudo apt install arp-scan"
        fi
    fi
}

#############################################################################
# REPORTING FUNCTIONS
#############################################################################

setup_output() {
    mkdir -p "$OUTPUT_DIR"
    print_success "Results will be saved to: $RESULTS_FILE"
}

save_results() {
    {
        echo "=============================================="
        echo " Network Reconnaissance and Enumeration Report"
        echo " Target: $TARGET"
        echo " Date: $(date)"
        echo "=============================================="
        echo ""
    } > "$RESULTS_FILE"

    # Appends Nmap results
    {
        echo "=== NMAP RESULTS ==="
        nmap -sV -O --open "$TARGET" 2>/dev/null
        echo ""
        echo "=== OPEN PORTS ==="
        nmap -p- --open "$TARGET" 2>/dev/null | grep open
    } >> "$RESULTS_FILE"

    print_success "Results saved to $RESULTS_FILE"
}

print_summary() {
    echo -e "\n${YELLOW}════════════════════════════════════════════${NC}"
    echo -e "${GREEN}[+] Enumeration Complete${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════${NC}"
    echo "Results saved to: $RESULTS_FILE"
    echo ""
    echo "Next Steps:"
    echo " 1. Review findings very carefully"
    echo " 2. Prioritize services by criticality"
    echo " 3. Research known vulnerabilities for identified services"
    echo " 4. Plan further penetration testing or security assessment based on findings"
    echo ""
    echo "SECURITY REMINDER:"
    echo " - Only test networks you own or have written permission to test."
    echo " - Document all findings and methodologies"
    echo " - Respect responsible disclosure practices"
    echo -e "${YELLOW}══════════════════════════════════════════════${NC}"
}

#############################################################################
# MAIN EXECUTION
#############################################################################

main() {
    print_banner

    # Validate input
    if [[ $# -eq 0 ]]; then
        print_error "Usage: $0 <target_ip_or_hostname> [options]" 
        echo "Examples:"
        echo "  $0 192.168.1.1          # Single host"
        echo "  $0 192.168.1.0/24       # Network range"
        echo "  $0 example.com          # Domain name"
        exit 1
    fi

    TARGET="$1"

    # Checks dependencies
    print_section "Checking dependencies"
    local required_commands=("nmap" "ping" "nslookup" "whois")

    for cmd in "${required_commands[@]}"; do
        if check_command "$cmd"; then
            print_success "$cmd is installed"
        else
            print_error "Required dependency missing: $cmd"
            exit 1
        fi
    done

    # Validate target
    print_section "Validating target"
    if ! validate_target; then
        exit 1
    fi
    print_success "Target validated: $TARGET"

    # Setup output
    setup_output

    # Run enumeration modules
    echo ""
    enum_ping_sweep
    enum_port_scan
    enum_os_detection
    enum_dns_lookup
    enum_whois
    enum_traceroute
    enum_ssl_tls
    enum_subnet_analysis

    # Save results
    save_results

    # Print summary
    print_summary
}

# Execute main function
main "$@"