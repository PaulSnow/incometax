# Design: Citation-Based Tax System Using Decision Tables

## Why Decision Tables for Tax Law?

Tax law is fundamentally a set of conditional rules: "IF condition THEN result." Decision tables are the perfect tool for implementing tax law because they:

1. **Make Rules Explicit** - Every tax rule is visible in tabular form
2. **Ensure Completeness** - Decision tables force you to consider all combinations
3. **Support Traceability** - Each cell can reference the legal authority
4. **Enable Verification** - Tax professionals can review tables against actual law
5. **Facilitate Updates** - Annual tax changes update specific cells, not scattered code

## Decision Table Structure with Citations

### Traditional Decision Table
```
Condition: Income Level
Action: Tax Rate
```

### Enhanced Decision Table with Legal Authority
```
Condition: Income Level
Action: Tax Rate
Policy Reference: [Legal Citation]
Explanation: [Why this rule applies]
Effective Date: [When law took effect]
```

## Architecture: Three-Layer Model

### Layer 1: Legal Authority Database
- **Purpose**: Central repository of all tax law references
- **Contents**: IRC sections, IRS publications, revenue procedures, form instructions
- **Format**: Structured JSON with metadata

```json
{
  "id": "IRC_24_a",
  "citation": "IRC §24(a)",
  "title": "Allowance of child tax credit",
  "text": "There shall be allowed as a credit against the tax imposed by this chapter...",
  "url": "https://www.law.cornell.edu/uscode/text/26/24",
  "effectiveDate": "2018-01-01",
  "amendedBy": ["TCJA 2017"],
  "relatedSections": ["IRC §24(b)", "IRC §24(c)", "IRC §152"]
}
```

### Layer 2: Decision Tables with Citations
- **Purpose**: Implement tax rules referencing legal authority
- **Contents**: Conditions, actions, policy statements, citations
- **Format**: Excel → XML with embedded citations

```
Decision Table: Child_Tax_Credit_Eligibility

                            Column 1                    Column 2
POLICY STATEMENT           Credit allowed              Credit not allowed
                          for qualifying child         - child too old

Child Age < 17              Y                          N
Child is Dependent          Y                          -
Lives with Taxpayer         Y                          -

Allow Credit ($2000)        X                          -
Deny Credit                 -                          X
Record Reason              X                          X

CITATION                   IRC §24(a)                  IRC §24(c)(1)
CITATION                   IRC §24(h)(2)               -
EXPLANATION                Child under 17 who is       Child 17 or older does
                          a dependent qualifies        not qualify under age
                          for $2,000 credit           requirement
```

### Layer 3: Report Generation
- **Purpose**: Generate human-readable reports with full citations
- **Contents**: Decisions made, calculations performed, legal references
- **Format**: JSON, PDF, HTML with hyperlinks to law

## Data Flow

```
Input (JSON)
    ↓
[DTRules Engine]
    ↓
Decision Tables (with citations) → Execute rules
    ↓                                    ↓
[Create Decision Record]        [Create Calculation Record]
    ↓                                    ↓
[Attach Citations]              [Attach Legal References]
    ↓                                    ↓
Output (JSON with full audit trail)
    ↓
[Report Generator]
    ↓
PDF/HTML Report with citations and hyperlinks
```

## Example: Complete Decision Chain

### Input
```json
{
  "dependents": [
    { "name": "Emily", "age": 9, "relationship": "daughter" }
  ]
}
```

### Decision Table Execution

**Table 1: Qualifying Child Test**
- Condition: Age < 17 ✓
- Condition: Relationship = child/stepchild/foster ✓
- Condition: Lives with taxpayer > 6 months ✓
- **Result**: Qualifying child = TRUE
- **Citation**: IRC §152(c)

**Table 2: Child Tax Credit Amount**
- Condition: Has qualifying child ✓
- Condition: Tax year = 2024 ✓
- **Result**: Credit = $2,000
- **Citation**: IRC §24(h)(2); Rev. Proc. 2023-34

