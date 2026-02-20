# Managing IRS Forms and Accessing Tax Law

## How Many Forms Can We Reasonably Manage?

### The Full Scope
- **IRS has ~1,260+ forms/publications** in their PDF directory
- Most are specialized (business, estate, international, etc.)
- Many are informational publications, not calculation forms

### Realistic Scope for Individual Income Tax

**Core Forms (Must Have):**
1. Form 1040 - U.S. Individual Income Tax Return
2. Schedule 1 - Additional Income and Adjustments to Income
3. Schedule 2 - Additional Taxes
4. Schedule 3 - Additional Credits and Payments
5. Schedule A - Itemized Deductions
6. Schedule B - Interest and Ordinary Dividends
7. Schedule C - Profit or Loss from Business (Sole Proprietorship)
8. Schedule D - Capital Gains and Losses
9. Schedule E - Supplemental Income and Loss
10. Schedule 8812 - Credits for Qualifying Children and Other Dependents
11. Schedule EIC - Earned Income Credit

**Total: ~11 core forms** covers 80%+ of individual filers

**Extended Coverage (20-30 forms):**
Add these for broader coverage:
- Form 8863 - Education Credits
- Form 2441 - Child and Dependent Care Expenses
- Form 8889 - Health Savings Accounts
- Form 5695 - Residential Energy Credits
- Schedule SE - Self-Employment Tax
- Form 8606 - Nondeductible IRAs
- Form 4952 - Investment Interest Expense Deduction
- Form 6251 - Alternative Minimum Tax
- Form 8949 - Sales and Other Dispositions of Capital Assets
- Various state-specific forms

**Comprehensive Coverage (50-75 forms):**
Would handle 95%+ of individual scenarios including:
- Rental property (Schedule E)
- Stock options (Form 3921, 3922)
- Foreign accounts (FBAR, FATCA forms)
- Retirement distributions (1099-R related forms)
- Trust and estate income (Schedule K-1)

### Recommendation

**Start with 11 core forms** - This handles the vast majority of individual taxpayers:
- W-2 wage earners
- Basic investments (interest, dividends, capital gains)
- Standard/itemized deductions
- Common credits (Child Tax Credit, EITC, education)
- Basic self-employment

**Expand incrementally** based on user needs.

## Accessing IRS Forms

### Direct Download Options

#### 1. IRS PDF Directory (Easiest)
**URL**: `https://www.irs.gov/pub/irs-pdf/`

**Access Method**:
```bash
# Download specific form
curl -O https://www.irs.gov/pub/irs-pdf/f1040.pdf
curl -O https://www.irs.gov/pub/irs-pdf/i1040gi.pdf  # Instructions

# Download multiple forms
for form in f1040 f1040s1 f1040s2 f1040sa f1040sc f1040sd f1040se f8812; do
  curl -O https://www.irs.gov/pub/irs-pdf/${form}.pdf
  curl -O https://www.irs.gov/pub/irs-pdf/i${form}.pdf  # Instructions
done
```

**Naming Convention**:
- Forms: `f[form_number].pdf` (e.g., `f1040.pdf`)
- Instructions: `i[form_number].pdf` or `i[form_number]gi.pdf`
- Schedules: `f1040s[letter].pdf` (e.g., `f1040sa.pdf` for Schedule A)
- Publications: `p[number].pdf` (e.g., `p17.pdf` for Pub 17)

**Updates**: Forms are updated annually (usually December for next tax year)

#### 2. Prior Year Forms
**URL**: `https://www.irs.gov/pub/irs-prior/`

Access historical forms for amended returns or reference.

### Form Management Strategy

```
forms/
├── 2024/
│   ├── f1040.pdf
│   ├── i1040gi.pdf
│   ├── f1040s1.pdf
│   ├── ...
├── 2025/
│   ├── f1040.pdf
│   └── ...
└── metadata.json  # Track form versions, URLs, dates
```

### Automated Download Script

