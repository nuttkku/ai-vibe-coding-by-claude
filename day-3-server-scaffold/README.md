# 🏗️ วันที่ 3 — Server จำลอง + Cloudflare Tunnel + เริ่มสร้างแอป

## 🎯 เป้าหมายของวัน

- 🖥️ มี **Server จำลอง (VirtualBox VM, Ubuntu Server)** ที่ SSH เข้าได้และมี Docker
- ☁️ เปิดเว็บใน VM ให้คนภายนอกเข้าได้ด้วย **Cloudflare Quick Tunnel** (ไม่ต้องมีโดเมน)
- 💡 มี App Idea ที่ตัด scope แล้ว และ repo โปรเจกต์พร้อม `CLAUDE.md`
- 🐳 เข้าใจ image/container, port, volume, bind mount, network ก่อนสร้างแอป
- 🏗️ **Scaffold แอป Svelte + Express + PostgreSQL** รันบน Docker Compose ได้ และ push ขึ้น GitHub แล้ว

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–10:15 | 🖥️ สร้าง VirtualBox VM + ติดตั้ง Docker บน VM + Snapshot |
| 10:15–11:15 | ☁️ Cloudflare Quick Tunnel กับ hello-compose บน VM |
| 11:15–12:00 | 💡 Workshop: App Idea |
| 13:00–13:30 | 📝 CLAUDE.md + เตรียม repo โปรเจกต์ |
| 13:30–13:55 | 🐳 Docker ลงลึกก่อน Scaffold |
| 13:55–15:40 | 🧪 Lab: Scaffold จาก Prompt เดียว |
| 15:40–16:00 | ☁️ Commit + Push + ตรวจ ER Diagram ของตารางที่ Claude สร้าง |

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

## 💡 3. Workshop: เขียน Prompt App Idea

แอปที่จะสร้างควร **เล็กพอทำเสร็จ แต่ใหญ่พอให้ได้ใช้ครบ** (UI + API + DB) — เริ่มจาก "ปัญหาที่อยากแก้" ที่แต่ละคนเล่าตอนแนะนำตัววันที่ 1

> ⚠️ เวลาสร้างแอปจริงมี **บ่ายนี้ (scaffold) + วันที่ 4 (UI เช้า + Sprint บ่าย 1 ชั่วโมง)** แล้ววันที่ 5 นำเสนอ — ให้ Must have มีแค่ 1 resource หลัก + CRUD + ฟีเจอร์เด่น 1 อย่าง

ใช้แม่แบบ [`templates/app-idea.md`](../templates/app-idea.md) กรอกให้ครบ แล้วลองให้ Claude ช่วยขัดเกลา (ใช้ **Plan mode** ที่เรียนวันที่ 2):

```
นี่คือไอเดียแอปของฉัน: <วางเนื้อหา app-idea.md>

ช่วย:
1. ถามคำถามที่ยังไม่ชัดเจนไม่เกิน 5 ข้อ
2. ตัด scope ให้ Must have ทำเสร็จได้ภายในวันที่ 4 (scaffold + UI + Sprint รวม ~4 ชั่วโมง) ด้วย Svelte + Express + PostgreSQL
3. เสนอ data model (ตาราง/คอลัมน์) และรายการ API endpoint
ยังไม่ต้องเขียนโค้ด
```

ตัวอย่างไอเดียที่เหมาะ: ระบบจองห้องประชุม, ระบบยืม-คืนอุปกรณ์, บันทึกรายรับรายจ่าย, คลังข้อสอบ, ระบบรับเรื่องร้องเรียน, แอปจัดการ Todo ของทีม

---

## 📝 4. CLAUDE.md + เตรียม repo โปรเจกต์

`CLAUDE.md` คือไฟล์ที่ Claude Code **อ่านอัตโนมัติทุกครั้ง** ที่เริ่มทำงานในโปรเจกต์ เปรียบเหมือน "คู่มือพนักงานใหม่" — สิ่งที่เขียนไว้ในนี้ไม่ต้องพิมพ์ซ้ำในทุก Prompt

### 📋 ควรมีอะไรบ้าง

