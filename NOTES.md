# Implementation Notes

## Next Steps

### 1. Integrate DTRules Go Implementation

We need to integrate the DTRules Go implementation into this project. Options:

**Option A: Git Submodule**
```bash
git submodule add https://github.com/DTRules/DTRules.git vendor/dtrules
```

**Option B: Copy/Fork Go Implementation**
- Copy the Go implementation from DTRules repository
- Adapt to our specific needs
- Maintain separately

**Option C: Create Go Module Dependency**
- If DTRules publishes a Go module, add it to go.mod
- Currently may need to use `replace` directive

### 2. Create Entity Definition Documents

Create Excel files in `entities/` directory:
- taxpayer_edd.xlsx
- income_edd.xlsx
- deductions_edd.xlsx
- dependent_edd.xlsx
- tax_calculation_edd.xlsx
- credits_edd.xlsx
- tax_return_edd.xlsx

### 3. Create Decision Tables

Create Excel files in `tables/` directory:
- filing_status_dt.xlsx - Determine filing status
- standard_deduction_dt.xlsx - Calculate standard deduction
- tax_brackets_dt.xlsx - Apply tax brackets and rates
- eitc_dt.xlsx - Earned Income Tax Credit
- child_tax_credit_dt.xlsx - Child Tax Credit calculations

### 4. Compile Excel to XML

Use DTRules compiler to convert Excel files to XML:
```bash
# Example compilation command (exact syntax TBD based on DTRules Go implementation)
dtrules compile entities/*.xlsx -o xml/
dtrules compile tables/*.xlsx -o xml/
```

### 5. Implement Tax Calculator

Create Go packages to:
- Load DTRules engine
- Load compiled decision tables
- Accept taxpayer input data
- Execute decision tables
- Generate Form 1040 output

### 6. Testing

- Unit tests for individual decision tables
- Integration tests for complete tax calculations
- Test cases covering various scenarios:
  - Different filing statuses
  - Various income levels
  - With/without dependents
  - Different credit eligibility scenarios

### 7. Tax Year Data

Maintain tax year specific data:
- 2024 tax brackets and rates
- 2024 standard deduction amounts
- 2024 credit phase-out thresholds
- Update annually

## Research Needed

1. Exact DTRules Go implementation usage and API
2. Excel template format for entity definitions
3. Excel template format for decision tables
4. Compilation process from Excel to XML
5. Loading and executing decision tables in Go

## References

- DTRules GitHub: https://github.com/DTRules/DTRules
- DTRules Go implementation: https://github.com/DTRules/DTRules/tree/master/go
- IRS Tax Information: https://www.irs.gov/
- Form 1040 Instructions: https://www.irs.gov/forms-pubs/about-form-1040