```bash
#!/bin/bash
# download-irs-forms.sh

YEAR=2024
FORMS=(
  "f1040:i1040gi"           # Form 1040 and instructions
  "f1040s1:i1040s1"         # Schedule 1
  "f1040s2:i1040s2"         # Schedule 2
  "f1040s3:i1040s3"         # Schedule 3
  "f1040sa:i1040sa"         # Schedule A
  "f1040sc:i1040sc"         # Schedule C
  "f1040sd:i1040sd"         # Schedule D
  "f1040se:i1040se"         # Schedule E
  "f8812:i8812"             # Schedule 8812
  "p17"                      # Publication 17
)

mkdir -p forms/$YEAR

for form_pair in "${FORMS[@]}"; do
  IFS=':' read -ra PARTS <<< "$form_pair"
  for part in "${PARTS[@]}"; do
    echo "Downloading $part.pdf..."
    curl -s -o "forms/$YEAR/${part}.pdf" \
      "https://www.irs.gov/pub/irs-pdf/${part}.pdf"

    # Check if download succeeded
    if [ $? -eq 0 ]; then
      echo "✓ Downloaded $part.pdf"
    else
      echo "✗ Failed to download $part.pdf"
    fi
  done
done

echo "Download complete!"
```

## Accessing Tax Law

### 1. Internal Revenue Code (IRC) - Title 26 USC

#### Official Source: House.gov
**URL**: https://uscode.house.gov/download/download.shtml

**Available Formats**:
- ✅ **XML** - Structured, machine-readable (recommended)
- ✅ XHTML - Web-friendly
- ✅ PDF - Human-readable
- ✅ PCC - Legacy text format

**Download Title 26**:
```bash
# Download Title 26 XML
curl -O https://uscode.house.gov/download/releasepoints/us/pl/119/73/xml_usc26@119-73.zip

# Extract
unzip xml_usc26@119-73.zip -d tax-code/title26/
```

**Structure**:
- Organized by subtitle, chapter, subchapter, section
- Each IRC section is a separate XML file
- Schema: USLM (United States Legislative Markup)

**Update Frequency**: Updated after each public law passage

#### Alternative: Cornell Law
**URL**: https://www.law.cornell.edu/uscode/text/26

**Access Method**:
- Web scraping (be respectful of rate limits)
- HTML format with consistent URL structure
- Example: `https://www.law.cornell.edu/uscode/text/26/1` for IRC §1

**Pros**: Clean HTML, easy to parse
**Cons**: No bulk download, must scrape

### 2. Treasury Regulations (26 CFR)

**URL**: https://www.ecfr.gov/current/title-26

**Access**:
- XML bulk download available via eCFR
- API access through GovInfo

**Download via GovInfo API**:
```bash
# Get API key from api.data.gov
# Then access CFR Title 26

curl "https://api.govinfo.gov/collections/CFR/2024/packages.json?api_key=YOUR_KEY"
```

### 3. IRS Publications and Guidance

#### Revenue Procedures
**URL**: `https://www.irs.gov/pub/irs-drop/`

**Example - 2024 Inflation Adjustments**:
```bash
curl -O https://www.irs.gov/pub/irs-drop/rp-23-34.pdf
```

#### IRS Publications
**URL**: `https://www.irs.gov/pub/irs-pdf/`

**Key Publications for Individual Tax**:
- **Pub 17** - Your Federal Income Tax (comprehensive guide)
- **Pub 334** - Tax Guide for Small Business
- **Pub 501** - Dependents, Standard Deduction, and Filing Information
- **Pub 502** - Medical and Dental Expenses
- **Pub 503** - Child and Dependent Care Expenses
- **Pub 504** - Divorced or Separated Individuals
- **Pub 525** - Taxable and Nontaxable Income
- **Pub 529** - Miscellaneous Deductions
- **Pub 590-A** - Contributions to IRAs
- **Pub 590-B** - Distributions from IRAs
- **Pub 936** - Home Mortgage Interest Deduction
- **Pub 970** - Tax Benefits for Education

```bash
# Download key publications
for pub in 17 334 501 502 503 525 590-a 590-b 970; do
  curl -O https://www.irs.gov/pub/irs-pdf/p${pub}.pdf
done
```

