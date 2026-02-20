# Citation and Explanation Entities

These entities track the legal authority and explanation for each tax decision.

## Citation Entity

Represents a reference to tax law, IRS publications, or other authority.

### Attributes

- `id` (String) - Unique identifier for the citation
- `type` (String) - Type of authority (IRC, Publication, Form, Revenue Ruling, etc.)
- `citation` (String) - Full citation text (e.g., "IRC §1(a)")
- `description` (String) - Human-readable description
- `url` (String) - Link to authoritative source
- `taxYear` (Number) - Applicable tax year (if year-specific)
- `section` (String) - Specific section referenced
- `effectiveDate` (Date) - When this law/rule became effective
- `expirationDate` (Date) - When this law/rule expires (null if permanent)

## Calculation Entity (Enhanced)

Extended to include citation tracking for each calculation.

### Additional Attributes

- `calculationName` (String) - Name of the calculation
- `inputValues` (Array) - Input values used
- `outputValue` (Number or String) - Result of calculation
- `formula` (String) - Formula or logic applied
- `explanation` (String) - Plain English explanation
- `primaryCitation` (Citation) - Main legal authority
- `supportingCitations` (Array of Citation) - Additional references
- `notes` (String) - Additional notes or special circumstances
- `calculatedBy` (String) - Which decision table performed this calculation
- `timestamp` (Date) - When calculation was performed

## Decision Entity

Tracks each decision point in the tax calculation.

### Attributes

- `decisionId` (String) - Unique identifier
- `decisionType` (String) - Type of decision (filing status, deduction, credit, etc.)
- `condition` (String) - Condition that was evaluated
- `conditionMet` (Boolean) - Whether condition was satisfied
- `result` (String) - Decision outcome
- `explanation` (String) - Why this decision was made
- `citations` (Array of Citation) - Legal authorities supporting decision
- `alternatives` (Array) - Other options considered
- `decisionTableName` (String) - Which table made this decision
- `rowOrColumn` (String) - Specific row/column in decision table

## TaxReport Entity

Complete tax report with all decisions and citations.

### Attributes

- `reportId` (String) - Unique report identifier
- `taxReturn` (TaxReturn) - Reference to the tax return
- `generatedDate` (Date) - When report was generated
- `decisions` (Array of Decision) - All decisions made
- `calculations` (Array of Calculation) - All calculations performed
- `allCitations` (Array of Citation) - All legal references used
- `summary` (String) - Executive summary
- `warnings` (Array of String) - Any warnings or special notes
- `taxDue` (Number) - Final tax liability
- `refund` (Number) - Refund amount (if applicable)

## Example Usage in Decision Tables

### Standard Deduction Decision

**Condition**: `filing_status == "MFJ" AND tax_year == 2024`

**Action**:
```
standard_deduction = 29200

CREATE_DECISION {
  decisionType: "Standard Deduction"
  condition: "Filing Status: Married Filing Jointly, Tax Year: 2024"
  result: "$29,200 standard deduction"
  explanation: "Married couples filing jointly for 2024 receive a standard deduction of $29,200, which is indexed annually for inflation."
  citations: [
    {
      type: "IRC"
      citation: "IRC §63(c)(2)(A)"
      description: "Standard deduction for joint returns"
      url: "https://www.law.cornell.edu/uscode/text/26/63"
    },
    {
      type: "Revenue Procedure"
      citation: "Rev. Proc. 2023-34"
      description: "2024 inflation adjustments"
    },
    {
      type: "Form Instructions"
      citation: "Form 1040 Instructions, Page 95"
      description: "Standard Deduction Chart"
      taxYear: 2024
    }
  ]
}
```

### Tax Bracket Calculation

**Condition**: `filing_status == "MFJ" AND taxable_income > 94300 AND taxable_income <= 201050`

**Action**:
```
tax_bracket = "22%"
bracket_base = 11757
bracket_rate = 0.22
bracket_threshold = 94300

CREATE_CALCULATION {
  calculationName: "Tax in 22% Bracket"
  inputValues: {
    taxable_income: 125000
    filing_status: "MFJ"
  }
  formula: "11757 + ((125000 - 94300) * 0.22)"
  outputValue: 18511
  explanation: "For married filing jointly with taxable income of $125,000, tax is calculated as: base tax of $11,757 plus 22% of income over $94,300, resulting in total tax of $18,511."
  primaryCitation: {
    type: "IRC"
    citation: "IRC §1(a)"
    description: "Tax rates for married individuals filing jointly"
    url: "https://www.law.cornell.edu/uscode/text/26/1"
  }
  supportingCitations: [
    {
      type: "Revenue Procedure"
      citation: "Rev. Proc. 2023-34, Section 3.01"
      description: "2024 tax rate schedules"
    }
  ]
  calculatedBy: "Tax_Bracket_Calculation_DT"
}
```

## Output Structure

The final report should include:

1. **Cover Page** - Summary with total tax/refund
2. **Decision Log** - Every decision made with citations
3. **Calculation Worksheet** - Every calculation with formulas and references
4. **Legal References** - Alphabetical list of all authorities cited
5. **Form Output** - Completed Form 1040 with line-by-line citations

This creates a fully auditable tax return where every number can be traced to its legal authority.
