# Download Scripts

This directory contains scripts to download IRS forms, publications, and tax code from official sources.

## Available Scripts

### 1. `download-forms.sh` - Download IRS Forms and Publications

Downloads current year tax forms and publications from IRS.gov.

**Usage:**
```bash
# Download core forms for 2024
./scripts/download-forms.sh 2024

# Download core + additional forms
./scripts/download-forms.sh 2024 --extended

# Download for different year
./scripts/download-forms.sh 2025
```

**What It Downloads:**

**Core Forms (default):**
- Form 1040 and Schedules 1-3
- Schedule A (Itemized Deductions)
- Schedule B (Interest and Dividends)
- Schedule C (Business Income)
- Schedule D (Capital Gains)
- Schedule E (Supplemental Income)
- Schedule 8812 (Child Tax Credit)
- Schedule EIC (Earned Income Credit)
- Instructions for all forms

**Extended Forms (--extended flag):**
- Form 8863 (Education Credits)
- Form 2441 (Child Care Expenses)
- Form 8889 (HSA)
- Form 5695 (Energy Credits)
- Schedule SE (Self-Employment Tax)
- Form 8606 (Nondeductible IRAs)
- Form 8949 (Capital Asset Sales)
- Form 6251 (Alternative Minimum Tax)

**Publications:**
- Pub 17 (Your Federal Income Tax)
- Pub 501 (Dependents, Standard Deduction)
- Pub 502 (Medical Expenses)
- Pub 503 (Child Care)
- Pub 525 (Taxable Income)
- Pub 590-A/B (IRAs)
- Pub 970 (Education)

**Output:**
```
forms/
└── 2024/
    ├── f1040.pdf
    ├── i1040gi.pdf
    ├── f1040s1.pdf
    ├── ...
    └── metadata.json
```

### 2. `download-tax-code.sh` - Download Internal Revenue Code

Downloads Title 26 (Internal Revenue Code) in XML format from uscode.house.gov.

**Usage:**
```bash
./scripts/download-tax-code.sh
```

**What It Downloads:**
- Complete Title 26 USC in XML format
- USLM (United States Legislative Markup) schema
- User guide for XML structure
- All IRC sections relevant to individual and business taxation

**Output:**
```
tax-code/
├── title26/
│   ├── usc26-*.xml (all sections)
│   └── ...
├── schema/
│   ├── uslm.xsd
│   └── USLM-User-Guide.pdf
└── metadata.json
```

**Key IRC Sections for Individual Tax:**
- §1: Tax rates and brackets
- §24: Child tax credit
- §32: Earned income credit
- §61-68: Gross income, adjusted gross income
- §151-152: Dependents
- §162-179: Business deductions
- §401-408: Retirement plans

## First Time Setup

Run both scripts to set up initial data:

```bash
# Download current year forms
./scripts/download-forms.sh 2024

# Download IRC
./scripts/download-tax-code.sh

# Verify downloads
ls -lh forms/2024/
ls -lh tax-code/title26/
```

## Updating Data

### Annual Updates (December/January)
When new tax year forms are published:

```bash
# Download new year forms
./scripts/download-forms.sh 2025

# Check for IRC updates (typically updated quarterly)
./scripts/download-tax-code.sh
```

### Mid-Year Updates
IRS occasionally updates forms mid-year. Re-run the download script:

```bash
# This will skip files that already exist
# Delete forms/2024/ directory first if you want to force re-download
./scripts/download-forms.sh 2024
```

## Checking for Updates

Check Last-Modified dates:

```bash
# Check when a form was last updated on IRS.gov
curl -I https://www.irs.gov/pub/irs-pdf/f1040.pdf | grep Last-Modified
```

## Troubleshooting

### Form Not Available
Some forms for future years may not be published yet:
```
✗ Form 8863 (not available)
```

This is normal - forms are typically published in December for the next tax year.

### Download Fails
1. Check internet connection
2. Verify IRS.gov is accessible
3. Try downloading manually from https://www.irs.gov/forms-instructions

### IRC Release Point Out of Date
The download-tax-code.sh script uses a specific release point (e.g., 119-73).
Check for the latest at: https://uscode.house.gov/download/download.shtml

Update the `RELEASE` variable in the script if needed.

## Data Sources

All data downloaded from official government sources:

- **IRS Forms**: https://www.irs.gov/pub/irs-pdf/
- **IRS Prior Years**: https://www.irs.gov/pub/irs-prior/
- **IRC (Title 26)**: https://uscode.house.gov
- **Cornell Law**: https://www.law.cornell.edu/uscode/text/26 (alternative)

## Legal Notice

All IRS forms, publications, and U.S. Code materials are in the public domain.
No copyright restrictions apply to U.S. government works.

These scripts simply automate downloading of publicly available materials.
