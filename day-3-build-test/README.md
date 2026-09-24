# 🏗️ วันที่ 3 — สร้างแอป + Test + Security Scan + CI

## 🎯 เป้าหมายของวัน

- 🎨 ต่อ Svelte UI เข้ากับ API ให้ CRUD ได้ครบ และมี E2E test
- 🧪 ให้ Claude เขียน Unit + Integration Test ให้ครอบคลุม อ่าน Coverage แล้วสั่งแก้อย่างมีเป้าหมาย
- 🛡️ สแกนความปลอดภัยระดับ **Dependency (Snyk)** และ **Web App (OWASP ZAP)** แล้วให้ Claude ช่วยแก้
- ⚙️ ตั้ง **GitHub Actions**: Test → Snyk → Build → Push Image ให้ Pipeline เขียว

> ⚠️ **จริยธรรมและกฎหมาย:** สแกนเฉพาะแอปและเครื่องของตัวเอง หรือที่ได้รับอนุญาตเป็นลายลักษณ์อักษรเท่านั้น
> การสแกนระบบของผู้อื่นโดยไม่ได้รับอนุญาตอาจผิด พ.ร.บ.คอมพิวเตอร์ฯ

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–09:30 | 🧪 เก็บงาน Scaffold ที่ค้างจากเมื่อวาน (ใครเสร็จแล้วเริ่ม UI ได้เลย) |
| 09:30–10:50 | 🎨 Lab: Svelte UI เชื่อม API |
| 10:50–11:30 | 🔁 E2E: Smoke test + Playwright |
| 11:30–12:00 | ☁️ Commit + Push + ช่วยคนที่ตามไม่ทัน |
| 13:00–14:15 | 🧪 Unit + Integration Test + อ่าน Coverage และแก้ |
| 14:15–14:45 | 📦 Snyk: สแกน Dependency |
| 14:45–15:15 | 🕷️ OWASP ZAP: Dynamic Scan |
| 15:15–16:00 | ⚙️ GitHub Actions Workflow |

---

## 🎨 1. Lab: Svelte UI เชื่อม API

ทำทีละฟีเจอร์ เล็กๆ แล้ว Commit:

```
สร้างหน้า <resources> ใน Svelte:
- ตารางแสดงรายการจาก GET /api/<resources>
- ฟอร์มเพิ่มรายการ (POST) พร้อม validation ฝั่ง client
- ปุ่มลบ (DELETE) มี confirm ก่อนลบ
- แสดง loading และ error message ที่อ่านเข้าใจได้
ตั้ง Vite proxy /api → backend ให้ทำงานได้ทั้งตอน dev และใน Docker
```

เมื่อเจอ Error — **วางข้อความ error เต็มๆ** พร้อมบอกว่าทำอะไรอยู่:
```
กดปุ่มบันทึกแล้วขึ้น error นี้ใน browser console:
<วาง error>
และ log ของ backend:
<วางผลจาก docker compose logs backend --tail 50>
ช่วยหาสาเหตุและแก้
```

---

## 🔁 2. ทดสอบระบบแบบ End-to-End

### 🖐️ ทดสอบด้วยมือ (Smoke test)
1. `docker compose down -v && docker compose up -d --build` (เริ่มจากศูนย์)
2. เปิดหน้าเว็บ → เพิ่ม → แก้ไข → ลบ → รีเฟรช ข้อมูลยังอยู่ถูกต้อง
3. `docker compose restart backend` แล้วลองใหม่ (ข้อมูลต้องยังอยู่)

### 🎭 ให้ Claude สร้าง E2E Test อัตโนมัติ (Playwright)
```
ติดตั้ง Playwright ใน frontend แล้วเขียน E2E test 1 ไฟล์:
เปิดหน้าแรก → เพิ่มรายการใหม่ → ตรวจว่าแสดงในตาราง → ลบ → ตรวจว่าหายไป
เพิ่ม npm script "test:e2e" และรันให้ผ่าน
```

---

## ☁️ 3. Commit และ Push ขึ้น GitHub