**Table 3: Credit Phase-Out**
- Condition: Filing status = MFJ ✓
- Condition: MAGI = $80,550 ✓
- Condition: MAGI < $400,000 threshold ✓
- **Result**: No phase-out applies
- **Citation**: IRC §24(b)

### Output
```json
{
  "decision": "Child Tax Credit Allowed",
  "amount": 2000,
  "for": "Emily Smith",
  "explanation": "Emily qualifies as a dependent child under age 17. The credit amount is $2,000 per qualifying child for 2024. No phase-out applies because modified AGI ($80,550) is below the threshold ($400,000 for married filing jointly).",
  "citations": [
    {
      "step": "Qualifying child determination",
      "authority": "IRC §152(c)",
      "rule": "Child must be under 17, related, and live with taxpayer"
    },
    {
      "step": "Credit amount",
      "authority": "IRC §24(h)(2)",
      "rule": "$2,000 per qualifying child"
    },
    {
      "step": "Inflation adjustment",
      "authority": "Rev. Proc. 2023-34",
      "rule": "2024 amounts confirmed"
    },
    {
      "step": "Phase-out test",
      "authority": "IRC §24(b)",
      "rule": "Credit phases out above $400,000 MAGI for MFJ"
    }
  ],
  "decisionTables": [
    "Qualifying_Child_Test_DT",
    "Child_Tax_Credit_Amount_DT",
    "Credit_Phase_Out_DT"
  ]
}
```

## Benefits of This Approach

### For Tax Professionals
- Can verify every calculation against actual law
- Understand exactly why software made each decision
- Confidence in accuracy and compliance

### For Taxpayers
- Transparency into how tax was calculated
- Educational - learn what laws apply to their situation
- Audit defense - complete documentation if questioned

### For Developers
- Clear separation between rules and code
- Easy to update when tax law changes
- Testable - can verify each rule against tax code
- Maintainable - tax professionals can review decision tables

### For Auditors (IRS)
- Complete audit trail
- Every number traceable to legal authority
- Reduces disputes - reasoning is documented

## Implementation Strategy

### Phase 1: Core Infrastructure
1. Set up DTRules engine
2. Create citation database structure
3. Build basic entity definitions

### Phase 2: Fundamental Rules
1. Filing status determination
2. Standard deduction
3. Tax bracket calculation
4. Basic income aggregation

### Phase 3: Credits and Deductions
1. Child Tax Credit (with full citations)
2. Earned Income Credit
3. Education credits
4. Common deductions

### Phase 4: Report Generation
1. Decision log with citations
2. Calculation worksheets
3. Form 1040 with line-by-line references
4. PDF/HTML output with hyperlinks

### Phase 5: Validation and Testing
1. Test against IRS examples
2. Verify citations are accurate
3. Compare results to commercial software
4. Tax professional review

## Maintenance

### Annual Updates
- Update inflation-adjusted amounts (Rev. Proc.)
- Add new tax law changes (TCJA, etc.)
- Update form instructions references
- Test against new IRS examples

### Version Control
- Tag each tax year's rules
- Maintain historical versions for amended returns
- Document all changes with legal references

## Quality Assurance

Every decision table must:
1. ✅ Have complete citations for all rules
2. ✅ Include plain-English explanations
3. ✅ Reference current tax year authorities
4. ✅ Be tested against IRS examples
5. ✅ Be reviewed by tax professional

## Success Metrics

- **Coverage**: % of Form 1040 lines with citations
- **Accuracy**: Match IRS examples 100%
- **Completeness**: All common scenarios covered
- **Traceability**: Every calculation has legal reference
- **Transparency**: Tax professional can verify any decision

## Future Enhancements

- Interactive reports with collapsible citation details
- "What-if" scenarios showing alternative outcomes
- Tax planning suggestions with legal basis
- State tax integration with state law citations
- Multi-year comparison with law change tracking
