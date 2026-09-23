# 🛡️ วันที่ 3 — Testing และ Security

## 🎯 เป้าหมายของวัน

- ให้ Claude เขียน Unit Test + Integration Test ให้ครอบคลุม และรันผ่าน
- อ่าน Test/Coverage Report แล้วสั่งแก้อย่างมีเป้าหมาย
- สแกนความปลอดภัย 3 ระดับ: **Dependency (Snyk)** → **Web App (OWASP ZAP)** → **Host/Infrastructure (Nessus)**
- จัดลำดับความสำคัญของช่องโหว่ และให้ Claude ช่วยแก้

> ⚠️ **จริยธรรมและกฎหมาย:** สแกนเฉพาะแอปและเครื่องของตัวเอง หรือที่ได้รับอนุญาตเป็นลายลักษณ์อักษรเท่านั้น
> การสแกนระบบของผู้อื่นโดยไม่ได้รับอนุญาตอาจผิด พ.ร.บ.คอมพิวเตอร์ฯ

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–10:30 | ให้ Claude เขียน Unit Test + Integration Test |
| 10:30–12:00 | อ่าน Report และแก้ไข |
| 13:00–14:00 | Snyk: สแกน Dependency |
| 14:00–15:00 | OWASP ZAP: Dynamic Scan |
| 15:00–16:00 | Nessus: สแกน Host + สรุปผล |

---

## 🧪 1. Unit Test + Integration Test

### ⚖️ ความต่าง

| ประเภท | ทดสอบอะไร | เครื่องมือ | ต้องมี DB ไหม |
|---|---|---|---|
| Unit | ฟังก์ชันเดี่ยว เช่น validation, คำนวณราคา | Vitest | ไม่ (mock) |
| Integration | API endpoint จริง ผ่าน HTTP ถึง DB | Vitest + Supertest | ใช่ (DB ทดสอบ) |
| E2E | ผู้ใช้คลิกบนเบราว์เซอร์ | Playwright (ทำแล้ววันที่ 2) | ใช่ |

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

## 📊 2. อ่าน Report และแก้ไข

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

## 📦 3. Snyk — สแกน Dependency

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

## 🕷️ 4. OWASP ZAP — Dynamic Scan เว็บแอป

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

## 🛰️ 5. Nessus — สแกน Infrastructure/Host

Nessus ตรวจระดับ **เครื่อง/เซิร์ฟเวอร์**: พอร์ตที่เปิด, บริการที่ล้าสมัย, config ที่ไม่ปลอดภัย

### 📥 ติดตั้ง Nessus Essentials (ฟรี, สูงสุด 16 IP)
1. ขอ Activation Code ที่ <https://www.tenable.com/products/nessus/nessus-essentials>
2. รันผ่าน Docker:
   ```bash
   docker run -d --name nessus -p 8834:8834 tenable/nessus:latest-ubuntu
   ```
3. เปิด <https://localhost:8834> (ยอมรับ certificate) → เลือก *Nessus Essentials* → ใส่ Activation Code
4. รอดาวน์โหลด plugin (อาจใช้ 15–30 นาที — **ควรทำตั้งแต่ช่วงเช้า**)

### 🔎 สแกน
- New Scan → **Basic Network Scan**
- Target: **IP Host-only ของ VM** ที่สร้างในวันที่ 1 (เช่น `192.168.56.101`) — เป็นเครื่องของเราเอง สแกนได้อย่างปลอดภัย
- ดูผลตาม Severity: Critical → High → Medium

### 🧪 Lab: เห็นผลต่างก่อน/หลัง
1. บน VM รัน `hello-compose` จากวันที่ 1 (ซึ่ง **เปิดพอร์ต Postgres 5432 ออกมา**) แล้วสแกนรอบที่ 1
2. ให้ Claude ช่วยแก้ compose ให้ Postgres ไม่ publish port และปิดบริการที่ไม่จำเป็น แล้วสแกนรอบที่ 2
3. เปรียบเทียบ: พอร์ต/finding ไหนหายไป — นี่คือหลัก *ลด attack surface* ที่จะใช้ตอน deploy วันที่ 5

> ⚠️ ข้อควรรู้: พอร์ตที่ Docker publish (`ports:`) **ข้าม firewall `ufw`** ของ Ubuntu ได้ การปิดพอร์ตจึงต้องทำที่ compose ด้วย ไม่ใช่แค่ที่ firewall

### 🤖 ให้ Claude ช่วยตีความ
```
นี่คือ finding จาก Nessus (export เป็น CSV): <วาง>
สรุปเป็นภาษาไทย: ความเสี่ยงคืออะไร, เกี่ยวกับแอปเราหรือเป็นของ OS/เครื่อง, วิธีแก้
```

---

## 🧅 สรุป: 3 ชั้นของการสแกน

| ชั้น | เครื่องมือ | หาอะไร | เมื่อไหร่ |
|---|---|---|---|
| Code/Dependency | Snyk, npm audit | package มีช่องโหว่, โค้ดไม่ปลอดภัย | ทุก commit (CI) |
| Running App | OWASP ZAP | header, XSS, cookie, misconfig ของเว็บ | ทุก deploy (CI) |
| Host/Network | Nessus | พอร์ต, บริการ, OS patch | ก่อนขึ้น production + ตามรอบ |

## ✅ Checklist ท้ายวัน

- [ ] Unit + Integration test ผ่านทั้งหมด, branch coverage ≥ 70%
- [ ] `snyk test` ไม่มี High/Critical ที่แก้ได้ค้างอยู่
- [ ] ZAP baseline ไม่มี FAIL และมีรายงาน `zap-report.html`
- [ ] Nessus สแกน VM ได้ 2 รอบ (ก่อน/หลังปิดพอร์ต) และเห็นความต่าง
- [ ] บันทึกสิ่งที่แก้ไว้ใน `docs/security-notes.md`
- [ ] Commit และ Push แล้ว (อย่า commit ไฟล์ report ที่มีข้อมูลเครื่อง — ใส่ใน `.gitignore`)

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "Framework & Library" และ "Security"

---

<p align="center"><a href="../day-2-scaffold/README.md">⬅️ 🏗️ วันที่ 2</a> · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../day-4-cicd-sprint/README.md">🚀 วันที่ 4 ➡️</a></p>
