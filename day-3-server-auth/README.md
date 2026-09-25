# 🏗️ วันที่ 3 — Server จำลอง + Cloudflare Tunnel + Login ผ่าน Email + MFA

## 🎯 เป้าหมายของวัน

- 🖥️ มี **Server จำลอง (VirtualBox VM, Ubuntu Server)** ที่ SSH เข้าได้และมี Docker
- ☁️ เปิดเว็บใน VM ให้คนภายนอกเข้าได้ด้วย **Cloudflare Quick Tunnel** (ไม่ต้องมีโดเมน) — **เสร็จก่อนเที่ยง**
- 📧 แอปของตัวเองมีระบบ **สมัคร → ยืนยันอีเมล → ล็อกอิน → ล็อกเอาต์** ที่ทำตามหลักความปลอดภัย
- 🔑 เพิ่ม **MFA แบบ TOTP** (แอป Authenticator) พร้อม recovery codes

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–10:30 | 🖥️ สร้าง VirtualBox VM + ติดตั้ง Docker บน VM + Snapshot |
| 10:30–12:00 | ☁️ Cloudflare Quick Tunnel กับ hello-compose บน VM → เปิดจากมือถือ (4G) ให้ได้ทุกคน |
| 13:00–14:30 | 📧 Login ผ่าน Email (สมัคร, ยืนยันอีเมลผ่าน Mailpit, ล็อกอิน, ล็อกเอาต์) |
| 14:30–16:00 | 🔑 MFA แบบ TOTP + recovery codes |

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

## 📧 3. Login ผ่าน Email (13:00–14:30)

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

## 🔑 4. MFA — ยืนยันตัวตน 2 ชั้น (14:30–16:00)

**MFA (Multi-Factor Authentication)** = ล็อกอินต้องใช้ **มากกว่า 1 อย่าง**: สิ่งที่รู้ (รหัสผ่าน) + สิ่งที่มี (มือถือ) — รหัสผ่านรั่วก็ยังเข้าไม่ได้

### 🧠 เลือกแบบไหน

| แบบ | วิธีทำงาน | ความปลอดภัย | ในหลักสูตร |
|---|---|---|---|
| 📱 **TOTP (แอป Authenticator)** | สแกน QR ครั้งเดียว แล้วแอปสร้างรหัส 6 หลักใหม่ทุก 30 วินาที (มาตรฐาน RFC 6238) | ดี · ไม่ต้องมีเน็ตบนมือถือ | ✅ **ทำ** |
| 📧 OTP ทางอีเมล | ส่งรหัสไปที่อีเมล | พอใช้ · ถ้าอีเมลโดนแฮ็กก็จบ | ทางเลือกเสริม |
| 💬 OTP ทาง SMS | ส่งรหัสทาง SMS | อ่อน · โดนสลับซิม/ดักได้ | ❌ ไม่แนะนำ |
| 🔐 Passkey / WebAuthn | ใช้ลายนิ้วมือ/ใบหน้า/กุญแจ USB | ดีที่สุด · กัน phishing | ขั้นสูง (อ่านเพิ่ม) |

**แอป Authenticator ที่ใช้ได้:** Google Authenticator, Microsoft Authenticator, 2FAS, Authy — ให้ผู้เรียนติดตั้งบนมือถือก่อนเริ่ม

### 🔄 Flow ของ TOTP

```
เปิดใช้ MFA:  สร้าง secret ──► แสดง QR (otpauth://...) ──► ผู้ใช้สแกนด้วยแอป
              ──► ผู้ใช้กรอกรหัส 6 หลักเพื่อยืนยัน ──► บันทึก secret + แสดง recovery codes 1 ครั้ง

ล็อกอิน:     อีเมล + รหัสผ่านถูก ──► session สถานะ "รอ MFA" (ยังเข้าหน้าอื่นไม่ได้)
              ──► กรอกรหัส 6 หลัก (หรือ recovery code) ──► session เต็มรูปแบบ
```

### 🔐 สิ่งที่ต้องรู้

| เรื่อง | ทำแบบนี้ ✅ |
|---|---|
| Secret ของ TOTP | สุ่มด้วย library, **เข้ารหัสก่อนเก็บใน DB** (ด้วย key จาก env) — ห้ามส่ง secret กลับไปที่ frontend หลังตั้งค่าเสร็จ |
| ขั้นยืนยันตอนเปิดใช้ | บังคับให้กรอกรหัสที่ถูกก่อน 1 ครั้งจึงเปิดใช้ (กันผู้ใช้ล็อกตัวเองออก) |
| Recovery codes | สร้าง 8–10 รหัส แสดง **ครั้งเดียว**, เก็บเป็น hash, ใช้แล้วใช้ซ้ำไม่ได้ |
| ตรวจรหัส | ยอมเวลาคลาดเคลื่อน ±1 ช่วง (30 วินาที), **rate limit** การกรอกรหัส, รหัสเดิมใช้ซ้ำไม่ได้ในช่วงเวลาเดียวกัน |
| session ระหว่างทาง | หลังรหัสผ่านถูกแต่ยังไม่ผ่าน MFA ห้ามเข้าถึง API อื่น |
| ปิด MFA | ต้องยืนยันด้วยรหัสผ่าน + รหัส TOTP ก่อน |

