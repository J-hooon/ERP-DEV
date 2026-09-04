Feature: ERP first vertical slice across two business operators
  The first product slice must keep shared product identity while isolating
  channel identity, stock authority, fulfilment, and problem handling.

  Background:
    Given the synthetic fixture "two-business-synthetic-v1" is loaded
    And Product "P1" has SKU "SKU-001"
    And BusinessOperator "OP-A" and "OP-B" can both sell SKU "SKU-001"
    And inventory pool "POOL-A-INTERNAL" is INTERNAL_LEDGER with 10 units on hand
    And inventory pool "POOL-B-RG" is EXTERNAL_OBSERVED with remote orderable quantity 7

  Scenario: Shared product does not create duplicate masters
    When I switch from BusinessOperator "OP-A" to "OP-B"
    Then Product "P1" remains the same shared Product identity
    And SKU "SKU-001" remains the same shared SKU identity
    And operator-specific sellability/policy remains separate

  Scenario: Same external order id is isolated by ChannelAccount
    Given ChannelAccount "CA-A" and "CA-B" both receive external order id "ORDER-SAME-001"
    When both orders are imported
    Then two distinct internal Orders exist
    And one Order belongs to "CA-A" and "OP-A"
    And one Order belongs to "CA-B" and "OP-B"

  Scenario: Re-importing the same channel order is idempotent
    Given internal Order "ORD-A-001" already exists for platform "COUPANG", ChannelAccount "CA-A", external order id "ORDER-SAME-001"
    When the same source order is imported again
    Then no new internal Order is created
    And the import resolves to "ORD-A-001"
    And the import attempt is auditable

  Scenario: Concurrent internal commitments cannot oversell
    Given "POOL-A-INTERNAL" can safely promise at most 10 units
    When commitment request "R1" asks for 6 units concurrently with request "R2" asking for 5 units
    Then confirmed active commitment quantity is at most 10
    And the system does not end with 11 confirmed units
    And any rejected or reduced request has an explicit result

  Scenario: Shared SKU does not allow cross-operator stock consumption
    Given BusinessOperator "OP-B" has no transfer or allocation authority over "POOL-A-INTERNAL"
    When "OP-B" requests 1 unit from "POOL-A-INTERNAL"
    Then the commitment is rejected
    And the reason is "NO_EXPLICIT_TRANSFER_OR_ALLOCATION_AUTHORITY"
    And no OP-A stock quantity is silently reduced

  Scenario: Remote inventory observation is not presented as an internal ledger
    Given "POOL-B-RG" reports remote orderable quantity 7
    And the observation has fetchedAt but no sourceEventAt
    When the inventory state is shown or reconciled
    Then authority mode is shown as "EXTERNAL_OBSERVED"
    And the system does not infer a physical on-hand quantity
    And the system does not infer a location ledger
    And the system does not infer a warehouse reservation event
    And fetchedAt is not displayed as a provider inventory event timestamp

  Scenario: External quantity divergence becomes visible work
    Given ERP expectation for "POOL-B-RG" is 9 orderable units
    And remote observation for "POOL-B-RG" is 7 orderable units
    When reconciliation runs
    Then a Problem of type "EXTERNAL_INVENTORY_DIVERGENCE" exists
    And the Problem retains expected quantity 9
    And the Problem retains observed quantity 7
    And the Problem is visible from the Problem Dashboard
    And opening the Problem drills into the affected inventory/order work context

  Scenario: Problem-first home keeps operating context clear
    Given the current BusinessOperator is "OP-A"
    And at least one unresolved Problem exists for "OP-A"
    When I open Home
    Then the current BusinessOperator is visible
    And unresolved problems are visible before deep menu navigation
    When I open a problem count
    Then I reach the filtered affected work list
    And returning from an Order Detail preserves the prior list context

  Scenario: Order detail exposes traceability without menu hunting
    Given Order "ORD-A-001" is open
    When I view Order Detail
    Then I can see its BusinessOperator
    And I can see its ChannelAccount
    And I can see its SKU mapping
    And I can see inventory authority/commitment state
    And I can see fulfilment state
    And I can see blocking Problems
    And I can see the audit timeline

  Scenario: Power-work list supports efficient batch operation
    Given multiple imported Orders are visible in Channel Order Inbox
    When I use the power-work list
    Then I can search the list
    And I can filter the list
    And I can multi-select eligible rows
    And I can reach a bulk action without opening every Order Detail
    And keyboard navigation is supported
    And bulk action eligibility still enforces BusinessOperator and inventory authority rules
