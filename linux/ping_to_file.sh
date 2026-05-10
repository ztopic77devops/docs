#!/bin/bash

# Default values
hostname="example.com"
output_file="ping_results.txt"

# Function to ping the hostname, add timestamp for each ping, and write results to file
ping_host() {
    while true; do
        echo "Ping results for $hostname:" >> "$output_file"
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        ping_result=$(ping -c 1 "$hostname")
        echo "Ping at $timestamp:" >> "$output_file"
        echo "$ping_result" >> "$output_file"
        echo >> "$output_file"  # Add a blank line for better readability
        sleep 1  # Wait for 1 second before next ping
    done
}

# Call function to continuously ping hostname, add timestamp for each ping, and write results to file
ping_host