### 💬 Prompt: วางแผนก่อน (Plan mode)

```
อ่าน CLAUDE.md และระบบ Login ที่มีอยู่ แล้ววางแผนเพิ่ม MFA แบบ TOTP ยังไม่ต้องแก้โค้ด:
- migration ใหม่: เพิ่ม mfa_secret_encrypted, mfa_enabled_at ใน users และตาราง mfa_recovery_codes (code_hash, used_at)
- POST /api/mfa/setup (สร้าง secret + ส่ง QR เป็น data URL), POST /api/mfa/enable (ยืนยันรหัสแรก แล้วคืน recovery codes 10 อัน ครั้งเดียว),
  POST /api/mfa/verify (ขั้นที่ 2 ตอนล็อกอิน รับ TOTP หรือ recovery code), POST /api/mfa/disable (ต้องใส่รหัสผ่าน + TOTP)
- login: ถ้าผู้ใช้เปิด MFA ให้ session อยู่สถานะ mfa_pending และทุก API ที่ต้องล็อกอินต้องปฏิเสธจนกว่าจะผ่าน verify
- เข้ารหัส secret ด้วย key จาก env (MFA_ENCRYPTION_KEY) เก็บ recovery codes เป็น hash, rate limit ที่ verify
- หน้า Svelte: ตั้งค่า MFA (แสดง QR + ช่องกรอกรหัส + แสดง recovery codes ให้บันทึก), หน้ากรอกรหัส 6 หลักตอนล็อกอิน
ใช้ library TOTP และ QR code ที่ได้รับการยอมรับ บอกชื่อและเหตุผล ห้ามเขียนอัลกอริทึม TOTP เอง
```

### 🧪 Lab: ทดสอบเองให้ครบ

1. ล็อกอิน → หน้าตั้งค่า MFA → สแกน QR ด้วยแอป Authenticator บนมือถือ → กรอกรหัส → ได้ recovery codes (จดไว้)
2. ล็อกเอาต์ → ล็อกอินใหม่ → ต้องถามรหัส 6 หลัก → ลองเรียก API หน้า CRUD ตรงๆ ก่อนกรอกรหัส → ต้องถูกปฏิเสธ
3. กรอกรหัสผิด → ไม่ผ่าน · กรอกรหัสจากแอป → ผ่าน
4. ลองล็อกอินด้วย **recovery code** 1 อัน → ผ่าน → ใช้อันเดิมซ้ำ → ต้องไม่ผ่าน
5. ดูตาราง `users` ใน DataGrip/DBeaver → `mfa_secret_encrypted` ต้องไม่ใช่ secret ตรงๆ
6. (สนุก) เปิดแอปผ่าน **Cloudflare Tunnel** แล้วให้เพื่อนลองล็อกอินด้วยบัญชีทดสอบจากมือถือของเขา
7. Commit + Push → `/security-review` อีกครั้ง

> ⚠️ **ใช้บัญชีทดสอบเท่านั้น** — อย่าผูก MFA ของแอปทดลองกับบัญชีจริงใดๆ และเก็บ `MFA_ENCRYPTION_KEY` ไว้ใน `.env` เท่านั้น (หายแล้วถอด secret ไม่ได้ ผู้ใช้ทุกคนต้องตั้ง MFA ใหม่)

---

## ✅ Checklist ท้ายวัน

- [ ] 🖥️ SSH เข้า VM ได้, `docker run --rm hello-world` บน VM ผ่าน และ Take Snapshot `clean-docker` แล้ว
- [ ] ☁️ เปิด hello-compose ผ่าน URL `*.trycloudflare.com` จากมือถือ (4G) ได้ **ก่อนเที่ยง**
- [ ] 📧 สมัคร → ได้อีเมลยืนยันใน Mailpit → ล็อกอินได้เฉพาะหลังยืนยัน · ลิงก์ยืนยันใช้ซ้ำไม่ได้
- [ ] 🔐 รหัสผ่านใน DB เป็น hash (`$argon2id$...`), cookie session เป็น HttpOnly, login มี rate limit
- [ ] 🔑 เปิด MFA ด้วยแอป Authenticator ได้, ล็อกอินต้องกรอกรหัส 6 หลัก, recovery code ใช้ได้ครั้งเดียว
- [ ] 📦 migration ใหม่สำหรับ users / tokens / MFA อยู่ในโปรเจกต์ และ push ขึ้น GitHub แล้ว

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
| ล็อกตัวเองออก (ไม่มีมือถือ) | ใช้ recovery code · ในเครื่อง dev ปิด MFA ของบัญชีทดสอบผ่าน DataGrip/DBeaver ได้ (ห้ามทำแบบนี้กับระบบจริง) |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "เครื่องมือพัฒนา" (VirtualBox, Ubuntu), "CI/CD & Deploy" (Cloudflare Tunnel) และ "Authentication & MFA"

---

<p align="center"><a href="../day-2-bootcamp/README.md">⬅️ 🎮 วันที่ 2</a> · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../day-4-build-deploy/README.md">🚀 วันที่ 4 ➡️</a></p>
