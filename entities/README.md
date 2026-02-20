# Entity Definitions for Income Tax System

This directory contains Excel-based Entity Definition Documents (EDD) that define the data structures used in the tax calculation system.

## What are Entity Definitions?

Entity definitions describe the data model for the decision tables. They define:
- Entity types (objects/records)
- Attributes (fields) of each entity
- Data types (string, number, boolean, date, etc.)
- Relationships between entities

## Required Entities

### 1. Taxpayer (`taxpayer_edd.xlsx`)
Represents an individual filing taxes.

**Attributes:**
- `ssn` (String) - Social Security Number
- `firstName` (String)
- `lastName` (String)
- `dateOfBirth` (Date)
- `filingStatus` (String) - Single, MFJ, MFS, HOH, QW
- `isBlind` (Boolean)
- `canBeClaimedAsDependent` (Boolean)

### 2. Income (`income_edd.xlsx`)
Represents various income sources.

**Attributes:**
- `wages` (Number) - W-2 wages
- `tips` (Number)
- `taxableInterest` (Number)
- `ordinaryDividends` (Number)
- `qualifiedDividends` (Number)
- `capitalGains` (Number)
- `businessIncome` (Number)
- `otherIncome` (Number)
- `totalIncome` (Number) - Calculated
- `adjustedGrossIncome` (Number) - Calculated

### 3. Deductions (`deductions_edd.xlsx`)
Represents deductions from income.

**Attributes:**
- `standardDeduction` (Number) - Calculated
- `itemizedDeductions` (Number)
- `useItemized` (Boolean)
- `totalDeductions` (Number) - Calculated
- `qbiDeduction` (Number) - Qualified Business Income
- `studentLoanInterest` (Number)
- `iraDeduction` (Number)
- `healthSavingsAccount` (Number)

### 4. Dependent (`dependent_edd.xlsx`)
Represents a dependent claimed on the return.

**Attributes:**
- `ssn` (String)
- `firstName` (String)
- `lastName` (String)
- `dateOfBirth` (Date)
- `relationship` (String)
- `monthsLived` (Number)
- `isQualifyingChild` (Boolean)
- `isStudent` (Boolean)
- `isDisabled` (Boolean)

### 5. TaxCalculation (`tax_calculation_edd.xlsx`)
Represents the tax calculation results.

**Attributes:**
- `taxableIncome` (Number) - Calculated
- `taxBeforeCredits` (Number) - Calculated
- `totalCredits` (Number) - Calculated
- `taxAfterCredits` (Number) - Calculated
- `otherTaxes` (Number)
- `totalTax` (Number) - Calculated
- `federalWithholding` (Number)
- `estimatedPayments` (Number)
- `refundOrAmountOwed` (Number) - Calculated

### 6. Credits (`credits_edd.xlsx`)
Represents tax credits.

**Attributes:**
- `childTaxCredit` (Number) - Calculated
- `additionalChildTaxCredit` (Number) - Calculated
- `earnedIncomeCredit` (Number) - Calculated
- `educationCredits` (Number)
- `childCareCredit` (Number)
- `retirementSavingsCredit` (Number)
- `otherCredits` (Number)

### 7. TaxReturn (`tax_return_edd.xlsx`)
Main entity that aggregates all information.

**Attributes:**
- `taxYear` (Number)
- `taxpayer` (Taxpayer) - Reference
- `spouse` (Taxpayer) - Reference (if MFJ)
- `dependents` (Array of Dependent)
- `income` (Income) - Reference
- `deductions` (Deductions) - Reference
- `taxCalculation` (TaxCalculation) - Reference
- `credits` (Credits) - Reference

## Entity Relationships

```
TaxReturn
├── Taxpayer (primary)
├── Taxpayer (spouse, optional)
├── Dependents[] (array)
├── Income
├── Deductions
├── Credits
└── TaxCalculation
```

## Creating Entity Definition Documents

1. Create Excel file with entity name
2. Define entity name in first row
3. List attributes with their types
4. Specify any validation rules or ranges
5. Document relationships to other entities
6. Compile to XML using DTRules compiler

## Data Types Supported

- **String** - Text values
- **Number** - Numeric values (integer or decimal)
- **Boolean** - True/false values
- **Date** - Date values
- **Reference** - Reference to another entity
- **Array** - Collection of values or entities

## Notes

Entity definitions should align with IRS Form 1040 and related schedules.
Updates may be needed annually to reflect tax law changes.
