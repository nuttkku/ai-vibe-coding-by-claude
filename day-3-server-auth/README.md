# 🏗️ วันที่ 3 — Server จำลอง + Cloudflare Tunnel + Login + 2FA + RBAC

## 🎯 เป้าหมายของวัน

- 🖥️ มี **Server จำลอง (VirtualBox VM, Ubuntu Server)** ที่ SSH เข้าได้และมี Docker
- ☁️ เปิดเว็บใน VM ให้คนภายนอกเข้าได้ด้วย **Cloudflare Quick Tunnel** (ไม่ต้องมีโดเมน) — **เสร็จก่อนเที่ยง**
- 📧 แอปของตัวเองมีระบบ **สมัคร → ยืนยันอีเมล → ล็อกอิน → ล็อกเอาต์** ที่ทำตามหลักความปลอดภัย
- 🔑 เพิ่ม **2FA แบบ TOTP** (แอป Authenticator) พร้อม backup codes — ให้ Claude เรียนจาก [repo ตัวอย่าง](https://github.com/nuttkku/2FA-example-coding) แล้วนำมาใส่ในแอป
- 👮 เพิ่ม **RBAC**: บทบาท admin / user ตรวจสิทธิ์ที่ backend ทุก endpoint และผู้ใช้แก้ได้เฉพาะข้อมูลของตัวเอง

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–10:30 | 🖥️ สร้าง VirtualBox VM + ติดตั้ง Docker บน VM + Snapshot |
| 10:30–12:00 | ☁️ Cloudflare Quick Tunnel กับ hello-compose บน VM → เปิดจากมือถือ (4G) ให้ได้ทุกคน |
| 13:00–14:15 | 📧 Login ผ่าน Email (สมัคร, ยืนยันอีเมลผ่าน Mailpit, ล็อกอิน, ล็อกเอาต์) |
| 14:15–15:15 | 🔑 2FA แบบ TOTP — ให้ Claude เรียนจาก repo ตัวอย่างแล้ว implement ในแอป |
| 15:15–16:00 | 👮 RBAC (admin / user + ตรวจความเป็นเจ้าของข้อมูล) — เรียนจาก repo ตัวอย่างเดิม |

> 💡 **ช่วงเช้าให้เวลาเต็ม 3 ชั่วโมงสำหรับ VM + Tunnel** — ใครติดตั้ง Ubuntu ไม่ผ่าน ให้จับคู่ใช้ VM ของเพื่อนทำ Tunnel ไปก่อน · ช่วงบ่ายทำในเครื่องตัวเอง (VM ใช้ต่อวันที่ 4)

---

## 🖥️ 1. สร้าง Server จำลองด้วย VirtualBox

ทำตามคู่มือ **[virtualbox-vm.md](virtualbox-vm.md)** — สร้าง VM Ubuntu Server, ตั้ง Network (NAT + Host-only), SSH เข้า, ติดตั้ง Docker ด้วย [`examples/vm-setup.sh`](examples/vm-setup.sh) แล้ว Take Snapshot

VM นี้คือ "Server จริง" ของเรา: วันนี้ใช้ลอง Cloudflare Tunnel (ข้อ 2) และวันที่ 4 เป็นเป้าสแกน Nessus และเครื่อง Deploy (เปิดออกเน็ตด้วย Cloudflare Tunnel โดยไม่ต้องมีโดเมน)

> 💡 ระหว่างรอ Ubuntu ติดตั้ง (~10–15 นาที) ให้อ่านข้อ 2 ล่วงหน้า หรือติดตั้ง DataGrip/DBeaver ที่ยังค้างจากวันที่ 2

---

## ☁️ 2. Cloudflare Tunnel — เปิดเว็บใน VM ให้คนภายนอกเข้าได้

ทดลองกับ `hello-compose` (วันที่ 2) ก่อน — วันที่ 4 จะใช้วิธีเดียวกันกับแอปจริง

### 🧠 ทำไมไม่ต้องมีโดเมนและไม่ต้องเปิดพอร์ต

`cloudflared` ใน VM เป็นฝ่าย **เชื่อมต่อออกไป** หา Cloudflare เอง แล้ว Cloudflare ส่ง request กลับเข้ามาทางท่อนั้น — VM จะอยู่หลัง NAT ของ VirtualBox หรือ Wi-Fi ห้องอบรมก็ใช้ได้ และได้ **HTTPS** ให้อัตโนมัติ

```
มือถือ/เพื่อน ──HTTPS──► Cloudflare ◄══ท่อขาออก══ cloudflared ──► hello-compose (web :8080)
                                              (ใน VM)
```

| แบบ | ต้องมี | URL ที่ได้ | ใช้เมื่อ |
|---|---|---|---|
| ⚡ **Quick Tunnel** (ใช้ในหลักสูตร) | ไม่ต้องมีอะไร — ไม่ต้องสมัคร ไม่ต้องมีโดเมน | `https://<สุ่ม>.trycloudflare.com` เปลี่ยนทุกครั้งที่เริ่มใหม่ | ทดสอบ, Demo |
| 🏷️ Named Tunnel | บัญชี Cloudflare + โดเมน | `https://app.<โดเมนคุณ>` คงที่ | ใช้งานต่อหลังจบหลักสูตร (ดูวันที่ 4) |

### ▶️ ขั้นตอน

1. **คัดลอก hello-compose ขึ้น VM** (รันบนเครื่องเรา ในโฟลเดอร์ repo หลักสูตร):
   ```bash
   scp -r day-2-bootcamp/examples/hello-compose <user>@192.168.56.101:~
   ```
2. **รันบน VM** (SSH เข้า VM ก่อน):
   ```bash
   cd ~/hello-compose
   cp .env.example .env
   docker compose up -d
   curl -I http://localhost:8080        # ต้องได้ HTTP/1.1 200 OK
   ```
3. **เปิด Quick Tunnel แบบรันเบื้องหลัง:**
   ```bash
   docker run -d --name tunnel --network host cloudflare/cloudflared:latest \
     tunnel --no-autoupdate --url http://localhost:8080
   docker logs tunnel 2>&1 | grep trycloudflare.com
   ```
   ได้ `https://<คำสุ่ม>.trycloudflare.com` → **เปิดจากมือถือ (ปิด Wi-Fi ใช้ 4G)** ต้องเห็นหน้า "Hello Vibe Coding" 🎉
4. **ทดลองแก้สด:** บน VM `nano ~/hello-compose/html/index.html` แก้ข้อความ → รีเฟรชบนมือถือ เห็นทันที (bind mount)
5. **ปิด tunnel:** `docker rm -f tunnel` → URL ใช้ไม่ได้ทันที · เปิดใหม่ด้วยข้อ 3 จะได้ **URL ใหม่**

> ⚠️ **ใครมี URL ก็เข้าได้** — อย่าเปิด tunnel ให้เว็บที่มีข้อมูลจริง, ปิดเมื่อไม่ใช้ · Quick Tunnel ออกแบบมาสำหรับ **ทดสอบ/Demo** ไม่มีการรับประกัน uptime และจำกัดจำนวน request พร้อมกัน
> 💡 firewall ของ VM (`ufw`) ยังเปิดแค่ SSH เหมือนเดิม — tunnel เป็นการเชื่อมต่อขาออก จึงไม่ต้องเปิดพอร์ตเพิ่ม

### 🤖 ให้ Claude ช่วย

```
ฉันรัน cloudflared quick tunnel บน Ubuntu VM ด้วย docker แล้ว URL เปิดไม่ได้ ขึ้น error นี้:
<วาง error / ผลจาก docker logs tunnel>
ผลจาก curl -I http://localhost:8080 บน VM คือ: <วางผล>
ช่วยไล่หาสาเหตุทีละขั้น
```

---

## 📧 3. Login ผ่าน Email (13:00–14:15)

เพิ่มระบบ **สมัครสมาชิก → ยืนยันอีเมล → ล็อกอิน → ล็อกเอาต์** ให้แอปของตัวเอง โดยให้ Claude เขียน แต่ **เราต้องรู้ว่าอะไรคือวิธีที่ปลอดภัย** เพราะระบบ login คือจุดที่ถูกโจมตีบ่อยที่สุด

> ⚠️ **กฎข้อแรกของ Auth:** อย่าให้ Claude "คิดวิธีเข้ารหัสเอง" — ให้ใช้ library ที่ได้รับการยอมรับเสมอ (ระบุใน Prompt)

### 🧠 ภาพรวม Flow

```
สมัคร ──► เก็บ email + password_hash ──► ส่งอีเมลลิงก์ยืนยัน (token สุ่ม มีวันหมดอายุ)
                                              │
ผู้ใช้คลิกลิงก์ ◄──────────────────────────────┘ ──► email_verified = true
ล็อกอิน ──► ตรวจรหัสผ่านกับ hash ──► สร้าง session ──► cookie (HttpOnly, SameSite)
ล็อกเอาต์ ──► ลบ session ฝั่ง server
```

### 🔐 สิ่งที่ต้องรู้ก่อนสั่ง Claude

| เรื่อง | ทำแบบนี้ ✅ | ห้ามทำ ❌ |
|---|---|---|
| เก็บรหัสผ่าน | **hash** ด้วย `argon2id` (หรือ `bcrypt`) — hash ทางเดียว ย้อนกลับไม่ได้ | เก็บ plain text, เข้ารหัสแบบถอดกลับได้, ใช้ MD5/SHA-256 ตรงๆ |
| รหัสผ่านที่ยอมรับ | ยาวอย่างน้อย 8–12 ตัว, ยอมรับรหัสยาวๆ/วลีได้, เช็กกับรายการรหัสที่รั่ว (ถ้าทำได้) | บังคับกฎแปลกๆ เช่น ต้องมีสัญลักษณ์แต่จำกัดความยาว 12 ตัว |
| Token ยืนยันอีเมล | สุ่มด้วย crypto (32 bytes ขึ้นไป), เก็บ **hash** ของ token ใน DB, หมดอายุ (เช่น 24 ชม.), ใช้ได้ครั้งเดียว | ใช้ user id หรือเวลาเป็น token |
| Session | cookie `HttpOnly` + `SameSite=Lax` (+ `Secure` เมื่อเป็น HTTPS), เก็บ session ใน DB, สร้าง session id ใหม่หลังล็อกอิน | เก็บ token ใน `localStorage`, ใส่ข้อมูลผู้ใช้ทั้งก้อนใน cookie |
| ข้อความ error | "อีเมลหรือรหัสผ่านไม่ถูกต้อง" เหมือนกันทุกกรณี | "ไม่พบอีเมลนี้" (บอกคนร้ายว่าอีเมลนี้มีในระบบ) |
| กันเดารหัส | **Rate limit** ที่ endpoint login/สมัคร (เช่น 5 ครั้ง/นาที/IP+อีเมล) | ปล่อยให้ลองได้ไม่จำกัด |
| Log | log เหตุการณ์ (ล็อกอินสำเร็จ/ล้มเหลว) | log รหัสผ่านหรือ token |

### 📬 เตรียมกล่องจดหมายจำลอง: Mailpit

ตอน dev ไม่ส่งอีเมลจริง — ใช้ **Mailpit** รับอีเมลทุกฉบับที่แอปส่ง แล้วเปิดดูผ่านเว็บ

```
ให้เพิ่ม service mailpit (image axllent/mailpit) ใน docker-compose.yml:
SMTP พอร์ต 1025 (ใช้ภายใน compose), หน้าเว็บพอร์ต 8025 (publish ให้เปิดดูจากเครื่องได้)
ให้ backend ส่งอีเมลผ่าน SMTP host "mailpit" พอร์ต 1025 โดยอ่านค่าจาก env (SMTP_HOST, SMTP_PORT, MAIL_FROM)
เพิ่มค่าเหล่านี้ใน .env.example และอัปเดต CLAUDE.md
```

เปิด <http://localhost:8025> → อีเมลที่แอปส่งจะมาอยู่ที่นี่ทั้งหมด

### 💬 Prompt: วางแผนก่อน (Plan mode)

```
อ่าน CLAUDE.md แล้ววางแผนเพิ่มระบบ Login ผ่าน Email ให้แอปนี้ ยังไม่ต้องแก้โค้ด:
- ตาราง users (email unique, password_hash, email_verified_at) และ email_verification_tokens (token_hash, expires_at, used_at) ผ่าน migration ใหม่
- POST /api/auth/register, GET /api/auth/verify?token=..., POST /api/auth/login, POST /api/auth/logout, GET /api/auth/me
- hash รหัสผ่านด้วย argon2id, session แบบ cookie HttpOnly + SameSite=Lax เก็บ session ใน PostgreSQL
- ส่งอีเมลยืนยันผ่าน SMTP ของ mailpit, token สุ่มด้วย crypto เก็บเป็น hash หมดอายุ 24 ชม. ใช้ได้ครั้งเดียว
- rate limit ที่ register/login, ข้อความ error แบบกลางๆ ไม่บอกว่าอีเมลมีในระบบไหม
- ห้ามล็อกอินถ้ายังไม่ยืนยันอีเมล
- หน้า Svelte: สมัคร, ล็อกอิน, แสดงชื่อผู้ใช้ + ปุ่มล็อกเอาต์, ป้องกันหน้า CRUD ให้เข้าได้เฉพาะคนที่ล็อกอิน
ใช้ library ที่ได้รับการยอมรับ ห้ามเขียน crypto เอง บอกชื่อ library ที่จะใช้และเหตุผล
```

อ่านแผน → ตรวจกับตาราง "สิ่งที่ต้องรู้" ด้านบน → อนุมัติ → ทำทีละส่วนแล้ว commit

### 🧪 Lab: ทดสอบเองให้ครบ

1. สมัครด้วยอีเมลสมมติ เช่น `test@example.com` → เปิด Mailpit เห็นอีเมลยืนยัน
2. ลองล็อกอิน **ก่อน** คลิกลิงก์ → ต้องถูกปฏิเสธ
3. คลิกลิงก์ยืนยัน → ล็อกอินได้ → คลิกลิงก์เดิมอีกครั้ง → ต้องใช้ไม่ได้แล้ว
4. ใส่รหัสผิดติดกันหลายครั้ง → ต้องโดน rate limit
5. เปิด DataGrip/DBeaver ดูตาราง `users` → คอลัมน์รหัสผ่านต้องเป็น hash ยาวๆ ขึ้นต้นด้วย `$argon2id$` **ไม่ใช่รหัสจริง**
6. เปิด DevTools → Application → Cookies → cookie ของ session ต้องติ๊ก **HttpOnly**
7. ให้ Claude ตรวจงานตัวเอง:
   ```
   /security-review
   ```

> 💡 **ต่อยอด (ถ้าเหลือเวลา):** ลืมรหัสผ่าน (ส่งลิงก์รีเซ็ตทางอีเมล แนวคิดเดียวกับ token ยืนยันอีเมล) หรือ **Magic link** (ล็อกอินด้วยลิงก์ทางอีเมลโดยไม่ใช้รหัสผ่าน)

---

## 🔑 4. 2FA / MFA — ให้ Claude เรียนจาก repo ตัวอย่าง (14:15–15:15)

**MFA (Multi-Factor Authentication)** = ล็อกอินต้องใช้ **มากกว่า 1 อย่าง**: สิ่งที่รู้ (รหัสผ่าน) + สิ่งที่มี (มือถือ) — รหัสผ่านรั่วก็ยังเข้าไม่ได้ · วันนี้ใช้ **TOTP** (แอป Authenticator สร้างรหัส 6 หลักใหม่ทุก 30 วินาที)

> 📦 **repo ตัวอย่าง:** <https://github.com/nuttkku/2FA-example-coding> (Svelte + Express + PostgreSQL เหมือนแอปของเรา) — แทนที่จะเขียน Prompt ยาวๆ เอง เราให้ Claude **อ่านโค้ดที่ทำงานได้จริง แล้วนำแนวทางมาใส่ในแอปของเรา** ซึ่งเป็นทักษะ Vibe Coding ที่ใช้บ่อยมากในงานจริง

### 🔄 Flow สั้นๆ

```
เปิดใช้ 2FA:  สร้าง secret ──► แสดง QR ──► สแกนด้วยแอป ──► กรอกรหัส 6 หลักยืนยัน ──► ได้ backup codes (แสดงครั้งเดียว)
ล็อกอิน:     อีเมล + รหัสผ่านถูก ──► ขั้นที่ 2: กรอกรหัส 6 หลัก (หรือ backup code) ──► เข้าระบบ
```

**แอป Authenticator:** Google Authenticator, Microsoft Authenticator, 2FAS — ติดตั้งบนมือถือก่อนเริ่ม

### 🎬 1. ดูของจริงก่อน (วิทยากรสาธิต 10 นาที)

วิทยากรรัน repo ตัวอย่างตาม Quick Start ใน README แล้วสาธิต: สแกน QR → กรอกรหัส → ได้ backup codes → ล็อกเอาต์ → ล็อกอินใหม่ต้องกรอกรหัส → ใช้ backup code แทน

### 📥 2. ให้ Claude เข้าถึง repo ตัวอย่าง

```bash
git clone https://github.com/nuttkku/2FA-example-coding.git ~/2fa-example     # clone ไว้นอกโปรเจกต์
```

ใน Claude Code ของ **โปรเจกต์ตัวเอง**: `/add-dir` → เลือกโฟลเดอร์ `~/2fa-example` (ให้ Claude อ่านได้ แต่เราจะแก้เฉพาะโปรเจกต์ตัวเอง)

### 💬 3. Prompt: เรียนแล้ววางแผน (Plan mode)

```
อ่านโปรเจกต์ตัวอย่างใน ~/2fa-example เฉพาะส่วน 2FA:
- README หัวข้อ "ขั้นตอนการทำงานของ 2FA" และ "ความลับถูกเก็บอย่างไร: hash vs encrypt"
- backend/src/services/twofa.service.js, backend/src/utils/crypto.js, backend/src/utils/backupCodes.js
- frontend/src/pages/Setup2FA.svelte, Verify2FA.svelte, BackupCodes.svelte

แล้ววางแผนนำ TOTP 2FA + backup codes มาใส่ในแอปของฉัน (ยังไม่ต้องแก้โค้ด):
- ปรับให้เข้ากับระบบ Login ผ่าน Email ที่มีอยู่แล้ว (ใช้ session แบบเดิม ไม่ต้องเปลี่ยนเป็น JWT)
- ให้ผู้ใช้เลือกเปิด 2FA เองได้ (ไม่ต้องบังคับทุกคนแบบตัวอย่าง)
- ไม่เอา RBAC, SSO, Keycloak มา
- schema ใหม่ต้องเป็น migration ใหม่ของโปรเจกต์ฉัน, key เข้ารหัสอ่านจาก env
สรุปให้ด้วยว่าตัวอย่างทำอะไรบ้าง และส่วนไหนที่ต้องปรับให้เข้ากับแอปฉัน
```

**ก่อนอนุมัติแผน ตรวจว่ามี 4 ข้อนี้:**
- 🔒 TOTP secret **เข้ารหัส** ก่อนเก็บ (key จาก env) — backup codes เก็บเป็น **hash** และใช้ได้ครั้งเดียว
- ✅ ต้องกรอกรหัสที่ถูก 1 ครั้งก่อนเปิดใช้ 2FA จริง
- 🚧 หลังรหัสผ่านถูกแต่ยังไม่ผ่านขั้นที่ 2 → **เรียก API อื่นไม่ได้**
- ⏱️ มี rate limit ที่การกรอกรหัส 6 หลัก

อนุมัติ → ให้ Claude ทำทีละส่วน (backend → frontend) → commit แต่ละส่วน

### 🧪 4. ทดสอบเอง

1. เปิด 2FA → สแกน QR ด้วยมือถือ → กรอกรหัส → ได้ backup codes (จดไว้)
2. ล็อกเอาต์ → ล็อกอินใหม่ → ต้องถามรหัส 6 หลัก · ใส่รหัสผิด → ไม่ผ่าน
3. ใช้ backup code 1 อัน → ผ่าน → ใช้อันเดิมซ้ำ → ต้องไม่ผ่าน
4. เปิด DataGrip/DBeaver ดูตาราง → secret ต้องไม่ใช่ข้อความ base32 ตรงๆ และ backup codes เป็น hash
5. Commit + Push → `/security-review`

> ⚠️ ใช้ **บัญชีทดสอบเท่านั้น** และเก็บ key เข้ารหัสไว้ใน `.env` — key หายแล้วถอด secret ไม่ได้ ผู้ใช้ทุกคนต้องตั้ง 2FA ใหม่
> 💡 **อ่านต่อ:** repo ตัวอย่างมีเรื่อง RBAC, SSO (OIDC/LINE/Facebook/Keycloak) และ CI/CD ที่ใช้ Semgrep + Trivy ให้ศึกษาเพิ่ม · แบบอื่นของ MFA: OTP ทางอีเมล (พอใช้), SMS (ไม่แนะนำ), Passkey/WebAuthn (ปลอดภัยที่สุด)

---

## 👮 5. RBAC — กำหนดสิทธิ์ตามบทบาท (15:15–16:00)

**RBAC (Role-Based Access Control)** = ผู้ใช้แต่ละคนมี **บทบาท (role)** เช่น `admin`, `user` และแต่ละบทบาททำได้เฉพาะ **สิทธิ์ (permission)** ที่กำหนด — เช่น ผู้ใช้ทั่วไปจองห้องได้ แต่เฉพาะ admin เพิ่ม/ลบห้องได้

> 📦 ใช้ repo ตัวอย่างเดิม [2FA-example-coding](https://github.com/nuttkku/2FA-example-coding) (clone ไว้ที่ `~/2fa-example` แล้วตอนทำ 2FA) — มี RBAC 3 บทบาท (`admin`, `manager`, `user`) พร้อมหน้าจัดการผู้ใช้

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

> 💡 **เวลาไม่พอ?** ทำแค่ข้อ 1–3 (backend ตรวจสิทธิ์ + ตรวจเจ้าของ) ให้ผ่านก่อน — หน้า admin ทำต่อใน Sprint วันที่ 4 ได้

---

## ✅ Checklist ท้ายวัน

- [ ] 🖥️ SSH เข้า VM ได้, `docker run --rm hello-world` บน VM ผ่าน และ Take Snapshot `clean-docker` แล้ว
- [ ] ☁️ เปิด hello-compose ผ่าน URL `*.trycloudflare.com` จากมือถือ (4G) ได้ **ก่อนเที่ยง**
- [ ] 📧 สมัคร → ได้อีเมลยืนยันใน Mailpit → ล็อกอินได้เฉพาะหลังยืนยัน · ลิงก์ยืนยันใช้ซ้ำไม่ได้
- [ ] 🔐 รหัสผ่านใน DB เป็น hash (`$argon2id$...`), cookie session เป็น HttpOnly, login มี rate limit
- [ ] 🔑 เปิด 2FA ด้วยแอป Authenticator ได้, ล็อกอินต้องกรอกรหัส 6 หลัก, backup code ใช้ได้ครั้งเดียว
- [ ] 👮 บัญชี user เรียก API admin ได้ **403** และแก้ข้อมูลของคนอื่นไม่ได้ · admin เปลี่ยน role ได้
- [ ] 📦 migration ใหม่สำหรับ users / tokens / 2FA / role อยู่ในโปรเจกต์ และ push ขึ้น GitHub แล้ว

## 🛠️ Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| ปัญหา VirtualBox / VM | ดูตาราง Troubleshooting ใน [virtualbox-vm.md](virtualbox-vm.md#️-troubleshooting) |
| Tunnel ไม่ขึ้น URL | `docker logs tunnel` ดู error · VM ต้องออกเน็ตได้ (Adapter 1 = NAT) · เครือข่ายบางแห่งบล็อก Cloudflare — ลองฮอตสปอตมือถือ |
| URL เปิดได้แต่ขึ้น 502 / Bad gateway | เว็บใน VM ยังไม่รันหรือพอร์ตผิด — `curl -I http://localhost:8080` บน VM ต้องได้ 200 ก่อน |
| ไม่มีอีเมลเข้า Mailpit | เปิด <http://localhost:8025> · backend ต้องส่งไป host `mailpit` พอร์ต `1025` (ในเครือข่าย compose ไม่ใช่ `localhost`) · ดู `docker compose logs backend` |
| ล็อกอินแล้วรีเฟรชหลุด / cookie ไม่ถูกเก็บ | ตั้ง `Secure` เฉพาะตอนเป็น HTTPS (dev ใช้ http) · frontend ต้องเรียก API ผ่าน Vite proxy (origin เดียวกัน) และส่ง `credentials` |
| รหัส TOTP ไม่ผ่านตลอด | เวลาในมือถือหรือเครื่อง/คอนเทนเนอร์ไม่ตรง — เปิดตั้งเวลาอัตโนมัติบนมือถือ · ตรวจว่า backend ยอมคลาดเคลื่อน ±1 ช่วง |
| สแกน QR ไม่ได้ | ขยาย QR ให้ใหญ่ขึ้น หรือกรอก secret ด้วยมือในแอป Authenticator (แสดงเฉพาะตอนตั้งค่า) |
| ล็อกตัวเองออก (ไม่มีมือถือ) | ใช้ backup code · ในเครื่อง dev ปิด MFA ของบัญชีทดสอบผ่าน DataGrip/DBeaver ได้ (ห้ามทำแบบนี้กับระบบจริง) |
| เปลี่ยน role แล้วยังใช้สิทธิ์เดิม | session เก็บ role ไว้ตอนล็อกอิน — ให้ล็อกอินใหม่ หรือให้ backend อ่าน role จาก DB ทุก request |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "เครื่องมือพัฒนา" (VirtualBox, Ubuntu), "CI/CD & Deploy" (Cloudflare Tunnel) และ "Authentication & MFA" (รวม RBAC)

---

<p align="center"><a href="../day-2-bootcamp/README.md">⬅️ 🎮 วันที่ 2</a> · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../day-4-build-deploy/README.md">🚀 วันที่ 4 ➡️</a></p>