| หัวข้อ | ตัวอย่าง |
|---|---|
| โปรเจกต์นี้คืออะไร | "ระบบจองห้องประชุมสำหรับคณะ ผู้ใช้คือบุคลากร ~200 คน" |
| Tech stack + เวอร์ชัน | Svelte 5, Express 5, PostgreSQL 17, Node LTS |
| โครงสร้างโฟลเดอร์ | `frontend/`, `backend/`, `backend/migrations/` |
| คำสั่งที่ใช้บ่อย | `docker compose up -d`, `npm test`, `npm run migrate up` |
| มาตรฐานโค้ด | ESM, async/await, validate input ทุก endpoint |
| สิ่งที่ห้ามทำ | ห้าม commit `.env`, ห้ามต่อ SQL ด้วย string concat |
| Definition of Done | Test ผ่าน, lint ผ่าน, อัปเดต README |

### 💡 เคล็ดลับ
- **สั้นและเจาะจง** ดีกว่ายาวและกว้าง — Claude อ่านทุกครั้ง ข้อความที่ไม่จำเป็นกินบริบท
- เขียนเป็น **คำสั่ง** ("ใช้ parameterized query เสมอ") ไม่ใช่คำอธิบายยาว
- **อัปเดตเมื่อ Claude ทำผิดซ้ำ** — ถ้าต้องบอกเรื่องเดิมสองครั้ง ให้ใส่ลง `CLAUDE.md`
- ใช้คำสั่ง `/init` ใน Claude Code เพื่อสร้างร่างแรกจากโค้ดที่มีอยู่ แล้วแก้ต่อ

แม่แบบพร้อมใช้: [`templates/CLAUDE.md.template`](../templates/CLAUDE.md.template)

### 🎒 เตรียม repo โปรเจกต์ของตัวเอง (พร้อมเริ่ม Scaffold ในข้อ 6)

1. สร้าง repo ใหม่บน GitHub (เช่น `room-booking`) แบบ Private หรือ Public — ติ๊ก *Add README* และ `.gitignore` = Node
2. Clone ลงเครื่องด้วย GitHub Desktop แล้วเปิดใน VSCode
3. คัดลอก [`templates/CLAUDE.md.template`](../templates/CLAUDE.md.template) มาเป็น `CLAUDE.md` แล้วแก้ส่วน `<...>` ให้ตรงกับแอปของตัวเอง (ให้ Claude ช่วยได้: `อ่าน docs/app-idea.md แล้วช่วยกรอก CLAUDE.md ส่วน Project ให้กระชับ`)
4. วาง `app-idea.md` จาก Workshop ไว้ใน `docs/app-idea.md`
5. คัดลอก [`templates/claude/settings.json`](../templates/claude/settings.json) ไปเป็น `.claude/settings.json`
6. Commit + Push: `chore: add CLAUDE.md, app idea and claude settings`

---

## 🐳 5. Docker ลงลึกก่อน Scaffold

วันที่ 2 เราใช้ Docker ผ่านหน้าจอ วันนี้ Claude จะสร้าง **Dockerfile + docker-compose.yml** ของแอปจริงให้ — ผู้เรียนต้อง **อ่านออกและแก้ปัญหาได้**

> 📖 เปิด **[Docker Cheat Sheet](../guides/docker-commands.md)** ไว้ข้างจอ

### 🧠 แนวคิด 5 อย่าง (10 นาที)

| คำ | ความหมาย | ทำไมสำคัญวันนี้ |
|---|---|---|
| 🧱 **Image → Container** | Image = แม่แบบ (build จาก Dockerfile) · Container = ตัวที่รันจาก image ลบแล้วสร้างใหม่ได้ | แก้โค้ดแล้วต้อง `--build` ใหม่ ไม่งั้น container รันโค้ดเก่า |
| 🔌 **Port** `3000:3000` | **เครื่องเรา : container** | พอร์ตชน → เปลี่ยนเลขฝั่งซ้าย |
| 💾 **Named volume** | ที่เก็บข้อมูลที่อยู่รอดแม้ลบ container | ข้อมูล DB อยู่ที่นี่ — `down -v` = ข้อมูลหาย |
| 📁 **Bind mount** `./src:/app/src` | ผูกโฟลเดอร์ในเครื่องเข้า container | แก้โค้ดแล้วเห็นผลทันทีตอน dev |
| 🌐 **Network / ชื่อ service** | service ใน compose เดียวกันคุยกันด้วยชื่อ service | backend ต้องต่อ DB ที่ `db:5432` **ไม่ใช่ `localhost`** |

### 🧪 Lab: ทดลองกับ hello-compose (10 นาที)

