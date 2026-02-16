Image Asset Downloader – bash/zsh Guide
Overview
This document explains how to extract and download all ImageUrl assets from a product JSON file and organize them into product-named folders using a Bash script.
What the Script Does	
- Parses a product JSON file
- Extracts all ImageUrl fields (deeply nested)
- Downloads images via curl
- Organizes images into folders by product name
- Logs inaccessible URLs to failed_urls.txt
Supported Environment
• bash or zsh shell
• python3 (or above)
• homebrew
• jq
• curl
Prerequisites
1. Install Homebrew (if not already installed):
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

2. Install jq:
brew install jq
Setup
1. Create a working directory
2. Place ProductList.json in the directory
3. Save the script as download_all_images.sh
Running the Script
1. Make the script executable:
chmod +x download_all_images.sh

2. Run the script:
./download_all_images.sh
Output
• Images are saved under output/<Game Name>/
• Existing files are skipped on re-run
Failed Downloads
• Some assets may be blocked by CDN rules
• These URLs are logged to failed_urls.txt
• This indicates vendor-side restrictions, not script failure
Re-running
The script is idempotent and safe to run multiple times.
Notes
This script is production-ready and suitable for internal asset ingestion pipelines.
