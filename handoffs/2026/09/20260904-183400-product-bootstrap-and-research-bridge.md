# Handoff — 20260904-183400-product-bootstrap-and-research-bridge

- timestampKST: `2026-09-04 18:34`
- worker: `ChatGPT`
- scope: `ERP-DEV`
- status: `PARTIAL`
- mode: `MISSION_LOCK`

## 요청
- 사용자 원요청: ERP 개발을 시작하고, 개발 중 추가 연구가 필요한 부분을 별도 환류 연구 채널이 GitHub를 통해 받아 연구한 뒤 다시 개발 과정으로 반환할 수 있게 하되, 같은 목적을 더 가볍게 달성할 수 있다면 불필요한 구조를 만들지 않는다.
- 시작 목표: 새 제품 저장소 `J-hooon/ERP-DEV`를 ERP 제품 본선으로 초기화하고 개발↔연구 환류 경계를 만든다.
- 궁극 목표: 병렬 연구와 실제 개발이 서로 막지 않으면서, 검증된 지식만 제품 Decision으로 승격되는 실제 사용 가능한 한국형 ERP를 만든다.

## 작업의 본질과 성공 기준
- 본질: 연구 요청/결과를 파일로 복제하는 새 시스템이 아니라 GitHub Issue의 기존 추적 기능을 이용해 개발 질문과 canonical 연구를 느슨하게 연결한다.
- 성공 기준: ERP-DEV에서 `[RESEARCH]` Issue가 생성되고 환류 연구 채널이 이를 claim/return하며, 상세 연구는 ERP-Knowledge에만 남고 MASTER가 반환 결과를 소비할 수 있어야 한다.

## 방향 잠금
- 반드시 유지: 제품 코드는 ERP-DEV, 장문 연구는 ERP-Knowledge, 전역 routing은 AI-System-Core에 둔다.
- 변경 금지: 연구 결과를 연구 채널이 독자적으로 제품 Decision/코드로 승격하지 않는다. product foundation은 아직 Frappe/Custom/Hybrid 중 미확정이다.
- 폐기된 방향: request/return 폴더 큐, 별도 feedback 저장소, 초기 custom label taxonomy, Project board, router bot. 현재 규모에서는 불필요한 상태 중복을 만든다.

## 변화 과정
- 초기 제안은 custom label 3개를 고려했으나 같은 목적을 더 가볍게 달성하기 위해 Issue title prefix `[RESEARCH] -> [RESEARCHING] -> [RESEARCH-RETURNED] -> close`로 단순화했다. Issue number/URL은 유지되어 추적성 손실이 없다.

## 현재 위치
- 완료: 빈 ERP-DEV의 root README 생성, bootstrap branch 생성, ARCHITECTURE.md 및 research Issue Form 생성.
- 진행 중: canonical handoff 초기화, 중앙 Registry/ERP department 연결, feedback worker mission과 MASTER 연결.
- 미완료: bootstrap PR 생성/승격, AI-System-Core PR, ERP-Knowledge feedback mission/handoff 갱신, private 전환.

## 다음 작업 순서
1. ERP-DEV HANDOFF_HEAD를 생성하고 bootstrap branch 내용을 검증한 뒤 PR을 연다.
2. AI-System-Core에 `productRepository: J-hooon/ERP-DEV`를 등록하고 ERP HEAD/routing revision을 갱신한다.
3. ERP-Knowledge에 feedback worker mission을 생성하고 MASTER #20과 연결한다.
4. `ERP-DEV`를 private로 전환한 뒤에만 회사 실데이터/비공개 fixture 사용을 허용한다.

## 결과
- 제품 저장소가 실제 개발용 canonical repository로 초기화되기 시작했다.
- 개발 연구 환류는 별도 큐 파일 없이 GitHub Issue Bridge로 고정됐다.

## 변경
- root `README.md`
- `ARCHITECTURE.md`
- `.github/ISSUE_TEMPLATE/research.yml`
- this handoff record

## 검증
- `J-hooon/ERP-DEV` 접근 가능 및 push 권한 확인.
- 최초 확인 시 repository visibility는 `public`.
- root commit `5982a672a1258c351c580f9e6549e52838cd9c20` 생성 후 bootstrap branch 생성 성공.

## 새로 확정된 사실
- productRepository 실제 이름은 `J-hooon/ERP-DEV`다.
- 초기 feedback queue는 custom label 없이 title prefix만으로 운영한다.
- repository가 public인 동안 sensitive company data는 금지한다.

## 남은 것
- 중앙 Registry 및 ERP department 연결
- feedback worker mission
- MASTER 연결
- bootstrap PR/검증/병합 경로 확인
- repository private 전환

## 포인터
- research canonical: `J-hooon/ERP-Knowledge`
- feedback design: `program/erp-dev-research-feedback-loop-design.md`
- ERP MASTER: `J-hooon/ERP-Knowledge#20`