เปิด Terminal ในโฟลเดอร์ `day-2-bootcamp/examples/hello-compose` แล้วทำทีละข้อ — สังเกตหน้าจอ Docker Desktop คู่กันไปด้วย

```bash
docker compose up -d
docker compose ps                    # ใครรันอยู่ healthy ไหม พอร์ตอะไร
docker compose logs --tail 20 db     # log 20 บรรทัดล่าสุด (แบบที่วางให้ Claude ดูตอนมี error)
docker compose exec db psql -U app -d appdb -c "INSERT INTO greetings (message) VALUES ('ข้อมูลของฉัน');"
```

**ทดลอง 1 — Volume รักษาข้อมูล:**
```bash
docker compose down                  # ลบ container (volume ยังอยู่)
docker compose up -d
docker compose exec db psql -U app -d appdb -c "SELECT * FROM greetings;"   # 'ข้อมูลของฉัน' ยังอยู่ ✅
```

**ทดลอง 2 — `down -v` ลบข้อมูลจริง:**
```bash
docker compose down -v               # ⚠️ ลบ volume ด้วย
docker compose up -d
docker compose exec db psql -U app -d appdb -c "SELECT * FROM greetings;"   # เหลือแค่ 2 แถวเริ่มต้น ❌
```
→ นี่คือเหตุผลที่ `down -v` อยู่ใน `deny` ของ `settings.json` และต้อง backup ก่อนเสมอ

**ทดลอง 3 — Bind mount:** แก้ข้อความใน `html/index.html` แล้วรีเฟรช <http://localhost:8080> → เปลี่ยนทันทีโดยไม่ต้องรีสตาร์ท (เพราะโฟลเดอร์ `./html` ผูกเข้า container)

**ทดลอง 4 — เปลี่ยนพอร์ต:** แก้ `WEB_PORT=8090` ใน `.env` → `docker compose up -d` → เปิด <http://localhost:8090>

### 📄 อ่านไฟล์ที่ Claude จะสร้าง

ดูตัวอย่างพร้อมคำอธิบายทีละบรรทัดใน [cheat sheet ข้อ 4–5](../guides/docker-commands.md#-4-อ่าน-docker-composeyml-ให้ออก) — สิ่งที่ต้องหาให้เจอในไฟล์ของตัวเองหลัง scaffold:
- `healthcheck` ของ db + `depends_on: condition: service_healthy` ของ backend
- backend ใช้ host `db` ใน `DATABASE_URL`
- รหัสผ่านมาจาก `${...}` ใน `.env` ไม่ได้เขียนตรงๆ
- DB **ไม่จำเป็นต้อง** publish พอร์ตออกมา (ปลอดภัยกว่า — วันที่ 4 จะเห็นผลใน Nessus)

---

## 🧪 6. Lab: Scaffold จาก Prompt เดียว

### 🎒 เตรียม
เปิด repo โปรเจกต์ที่สร้างในข้อ 4 ใน VSCode แล้วตรวจว่ามีครบ:
- `CLAUDE.md` (กรอกส่วน `<...>` แล้ว) — ยังไม่มี: กลับไป [ข้อ 4](#-4-claudemd--เตรียม-repo-โปรเจกต์)
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

> 💡 เป้าหมายก่อน 16:00: `docker compose up -d --build` ขึ้นครบ 3 service และ `/api/health` ตอบ 200 แล้ว commit + push — ถ้ายังไม่เสร็จ ทำเป็นการบ้าน หรือเริ่มต้นวันที่ 4 ก่อน UI

---

## ✅ Checklist ท้ายวัน

- [ ] 🖥️ SSH เข้า VM ได้, `docker run --rm hello-world` บน VM ผ่าน และ Take Snapshot `clean-docker` แล้ว
- [ ] ☁️ เปิด hello-compose ผ่าน URL `*.trycloudflare.com` จากมือถือ (4G) ได้
- [ ] 💡 มี `docs/app-idea.md` ที่ตัด scope แล้ว + `CLAUDE.md` + `.claude/settings.json` ใน repo โปรเจกต์
- [ ] 🏗️ `docker compose up -d --build` ขึ้นครบ 3 service, `/api/health` ตอบ 200, ตาราง `pgmigrations` มีรายการ
- [ ] 🗄️ ER Diagram ของตารางที่ Claude สร้างตรงกับ data model
- [ ] ☁️ Commit แรกของโปรเจกต์ push ขึ้น GitHub แล้ว ไม่มี `.env`

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
