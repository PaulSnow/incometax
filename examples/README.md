# Income Tax System Examples

This directory contains example JSON files for input and output data.

## Input Format

The income tax system accepts JSON input containing all taxpayer information needed for tax calculations.

### Example Input: `sample-taxpayer.json`

This file shows a complete tax return input for a married couple filing jointly with 2 children:
- Tax year 2024
- Filing status: Married Filing Jointly (MFJ)
- 2 qualifying children (ages 9 and 6)
- Wages: $85,000
- Investment income: dividends and capital gains
- Deductions: Student loan interest, IRA contribution
- Federal withholding: $12,500

### Input Structure

```json
{
  "taxReturn": {
    "taxYear": 2024,
    "taxpayer": { ... },      // Primary taxpayer information
    "spouse": { ... },         // Spouse information (if MFJ)
    "dependents": [ ... ],     // Array of dependents
    "income": { ... },         // All income sources
    "deductions": { ... },     // Deductions and adjustments
    "credits": { ... },        // Tax credits
    "payments": { ... }        // Withholding and estimated payments
  }
}
```

## Expected Output Format

After processing through DTRules decision tables, the system will return a JSON result:

```json
{
  "success": true,
  "result": {
    "taxReturn": {
      "filingStatus": "MFJ",
      "totalIncome": 87250,
      "adjustedGrossIncome": 80550,
      "standardDeduction": 29200,
      "taxableIncome": 51350,
      "taxBeforeCredits": 5682,
      "childTaxCredit": 4000,
      "earnedIncomeCredit": 0,
      "totalCredits": 4000,
      "taxAfterCredits": 1682,
      "totalTax": 1682,
      "totalPayments": 12500,
      "refundOrAmountOwed": -10818,
      "refundAmount": 10818
    }
  }
}
```

## Using the JSON API

Once the DTRules API server is running, you can execute tax calculations:

```bash
# Start the DTRules API server
cd /path/to/DTRules/go
go run ./cmd/api -port 8080

# Execute tax calculation (example using curl)
curl -X POST http://localhost:8080/api/execute \
  -H "Content-Type: application/json" \
  -d @examples/sample-taxpayer.json
```

## Decision Tables Executed

For a complete tax calculation, the following decision tables will be executed in sequence:

1. **Filing Status Determination** - Validates/determines filing status
2. **Income Aggregation** - Calculates total income and AGI
3. **Standard Deduction** - Determines standard deduction amount
4. **Taxable Income** - Calculates taxable income
5. **Tax Bracket Calculation** - Applies tax brackets and rates
6. **Child Tax Credit** - Calculates child tax credit
7. **Earned Income Credit** - Calculates EITC if applicable
8. **Final Calculation** - Determines refund or amount owed

## Testing Different Scenarios

Create additional JSON files to test various scenarios:
- Different filing statuses (Single, Head of Household, etc.)
- Various income levels
- Different numbers of dependents
- Itemized vs. standard deduction
- Credit eligibility scenarios

## Validation

The decision tables will validate:
- Required fields are present
- Values are within valid ranges
- Business rules are satisfied (e.g., qualifying child criteria)
- Tax law requirements are met
