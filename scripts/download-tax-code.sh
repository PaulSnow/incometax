#!/bin/bash
# download-tax-code.sh - Download IRC Title 26 from uscode.house.gov

set -e  # Exit on error

OUTPUT_DIR="tax-code"
TITLE="26"

echo "Downloading Internal Revenue Code (Title 26) from uscode.house.gov..."

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Get the latest release point
# Note: This URL might need updating based on current public law
# Check https://uscode.house.gov/download/download.shtml for latest
RELEASE="119-73"  # Update this to latest release
BASE_URL="https://uscode.house.gov/download/releasepoints/us/pl/${RELEASE}"

# Download XML version (recommended for parsing)
echo ""
echo "=== Downloading Title 26 (IRC) in XML format ==="
echo "Release: Public Law $RELEASE"
echo "Output: ${OUTPUT_DIR}/title26/"

ZIP_FILE="${OUTPUT_DIR}/xml_usc${TITLE}@${RELEASE}.zip"
XML_DIR="${OUTPUT_DIR}/title26"

echo -n "Downloading XML archive... "
if curl -sf -o "$ZIP_FILE" "${BASE_URL}/xml_usc${TITLE}@${RELEASE}.zip"; then
  echo "✓"
else
  echo "✗"
  echo ""
  echo "ERROR: Failed to download Title 26 XML."
  echo "Please check the current release at:"
  echo "https://uscode.house.gov/download/download.shtml"
  exit 1
fi

# Extract
echo -n "Extracting archive... "
mkdir -p "$XML_DIR"
if unzip -q -o "$ZIP_FILE" -d "$XML_DIR"; then
  echo "✓"
else
  echo "✗"
  exit 1
fi

# Clean up zip file
rm "$ZIP_FILE"

# Count sections
SECTION_COUNT=$(find "$XML_DIR" -name "*.xml" | wc -l)

echo ""
echo "========================================="
echo "Download Complete!"
echo "  Title: 26 (Internal Revenue Code)"
echo "  Release: $RELEASE"
echo "  Format: XML (USLM schema)"
echo "  Sections: $SECTION_COUNT XML files"
echo "  Location: $XML_DIR"
echo "========================================="

# Create metadata
cat > "${OUTPUT_DIR}/metadata.json" <<EOF
{
  "title": 26,
  "name": "Internal Revenue Code",
  "release": "$RELEASE",
  "downloadDate": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "format": "XML (USLM)",
  "source": "https://uscode.house.gov",
  "sections": $SECTION_COUNT,
  "notes": "Title 26 of the United States Code - Internal Revenue Code"
}
EOF

echo ""
echo "Metadata saved to ${OUTPUT_DIR}/metadata.json"

# Download schema and user guide if not present
echo ""
echo "=== Downloading USLM Schema and User Guide ==="

SCHEMA_DIR="${OUTPUT_DIR}/schema"
mkdir -p "$SCHEMA_DIR"

SCHEMA_URL="https://uscode.house.gov/download/resources/schematron/1.0"

echo -n "  Downloading USLM schema... "
if curl -sf -o "${SCHEMA_DIR}/uslm.xsd" "${SCHEMA_URL}/USLM-1.0.xsd" 2>/dev/null; then
  echo "✓"
else
  echo "⏭  (schema not available at expected URL)"
fi

echo -n "  Downloading User Guide... "
if curl -sf -o "${SCHEMA_DIR}/USLM-User-Guide.pdf" "https://xml.house.gov/schemas/uslm/1.0/USLM-User-Guide.pdf" 2>/dev/null; then
  echo "✓"
else
  echo "⏭  (guide not available at expected URL)"
fi

echo ""
echo "Done! The Internal Revenue Code is ready for use."
echo ""
echo "Key sections for individual income tax:"
echo "  - Subtitle A: Income Taxes"
echo "  - Chapter 1: Normal Taxes and Surtaxes"
echo "  - Subchapter A: Determination of Tax Liability"
echo "  - §1: Tax imposed (brackets)"
echo "  - §24: Child tax credit"
echo "  - §32: Earned income credit"
echo "  - §63: Taxable income defined, standard deduction"
echo "  - §151-152: Dependents"
echo ""
echo "To find a specific section:"
echo "  find $XML_DIR -name \"*section*.xml\" | grep -i \"<keyword>\""