ก่อน Push ตรวจสอบ:
```bash
git status               # ต้องไม่มี .env
git log --oneline
```

แล้ว Push:
```bash
git push origin main
```
หรือกด **Push origin** ใน GitHub Desktop

> 💡 ให้ Claude ช่วยเขียน commit message ได้: `ช่วยสรุปการเปลี่ยนแปลงที่ยังไม่ commit และเขียน commit message แบบ Conventional Commits`

---

## 🧪 4. Unit Test + Integration Test

### ⚖️ ความต่าง

| ประเภท | ทดสอบอะไร | เครื่องมือ | ต้องมี DB ไหม |
|---|---|---|---|
| Unit | ฟังก์ชันเดี่ยว เช่น validation, คำนวณราคา | Vitest | ไม่ (mock) |
| Integration | API endpoint จริง ผ่าน HTTP ถึง DB | Vitest + Supertest | ใช่ (DB ทดสอบ) |
| E2E | ผู้ใช้คลิกบนเบราว์เซอร์ | Playwright (ทำแล้วในข้อ 2) | ใช่ |

### 💬 Prompt: วางแผนก่อนเขียน

```
อ่านโค้ดใน backend/ แล้วเสนอแผน test (ยังไม่ต้องเขียน):
- รายการ unit test ของฟังก์ชัน validation และ business logic
- รายการ integration test ของทุก endpoint ครอบคลุม:
  success, input ไม่ถูกต้อง (400), ไม่พบ (404), และ edge case
ใช้ Vitest + Supertest, integration test ต่อ PostgreSQL แยก (db ชื่อ appdb_test)
```

ตรวจแผนแล้วสั่ง:

```
เขียน test ตามแผน:
- แยก app (export) กับ server.listen เพื่อให้ Supertest import ได้
- ก่อนรัน test ให้ migrate up ที่ appdb_test และ reset ข้อมูลก่อนแต่ละ test
- เพิ่ม npm scripts: test, test:coverage
- รันจนผ่านทั้งหมด ถ้าพบบั๊กในโค้ดจริงให้แจ้งก่อนแก้ อย่าแก้ test ให้ผ่านแบบหลอกๆ
```

> 💡 ประโยคสุดท้ายสำคัญ — AI บางครั้ง "แก้ test ให้ผ่าน" แทน "แก้โค้ดให้ถูก"

Frontend ก็ทำเช่นเดียวกัน (Vitest + `@testing-library/svelte`) สำหรับ component ที่มี logic

---

## 📊 5. อ่าน Report และแก้ไข (ต่อจากข้อ 4)

```bash
cd backend
npm run test:coverage
```

อ่านอย่างไร:
- **Failed test** → อ่านข้อความ `expected ... received ...` ก่อนเสมอ
- **Coverage** → ดู *Branch coverage* สำคัญกว่า *Line coverage*, ตั้งเป้า ≥ 70% ในหลักสูตรนี้
- ไฟล์ที่ coverage ต่ำและเป็น logic สำคัญ = ต้องเพิ่ม test

Prompt แก้แบบมีเป้าหมาย:
```
นี่คือผล coverage: <วางตาราง>
src/routes/bookings.js branch coverage 45%
ช่วยเพิ่ม test ให้ครอบคลุม branch ที่ขาด โดยเฉพาะกรณีจองซ้อนเวลา
```

Commit: `git commit -m "test: add unit and integration tests"`

---

## 📦 6. Snyk — สแกน Dependency

Snyk ตรวจว่า npm package ที่ใช้อยู่มีช่องโหว่ที่รู้จัก (CVE) หรือไม่

```bash
npm install -g snyk      # หรือใช้ npx snyk
snyk auth                # ล็อกอินผ่านเบราว์เซอร์ (บัญชีฟรี)
cd backend && snyk test
cd ../frontend && snyk test
snyk code test           # สแกนโค้ดที่เขียนเอง (SAST) — ถ้าบัญชีเปิดใช้
```

ทางเลือกที่ไม่ต้องสมัคร: `npm audit`

