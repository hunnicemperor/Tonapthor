mkdir ~/Tonapthor
cd ~/Tonapthor

cat > install-tonapthor.sh << 'EOF'
#!/bin/bash

echo "TONAPHOR EDITOR INSTALLER"
echo "=========================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_dotnet() {
    echo -e "${YELLOW}Checking .NET SDK...${NC}"
    if command -v dotnet &> /dev/null; then
        echo -e "${GREEN}.NET SDK found${NC}"
        return 0
    else
        echo -e "${RED}.NET SDK not found${NC}"
        return 1
    fi
}

install_dotnet() {
    echo -e "${YELLOW}Installing .NET 7.0 SDK...${NC}"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
            sudo dpkg -i packages-microsoft-prod.deb
            rm packages-microsoft-prod.deb
            sudo apt update
            sudo apt install -y dotnet-sdk-7.0
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install --cask dotnet-sdk
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        winget install Microsoft.DotNet.SDK.7
    else
        echo -e "${RED}Unsupported OS${NC}"
        echo "Download .NET 7.0 SDK from: https://dotnet.microsoft.com"
        exit 1
    fi
    
    if command -v dotnet &> /dev/null; then
        echo -e "${GREEN}.NET SDK installed${NC}"
    else
        echo -e "${RED}.NET installation failed${NC}"
        exit 1
    fi
}

install_tonapthor() {
    echo -e "${YELLOW}Downloading Tonapthor...${NC}"
    
    if [ -d "Tonapthor" ]; then
        cd Tonapthor
        git pull
    else
        git clone https://github.com/hunnicemperor/Tonapthor.git
        cd Tonapthor
    fi
    
    echo -e "${GREEN}Tonapthor downloaded${NC}"
}

build_tonapthor() {
    echo -e "${YELLOW}Building Tonapthor...${NC}"
    
    if dotnet build --nologo; then
        echo -e "${GREEN}Build successful${NC}"
    else
        echo -e "${RED}Build failed${NC}"
        exit 1
    fi
}

main() {
    echo "Starting Tonapthor installation..."
    echo "----------------------------------"
    
    if ! check_dotnet; then
        read -p "Install .NET SDK? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_dotnet
        else
            echo -e "${RED}Installation cancelled. .NET SDK required.${NC}"
            exit 1
        fi
    fi
    
    install_tonapthor
    build_tonapthor
    
    echo ""
    echo "INSTALLATION COMPLETE!"
    echo "======================"
    echo -e "${GREEN}Tonapthor Editor installed successfully!${NC}"
    echo ""
    echo "Usage:"
    echo "  cd Tonapthor"
    echo "  dotnet run"
    echo ""
    echo "Commands:"
    echo "  write  - Write code"
    echo "  save   - Save to file"
    echo "  show   - Show buffer"
    echo "  list   - List files"
    echo "  clear  - Clear buffer"
    echo "  exit   - Exit"
    echo ""
    echo "GitHub: https://github.com/hunnicemperor/Tonapthor"
    echo ""
}

main "$@"
EOF

chmod +x install-tonapthor.sh
git add install-tonapthor.sh
git commit -m "Add installer script"
git push
