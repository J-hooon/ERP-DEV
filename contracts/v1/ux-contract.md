# Vertical Slice V1 — UX Contract

- status: `CANDIDATE / STACK-INDEPENDENT`
- primary reference synthesis: Amaranth 10 + SAP Fiori + ECOUNT + SystemEver
- research canonical: `J-hooon/ERP-Knowledge/knowledge/korea-erp-reference-ux-strategy.md`

The UX goal is not to make ERP merely look modern. The product must support both a new user who needs guidance and a power user who needs dense, fast operation.

## 1. Two deliberate work modes

### Guided / Overview
Purpose:
- show what needs attention now
- expose unfinished/problem work before menu taxonomy
- make the current BusinessOperator context obvious
- support drill-down from problem -> affected orders/items

### Power Work
Purpose:
- dense operational list
- keyboard navigation
- multi-select and bulk actions
- saved filters/views
- fast search
- minimal unnecessary page transitions

These are two interaction modes over the same domain truth, not two separate products.

## 2. Shell contract

The global shell must always expose:
- current BusinessOperator
- operator switch
- global search / command entry point
- current work area
- visible problem/alert entry point

Switching BusinessOperator:
- changes the operating context used for orders, inventory pools, channels, and permissions
- does not clone or rename shared Product/SKU masters
- must never make the user uncertain which operator owns the current transaction

## 3. Home / Problem Dashboard

Home is problem-first rather than menu-first.

Initial cards/queues:
- orders needing mapping
- insufficient authoritative stock
- cross-operator stock blocked
- external inventory divergence
- external inventory freshness unknown
- fulfilment exceptions

Required behavior:
- each count is clickable/drillable to the exact filtered work list
- empty problem states are distinguishable from data-not-loaded states
- severity and ownership/context are visible
- a problem cannot disappear solely because the user navigated away

## 4. Channel Order Inbox

The main list is the power-work surface for imported orders.

Minimum visible concepts:
- source platform
- ChannelAccount
- BusinessOperator
- external order identity
- customer/order summary as privacy policy allows
- SKU mapping state
- inventory/commitment state
- fulfilment state
- problem state
- last source observation/import time

Required interaction:
- search
- filters
- saved view
- multi-select
- bulk action entry point
- keyboard row navigation
- open detail without losing list context

The product must not force a user through deep menu trees to discover pending orders.

## 5. Order Detail

Order Detail must answer, without hunting across unrelated menus:

1. What order is this and from which ChannelAccount?
2. Which BusinessOperator owns the operating context?
3. Which SKU(s) does it map to?
4. Which InventoryPool/authority mode is relevant?
5. Is quantity committed, rejected, external/unknown, or divergent?
6. What fulfilment state exists?
7. What problem is blocking progress?
8. What changed and who/what changed it?

Recommended composition:
- compact header summary
- line items
- inventory/commitment panel
- fulfilment panel
- problem panel
- audit timeline

## 6. Inventory truth must be visible in the UI

The UI must visually distinguish:
- `INTERNAL_LEDGER` authoritative quantity
- `EXTERNAL_OBSERVED` remote quantity observation

For external observations, show freshness/source semantics explicitly. A user must not mistake a fetched remote orderable quantity for an internally proven physical on-hand ledger.

When `sourceEventAt` is unavailable, the UI must not display `fetchedAt` as though it were the provider's inventory event time.

## 7. Bulk and keyboard contract

Exact shortcut keys are intentionally deferred, but the product contract requires:
- keyboard movement through the order list
- keyboard-accessible open/close detail flow
- selection of multiple rows without repeated mouse-only actions
- bulk actions gated by safe eligibility checks
- action results summarized with succeeded / skipped / failed counts

Bulk operations must never bypass BusinessOperator, inventory authority, or permission invariants for convenience.

## 8. Error / problem UX

A blocking error should state:
- what cannot proceed
- why
- which object/context is responsible
- whether the user can resolve it now
- where to go next

Avoid generic `Error occurred` messaging when the domain reason is known.

Examples:
- `OP-B cannot use POOL-A-INTERNAL without explicit transfer/allocation authority.`
- `Remote inventory differs from ERP expectation: expected 9, observed 7. Observation age: ...`

## 9. Consistency rules

Across Dashboard, Inbox, Detail, Inventory, and Fulfilment:
- the same status term means the same thing
- action placement follows a reusable pattern
- destructive/irreversible actions are not visually equivalent to navigation
- source/system-of-record distinctions are preserved
- historical/audit information is reachable without specialist menu knowledge

## 10. First-slice UX acceptance targets

The slice is not considered UX-complete merely because screens render.

It must demonstrate:
- operator context is visible at all times
- a problem on Home can be reached in one drill-down to the affected list
- the same order can be found by search without navigating menu hierarchy
- a power user can filter/select/bulk-operate from the Inbox
- an external observed pool is not presented as authoritative internal stock
- list context survives opening and returning from Order Detail
- critical state changes are visible in the audit timeline

Hands-on benchmark metrics against reference ERP products will later add task time, click/keystroke count, error rate, and discoverability measurements.