### 🤖 ให้ Claude ช่วยแก้
```
นี่คือผล snyk test: <วางผล>
จัดลำดับตามความรุนแรง และเสนอวิธีแก้แต่ละตัว (อัปเกรดเวอร์ชันไหน, มี breaking change ไหม)
แก้เฉพาะ High/Critical ก่อน แล้วรัน test ยืนยันว่าไม่พัง
```

---

## 🕷️ 7. OWASP ZAP — Dynamic Scan เว็บแอป

ZAP โจมตีแอปที่ **กำลังรันอยู่** แบบอัตโนมัติ เพื่อหาปัญหาเช่น header ความปลอดภัยที่ขาด, XSS, cookie ไม่ปลอดภัย

### 👁️ Baseline Scan (passive — ปลอดภัย ใช้เวลาไม่นาน)

ให้แอปรันอยู่ก่อน (`docker compose up -d`) แล้ว:

```bash
# macOS / Linux / Git Bash
docker run --rm -v "$(pwd)":/zap/wrk:rw -t ghcr.io/zaproxy/zaproxy:stable \
  zap-baseline.py -t http://host.docker.internal:<frontend-port> -r zap-report.html
```

```powershell
# Windows PowerShell
docker run --rm -v "${PWD}:/zap/wrk:rw" -t ghcr.io/zaproxy/zaproxy:stable `
  zap-baseline.py -t http://host.docker.internal:<frontend-port> -r zap-report.html
```

เปิด `zap-report.html` ดูผล

ต้องการกำหนดว่า rule ไหน IGNORE/WARN/FAIL ให้คัดลอก [`examples/zap-rules.tsv`](examples/zap-rules.tsv) มาไว้ในโฟลเดอร์ปัจจุบัน แล้วเพิ่ม `-c zap-rules.tsv` ต่อท้ายคำสั่ง (คั่นคอลัมน์ด้วย Tab)

> 💡 Linux: ถ้า `host.docker.internal` ใช้ไม่ได้ ให้เพิ่ม `--add-host=host.docker.internal:host-gateway`

### 💥 Full Scan (active — โจมตีจริง)
ใช้ `zap-full-scan.py` แทน **เฉพาะกับแอปของตัวเองในเครื่องเท่านั้น** อาจสร้างข้อมูลขยะใน DB

### 🤖 ให้ Claude ช่วยแก้
```
นี่คือ alert จาก ZAP: <วางรายการ WARN/FAIL>
แก้ใน backend (เช่น ใช้ helmet ตั้ง security headers) และ nginx/vite config ถ้าจำเป็น
อธิบายแต่ละ alert สั้นๆ ว่าเสี่ยงอย่างไร
```

---

## ⚙️ 8. GitHub Actions Workflow

### 🗺️ ภาพรวม Pipeline

```
push / PR
   │
   ▼
 [test] ── unit + integration (มี Postgres service)
   │
   ├──► [snyk] ── dependency scan (fail ถ้ามี High ขึ้นไป)
   └──► [zap]  ── เปิดแอปด้วย docker compose แล้ว baseline scan
           │
           ▼
     [build-push] ── build image → push ghcr.io (เฉพาะ main)
