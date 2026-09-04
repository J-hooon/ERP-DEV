# ERP-DEV

`ERP-DEV` is the canonical product repository for the ERP we are building.

## Canonical repositories

- Product code and product state: `J-hooon/ERP-DEV`
- ERP research evidence and reusable knowledge: `J-hooon/ERP-Knowledge`
- Global routing and operating rules: `J-hooon/AI-System-Core`

Research evidence is not duplicated into this repository. Product code is not stored in ERP-Knowledge.

## Current product state

- foundation: `UNDECIDED`
- candidates: Frappe / Custom / Hybrid
- framework-specific lock-in is prohibited until the platform architecture track produces sufficient evidence.
- development has started with stack-independent V1 contracts and synthetic acceptance fixtures.

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

Current V1 product assets:
- `contracts/v1/domain-contract.md`
- `contracts/v1/inventory-contract.md`
- `contracts/v1/ux-contract.md`
- `fixtures/v1/two-business-synthetic.json`
- `acceptance/v1/vertical-slice.feature`

These are designed to survive the later Frappe / Custom / Hybrid decision.

## Development -> research feedback

Development questions that require additional research use ERP-DEV GitHub Issues as a lightweight bridge.

```text
[RESEARCH]
  -> [RESEARCHING]
  -> [RESEARCH-RETURNED]
  -> close after MASTER consumes the result
```

The long-form research result remains canonical in `ERP-Knowledge`; the ERP-DEV Issue only keeps the development context, concise result, and evidence pointer.

First real feedback issue created during V1 contract development:
- `#2 External fulfilment pool reservation contract`

## Security gate

This repository is currently detected as **public**. Do not commit real company orders, business-registration data, settlement data, credentials, private fixtures, or proprietary operational data until the repository is changed to private. Secrets must never be committed regardless of repository visibility.

Synthetic fixtures such as `fixtures/v1/two-business-synthetic.json` intentionally contain no real identifiers or company data.
