# Income Tax Filing System

A US Federal Income Tax filing system built using DTRules decision table engine (Go implementation).

## Project Structure

```
incometax/
├── tables/          # Excel decision tables for tax rules
├── xml/            # Compiled XML decision tables
├── entities/       # Entity definition documents
├── cmd/
│   └── incometax/  # Main application entry point
└── pkg/
    ├── calculator/ # Tax calculation logic
    └── forms/      # Tax form generators
```

## Overview

This project uses DTRules to implement US Federal Income Tax calculations through decision tables. Decision tables provide a clear, maintainable way to express complex tax rules and logic.

## Decision Tables Planned

- **Filing Status Determination** - Determine taxpayer filing status
- **Standard Deduction** - Calculate standard deduction based on filing status and year
- **Tax Bracket Calculation** - Apply progressive tax rates
- **Credits and Deductions** - Handle various tax credits (EITC, Child Tax Credit, etc.)
- **Form 1040 Generation** - Generate completed Form 1040

## Prerequisites

- Go 1.21+
- DTRules Go implementation

## Setup

1. Clone DTRules repository:
```bash
git clone https://github.com/DTRules/DTRules.git
```

2. Install dependencies:
```bash
go mod tidy
```

## Usage

TBD - Will be added as implementation progresses

## Decision Table Workflow

1. Define tax-related entities in Excel Entity Definition Documents (EDD)
2. Create decision tables in Excel for tax rules
3. Compile Excel files to XML using DTRules compiler
4. Execute rules through the Go application or REST API

## Data Formats

- **Rule Definitions**: Excel spreadsheets (human-readable)
- **Compiled Rules**: XML (for execution engine)
- **Input Data**: JSON (taxpayer information, income, deductions, etc.)
- **Output Results**: JSON (calculated tax liability, credits, refund/owed)

The DTRules Go implementation provides a REST API that accepts JSON input and returns JSON output, making it easy to integrate with web applications or command-line tools.

## References

- [DTRules GitHub](https://github.com/DTRules/DTRules)
- [DTRules Website](http://www.dtrules.com/)
- [IRS Tax Forms and Instructions](https://www.irs.gov/forms-instructions)
