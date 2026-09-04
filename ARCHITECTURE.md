# ERP Architecture

## Current status

- product foundation: `UNDECIDED`
- candidates: `Frappe`, `Custom`, `Hybrid`
- final foundation decision authority: ERP MASTER
- architecture research: `J-hooon/ERP-Knowledge` Track #18

No framework-specific schema, UI shell, permission model, or deployment model may be treated as canonical merely because it is convenient to prototype.

## First vertical slice

```text
BusinessOperator
  -> Product / SKU
  -> Channel Order Inbox
  -> Order Detail
  -> Inventory Availability / Reservation
  -> Fulfilment
  -> Problem / Alert Dashboard
```

The first slice is used both to build product value and to compare platform candidates under the same requirements.

## Research boundary

- Product implementation lives here.
- Long-form ERP evidence, experiments, source maps, and reusable research live in `J-hooon/ERP-Knowledge`.
- Development-originated unanswered questions are opened as ERP-DEV Issues using the `[RESEARCH]` template.
- Returned research is a candidate input. Only MASTER can promote it to a product Decision or implementation contract.

## Correctness and UX

The product must not trade correctness for a simpler UI, and must not use correctness as an excuse for legacy ERP interaction patterns. Inventory, accounting/tax identity, integrations, and UX are validated independently and then integrated through explicit contracts.

## Security gate

Until this repository is private, only non-sensitive bootstrap material and public-safe code may be stored here. Real company data, credentials, settlement data, registration data, and private operational fixtures are prohibited.
