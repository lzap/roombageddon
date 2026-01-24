#!/usr/bin/env python3
"""
Simple Lua minifier for TIC80 games.

- Removes comments (except TIC80 metadata and data sections)
- Removes empty lines
- Removes indentation (leading whitespace)
- Basic whitespace cleanup
"""

import sys
import re


def is_tic80_metadata(line):
    """Check if line is TIC80 metadata (title, author, desc, etc.)"""
    stripped = line.strip()
    return any(stripped.startswith(f"-- {key}:") for key in 
               ["title", "author", "desc", "site", "license", "script", "version"])


def is_tic80_data_section(line):
    """Check if line is part of a TIC80 data section"""
    stripped = line.strip()
    # Check for section markers
    if re.match(r'^--\s*<[A-Z_]+>', stripped):
        return True
    # Check for data lines (hex patterns, etc.)
    if re.match(r'^--\s*[0-9a-fA-F]{3}:', stripped):
        return True
    return False


def minify_lua(content):
    """Minify Lua code while preserving TIC80 elements"""
    lines = content.split('\n')
    result = []
    in_tic80_section = False
    
    for line in lines:
        stripped = line.strip()
        
        # Check if we're entering/leaving a TIC80 data section
        if re.match(r'^--\s*<[A-Z_]+>', stripped):
            in_tic80_section = True
            result.append(line)
            continue
        
        if in_tic80_section:
            # Keep all lines in TIC80 sections
            result.append(line)
            # Check if section ends
            if re.match(r'^--\s*</[A-Z_]+>', stripped):
                in_tic80_section = False
            continue
        
        # Keep TIC80 metadata
        if is_tic80_metadata(line):
            result.append(line)
            continue
        
        # Keep TIC80 data section lines
        if is_tic80_data_section(line):
            result.append(line)
            continue
        
        # Remove empty lines
        if not stripped:
            continue
        
        # Remove comments (but not TIC80 ones)
        if stripped.startswith('--'):
            continue
        
        # Remove inline comments (simple approach - remove everything after --)
        # But be careful with strings
        if '--' in line:
            # Simple check: if -- is not in a string, remove comment
            # This is a basic implementation - might not handle all cases
            parts = line.split('--', 1)
            if parts[0].strip():  # Only if there's code before the comment
                line = parts[0].rstrip()
        
        # Remove indentation (leading whitespace) - Lua doesn't use indentation for syntax
        line = line.lstrip()
        
        # Add the line if it's not empty after processing
        if line.strip():
            result.append(line)
    
    return '\n'.join(result)


def main():
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Usage: minify.py <file.lua> [output.lua]", file=sys.stderr)
        print("  If output is omitted, file is modified in-place", file=sys.stderr)
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) == 3 else input_file
    
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Count original stats
        original_bytes = len(content.encode('utf-8'))
        
        minified = minify_lua(content)
        
        # Count minified stats
        minified_bytes = len(minified.encode('utf-8'))
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(minified)
        
        # Calculate reduction
        byte_reduction = original_bytes - minified_bytes
        byte_percent = (byte_reduction / original_bytes * 100) if original_bytes > 0 else 0
        
        if output_file == input_file:
            print(f"Minified {input_file} (in-place)")
        else:
            print(f"Minified {input_file} -> {output_file}")
        print(f"  Bytes: {original_bytes:,} -> {minified_bytes:,} ({byte_reduction:,} bytes, {byte_percent:.1f}% reduction)")
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
