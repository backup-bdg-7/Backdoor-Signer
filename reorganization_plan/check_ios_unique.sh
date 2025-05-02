#!/bin/bash

# This script checks iOS files against their duplicates in Core/Features/UI to see if they have unique content

echo "Checking iOS/Management/ServerCertificateManager.swift vs Core/Services/ServerCertificateManager.swift"
diff -q ./iOS/Management/ServerCertificateManager.swift ./Core/Services/ServerCertificateManager.swift || echo "DIFFERENT"

echo "Checking iOS/Management/EnhancedDropboxDeviceIdentifier.swift vs Core/Services/EnhancedDropboxDeviceIdentifier.swift"
diff -q ./iOS/Management/EnhancedDropboxDeviceIdentifier.swift ./Core/Services/EnhancedDropboxDeviceIdentifier.swift || echo "DIFFERENT"

echo "Checking iOS/Views/Hub/WebViewController.swift vs Features/Hub/Views/WebViewController.swift"
diff -q ./iOS/Views/Hub/WebViewController.swift ./Features/Hub/Views/WebViewController.swift || echo "DIFFERENT"

# Check iOS/Views/Extra vs UI/Views/Extra
echo "Checking iOS/Views/Extra vs UI/Views/Extra"
diff -rq ./iOS/Views/Extra ./UI/Views/Extra || echo "DIFFERENT"

# Check if AI.swift is unique (not in any other directory)
echo "Checking if iOS/Views/AI.swift exists elsewhere"
find . -path "./iOS" -prune -o -name "AI.swift" -print