```

ตัวอย่างเต็ม: [`examples/ci.yml`](examples/ci.yml) — **คัดลอกไปไว้ที่ `.github/workflows/ci.yml` ในโปรเจกต์ของตัวเอง**

### 💬 Prompt ให้ Claude เขียน/ปรับ Workflow

```
สร้าง .github/workflows/ci.yml สำหรับโปรเจกต์นี้ โดยใช้ day-3 examples/ci.yml เป็นต้นแบบ:
1. test: รัน backend + frontend test โดยมี postgres service
2. snyk: สแกน backend และ frontend, fail ถ้า severity >= high (ใช้ secret SNYK_TOKEN)
3. zap: docker compose up แล้ว ZAP baseline ที่พอร์ต frontend ของโปรเจกต์นี้
4. build-push: build image backend/frontend แล้ว push ghcr.io เฉพาะ push บน main
ปรับ path, พอร์ต, ชื่อ db ให้ตรงกับโปรเจกต์จริง และอธิบายแต่ละ job สั้นๆ
```

### 🔐 ตั้งค่าใน GitHub
1. Snyk → Account settings → คัดลอก **Auth Token**
2. GitHub repo → Settings → Secrets and variables → Actions → **New repository secret** ชื่อ `SNYK_TOKEN`
3. Push แล้วดูผลที่แท็บ **Actions**

### 🚨 เมื่อ Pipeline แดง
```
GitHub Actions job "<ชื่อ job>" fail ด้วย log นี้:
<วาง log ช่วงที่ error>
หาสาเหตุ แก้ที่ต้นเหตุ (ห้ามปิด test หรือลด threshold ของ security scan)
```

> 💡 เสริม: Claude Code มี GitHub Action ของตัวเอง ให้ mention `@claude` ใน Issue/PR เพื่อให้ช่วยแก้ได้ — ดูเอกสาร Claude Code GitHub Actions ใน [CREDITS.md](../CREDITS.md)

> ⏱️ **เวลาจำกัด 45 นาที:** ถ้า job `zap` ยังไม่ผ่าน ให้ปิด job นั้นไว้ก่อน (comment ออก) แล้วให้ `test` → `snyk` → `build-push` เขียวให้ได้ — ZAP สแกนด้วยมือไปแล้วในข้อ 7

---

## ✅ Checklist ท้ายวัน

- [ ] 🎨 หน้าเว็บ CRUD ได้ครบ และข้อมูลอยู่รอดหลังรีสตาร์ท
- [ ] 🔁 E2E test อย่างน้อย 1 case ผ่าน
- [ ] 🧪 Unit + Integration test ผ่านทั้งหมด, branch coverage ≥ 70%
- [ ] 📦 `snyk test` ไม่มี High/Critical ที่แก้ได้ค้างอยู่
- [ ] 🕷️ ZAP baseline ไม่มี FAIL · บันทึกสิ่งที่แก้ไว้ใน `docs/security-notes.md`
- [ ] ⚙️ `.github/workflows/ci.yml` รัน `test` → `snyk` → `build-push` เขียว และมี image ใน ghcr.io
- [ ] ☁️ Push แล้ว ไม่มี `.env` และไฟล์ report ใน repo

## 🛠️ Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| Frontend เรียก API แล้ว CORS error | ใช้ Vite proxy หรือ reverse proxy แทนการเปิด CORS กว้างๆ |
| Claude แก้ไฟล์เยอะเกินที่ขอ | ขอให้ "แก้เฉพาะไฟล์ X" และใช้ `git diff` ตรวจก่อน commit, ย้อนด้วย `git restore` |
| Snyk job fail `Authentication error` | ตรวจชื่อ secret ต้องเป็น `SNYK_TOKEN` ตรงตัว |
| ZAP job เชื่อมต่อแอปไม่ได้ | ใช้ `docker compose up -d --wait` และตรวจว่ามี healthcheck, พอร์ต target ถูก |
| Push image `denied: permission_denied` | ต้องมี `permissions: packages: write` ใน job |
| CI fail ที่ `migrate up` | มักเกิดจากแก้ไฟล์ migration เดิม หรือ migration พึ่งข้อมูลที่ไม่มีใน DB ว่าง — สร้าง migration ใหม่แทน |
| Test ผ่านในเครื่องแต่ fail ใน CI | ตรวจ env var ที่ใช้ในเครื่องแต่ไม่ได้ตั้งใน CI, และ `npm ci` ต้องมี `package-lock.json` |
| Coverage ไม่ถึง 70% แต่หมดเวลา | จดไฟล์ที่ต่ำไว้ แล้วให้ Claude เติม test ช่วง Sprint วันที่ 4 |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "Framework & Library", "Security" และ "CI/CD & Deploy"

---

<p align="center"><a href="../day-2-bootcamp/README.md">⬅️ 🎮 วันที่ 2</a> · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../day-4-security-deploy/README.md">🚀 วันที่ 4 ➡️</a></p>
