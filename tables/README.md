# Decision Tables for US Federal Income Tax

This directory contains Excel-based decision tables that define the tax calculation rules.

## Decision Table Structure

Each decision table is an Excel file (.xls or .xlsx) with the following structure:

### Conditions (Upper Rows)
- Define the conditions that must be met
- Can use boolean expressions, comparisons, ranges
- Evaluated left to right across columns

### Actions (Lower Rows)
- Define what happens when conditions are met
- Can set values, perform calculations, call other tables
- Executed when all conditions in a column are true

## Planned Decision Tables

### 1. Filing Status Determination (`filing_status_dt.xlsx`)
Determines the taxpayer's filing status based on marital status, dependents, etc.

**Conditions:**
- Marital status (Single, Married, Widowed)
- Spouse filing separately?
- Qualifying dependents
- Head of household criteria

**Actions:**
- Set filing status (Single, Married Filing Jointly, Married Filing Separately, Head of Household, Qualifying Widow(er))

### 2. Standard Deduction (`standard_deduction_dt.xlsx`)
Calculates the standard deduction based on filing status and tax year.

**Conditions:**
- Tax year
- Filing status
- Age (65+)
- Blind status

**Actions:**
- Set standard deduction amount
- Apply additional amounts for age/blindness

### 3. Tax Bracket Calculation (`tax_brackets_dt.xlsx`)
Applies the correct marginal tax rates based on taxable income and filing status.

**Conditions:**
- Filing status
- Taxable income ranges
- Tax year

**Actions:**
- Calculate tax for each bracket
- Sum total tax liability

### 4. Earned Income Tax Credit (`eitc_dt.xlsx`)
Determines eligibility and calculates EITC amount.

**Conditions:**
- Earned income
- AGI limits
- Number of qualifying children
- Filing status

**Actions:**
- Calculate EITC amount
- Apply phase-out rules

### 5. Child Tax Credit (`child_tax_credit_dt.xlsx`)
Calculates Child Tax Credit and Additional Child Tax Credit.

**Conditions:**
- Number of qualifying children
- Modified AGI
- Tax liability

**Actions:**
- Calculate CTC amount
- Calculate Additional CTC (refundable portion)
- Apply phase-out rules

## Creating Decision Tables

1. Create Excel file with appropriate naming
2. Define entity references in first columns
3. Create condition rows with expressions
4. Create action rows with assignments
5. Fill in columns for each rule scenario
6. Compile to XML using DTRules compiler

## Example Table Format

Each decision table should include citation rows to document legal authority:

```
                        Column 1            Column 2            Column 3
POLICY STATEMENT        [Legal citation]    [Legal citation]    [Legal citation]
Condition 1            value1              value2              value3
Condition 2            value4              value5              value6
Action 1               result1             result2             result3
Action 2               result4             result5             result6
EXPLANATION            [Explanation 1]      [Explanation 2]     [Explanation 3]
CITATION               IRC §X(y)           IRC §X(z)           Pub 17, Pg X
CITATION               Rev. Proc. 20XX-XX  Form Instructions   Revenue Ruling
```

### Standard Deduction Example

```
Decision Table: Standard_Deduction_DT
Type: FIRST (execute first matching column)

                        MFJ         Single      HOH
POLICY STATEMENT        Standard deduction for married filing jointly
                        Standard deduction for single filers
                        Standard deduction for head of household

Filing Status           MFJ         Single      HOH
Tax Year               2024        2024        2024
Age < 65               Y           Y           Y
Not Blind              Y           Y           Y

Set Deduction          29200       14600       21900
Record Decision        X           X           X
Add Citation           X           X           X

EXPLANATION            Married couples filing jointly receive $29,200 standard deduction for 2024, indexed for inflation
                       Single filers receive $14,600 standard deduction
                       Head of household filers receive $21,900 standard deduction

CITATION               IRC §63(c)(2)(A)
                       IRC §63(c)(2)(C)
                       IRC §63(c)(2)(B)
CITATION               Rev. Proc. 2023-34, Section 3.12
                       Rev. Proc. 2023-34
                       Rev. Proc. 2023-34
CITATION               Form 1040 Instructions, Line 12
                       Form 1040 Instructions
                       Form 1040 Instructions
```

## Tax Year

Currently targeting tax year 2024 (for 2025 filing).
Tax rates, deductions, and credit amounts should be updated annually.

## References

- [IRS Form 1040](https://www.irs.gov/forms-pubs/about-form-1040)
- [IRS Publication 17 - Your Federal Income Tax](https://www.irs.gov/publications/p17)
- [Tax Brackets and Rates](https://www.irs.gov/filing/federal-income-tax-rates-and-brackets)
