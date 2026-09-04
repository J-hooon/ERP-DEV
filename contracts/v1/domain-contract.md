# Vertical Slice V1 — Domain Contract

- status: `CANDIDATE / STACK-INDEPENDENT`
- foundation: `UNDECIDED`
- research canonical: `J-hooon/ERP-Knowledge`
- product decision authority: `ERP-Knowledge#20`

This document is a logical product contract, **not a physical database schema**. Table layout, ORM model, service boundaries, and framework-specific names remain reversible until Track #18 produces evidence and MASTER promotes a foundation decision.

## First vertical slice

```text
BusinessOperator context
  -> shared Product / SKU
  -> Channel Order Inbox
  -> Order Detail
  -> Inventory Availability / Commitment
  -> Fulfilment
  -> Problem / Alert Dashboard
```

## Logical objects

### BusinessOperator
The operating business context under which commercial, inventory, channel, settlement, and permission decisions are evaluated.

Required contract:
- every order and inventory commitment has one operating BusinessOperator context
- switching BusinessOperator must not clone shared Product/SKU identity
- cross-operator stock use requires an explicit authority/transfer relation; shared SKU alone is never enough

### Product / SKU
Shared commercial master identity.

Required contract:
- one SKU may be sellable by multiple BusinessOperators
- operator-specific defaults/policies are separate from the shared Product/SKU
- historical orders reference the SKU used at transaction time without rewriting past facts when current master data changes

### ChannelAccount
One platform account/store/vendor context owned or operated by a BusinessOperator for a period.

Required contract:
- ChannelAccount is separate from TaxRegistration and BusinessOperator identity
- a BusinessOperator/TaxRegistration may map to multiple ChannelAccounts
- external IDs are always scoped by platform + ChannelAccount + external entity type

### Order
Internal canonical order created from a channel observation/import or internal entry.

Minimum identity contract:

```text
ExternalOrderKey = platform + channelAccountId + externalOrderId
```

Required behavior:
- repeated ingestion of the same ExternalOrderKey is idempotent and does not create a second internal Order
- the same externalOrderId under a different ChannelAccount is allowed and produces a distinct internal Order
- Order retains BusinessOperator and ChannelAccount binding used when it was created

### InventoryPool
A quantity/availability boundary for one operating context and SKU.

Required fields at the logical level:
- inventoryPoolId
- businessOperatorId
- SKU binding
- inventory owner reference or explicit `UNKNOWN`
- custody provider
- authority mode

Authority modes for V1:
- `INTERNAL_LEDGER`: ERP owns authoritative stock/commitment truth for the pool
- `EXTERNAL_OBSERVED`: ERP receives remote availability observations but does not claim a complete physical movement ledger

### InventoryCommitment
Product-level obligation that an order intends to consume quantity from an InventoryPool.

Important: `InventoryCommitment` is intentionally more abstract than a warehouse reservation. For `INTERNAL_LEDGER`, it must be enforceable against authoritative quantity. For `EXTERNAL_OBSERVED`, it must not imply a physical reservation event unless an external authoritative source proves one.

Exact external-pool semantics are intentionally open under `ERP-DEV#2`.

### Fulfilment
Execution lineage from an Order toward shipment/delivery, with provider/program context.

Required contract:
- fulfilment program/provider is explicit
- internal execution facts and remote observations are distinguishable
- a remote shipment/availability observation does not retroactively manufacture internal physical movement facts

### Problem
First-class issue visible to users when the system cannot safely continue or detects divergence.

Initial problem classes:
- `DUPLICATE_IMPORT_BLOCKED`
- `INSUFFICIENT_AUTHORITATIVE_STOCK`
- `CROSS_OPERATOR_STOCK_BLOCKED`
- `EXTERNAL_INVENTORY_DIVERGENCE`
- `EXTERNAL_INVENTORY_FRESHNESS_UNKNOWN`
- `MAPPING_REQUIRED`

### AuditEvent
Append-oriented product audit record for meaningful state changes.

Required contract:
- order state changes are attributable
- commitment changes are attributable
- fulfilment changes are attributable
- BusinessOperator/ChannelAccount binding changes must not rewrite historical audit context

## Non-negotiable invariants

1. **Shared Product != shared inventory ownership.**
2. **ChannelAccount != TaxRegistration.**
3. **External identity is account-scoped.**
4. **Same-source order ingestion is idempotent.**
5. **Internal authoritative stock cannot oversell under concurrent commitment attempts.**
6. **Cross-operator stock consumption requires explicit authority/transfer.**
7. **Remote orderable quantity is an observation, not a reconstructed warehouse ledger.**
8. **Current-master edits do not rewrite historical transaction identity.**
9. **Every meaningful state transition is auditable.**
10. **Problems that prevent safe automation are visible as first-class work, not silent log entries.**

## Initial lifecycle vocabulary

These names are product vocabulary candidates, not final DB enums.

### Order
`IMPORTED -> READY | HOLD | CANCELLED`

### InventoryCommitment
`PENDING -> CONFIRMED | REJECTED | RELEASED`

### Fulfilment
`NOT_STARTED -> PROCESSING -> SHIPPED -> DELIVERED | CANCELLED`

State transitions may be expanded by later domain evidence, but implementations must not silently skip audit history.

## Out of V1 scope

- full accounting close / tax filing automation
- payroll / HR
- full MRP
- all marketplaces
- commercial SaaS multi-tenancy
- final physical DB schema
- final framework selection
- final external-fulfilment reservation semantics (`ERP-DEV#2`)
