#!/bin/bash

echo "Removing temp files"
    rm -rf modules
    rm -rf providers
    rm -rf tfstates
    rm -rf .vscode

    find . -name  backend.azurerm.tf -delete
    find . -name "*terraform*" -delete