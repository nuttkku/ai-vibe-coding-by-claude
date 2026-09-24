# 🏗️ วันที่ 3 — สร้าง Scaffold โปรเจกต์จริง

## 🎯 เป้าหมายของวัน

- 🐳 เข้าใจ image/container, port, volume, bind mount, network และใช้คำสั่ง `docker compose` หลักได้
- ให้ Claude สร้าง Scaffold **Svelte + Express + PostgreSQL + Docker Compose** จาก Prompt เดียว
- ต่อ Svelte UI เข้ากับ API แล้วทดสอบ End-to-End ได้
- Commit และ Push โปรเจกต์ขึ้น GitHub

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–09:30 | 🐳 Docker ที่ต้องรู้ก่อน Scaffold (แนวคิด + Lab กับ hello-compose) |
| 09:30–12:00 | 🧪 Lab: Scaffold โปรเจกต์จาก Prompt เดียว |
| 13:00–14:30 | 🎨 Lab: Svelte UI เชื่อม API |
| 14:30–15:30 | 🔁 ทดสอบระบบแบบ End-to-End |
| 15:30–16:00 | ☁️ Commit และ Push ขึ้น GitHub |

---

## 🐳 1. Docker ที่ต้องรู้ก่อน Scaffold

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

## 🧪 2. Lab: Scaffold จาก Prompt เดียว

### 🎒 เตรียม
เปิด repo โปรเจกต์ที่สร้างไว้ท้ายวันที่ 2 ใน VSCode แล้วตรวจว่ามีครบ:
- `CLAUDE.md` (กรอกส่วน `<...>` แล้ว) — ยังไม่มี: ดู [วันที่ 2 ข้อ 5](../day-2-bootcamp/README.md#-5-claudemd--เตรียม-repo-โปรเจกต์)
- `docs/app-idea.md` ที่ตัด scope แล้ว
- `.claude/settings.json` (กันอ่าน `.env` และคำสั่งอันตราย)
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

hello-compose (วันที่ 2) ใช้ `init.sql` ซึ่ง **รันแค่ครั้งแรกตอน volume ของ Postgres ยังว่าง** — พอ Sprint วันที่ 5 ต้องเพิ่มคอลัมน์ แก้ `init.sql` ไปก็ไม่มีผล ต้องลบข้อมูลทิ้ง (`down -v`) ซึ่งทำบน Server จริงไม่ได้

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

---

## 🎨 3. Lab: Svelte UI เชื่อม API

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

## 🔁 4. ทดสอบระบบแบบ End-to-End

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

## ☁️ 5. Commit และ Push ขึ้น GitHub

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

## ✅ Checklist ท้ายวัน

- [ ] ทดลอง `down` เทียบ `down -v` แล้วอธิบายได้ว่าข้อมูลใน volume หายเมื่อไหร่
- [ ] `docker compose up -d --build` แล้วทั้ง 3 service ขึ้น `healthy`/`running`
- [ ] ตาราง `pgmigrations` มีรายการ migration ที่รันแล้ว (`docker compose exec db psql -U app -d appdb -c "SELECT name FROM pgmigrations;"`)
- [ ] `curl http://localhost:<port>/api/health` ตอบ 200
- [ ] หน้าเว็บ CRUD ได้ครบ และข้อมูลอยู่รอดหลังรีสตาร์ท
- [ ] E2E test อย่างน้อย 1 case ผ่าน
- [ ] Push ขึ้น GitHub แล้ว และไม่มี `.env` ใน repo

## 🛠️ Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| คำสั่ง docker อื่นๆ / container `Exited` / ดิสก์เต็ม | ดู [Docker Cheat Sheet ข้อ 7](../guides/docker-commands.md#-7-แก้ปัญหาที่เจอบ่อย) |
| Backend ต่อ DB ไม่ได้ (`ECONNREFUSED`) | ใน Docker ต้องใช้ host ชื่อ service (`db`) ไม่ใช่ `localhost`, และใช้ `depends_on: condition: service_healthy` |
| Frontend เรียก API แล้ว CORS error | ใช้ Vite proxy หรือ reverse proxy แทนการเปิด CORS กว้างๆ |
| แก้โค้ดแล้วไม่เปลี่ยน | รัน `docker compose up -d --build` หรือใช้ volume mount ตอน dev |
| แก้ schema แล้วตารางไม่เปลี่ยน | อย่าแก้ migration เดิม — สร้างไฟล์ใหม่แล้ว `npm run migrate up` (ดูหัวข้อ Migration) |
| Claude แก้ไฟล์เยอะเกินที่ขอ | ขอให้ "แก้เฉพาะไฟล์ X" และใช้ `git diff` ตรวจก่อน commit, ย้อนด้วย `git restore` |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "Claude / Anthropic" (Memory / CLAUDE.md, Best practices) และ "Framework & Library"

---

<p align="center"><a href="../day-2-bootcamp/README.md">⬅️ 🎮 วันที่ 2</a> · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../day-4-testing-security/README.md">🛡️ วันที่ 4 ➡️</a></p>
