# Handoff — 20260904-194224-vertical-slice-v1-contracts

- timestampKST: `2026-09-04 19:42:24`
- worker: `ChatGPT`
- scope: `ERP-DEV`
- status: `PARTIAL`
- mode: `MISSION_LOCK`

## 요청
- 사용자 원요청: ERP 저장소 상태를 다시 확인하고 다음 ERP 개발 작업까지 이어서 진행한다.
- 시작 목표: 기술 foundation을 성급히 확정하지 않으면서 실제 ERP 제작을 시작한다.
- 궁극 목표: 한국 중소/중견 실무에 맞고 UX/UI와 처리속도에서 기존 ERP보다 명확한 우위를 가지는 실제 사용 가능한 ERP를 만든다.

## 방향 잠금
- Frappe / Custom / Hybrid는 Track #18 evidence 전까지 `UNDECIDED`.
- 제품 코드/계약은 ERP-DEV, 장문 연구는 ERP-Knowledge에 둔다.
- 실제 회사 식별정보/주문/정산/credential/비공개 fixture는 ERP-DEV private 전환 전까지 금지한다.
- stack-independent product contract와 synthetic fixture는 foundation 결정 전에도 진행한다.
- 연구가 필요한 새 개발 gap은 ERP-DEV `[RESEARCH]` Issue로 보내고 관련 없는 개발은 계속한다.

## 이번 작업
- branch: `feat/vertical-slice-v1-contracts`
- added: `contracts/v1/domain-contract.md`
- added: `contracts/v1/inventory-contract.md`
- added: `contracts/v1/ux-contract.md`
- added: `fixtures/v1/two-business-synthetic.json`
- added: `acceptance/v1/vertical-slice.feature`
- revised: `ARCHITECTURE.md`
- revised: `README.md`

## 첫 실제 개발 환류
- created: `ERP-DEV#2 [RESEARCH] External fulfilment pool reservation contract`
- 이유: Rocket Growth 같은 EXTERNAL_OBSERVED pool에 내부 warehouse reservation과 같은 의미를 부여하면 원격 관측과 물리 truth가 섞일 수 있음.
- 현재 개발은 `InventoryCommitment`라는 reversible product-level contract를 사용하고 외부 물리 reservation semantics는 Issue #2 결과 전까지 잠근다.

## 현재 V1 계약 핵심
- shared Product/SKU와 BusinessOperator-specific policy를 분리
- ExternalOrderKey는 platform + ChannelAccount + externalOrderId 범위로 idempotent
- InventoryPool authority를 INTERNAL_LEDGER vs EXTERNAL_OBSERVED로 구분
- internal authoritative pool은 concurrent commitment에서도 oversell 금지
- shared SKU만으로 cross-operator stock 사용 금지
- remote orderable quantity를 physical on-hand/location ledger/reservation event로 추론 금지
- Home은 problem-first, Order Inbox는 dense power-work, Order Detail은 audit/stock/fulfilment/problem을 한 흐름에서 보여줌

## 검증
- synthetic fixture JSON은 작성 전 JSON parser로 유효 문법을 검증했다.
- fixture에는 실제 사업자번호/주문/정산/credential이 없고 synthetic IDs만 사용한다.
- acceptance scenarios는 shared SKU, channel-scoped identity, duplicate import idempotency, concurrency no-oversell, cross-operator block, external observation truth, problem dashboard, audit/UX를 공격한다.

## 다음 작업 순서
1. branch 변경 범위를 GitHub compare로 검증하고 PR을 연다.
2. `ERP-DEV#2`는 feedback research worker #21 채널에서 연구 후 `[RESEARCH-RETURNED]`로 반환한다.
3. Track #18 foundation 비교 결과가 도착하기 전까지 contract/fixture 기반 reversible 개발을 계속한다.
4. foundation 결정 후 같은 acceptance scenarios를 실제 runtime test로 바꾼다.
5. ERP-DEV가 private 전환되면 anonymized real-company fixture mapping을 별도 단계로 시작한다.

## blockers
- sensitive-data development: ERP-DEV visibility가 현재 `public`이라 blocked.
- physical external reservation semantics: `ERP-DEV#2` 결과 대기.
- foundation-specific implementation: Track #18 결과 대기.
- stack-independent product development: 진행 가능.