#### Internal Revenue Bulletins
**URL**: `https://www.irs.gov/pub/irs-irbs/`

Contains:
- Revenue Rulings
- Revenue Procedures
- Treasury Decisions
- Notices
- Announcements

## Data Management Strategy

### Repository Structure

```
incometax/
├── forms/
│   ├── 2024/
│   │   ├── pdf/          # Original PDFs
│   │   └── metadata/     # Form structure data
│   └── download.sh
├── tax-code/
│   ├── title26/          # IRC XML files
│   ├── cfr/              # Treasury Regulations
│   └── parse-irc.go      # Parser to extract sections
├── publications/
│   ├── 2024/
│   │   ├── pub17.pdf
│   │   ├── revenue-procedures/
│   │   └── revenue-rulings/
│   └── extract-guidance.go
└── references/
    ├── irc-index.json           # IRC section index
    ├── cfr-index.json           # Regulation index
    ├── pub-index.json           # Publication index
    └── tax-code-references-2024.json  # Current year references
```

### Automated Updates

Create a script to check for updates:

```go
// update-tax-data.go
package main

import (
    "fmt"
    "net/http"
    "time"
)

type TaxResource struct {
    Name     string
    URL      string
    LastMod  time.Time
    LocalPath string
}

func checkForUpdates(resources []TaxResource) {
    for _, res := range resources {
        resp, err := http.Head(res.URL)
        if err != nil {
            continue
        }

        lastMod := resp.Header.Get("Last-Modified")
        // Compare with local version
        // Download if newer
    }
}

func main() {
    resources := []TaxResource{
        {"Form 1040", "https://www.irs.gov/pub/irs-pdf/f1040.pdf", time.Time{}, "forms/2024/f1040.pdf"},
        {"Pub 17", "https://www.irs.gov/pub/irs-pdf/p17.pdf", time.Time{}, "publications/2024/pub17.pdf"},
        // ... more resources
    }

    checkForUpdates(resources)
}
```

## Parsing and Extraction

### Parsing IRC XML

Title 26 XML uses USLM schema:

```xml
<section identifier="/us/usc/t26/s1">
  <num value="1">§1</num>
  <heading>Tax imposed</heading>
  <subsection identifier="/us/usc/t26/s1/a">
    <num value="a">(a)</num>
    <heading>Married individuals filing joint returns...</heading>
    <content>
      <p>There is hereby imposed on the taxable income...</p>
    </content>
  </subsection>
</section>
```

### Extracting Form Field Definitions

Use PDF parsing libraries:
- **pdftotext** - Extract text from PDFs
- **tabula-py** - Extract tables
- **pdfplumber** - Python library for detailed PDF analysis

For structured data, IRS sometimes provides JSON schemas for e-filing, but not always publicly accessible.

## Realistic Implementation Plan

### Phase 1: Core Data (Week 1)
- Download 11 core forms for current year
- Download Title 26 IRC XML
- Download Pub 17 and Rev. Proc. for current year
- Set up directory structure

### Phase 2: Reference Database (Week 2-3)
- Parse IRC XML to extract relevant sections
- Create JSON index of IRC sections with metadata
- Extract key values from Revenue Procedures (tax brackets, limits, etc.)
- Link forms to IRC sections

### Phase 3: Automation (Week 4)
- Create update scripts
- Set up version tracking
- Implement change detection

### Phase 4: Integration (Week 5+)
- Link decision tables to IRC sections
- Embed citations in calculations
- Generate reports with legal references

## Summary

**Forms**: Start with 11 core forms, expand to 20-30 as needed
**Tax Law**: Download Title 26 XML (~all sections relevant to individual tax)
**Publications**: Focus on Pub 17, Rev. Proc., and form instructions
**Total Data Size**: ~500MB - 1GB (manageable)
**Updates**: Annual (forms), periodic (law), as needed (guidance)

The data is **freely available and accessible**. The challenge is parsing, structuring, and maintaining it - which is exactly what this system is designed to handle!
