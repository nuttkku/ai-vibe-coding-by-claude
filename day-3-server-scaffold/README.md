# 🏗️ วันที่ 3 — Server จำลอง + Cloudflare Tunnel + เริ่มสร้างแอป

## 🎯 เป้าหมายของวัน

- 🖥️ มี **Server จำลอง (VirtualBox VM, Ubuntu Server)** ที่ SSH เข้าได้และมี Docker
- ☁️ เปิดเว็บใน VM ให้คนภายนอกเข้าได้ด้วย **Cloudflare Quick Tunnel** (ไม่ต้องมีโดเมน) — **เสร็จก่อนเที่ยง**
- 🏗️ **Scaffold แอป Svelte + Express + PostgreSQL** รันบน Docker Compose ได้ ตรวจตารางด้วย ER Diagram และ push ขึ้น GitHub
- 🎨 เริ่มต่อ Svelte UI เข้ากับ API

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–10:30 | 🖥️ สร้าง VirtualBox VM + ติดตั้ง Docker บน VM + Snapshot |
| 10:30–12:00 | ☁️ Cloudflare Quick Tunnel กับ hello-compose บน VM → เปิดจากมือถือ (4G) ให้ได้ทุกคน |
| 13:00–14:45 | 🧪 Lab: Scaffold จาก Prompt เดียว + ตรวจ ER Diagram ด้วย DataGrip/DBeaver |
| 14:45–16:00 | 🎨 Lab: Svelte UI เชื่อม API (เริ่ม) + Commit + Push |

> 💡 **ช่วงเช้าให้เวลาเต็ม 3 ชั่วโมงสำหรับ VM + Tunnel** — ใครเสร็จก่อนช่วยเพื่อนข้างๆ หรือลองแก้ HTML บน VM แล้วดูผลผ่าน URL · ใครติดตั้ง Ubuntu ไม่ผ่าน ให้จับคู่ใช้ VM ของเพื่อนทำ Tunnel ไปก่อน

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

## 🧪 3. Lab: Scaffold จาก Prompt เดียว

