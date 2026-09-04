# ERP Architecture

## Current status

- product foundation: `UNDECIDED`
- candidates: `Frappe`, `Custom`, `Hybrid`
- final foundation decision authority: ERP MASTER (`ERP-Knowledge#20`)
- architecture research: `J-hooon/ERP-Knowledge` Track #18

No framework-specific schema, UI shell, permission model, or deployment model may be treated as canonical merely because it is convenient to prototype.

## Stack-independent product layer

Development has started at the layer that must survive any foundation choice.

Current V1 contracts:
- `contracts/v1/domain-contract.md`
- `contracts/v1/inventory-contract.md`
- `contracts/v1/ux-contract.md`

Current executable-by-future-implementation specification assets:
- `fixtures/v1/two-business-synthetic.json`
- `acceptance/v1/vertical-slice.feature`

These define product invariants and acceptance behavior, not ORM tables or framework classes.

## First vertical slice

```text
BusinessOperator
  -> Product / SKU
  -> Channel Order Inbox
  -> Order Detail
  -> Inventory Availability / Commitment
  -> Fulfilment
  -> Problem / Alert Dashboard
```

The first slice is used both to build product value and to compare platform candidates under the same requirements.

## Current unresolved architecture gates

### Foundation
Frappe / Custom / Hybrid remains open until Track #18 produces comparable evidence against this same vertical slice.

### External fulfilment inventory semantics
`ERP-DEV#2` asks how an external-observed pool such as Rocket Growth should map internal demand/commitment semantics without fabricating a physical warehouse reservation. Until returned, product contracts use abstract `InventoryCommitment` and keep remote observation separate from physical ledger truth.

### Internal concurrency mechanism
The product requires no-oversell behavior for authoritative internal pools, but the physical locking/conflict mechanism is not yet selected. Track #16 / Track #18 evidence must decide the implementation mechanism.

## Research boundary

- Product implementation lives here.
- Long-form ERP evidence, experiments, source maps, and reusable research live in `J-hooon/ERP-Knowledge`.
- Development-originated unanswered questions are opened as ERP-DEV Issues using the `[RESEARCH]` template.
- Returned research is a candidate input. Only MASTER can promote it to a product Decision or implementation contract.

## Correctness and UX

The product must not trade correctness for a simpler UI, and must not use correctness as an excuse for legacy ERP interaction patterns. Inventory, accounting/tax identity, integrations, and UX are validated independently and then integrated through explicit contracts.

The current UX contract deliberately combines:
- problem-first guided/overview work
- dense power-work lists
- visible BusinessOperator context
- explicit internal-vs-external inventory authority
- audit traceability

## Security gate

Until this repository is private, only non-sensitive bootstrap material, synthetic fixtures, public-safe product contracts, and public-safe code may be stored here. Real company data, credentials, settlement data, registration data, and private operational fixtures are prohibited.
