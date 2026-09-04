# Vertical Slice V1 — Inventory Authority Contract

- status: `CANDIDATE / STACK-INDEPENDENT`
- related research: `J-hooon/ERP-Knowledge` Inventory/WMS evidence + `experiments/two-business-operator-commerce-fixture.md`
- open feedback issue: `ERP-DEV#2`

This contract defines **what must remain true**. It intentionally does not choose database locks, ORM behavior, queue technology, or the final external-fulfilment reservation model.

## 1. Pool authority modes

### INTERNAL_LEDGER
The ERP is authoritative for inventory facts used by the first slice.

Minimum obligations:
- authoritative on-hand/projection is internally reproducible
- active commitments are internally known
- a commitment confirmation is atomic with respect to the available quantity invariant
- two concurrent requests must never confirm a total quantity above what the pool can safely promise

Implementation mechanism is undecided. Row lock, advisory lock, stable-anchor row, optimistic conflict, or another method must be selected by evidence, not assumed here.

### EXTERNAL_OBSERVED
The ERP does **not** own a complete physical warehouse ledger for the pool.

Minimum obligations:
- remote quantity is stored as an observation with `fetchedAt`
- `sourceEventAt` remains nullable when the provider does not expose it
- the observation source/provider is explicit
- remote quantity never creates synthetic location movements, warehouse reservations, or physical on-hand facts
- divergence between internal expectation and remote observation is preserved as a Problem until reconciled

## 2. BusinessOperator isolation

For every commitment attempt:

```text
request.businessOperatorId
must have explicit authority over
inventoryPool.businessOperatorId / ownership / allocation relation
```

Shared Product/SKU identity does not grant stock authority.

A request from OP-B against OP-A stock must be rejected unless an explicit cross-entity transfer/allocation authority exists.

## 3. Internal availability invariant

The first slice requires this behavioral guarantee:

```text
sum(CONFIRMED active commitments)
<= quantity the INTERNAL_LEDGER pool can safely promise
```

The exact formula for `available-to-promise` may later include safety stock, inbound certainty, lot/serial restrictions, expiry, quality state, or other policy. V1 must not hard-code those future concepts into the logical contract.

For the synthetic concurrency attack:

```text
on-hand candidate = 10
request A = 6
request B = 5
```

The system may confirm A or B first, or partially support future allocation policy, but it must never end with 11 confirmed units against a safe promise of 10.

## 4. External-pool commitment boundary

For `EXTERNAL_OBSERVED`, an internal order may still need a product-level demand/commitment record so the ERP can explain its own expected workload. However that record must be distinguishable from a proven physical reservation at the external provider.

Until `ERP-DEV#2` returns:

- use `InventoryCommitment` as the abstract product contract
- do not call an external commitment a physical warehouse reservation in canonical product semantics
- do not decrement or rewrite remote observations merely because an internal commitment was created
- keep external confirmation/observation evidence separate from internal intent

## 5. Observation and reconciliation

Minimum external observation shape:

```text
inventoryPoolId
skuId
observedOrderableQuantity
fetchedAt
sourceEventAt?  # nullable
sourceReference?
```

If internal expected orderable quantity and remote observed quantity differ:

```text
Problem(type=EXTERNAL_INVENTORY_DIVERGENCE)
```

must retain:
- expected value
- observed value
- observation timestamp
- source
- resolution/reason when closed

Do not silently overwrite one truth with the other.

## 6. Historical integrity

The following are not editable historical rewrites:
- confirmed commitment quantity/history
- which BusinessOperator requested it
- which InventoryPool it targeted
- authority mode at the relevant operation time
- audit attribution

Corrections use explicit release/compensation/reconciliation events rather than silent deletion when the event has already affected product state.

## 7. Acceptance attacks

The contract fails if any implementation can:

1. confirm 11 units against a safely promiseable 10-unit internal pool
2. let OP-B consume OP-A stock because they share SKU-001
3. turn Rocket Growth `totalOrderableQuantity` into a fabricated location ledger
4. infer `sourceEventAt = fetchedAt` without provider evidence
5. erase a divergence without a reconciliation reason
6. rewrite historical commitment ownership after a master-data change

## 8. Deferred decisions

- physical DB key and lock anchor
- isolation/transaction strategy
- reservation vs allocation naming below the product-level `InventoryCommitment`
- exact external fulfilment confirmation states
- safety stock / ATP formula
- lot/serial/package/location modeling

These remain reopenable until Track #16, Track #18, and feedback Issue #2 provide sufficient evidence.