### 🎒 เตรียม
เปิด repo โปรเจกต์ที่สร้างวันที่ 2 ใน VSCode แล้วตรวจว่ามีครบ:
- `CLAUDE.md` (กรอกส่วน `<...>` แล้ว) — ยังไม่มี: ดู [วันที่ 2 ข้อ 5](../day-2-bootcamp/README.md#-5-claudemd--เตรียม-repo-โปรเจกต์)
- `docs/app-idea.md` ที่ตัด scope แล้ว
- `.claude/settings.json` (กันอ่าน `.env` และคำสั่งอันตราย)
- 🗄️ หลัง scaffold เสร็จ เปิด DataGrip/DBeaver เชื่อม DB ของโปรเจกต์ แล้วดู **ER Diagram** ว่าตารางที่ Claude สร้างตรงกับ data model ใน `app-idea.md` ไหม
- โหมด Claude Code เป็น **Manual** หรือ **Plan** — ไม่ใช่ Auto

### 💬 Prompt Scaffold

```
อ่าน CLAUDE.md และ docs/app-idea.md แล้วสร้าง Scaffold ของโปรเจกต์:

- frontend/: Svelte 5 + Vite, หน้าแรกแสดงรายการ <resource หลัก> ดึงจาก API
- backend/: Express (ESM) มี GET /api/health และ CRUD /api/<resources>
  ใช้ pg ต่อ PostgreSQL ด้วย parameterized query, อ่าน config จาก env
- backend/migrations/: ใช้ node-pg-migrate (ไฟล์ SQL) สร้างตารางตาม data model
  migration แรก = สร้างตาราง, migration ที่สอง = ข้อมูลตัวอย่าง 5 แถว
  เพิ่ม npm script "migrate" และให้ container backend รัน migrate up ก่อน start server
- Dockerfile แยกสำหรับ frontend และ backend
- docker-compose.yml: frontend, backend, db (มี healthcheck), ใช้ .env
- .env.example, .gitignore (ต้องมี .env และ node_modules)
- README.md วิธีรัน

เสร็จแล้วรัน docker compose up -d --build และ curl /api/health ให้ดูว่าผ่าน
ถ้ามี error ให้แก้จนผ่านก่อนรายงาน
```

### 👀 ขณะ Claude ทำงาน — สิ่งที่ผู้เรียนควรทำ
- **อ่านแผน** ที่ Claude เสนอก่อนกดอนุญาต ถ้าไม่ตรงใจให้แก้ตั้งแต่ตอนนี้
- สังเกตคำสั่งที่ Claude ขอรัน — อย่ากดอนุญาตคำสั่งที่ไม่เข้าใจ ให้ถามก่อน
- เมื่อเสร็จ ให้ **รันเองอีกรอบ** เพื่อยืนยัน
- วันนี้ใช้โควต้าหนัก: commit แล้ว `/clear` ทุกครั้งที่จบ task (ดู [guides/claude-code-efficiency.md](../guides/claude-code-efficiency.md))

### 🗃️ ทำไมใช้ Migration แทน `init.sql`

hello-compose (วันที่ 2) ใช้ `init.sql` ซึ่ง **รันแค่ครั้งแรกตอน volume ของ Postgres ยังว่าง** — พอ Sprint วันที่ 4 ต้องเพิ่มคอลัมน์ แก้ `init.sql` ไปก็ไม่มีผล ต้องลบข้อมูลทิ้ง (`down -v`) ซึ่งทำบน Server จริงไม่ได้

**Migration** = ไฟล์ที่บันทึกการเปลี่ยนแปลง schema ทีละขั้น เรียงลำดับตามเวลา เครื่องมือจะจำว่ารันไปถึงไฟล์ไหนแล้ว (ในตาราง `pgmigrations`) และรันเฉพาะไฟล์ใหม่

```
backend/migrations/
├── 1727000000000_create-bookings.sql     ← รันแล้ว
├── 1727000100000_seed-bookings.sql       ← รันแล้ว
└── 1727100000000_add-room-capacity.sql   ← ใหม่: migrate up จะรันแค่ไฟล์นี้
```

ตัวอย่างไฟล์ migration แบบ SQL:
```sql
-- Up Migration
ALTER TABLE rooms ADD COLUMN capacity INTEGER NOT NULL DEFAULT 10;

-- Down Migration
ALTER TABLE rooms DROP COLUMN capacity;
```

คำสั่งที่ใช้:
```bash
cd backend
npx node-pg-migrate create add-room-capacity --migration-file-language sql   # สร้างไฟล์ใหม่
npm run migrate up      # รัน migration ที่ยังไม่ได้รัน (ต้องตั้ง DATABASE_URL)
npm run migrate down    # ย้อน migration ล่าสุด 1 ไฟล์
```

**กฎทอง 3 ข้อ** (ใส่ไว้ใน `CLAUDE.md` แล้วในแม่แบบ):
1. **ห้ามแก้ไฟล์ migration ที่รันไปแล้ว** — ต้องการเปลี่ยนอะไร ให้สร้างไฟล์ใหม่
2. ทุก migration ต้องมี **Down** ที่ย้อนกลับได้
3. Commit ไฟล์ migration พร้อมโค้ดที่ใช้ schema ใหม่ใน commit เดียวกัน

### 📦 Commit แรก
```bash
git add .
git commit -m "chore: scaffold svelte + express + postgres"
```

> 💡 เป้าหมายก่อน 14:45: `docker compose up -d --build` ขึ้นครบ 3 service และ `/api/health` ตอบ 200 แล้ว commit + push — ถ้ายังไม่เสร็จ ทำต่อแทนการเริ่ม UI (ข้อ 4)

---

## 🎨 4. Lab: Svelte UI เชื่อม API (เริ่มวันนี้ ทำต่อวันที่ 4)

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

## ✅ Checklist ท้ายวัน

- [ ] 🖥️ SSH เข้า VM ได้, `docker run --rm hello-world` บน VM ผ่าน และ Take Snapshot `clean-docker` แล้ว
- [ ] ☁️ เปิด hello-compose ผ่าน URL `*.trycloudflare.com` จากมือถือ (4G) ได้ **ก่อนเที่ยง**
- [ ] 🏗️ `docker compose up -d --build` ขึ้นครบ 3 service, `/api/health` ตอบ 200, ตาราง `pgmigrations` มีรายการ
- [ ] 🗄️ ER Diagram ของตารางที่ Claude สร้างตรงกับ data model ใน `app-idea.md`
- [ ] 🎨 หน้าแรกแสดงรายการจาก API ได้แล้วอย่างน้อย 1 หน้า
- [ ] ☁️ Commit + Push ขึ้น GitHub แล้ว ไม่มี `.env`

## 🛠️ Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| ปัญหา VirtualBox / VM | ดูตาราง Troubleshooting ใน [virtualbox-vm.md](virtualbox-vm.md#️-troubleshooting) |
| Tunnel ไม่ขึ้น URL | `docker logs tunnel` ดู error · VM ต้องออกเน็ตได้ (Adapter 1 = NAT) · เครือข่ายบางแห่งบล็อก Cloudflare — ลองฮอตสปอตมือถือ |
| URL เปิดได้แต่ขึ้น 502 / Bad gateway | เว็บใน VM ยังไม่รันหรือพอร์ตผิด — `curl -I http://localhost:8080` บน VM ต้องได้ 200 ก่อน |
| คำสั่ง docker อื่นๆ / container `Exited` / ดิสก์เต็ม | ดู [Docker Cheat Sheet ข้อ 7](../guides/docker-commands.md#-7-แก้ปัญหาที่เจอบ่อย) |
| Backend ต่อ DB ไม่ได้ (`ECONNREFUSED`) | ใน Docker ต้องใช้ host ชื่อ service (`db`) ไม่ใช่ `localhost`, และใช้ `depends_on: condition: service_healthy` |
| แก้โค้ดแล้วไม่เปลี่ยน | รัน `docker compose up -d --build` หรือใช้ volume mount ตอน dev |
| แก้ schema แล้วตารางไม่เปลี่ยน | อย่าแก้ migration เดิม — สร้างไฟล์ใหม่แล้ว `npm run migrate up` (ดูหัวข้อ Migration) |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "เครื่องมือพัฒนา" (VirtualBox, Ubuntu, Docker), "CI/CD & Deploy" (Cloudflare Tunnel) และ "Claude / Anthropic"

---

<p align="center"><a href="../day-2-bootcamp/README.md">⬅️ 🎮 วันที่ 2</a> · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../day-4-build-deploy/README.md">🚀 วันที่ 4 ➡️</a></p>
