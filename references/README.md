# Tax Law References and Citations

This directory contains structured references to tax law, IRS publications, and form instructions that support every decision made by the system.

## Reference Types

### 1. Internal Revenue Code (IRC)
- **Format**: `IRC §[section]([subsection])`
- **Example**: `IRC §1(a)` - Tax rates for married individuals filing jointly
- **Source**: https://www.law.cornell.edu/uscode/text/26

### 2. IRS Publications
- **Format**: `Pub [number], Page [page], [description]`
- **Example**: `Pub 17, Page 25, Standard Deduction Amounts`
- **Source**: https://www.irs.gov/publications

### 3. Form Instructions
- **Format**: `Form [number] Instructions, Line [line], [year]`
- **Example**: `Form 1040 Instructions, Line 12a, 2024`
- **Source**: https://www.irs.gov/forms-instructions

### 4. Revenue Rulings
- **Format**: `Rev. Rul. [year]-[number]`
- **Example**: `Rev. Rul. 2024-15`
- **Source**: https://www.irs.gov/irb

### 5. Treasury Regulations
- **Format**: `Treas. Reg. §[section]`
- **Example**: `Treas. Reg. §1.1-1(b)`

### 6. Case Law
- **Format**: `[Case Name], [Citation]`
- **Example**: `Commissioner v. Smith, 324 U.S. 177 (1945)`

## Reference Structure

Each reference should include:

```json
{
  "id": "ref_std_deduction_mfj_2024",
  "type": "IRC",
  "citation": "IRC §63(c)(2)(A)",
  "description": "Standard deduction for married filing jointly",
  "taxYear": 2024,
  "amount": 29200,
  "url": "https://www.law.cornell.edu/uscode/text/26/63",
  "additionalReferences": [
    "Rev. Proc. 2023-34",
    "Pub 17, Page 95"
  ],
  "effectiveDate": "2024-01-01",
  "expirationDate": null,
  "notes": "Indexed for inflation annually"
}
```

## Integration with Decision Tables

Each decision table row should include:
- **Policy Reference**: The legal authority for the rule
- **Citation**: Specific code section or publication
- **Explanation**: Human-readable explanation linking decision to law

### Example Decision Table Structure

```
Condition: Filing Status == "MFJ"
Action: Set standard_deduction = 29200
Policy Reference: IRC §63(c)(2)(A); Rev. Proc. 2023-34
Explanation: Standard deduction for married filing jointly (2024)
```

## Output Format with Citations

Every calculation should produce:

```json
{
  "calculation": "standard_deduction",
  "value": 29200,
  "explanation": "Standard deduction for married filing jointly",
  "citations": [
    {
      "authority": "IRC §63(c)(2)(A)",
      "type": "statute",
      "url": "https://www.law.cornell.edu/uscode/text/26/63"
    },
    {
      "authority": "Rev. Proc. 2023-34",
      "type": "revenue_procedure",
      "description": "2024 inflation adjustments"
    },
    {
      "authority": "Form 1040 Instructions, Line 12",
      "type": "form_instructions",
      "year": 2024
    }
  ],
  "notes": "Amount indexed annually for inflation"
}
```

## Reference Database

Maintain a JSON database of all tax law references:

### `tax-code-references.json`
All IRC sections relevant to individual income tax

### `publication-references.json`
IRS publications with specific page references

### `form-instructions-references.json`
Line-by-line instructions from tax forms

### `revenue-procedures.json`
Annual inflation adjustments and procedural guidance

### `tax-rates-brackets.json`
Historical tax rates with legal citations

## Annual Updates

Tax law changes annually. This directory should maintain:
- Current year references (2024)
- Historical references for amended returns
- Change log documenting law changes

## Verification

Each reference should be:
1. **Verified** - Confirmed against official IRS/legal sources
2. **Current** - Updated for the applicable tax year
3. **Complete** - Includes all necessary citation information
4. **Traceable** - Links to authoritative sources

## Example: Child Tax Credit Chain

```
Decision: Taxpayer qualifies for $2,000 per child
├─ IRC §24(a) - Credit allowed for qualifying child
├─ IRC §24(c) - Definition of qualifying child
│  └─ IRC §152(c) - Dependent definition
├─ IRC §24(h)(2) - Credit amount ($2,000)
├─ IRC §24(b) - Phase-out thresholds
│  └─ Rev. Proc. 2023-34 - 2024 inflation adjustments
└─ Form 1040 Instructions, Schedule 8812 - Calculation worksheet
```

Every decision should have a similar citation chain showing the complete legal basis.
