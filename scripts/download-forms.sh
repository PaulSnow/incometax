#!/bin/bash
# download-forms.sh - Download IRS forms and publications for a tax year

set -e  # Exit on error

YEAR=${1:-2024}
BASE_URL="https://www.irs.gov/pub/irs-pdf"
OUTPUT_DIR="forms/$YEAR"

echo "Downloading IRS forms for tax year $YEAR..."
echo "Output directory: $OUTPUT_DIR"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Core forms for individual income tax
# Format: "form_file:instruction_file:description"
FORMS=(
  "f1040:i1040gi:Form 1040 - U.S. Individual Income Tax Return"
  "f1040s1:i1040s1:Schedule 1 - Additional Income and Adjustments"
  "f1040s2:i1040s2:Schedule 2 - Additional Taxes"
  "f1040s3:i1040s3:Schedule 3 - Additional Credits and Payments"
  "f1040sa:i1040sa:Schedule A - Itemized Deductions"
  "f1040sb:i1040sb:Schedule B - Interest and Ordinary Dividends"
  "f1040sc:i1040sc:Schedule C - Profit or Loss from Business"
  "f1040sd:i1040sd:Schedule D - Capital Gains and Losses"
  "f1040se:i1040se:Schedule E - Supplemental Income and Loss"
  "f8812:i8812:Schedule 8812 - Credits for Qualifying Children"
  "f1040sei:i1040sei:Schedule EIC - Earned Income Credit"
)

# Additional common forms
ADDITIONAL_FORMS=(
  "f8863:i8863:Form 8863 - Education Credits"
  "f2441:i2441:Form 2441 - Child and Dependent Care Expenses"
  "f8889:i8889:Form 8889 - Health Savings Accounts"
  "f5695:i5695:Form 5695 - Residential Energy Credits"
  "f1040sse:i1040sse:Schedule SE - Self-Employment Tax"
  "f8606:i8606:Form 8606 - Nondeductible IRAs"
  "f8949:i8949:Form 8949 - Sales and Dispositions of Capital Assets"
  "f6251:i6251:Form 6251 - Alternative Minimum Tax"
)

# Key publications
PUBLICATIONS=(
  "p17:Publication 17 - Your Federal Income Tax"
  "p501:Publication 501 - Dependents, Standard Deduction, Filing Info"
  "p502:Publication 502 - Medical and Dental Expenses"
  "p503:Publication 503 - Child and Dependent Care Expenses"
  "p525:Publication 525 - Taxable and Nontaxable Income"
  "p590a:Publication 590-A - Contributions to IRAs"
  "p590b:Publication 590-B - Distributions from IRAs"
  "p970:Publication 970 - Tax Benefits for Education"
)

# Function to download a file
download_file() {
  local file=$1
  local desc=$2
  local url="${BASE_URL}/${file}.pdf"
  local output="${OUTPUT_DIR}/${file}.pdf"

  if [ -f "$output" ]; then
    echo "  ⏭  $desc (already exists)"
    return 0
  fi

  echo -n "  ⬇  $desc ... "

  if curl -sf -o "$output" "$url"; then
    echo "✓"
    return 0
  else
    echo "✗ (not available)"
    rm -f "$output"  # Remove partial file
    return 1
  fi
}

# Download core forms
echo ""
echo "=== Core Forms ==="
DOWNLOADED=0
FAILED=0

for form_info in "${FORMS[@]}"; do
  IFS=':' read -ra PARTS <<< "$form_info"
  form_file="${PARTS[0]}"
  inst_file="${PARTS[1]}"
  desc="${PARTS[2]}"

  # Download form
  if download_file "$form_file" "$desc"; then
    ((DOWNLOADED++))
  else
    ((FAILED++))
  fi

  # Download instructions
  if download_file "$inst_file" "$desc (Instructions)"; then
    ((DOWNLOADED++))
  else
    ((FAILED++))
  fi
done

# Download additional forms if requested
if [ "${2}" = "--extended" ]; then
  echo ""
  echo "=== Additional Forms ==="

  for form_info in "${ADDITIONAL_FORMS[@]}"; do
    IFS=':' read -ra PARTS <<< "$form_info"
    form_file="${PARTS[0]}"
    inst_file="${PARTS[1]}"
    desc="${PARTS[2]}"

    if download_file "$form_file" "$desc"; then
      ((DOWNLOADED++))
    else
      ((FAILED++))
    fi

    if download_file "$inst_file" "$desc (Instructions)"; then
      ((DOWNLOADED++))
    else
      ((FAILED++))
    fi
  done
fi

# Download publications
echo ""
echo "=== Publications ==="

for pub_info in "${PUBLICATIONS[@]}"; do
  IFS=':' read -ra PARTS <<< "$pub_info"
  pub_file="${PARTS[0]}"
  desc="${PARTS[1]}"

  if download_file "$pub_file" "$desc"; then
    ((DOWNLOADED++))
  else
    ((FAILED++))
  fi
done

# Summary
echo ""
echo "========================================="
echo "Download Summary:"
echo "  Downloaded: $DOWNLOADED files"
echo "  Failed: $FAILED files"
echo "  Location: $OUTPUT_DIR"
echo "========================================="

# Create metadata file
cat > "${OUTPUT_DIR}/metadata.json" <<EOF
{
  "taxYear": $YEAR,
  "downloadDate": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "source": "$BASE_URL",
  "filesDownloaded": $DOWNLOADED,
  "filesFailed": $FAILED
}
EOF

echo ""
echo "Metadata saved to ${OUTPUT_DIR}/metadata.json"

if [ $FAILED -gt 0 ]; then
  echo ""
  echo "⚠️  Some files failed to download. This is normal if forms for"
  echo "   tax year $YEAR haven't been published yet."
fi

echo ""
echo "Usage for extended download (includes additional forms):"
echo "  $0 $YEAR --extended"
