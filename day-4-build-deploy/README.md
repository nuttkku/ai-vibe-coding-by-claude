# 🚀 วันที่ 4 — RBAC + Test + Security + Deploy + Sprint + CI/CD

## 🎯 เป้าหมายของวัน

- 👮 เพิ่ม **RBAC**: บทบาท admin / user ตรวจสิทธิ์ที่ backend ทุก endpoint และผู้ใช้แก้ได้เฉพาะข้อมูลของตัวเอง
- 🎨 ทำ Svelte UI (เริ่มวันที่ 2) ให้ CRUD ได้ครบ ร่วมกับระบบ Login + 2FA (วันที่ 3)
- 🧪 ให้ Claude เขียน Unit + Integration Test อ่าน Coverage แล้วสั่งแก้
- 🛡️ สแกนความปลอดภัย 3 ระดับ: **Snyk** (dependency) → **OWASP ZAP** (เว็บแอป) → **Nessus** (VM)
- 🌍 **Deploy แอปขึ้น VM** และได้ URL HTTPS ผ่าน Cloudflare Tunnel
- 🏃 Sprint ปิด Must have + Polish แล้วอัปเดตขึ้น Server
- ⚙️ ปิดท้ายด้วย **CI/CD**: GitHub Actions รัน test + security scan แล้ว build/push image อัตโนมัติ
- 🎤 เตรียมสไลด์และซ้อมนำเสนอสำหรับ **Demo Day (วันที่ 5 — นำเสนอทั้งวัน ไม่มีการสอน)**

> ⚠️ **จริยธรรมและกฎหมาย:** สแกนเฉพาะแอปและเครื่องของตัวเอง หรือที่ได้รับอนุญาตเป็นลายลักษณ์อักษรเท่านั้น
> การสแกนระบบของผู้อื่นโดยไม่ได้รับอนุญาตอาจผิด พ.ร.บ.คอมพิวเตอร์ฯ

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–09:10 | 📥 เริ่มติดตั้ง Nessus ทิ้งไว้ (โหลด plugin 15–30 นาที) |
| 09:10–10:00 | 👮 RBAC — ให้ Claude เรียนจาก repo ตัวอย่างแล้ว implement |
| 10:00–10:30 | 🎨 ทำ UI ให้เสร็จ + 🖐️ Smoke test |
| 10:30–11:15 | 🧪 Unit + Integration Test (รวม auth + RBAC) + อ่าน Coverage |
| 11:15–11:40 | 📦 Snyk: สแกน Dependency |
| 11:40–12:00 | 🕷️ OWASP ZAP: Baseline Scan |
| 13:00–13:30 | 🛰️ Nessus: สแกน VM ก่อน/หลังปิดพอร์ต |
| 13:30–14:15 | 🌍 Deploy ขึ้น VM + Cloudflare Tunnel (ทางลัด: clone + build บน VM) |
| 14:15–15:00 | 🏃 Sprint: ปิดฟีเจอร์ + Polish + แก้บั๊ก → Backup + อัปเดตแอปบน Server → **Code freeze 15:00** |
| 15:00–15:15 | 📜 **ที่มาที่ไปของ CI/CD** (History of CI/CD) |
| 15:15–16:00 | ⚙️ **CI/CD ด้วย GitHub Actions**: Test → Snyk → Build → Push Image |
| 🌙 การบ้าน | 🎤 เตรียมสไลด์ + ซ้อมนำเสนอสำหรับ Demo Day · ⭐ เสริม: Playwright E2E |

> 💡 วันนี้แน่นที่สุด — ใครที่ UI หรือ Login/2FA ยังไม่เสร็จ ให้ **ตัด scope** ตั้งแต่เช้า — RBAC ทำแค่ส่วน backend ก่อนได้ (Demo แอปเล็กที่ใช้งานได้จริงดีกว่าแอปใหญ่ที่พัง)

---

## 📥 0. เริ่มติดตั้ง Nessus ไว้ก่อน

Nessus ต้องโหลด plugin นาน — ทำ **ขั้นที่ 1–3 ของ [ข้อ 8](#️-8-nessus--สแกน-infrastructurehost)** แล้วปล่อยทิ้งไว้ — บ่ายจะโหลดเสร็จพอดี

---

## 👮 1. RBAC — กำหนดสิทธิ์ตามบทบาท (09:10–10:00)

**RBAC (Role-Based Access Control)** = ผู้ใช้แต่ละคนมี **บทบาท (role)** เช่น `admin`, `user` และแต่ละบทบาททำได้เฉพาะ **สิทธิ์ (permission)** ที่กำหนด — เช่น ผู้ใช้ทั่วไปจองห้องได้ แต่เฉพาะ admin เพิ่ม/ลบห้องได้

> 📦 ใช้ repo ตัวอย่างเดิม [2FA-example-coding](https://github.com/nuttkku/2FA-example-coding) (clone ไว้ที่ `~/2fa-example` แล้วตอนทำ 2FA วันที่ 3) — มี RBAC 3 บทบาท (`admin`, `manager`, `user`) พร้อมหน้าจัดการผู้ใช้

### 🧠 หลักการ

```
ผู้ใช้ ──► role (เก็บใน DB) ──► permission map กลาง ──► middleware ตรวจทุก request ฝั่ง backend
                                 'rooms:write': ['admin']            ผ่าน → ทำงาน · ไม่ผ่าน → 403
```

| เรื่อง | ทำแบบนี้ ✅ | ห้ามทำ ❌ |
|---|---|---|
| ตรวจสิทธิ์ที่ไหน | **backend ทุก endpoint** — frontend ซ่อนปุ่มได้แค่เพื่อความสะดวก | ซ่อนปุ่มใน Svelte แล้วคิดว่าปลอดภัย (ยิง API ตรงได้) |
| role มาจากไหน | อ่านจาก DB/session ฝั่ง server | เชื่อ role ที่ frontend ส่งมา |
| ค่าเริ่มต้น | **ปฏิเสธไว้ก่อน** — permission ที่ไม่มีในแผนที่ = ไม่อนุญาต · สมัครใหม่ได้ role ต่ำสุด | สมัครแล้วเลือก role เองได้ |
| เป็นเจ้าของข้อมูล | ผู้ใช้ทั่วไปแก้/ลบได้เฉพาะ **ข้อมูลของตัวเอง** (ตรวจ `owner_id`) | ใครก็แก้ `/api/bookings/15` ได้ถ้ารู้เลข id (ช่องโหว่ IDOR) |
| admin คนแรก | สร้างจาก seed / env / สั่งผ่าน DB | หน้าเว็บให้ใครก็ได้ตั้งตัวเองเป็น admin |
| เปลี่ยน role | เฉพาะ admin + บันทึก audit log | แก้ role แล้วไม่มีร่องรอย |

### 💬 Prompt: เรียนแล้ววางแผน (Plan mode)

```
อ่านโปรเจกต์ตัวอย่างใน ~/2fa-example เฉพาะส่วน RBAC:
- README หัวข้อ "RBAC ทำงานอย่างไร"
- backend/src/config/permissions.js, backend/src/middleware/rbac.middleware.js, backend/src/routes/admin.routes.js
- คอลัมน์ role ใน backend/src/db/migrations/001_init.sql
- frontend/src/lib/guards.js และ frontend/src/pages/AdminUsers.svelte

แล้ววางแผนเพิ่ม RBAC ให้แอปของฉัน (ยังไม่ต้องแก้โค้ด):
- 2 บทบาท: admin และ user (สมัครใหม่ได้ user เสมอ) — เพิ่มผ่าน migration ใหม่
- permission map กลางไฟล์เดียว แบบตัวอย่าง ครอบคลุม resource หลักของแอปฉัน (ดู docs/app-idea.md)
- user แก้/ลบได้เฉพาะข้อมูลของตัวเอง (ตรวจเจ้าของ) · admin จัดการได้ทั้งหมด
- หน้า admin ง่ายๆ: รายชื่อผู้ใช้ + เปลี่ยน role
- สร้าง admin คนแรกจาก seed ที่อ่านอีเมลจาก env (ห้าม seed ตอน NODE_ENV=production)
- frontend ซ่อนเมนูตาม role แต่ backend ต้องตรวจทุก endpoint
ไม่ต้องทำ manager, SSO หรือ audit log เต็มรูปแบบ บอกว่าส่วนไหนเอามาจากตัวอย่าง ส่วนไหนปรับ
```

**ก่อนอนุมัติแผน ตรวจว่า:** ตรวจสิทธิ์ที่ backend ทุก endpoint · ค่าเริ่มต้นคือปฏิเสธ · มีการตรวจความเป็นเจ้าของข้อมูล · ผู้ใช้เลือก role เองไม่ได้

### 🧪 ทดสอบเอง

1. สมัครบัญชีใหม่ → ต้องเป็น `user` → ไม่เห็นเมนู admin
2. **ลองยิง API admin ตรงๆ** ด้วยบัญชี user (DevTools → Console: `fetch('/api/admin/users').then(r => r.status)`) → ต้องได้ **403** ไม่ใช่ 200
3. ด้วยบัญชี user A ลองแก้ข้อมูลของ user B โดยเปลี่ยน id ใน request → ต้องถูกปฏิเสธ
4. ล็อกอินเป็น admin (จาก seed) → เปลี่ยน role ของ user คนหนึ่งเป็น admin → ล็อกอินบัญชีนั้นใหม่ → เห็นเมนู admin
5. เปิด DataGrip/DBeaver ดูคอลัมน์ `role` ในตาราง `users`
6. Commit + Push → `/security-review`

> 💡 **เวลาไม่พอ?** ทำแค่ข้อ 1–3 (backend ตรวจสิทธิ์ + ตรวจเจ้าของ) ให้ผ่านก่อน — หน้า admin ทำต่อใน Sprint บ่ายนี้ได้

---

## 🔁 2. ทำ UI ให้เสร็จ + ทดสอบระบบแบบ End-to-End

> 🎨 ทำ UI ที่เริ่มไว้วันที่ 2 ให้ CRUD ได้ครบก่อน (รวมหน้าที่ต้องล็อกอิน และเมนูตาม role จากวันที่ 3) — Prompt อยู่ใน [วันที่ 2 ข้อ 9](../day-2-bootcamp/README.md#-9-lab-svelte-ui-เชื่อม-api)

### 🖐️ ทดสอบด้วยมือ (Smoke test)
1. `docker compose down -v && docker compose up -d --build` (เริ่มจากศูนย์)
2. เปิดหน้าเว็บ → เพิ่ม → แก้ไข → ลบ → รีเฟรช ข้อมูลยังอยู่ถูกต้อง
3. `docker compose restart backend` แล้วลองใหม่ (ข้อมูลต้องยังอยู่)

### 🎭 ⭐ เสริม: ให้ Claude สร้าง E2E Test อัตโนมัติ (Playwright) — ถ้ามีเวลาหรือเป็นการบ้าน
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
| E2E | ผู้ใช้คลิกบนเบราว์เซอร์ | Playwright (เสริมในข้อ 2) | ใช่ |

### 💬 Prompt: วางแผนก่อนเขียน

```
อ่านโค้ดใน backend/ แล้วเสนอแผน test (ยังไม่ต้องเขียน):
- รายการ unit test ของฟังก์ชัน validation และ business logic
- รายการ integration test ของ auth: สมัคร, ยืนยันอีเมล (token หมดอายุ/ใช้ซ้ำ), ล็อกอินผิด/ถูก, rate limit, MFA (รหัสผิด, recovery code ใช้ซ้ำ, เข้า API ตอนยัง mfa_pending)
- รายการ integration test ของ RBAC: user เรียก API ของ admin ได้ 403, user แก้ข้อมูลของคนอื่นไม่ได้, admin ทำได้
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

## 🛰️ 8. Nessus — สแกน Infrastructure/Host

Nessus ตรวจระดับ **เครื่อง/เซิร์ฟเวอร์**: พอร์ตที่เปิด, บริการที่ล้าสมัย, config ที่ไม่ปลอดภัย

### 📥 ติดตั้ง Nessus Essentials (ฟรี, สูงสุด 16 IP)
1. ขอ Activation Code ที่ <https://www.tenable.com/products/nessus/nessus-essentials>
2. รันผ่าน Docker:
   ```bash
   docker run -d --name nessus -p 8834:8834 tenable/nessus:latest-ubuntu
   ```
3. เปิด <https://localhost:8834> (ยอมรับ certificate) → เลือก *Nessus Essentials* → ใส่ Activation Code
4. รอดาวน์โหลด plugin (อาจใช้ 15–30 นาที — **เริ่มไว้ตั้งแต่ต้นวัน** ตามข้อ 0)

### 🔎 สแกน
- New Scan → **Basic Network Scan**
- Target: **IP Host-only ของ VM** ที่สร้างวันที่ 3 (เช่น `192.168.56.101`) — เป็นเครื่องของเราเอง สแกนได้อย่างปลอดภัย
- ดูผลตาม Severity: Critical → High → Medium

### 🧪 Lab: เห็นผลต่างก่อน/หลัง
1. บน VM มี `hello-compose` จากวันที่ 3 อยู่แล้ว (ซึ่ง **เปิดพอร์ต Postgres 5432 ออกมา**) — `cd ~/hello-compose && docker compose up -d` แล้วสแกนรอบที่ 1
2. ให้ Claude ช่วยแก้ compose ให้ Postgres ไม่ publish port และปิดบริการที่ไม่จำเป็น แล้วสแกนรอบที่ 2
3. เปรียบเทียบ: พอร์ต/finding ไหนหายไป — นี่คือหลัก *ลด attack surface* ที่จะใช้ตอน deploy ในข้อ 9

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

---

## 🌍 9. Deploy ขึ้น Server จริง

### 🧭 ทางเลือก — ไม่มีโดเมนก็ได้ URL

| ทางเลือก | ต้องมีอะไร | URL ที่ได้ | เหมาะกับ |
|---|---|---|---|
| **A. VirtualBox VM + Cloudflare Quick Tunnel** (ค่าเริ่มต้นของหลักสูตร) | VM จากวันที่ 3 เท่านั้น — **ไม่ต้องมีโดเมน ไม่ต้องสมัคร Cloudflare** | `https://<สุ่ม>.trycloudflare.com` (เปลี่ยนทุกครั้งที่รีสตาร์ท) | Demo ในห้อง, ทดสอบ |
| B. VM/VPS + Cloudflare Named Tunnel | บัญชี Cloudflare ฟรี + โดเมนที่ใช้ DNS ของ Cloudflare | `https://app.<โดเมนคุณ>` (คงที่) | ใช้ต่อหลังจบหลักสูตร |
| C. VPS สาธารณะ + โดเมน + Caddy | VPS ที่มี Public IP + โดเมน | `https://<โดเมนคุณ>` | Production แบบดั้งเดิม |

**ทำไม Tunnel ถึงไม่ต้องเปิดพอร์ต:** `cloudflared` บน VM เป็นฝ่าย *เชื่อมต่อออกไป* หา Cloudflare เอง แล้ว Cloudflare ส่ง request กลับเข้ามาทางท่อนั้น VM อยู่หลัง NAT ของ VirtualBox หรือ Wi-Fi ห้องอบรมก็ใช้ได้ และ HTTPS จัดการให้โดย Cloudflare

```
ผู้ใช้ ──HTTPS──► Cloudflare ◄══ท่อขาออก══ cloudflared ─► caddy ─┬─► frontend
                                          (ใน VM)               └─► backend ─► db
```

> ⚠️ Quick Tunnel ออกแบบมาสำหรับ **ทดสอบ/Demo** ไม่มีการรับประกัน uptime และจำกัดจำนวน request พร้อมกัน — ถ้าจะใช้งานจริงต่อ ให้ย้ายไปทางเลือก B

ไฟล์ตัวอย่าง: [`docker-compose.prod.yml`](examples/docker-compose.prod.yml), [`Caddyfile`](examples/Caddyfile), [`.env.example`](examples/.env.example), [`docker-compose.domain.yml`](examples/docker-compose.domain.yml) (เฉพาะทางเลือก C)

### ⚡ ทางลัด (แนะนำในหลักสูตร): clone แล้ว build บน VM

ไม่ต้องรอ CI — ใช้ `docker-compose.yml` ของโปรเจกต์ตัวเอง + Quick Tunnel แบบที่ลองกับ hello-compose เมื่อวาน (วันที่ 3)

```bash
# บน VM
git clone https://github.com/<user>/<repo>.git ~/app && cd ~/app
cp .env.example .env && nano .env        # ตั้งรหัสผ่าน DB ใหม่ที่ยาวและสุ่ม
docker compose up -d --build
docker compose ps                        # ต้องขึ้นครบทุก service
curl -I http://localhost:<frontend-port>

docker rm -f tunnel 2>/dev/null          # ปิด tunnel ของ hello-compose ถ้ายังเปิดอยู่
docker run -d --name tunnel --network host cloudflare/cloudflared:latest \
  tunnel --no-autoupdate --url http://localhost:<frontend-port>
docker logs tunnel 2>&1 | grep trycloudflare.com
```

- 🔒 **repo เป็น Private?** ต้องล็อกอิน GitHub บน VM ก่อน: สร้าง Personal Access Token (สิทธิ์อ่าน repo) แล้วใช้แทนรหัสผ่านตอน `git clone` — หรือตั้ง repo เป็น Public ชั่วคราวถ้าไม่มีความลับในโค้ด
- 🔄 **อัปเดตหลัง Sprint:** `cd ~/app && git pull && docker compose up -d --build` — **ไม่ต้องแตะ tunnel** URL จึงไม่เปลี่ยน
- 🚫 **เปิดผ่าน URL แล้วขึ้น "Blocked request. This host is not allowed"** = frontend เป็น Vite dev server ที่ไม่ยอมรับ host แปลกหน้า → ให้ Claude แก้:
  ```
  frontend ของฉันเปิดผ่าน cloudflare quick tunnel แล้วขึ้น "Blocked request. This host is not allowed"
  ช่วยแก้ vite.config ให้อนุญาต host *.trycloudflare.com (server.allowedHosts) โดยไม่เปิดกว้างเกินจำเป็น
  ```
- 🛡️ ตรวจว่า `docker-compose.yml` ของโปรเจกต์ **ไม่ publish พอร์ต DB** (`5432`) — สแกน Nessus ซ้ำหลัง deploy ต้องไม่เห็นพอร์ตนี้

ทางด้านล่าง (**ทางเต็ม**) ใช้ image ที่ CI build ไว้ใน GHCR + Caddy เป็น reverse proxy — ใช้เมื่อตั้ง GitHub Actions ([ข้อ 12](#️-12-cicd-ด้วย-github-actions-15001600)) สำเร็จแล้ว

### 🅰️ ทางเต็ม A: image จาก CI + Caddy + Cloudflare Quick Tunnel

1. **เปิด VM** จากวันที่ 3 แล้ว SSH เข้า (`ssh <user>@192.168.56.101`) — ถ้า VM พัง ย้อน Snapshot `clean-docker`
2. **คัดลอกไฟล์** ขึ้น VM:
   ```bash
   ssh <user>@192.168.56.101 "mkdir -p ~/app"
   scp docker-compose.prod.yml Caddyfile .env.example backup.sh restore.sh <user>@192.168.56.101:~/app/
   ```
3. **ตั้งค่า** บน VM: `cd ~/app && cp .env.example .env && nano .env` (ใส่ `IMAGE_PREFIX` และรหัสผ่าน DB)
4. **ล็อกอิน GHCR** (ถ้า image เป็น private): สร้าง Personal Access Token สิทธิ์ `read:packages` แล้ว
   ```bash
   echo <TOKEN> | docker login ghcr.io -u <github-user> --password-stdin
   ```
5. **รัน:**
   ```bash
   docker compose -f docker-compose.prod.yml --profile quick pull
   docker compose -f docker-compose.prod.yml --profile quick up -d
   ```
6. **เอา URL:**
   ```bash
   docker compose -f docker-compose.prod.yml logs tunnel-quick | grep trycloudflare.com
   ```
   เปิด `https://<สุ่ม>.trycloudflare.com` จากมือถือ (ปิด Wi-Fi ใช้ 4G) เพื่อยืนยันว่าเข้าจากภายนอกได้ 🎉

   ตาราง DB ถูกสร้างอัตโนมัติ เพราะ container backend รัน `npm run migrate up` ก่อน start (ตั้งไว้ตั้งแต่ Scaffold วันที่ 3) — ตรวจได้ด้วย
   `docker compose -f docker-compose.prod.yml logs backend | head -20`

> ⚠️ URL ของ Quick Tunnel จะเปลี่ยนเมื่อ container `tunnel-quick` รีสตาร์ท — **อย่ารีสตาร์ทหลังส่ง URL ให้ผู้ชม Demo แล้ว** อัปเดตแอปด้วย `docker compose ... up -d frontend backend` แทน

### 🅱️ ทางเลือก B: Named Tunnel (มีโดเมน, URL คงที่)
1. เพิ่มโดเมนเข้า Cloudflare (เปลี่ยน nameserver ตามที่ Cloudflare บอก)
2. Cloudflare Dashboard → **Zero Trust → Networks → Tunnels → Create a tunnel** (ชนิด Cloudflared) → คัดลอก **token**
3. ตั้ง **Public Hostname** เช่น `app.example.com` → Service `http://caddy:80`
4. บน VM: ใส่ `TUNNEL_TOKEN=<token>` ใน `.env` แล้ว
   ```bash
   docker compose -f docker-compose.prod.yml --profile named up -d
   ```

### 🌐 ทางเลือก C: VPS สาธารณะ + โดเมน + Caddy
1. ตั้ง A record ของโดเมน → Public IP ของ VPS, เปิด firewall 22/80/443
2. ใส่ `SITE_ADDRESS=<โดเมน>` ใน `.env` (Caddy จะขอใบรับรอง Let's Encrypt ให้เอง)
3. `docker compose -f docker-compose.prod.yml -f docker-compose.domain.yml up -d`

### 💾 อัปเดตเวอร์ชันใหม่ + Backup ก่อนทุกครั้ง

เมื่อ CI push image ใหม่ (อาจมี migration ใหม่ที่เปลี่ยน schema) ให้ **backup ก่อนเสมอ**:

```bash
cd ~/app
bash backup.sh                                                  # ได้ไฟล์ใน backups/
docker compose -f docker-compose.prod.yml pull frontend backend
docker compose -f docker-compose.prod.yml up -d frontend backend   # backend รัน migration ใหม่ตอน start
```

ถ้า migration ใหม่ทำข้อมูลพัง ย้อนกลับด้วย:
```bash
bash restore.sh backups/<ไฟล์ล่าสุดก่อนอัปเดต>.dump
```

ไฟล์: [`backup.sh`](examples/backup.sh) (เก็บ 7 ไฟล์ล่าสุด, ตั้ง cron รายวันได้), [`restore.sh`](examples/restore.sh) (ถามยืนยันก่อนเขียนทับ)

> 💡 **ก่อน Demo:** รัน `bash backup.sh` 1 ครั้ง และลอง `restore.sh` กับไฟล์นั้นให้แน่ใจว่าใช้ได้ — backup ที่ไม่เคยลอง restore ถือว่ายังไม่มี backup
> ไฟล์ backup อยู่บน VM เครื่องเดียวกัน — ถ้าจะใช้งานจริงต่อ ให้คัดลอกออกไปเก็บที่อื่นด้วย (`scp` กลับมาเครื่องตัวเอง)

### 🤖 ให้ Claude ช่วย Deploy
```
ช่วยเตรียม deploy โปรเจกต์นี้ขึ้น VirtualBox VM (Ubuntu Server, มี Docker แล้ว)
และเปิดออกอินเทอร์เน็ตด้วย Cloudflare Quick Tunnel โดยใช้ day-4 examples เป็นต้นแบบ:
- ปรับพอร์ต backend/frontend ใน Caddyfile ให้ตรงกับ Dockerfile จริง
- สร้าง scripts/deploy.sh ที่ scp ไฟล์ขึ้น VM, pull image ล่าสุด, up -d และพิมพ์ URL trycloudflare ออกมา
- อัปเดต frontend/backend โดยไม่รีสตาร์ท tunnel (URL ต้องไม่เปลี่ยน)
ห้ามใส่ความลับใดๆ ลงไฟล์ที่ commit
```

> ⚠️ **อย่าวางรหัสผ่าน SSH หรือ Tunnel token ลงใน Prompt** — ใช้ SSH key และอนุญาตคำสั่งทีละคำสั่ง

### 🔁 (เสริม) Deploy อัตโนมัติจาก CI
VM ใน VirtualBox อยู่หลัง NAT ทำให้ GitHub Actions SSH เข้ามาไม่ได้ ทางออกที่ง่าย: ตั้ง cron บน VM ให้รัน `docker compose -f docker-compose.prod.yml pull frontend backend && docker compose -f docker-compose.prod.yml up -d frontend backend` ทุก 5 นาที เพื่อดึง image ใหม่จาก GHCR เอง (ให้ Claude ช่วยเขียน crontab)
(ทางเลือก C ใช้ job SSH จาก CI ได้ตรงๆ โดยเก็บ SSH key ใน GitHub Secrets)

### 🔎 สแกน Production
- **ZAP baseline** กับ URL ของ Tunnel (ของตัวเองเท่านั้น) — Cloudflare อาจ rate-limit ถ้าสแกนหนัก ใช้ baseline ไม่ใช่ full scan
- **Nessus Basic Network Scan** กับ IP Host-only ของ VM — ควรเห็นเฉพาะพอร์ต **22** เปิด (Caddy bind แค่ `127.0.0.1`, Postgres ไม่ publish) เทียบกับผลสแกนในข้อ 8

---

## 🏃 10. Sprint — ปิดฟีเจอร์ + Polish + แก้บั๊ก

**เป้าหมาย:** ฟีเจอร์ "Must have" จาก `docs/app-idea.md` ทำงานได้ครบวงจร พร้อม Demo — **Code freeze 15:00** หลังจากนี้ไม่เพิ่มฟีเจอร์ใหม่

**ลำดับความสำคัญ** (ทำจากบนลงล่าง หมดเวลาตรงไหนหยุดตรงนั้น):
1. 🔴 Must have ที่ยังไม่เสร็จ
2. 🐞 บั๊กที่จะทำให้ Demo พัง
3. 💅 Polish UI (responsive, empty/loading/error state)
4. 🟡 Should have — ถ้ามีเวลาเหลือจริงๆ เท่านั้น

### 🔄 วิธีทำงานแบบ Sprint กับ Claude

1. **วางแผน (Plan mode)** — ให้ Claude เสนอแผนก่อน ยังไม่แก้โค้ด
   ```
   อ่าน docs/app-idea.md หัวข้อ Must have
   วางแผน Sprint (45 นาที) เป็น task ย่อยที่แต่ละ task commit ได้เอง เรียงตามลำดับความสำคัญ
   ระบุไฟล์ที่ต้องแก้, migration DB, endpoint, หน้าจอ, และ test ของแต่ละ task
   ```
2. **ทำทีละ task** → รัน test → commit → `/clear` ก่อนเริ่ม task ถัดไป (ประหยัดโควต้า — ดู [guides/claude-code-efficiency.md](../guides/claude-code-efficiency.md))
   ```
   ทำ task 1: <ชื่อ task> ตามแผน เขียน test ด้วย รันให้ผ่านแล้วสรุปสิ่งที่เปลี่ยน
   ```
3. **Review เอง** ด้วย `git diff` ก่อน commit ทุกครั้ง — ถ้า task เปลี่ยน schema ต้องเห็น **ไฟล์ migration ใหม่** ใน diff (ไม่ใช่การแก้ไฟล์เดิม)
4. **Push** → ดู Pipeline เขียว

### 🌿 แนวทาง Feature Branch (แนะนำ)
```bash
git switch -c feat/booking-create
# ... ทำงาน ...
git push -u origin feat/booking-create
```
แล้วเปิด Pull Request → CI รัน → Merge เมื่อเขียว

### 💅 Polish UI
```
ปรับ UI ทั้งแอปให้:
- responsive บนมือถือ (กว้าง 375px ต้องใช้งานได้)
- มี empty state, loading state, error state ทุกหน้า
- ปุ่มและฟอร์มเข้าถึงได้ด้วยคีย์บอร์ด มี label ครบ
- ใช้สีและระยะห่างให้สม่ำเสมอ (สร้าง CSS variables กลาง)
ไม่ต้องเพิ่ม UI library ใหม่
```

### 🐞 แก้ Bug อย่างเป็นระบบ
1. เขียนขั้นตอนทำให้เกิดบั๊ก (Reproduce steps)
2. ให้ Claude **เขียน test ที่ fail ก่อน** แล้วค่อยแก้ให้ test ผ่าน
   ```
   บั๊ก: <อธิบาย> ขั้นตอน: 1... 2... 3...
   เขียน test ที่ reproduce บั๊กนี้ (ต้อง fail) แล้วแก้โค้ดให้ผ่าน
   ```

### 🏁 ตรวจก่อน Code freeze (14:45)

```
ตรวจทั้งโปรเจกต์เพื่อเตรียม demo:
1. รายการฟีเจอร์ใน docs/app-idea.md ที่ยังไม่เสร็จ — อะไรควรตัดทิ้ง
2. จุดที่น่าจะพังระหว่าง demo (input แปลก, ข้อมูลว่าง, network ช้า)
3. ข้อความ error / UI ที่ยังดูไม่เรียบร้อย
เรียงตามผลกระทบต่อ demo แล้วแก้ทีละข้อพร้อม commit
```

### 🧑‍🏫 Coach รายบุคคล — คำถามที่วิทยากรใช้ถาม (ตลอดช่วง Sprint)

- ตอนนี้ติดอะไรอยู่? ลองให้ Claude ทำไปแล้วกี่รอบ? Prompt ล่าสุดคืออะไร?
- `CLAUDE.md` ของคุณมีกฎที่ช่วยเรื่องนี้หรือยัง?
- Scope ยังพอดีกับเวลาที่เหลือไหม? อะไรตัดได้?
- โควต้า Claude เหลือเท่าไหร่? ถ้าใกล้หมด ใช้ Plan B ในคู่มือโควต้า (จับคู่, เตรียม Prompt ไว้ก่อน, ทำงานที่ไม่ต้องใช้ AI)
- Pipeline เขียวหรือยัง? ถ้าแดง แดงที่ job ไหน?

---

## 🎤 11. อัปเดต Server + เตรียมนำเสนอ (การบ้าน)

### 🔄 อัปเดตแอปบน Server (ท้าย Sprint ก่อน 15:00)
1. Push งาน Sprint ขึ้น GitHub
2. **Backup ก่อนอัปเดต** — ทางลัด: `cd ~/app && docker compose exec -T db pg_dump -U app -d appdb --format=custom > ~/backup-$(date +%H%M).dump` (ปรับชื่อ user/db ให้ตรง `.env`) · ทางเต็ม: `bash backup.sh`
3. อัปเดต — ทางลัด: `git pull && docker compose up -d --build` · ทางเต็ม: `pull` + `up -d frontend backend` (ดู [ข้อ 9](#-9-deploy-ขึ้น-server-จริง)) — **อย่ารีสตาร์ท tunnel** URL จะเปลี่ยน
4. เปิด URL จากมือถือ (4G) ไล่ flow หลักที่จะ Demo ให้ผ่านทั้งหมด

### 🎬 เตรียมสไลด์ + ซ้อม (🌙 การบ้านคืนนี้)
- กรอกแม่แบบ [`templates/demo-presentation.md`](../templates/demo-presentation.md) — ท้ายไฟล์มี **รูปแบบ 10 นาที, เกณฑ์ประเมิน, สิ่งที่ต้องเช็กเช้าวันนำเสนอ และแผนสำรอง** · ให้ Claude ช่วยร่างจาก `git log` และ `docs/app-idea.md` ได้:
  ```
  อ่าน docs/app-idea.md, README.md และ git log --oneline แล้วช่วยกรอก templates/demo-presentation.md
  สำหรับนำเสนอ 8 นาที เน้นปัญหา → Demo → เบื้องหลัง → Prompt ที่ได้ผล ภาษาไทย กระชับ
  ```
- เลือก **Prompt/Strategy ที่ได้ผลที่สุด 1–3 อัน** ไว้แชร์ (ใช้ `/export` ดึงบทสนทนาได้)
- ซ้อมกับเพื่อนข้างๆ 1 รอบ จับเวลา 8 นาที
- 📌 จด URL + ลิงก์ repo + ลิงก์ GitHub Actions run ล่าสุด ไว้ในสไลด์

> ⚠️ **คืนนี้:** เปิด VM ค้างไว้ หรือถ้าต้องปิดเครื่อง พรุ่งนี้เช้าต้องเปิด VM แล้วดู URL ใหม่จาก `logs tunnel-quick` (Quick Tunnel เปลี่ยน URL ทุกครั้งที่เริ่มใหม่)

---

## ⚙️ 12. CI/CD ด้วย GitHub Actions (15:00–16:00)

### 📜 ที่มาที่ไป (15:00–15:15)

> 📖 เนื้อหาเต็มพร้อมแหล่งอ้างอิง: **[History of CI/CD](../guides/cicd-history.md)**

**ปัญหาตั้งต้น — "Integration Hell":** สมัยก่อนแต่ละคนเขียนโค้ดแยกกันหลายสัปดาห์แล้วค่อยรวม → โค้ดชนกันเป็นร้อยจุด บั๊กเจอช้า release ปีละไม่กี่ครั้งและน่ากลัว

| ปี | ใคร | เสนออะไร |
|---|---|---|
| 1996 | Microsoft / Steve McConnell | **Daily Build and Smoke Test** — build ทั้งระบบทุกวัน + ทดสอบเบื้องต้น |
| ปลาย 1990s | Kent Beck (Extreme Programming) | **Continuous Integration** — รวมโค้ด + test อัตโนมัติ **หลายครั้งต่อวัน** |
| 2000 | Martin Fowler | บทความ "Continuous Integration" — แนวปฏิบัติ 11 ข้อ เช่น self-testing build, fix broken builds immediately |
| ~2001–2011 | CruiseControl → Hudson → Jenkins | เครื่องมือ CI server อัตโนมัติ |
| 2009 | Timothy Fitz (IMVU) · Allspaw & Hammond (Flickr) | **Continuous Deployment** วันละ 50 ครั้ง · **DevOps** — Dev กับ Ops ทำงานร่วมกัน |
| 2010 | Jez Humble & David Farley | หนังสือ **Continuous Delivery** — **Deployment Pipeline**, "If it hurts, do it more frequently" |
| 2013 | Docker | build ครั้งเดียวเป็น image รันเหมือนกันทุกที่ |
| 2018 | Accelerate / DORA | งานวิจัย: ทีมที่ deploy บ่อย **เสถียรกว่า** — วัดด้วย DORA metrics |
| 2019 | GitHub Actions | CI/CD อยู่ใน repo เป็นไฟล์ YAML — **ที่เราจะทำต่อจากนี้** |

**CI vs CD:** **CI** = รวมโค้ดบ่อย + build/test อัตโนมัติทุก push · **Continuous Delivery** = ผ่าน pipeline แล้ว **พร้อม release** (คนกดปุ่ม) · **Continuous Deployment** = ผ่านแล้ว **ขึ้นระบบจริงอัตโนมัติ**

🗣️ ถามห้อง: *"ทำไม deploy บ่อยขึ้น ระบบถึงพังน้อยลง?"* — แล้วเฉลยด้วยหลัก "งานเล็ก → พังเล็ก → หาสาเหตุง่าย → แก้เร็ว"

### ⚙️ ลงมือสร้าง Pipeline (15:15–16:00)

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
สร้าง .github/workflows/ci.yml สำหรับโปรเจกต์นี้ โดยใช้ day-4 examples/ci.yml เป็นต้นแบบ:
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

> ⏱️ **มีเวลา 1 ชั่วโมง:** ถ้า job `zap` ยังไม่ผ่าน ให้ปิด job นั้นไว้ก่อน (comment ออก) แล้วให้ `test` → `snyk` → `build-push` เขียวให้ได้ — ZAP สแกนด้วยมือไปแล้วในข้อ 7

### 🚚 CD: ส่งของขึ้น Server

- **CI** (Continuous Integration) = ทุก push ต้องผ่าน test + security scan อัตโนมัติ
- **CD** (Continuous Delivery/Deployment) = build image ที่ผ่าน CI แล้วส่งไปพร้อมใช้งาน — job `build-push` ส่ง image ขึ้น **GHCR** แล้ว
- VM ใน VirtualBox อยู่หลัง NAT → GitHub Actions SSH เข้ามาไม่ได้ → ใช้วิธีให้ VM **ดึง image ใหม่เอง** (cron) ตามหัวข้อ "Deploy อัตโนมัติจาก CI" ใน [ข้อ 9](#-9-deploy-ขึ้น-server-จริง) หรืออัปเดตด้วยมือแบบทางลัด

> 📦 **ดูตัวอย่างจริง:** repo [2FA-example-coding](https://github.com/nuttkku/2FA-example-coding) (จากวันที่ 3) มี `CI-CD.md` และ `.github/workflows/ci.yml` + `cd.yml` ที่ใช้ npm audit, **Semgrep**, **Trivy** (สแกน image), smoke test และ CD ที่ publish image เมื่อสร้าง tag `vX.Y.Z` — ให้ Claude อ่านเทียบกับ workflow ของเราได้:
> ```
> อ่าน ~/2fa-example/CI-CD.md และ .github/workflows/ แล้วเปรียบเทียบกับ .github/workflows/ci.yml ของฉัน
> เสนอว่าควรเพิ่มอะไร 1–2 อย่างที่คุ้มที่สุด (เช่น Trivy scan image) ยังไม่ต้องแก้
> ```

---

## ✅ Checklist ท้ายวัน (พร้อมสำหรับ Demo Day)

- [ ] 👮 บัญชี user เรียก API admin ได้ **403** และแก้ข้อมูลของคนอื่นไม่ได้ · admin เปลี่ยน role ได้
- [ ] 🎨 หน้าเว็บ CRUD ได้ครบ และข้อมูลอยู่รอดหลังรีสตาร์ท
- [ ] 🧪 Unit + Integration test ผ่านทั้งหมด (เป้า branch coverage ≥ 70%)
- [ ] 📦 `snyk test` ไม่มี High/Critical ที่แก้ได้ค้างอยู่ · 🕷️ ZAP baseline ไม่มี FAIL · บันทึกใน `docs/security-notes.md`
- [ ] 🛰️ Nessus สแกน VM ได้ 2 รอบ (ก่อน/หลังปิดพอร์ต) และเห็นความต่าง
- [ ] 🌍 แอปเข้าได้ที่ URL ของ Cloudflare Tunnel จากเครือข่ายภายนอก เช่น มือถือที่ใช้ 4G
- [ ] 🏃 ฟีเจอร์ Must have ใช้งานได้ครบ และ schema เปลี่ยนผ่าน migration ใหม่เท่านั้น
- [ ] 💾 Backup DB บน VM แล้วอย่างน้อย 1 ครั้ง · 🔒 Postgres ไม่เปิดพอร์ตออกภายนอก
- [ ] 📄 README ของโปรเจกต์มี URL, วิธีรัน, สถาปัตยกรรม
- [ ] ⚙️ `.github/workflows/ci.yml` รัน `test` → `snyk` → `build-push` เขียว และมี image ใน ghcr.io
- [ ] 🌙 (การบ้าน) สไลด์ Demo พร้อม และซ้อมจับเวลาแล้ว · ⭐ (เสริม) Playwright E2E ผ่าน

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
| Nessus ยังโหลด plugin ไม่เสร็จตอนบ่าย | สร้าง VM ต่อไปก่อน · ถ้าไม่ทันจริง ใช้ `nmap` สแกนพอร์ต VM ของตัวเองแทนชั่วคราว |
| Quick Tunnel URL เปลี่ยน | container `tunnel-quick` ถูกรีสตาร์ท — ดู URL ใหม่จาก `logs tunnel-quick` และอย่ารีสตาร์ทหลังส่ง URL ให้ผู้ชมแล้ว |
| เปิด URL แล้วขึ้น "Blocked request. This host is not allowed" | frontend เป็น Vite dev server — เพิ่ม `server.allowedHosts` ให้ `*.trycloudflare.com` (ดูข้อ 9 ทางลัด) |
| เปลี่ยน role แล้วยังใช้สิทธิ์เดิม | session เก็บ role ไว้ตอนล็อกอิน — ให้ล็อกอินใหม่ หรือให้ backend อ่าน role จาก DB ทุก request |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "Framework & Library", "Security" และ "CI/CD & Deploy"

---

<p align="center"><a href="../day-3-server-auth/README.md">⬅️ 🏗️ วันที่ 3</a> · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../templates/demo-presentation.md">🎤 วันที่ 5: Demo Day ➡️</a></p>
