# 🏗️ วันที่ 2 — สร้าง Scaffold โปรเจกต์จริง

## 🎯 เป้าหมายของวัน

- เขียน `CLAUDE.md` ที่ทำให้ Claude ทำงานตรงตามมาตรฐานของโปรเจกต์
- ให้ Claude สร้าง Scaffold **Svelte + Express + PostgreSQL + Docker Compose** จาก Prompt เดียว
- ต่อ Svelte UI เข้ากับ API แล้วทดสอบ End-to-End ได้
- Commit และ Push โปรเจกต์ขึ้น GitHub

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–10:00 | วิธีเขียน CLAUDE.md ให้ได้ผล |
| 10:00–12:00 | Lab: Scaffold โปรเจกต์จาก Prompt เดียว |
| 13:00–14:30 | Lab: Svelte UI เชื่อม API |
| 14:30–15:30 | ทดสอบระบบแบบ End-to-End |
| 15:30–16:00 | Commit และ Push ขึ้น GitHub |

---

## 📝 1. วิธีเขียน CLAUDE.md ให้ได้ผล

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

---

## 🧪 2. Lab: Scaffold จาก Prompt เดียว

### 🎒 เตรียม
1. สร้าง repo ใหม่บน GitHub (เช่น `room-booking`) แบบ Private หรือ Public — ติ๊ก *Add README* และ `.gitignore` = Node
2. Clone ลงเครื่องด้วย GitHub Desktop แล้วเปิดใน VSCode
3. คัดลอก `templates/CLAUDE.md.template` มาเป็น `CLAUDE.md` แล้วแก้ส่วน `<...>` ให้ตรงกับแอปของตัวเอง
4. วาง `app-idea.md` จากวันที่ 1 ไว้ใน `docs/app-idea.md`

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

วันที่ 1 เราใช้ `init.sql` ซึ่ง **รันแค่ครั้งแรกตอน volume ของ Postgres ยังว่าง** — พอ Sprint วันที่ 4 ต้องเพิ่มคอลัมน์ แก้ `init.sql` ไปก็ไม่มีผล ต้องลบข้อมูลทิ้ง (`down -v`) ซึ่งทำบน Server จริงไม่ได้

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

- [ ] มี `CLAUDE.md` ที่ปรับให้เข้ากับแอปของตัวเอง
- [ ] `docker compose up -d --build` แล้วทั้ง 3 service ขึ้น `healthy`/`running`
- [ ] ตาราง `pgmigrations` มีรายการ migration ที่รันแล้ว (`docker compose exec db psql -U app -d appdb -c "SELECT name FROM pgmigrations;"`)
- [ ] `curl http://localhost:<port>/api/health` ตอบ 200
- [ ] หน้าเว็บ CRUD ได้ครบ และข้อมูลอยู่รอดหลังรีสตาร์ท
- [ ] E2E test อย่างน้อย 1 case ผ่าน
- [ ] Push ขึ้น GitHub แล้ว และไม่มี `.env` ใน repo

## 🛠️ Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| Backend ต่อ DB ไม่ได้ (`ECONNREFUSED`) | ใน Docker ต้องใช้ host ชื่อ service (`db`) ไม่ใช่ `localhost`, และใช้ `depends_on: condition: service_healthy` |
| Frontend เรียก API แล้ว CORS error | ใช้ Vite proxy หรือ reverse proxy แทนการเปิด CORS กว้างๆ |
| แก้โค้ดแล้วไม่เปลี่ยน | รัน `docker compose up -d --build` หรือใช้ volume mount ตอน dev |
| แก้ schema แล้วตารางไม่เปลี่ยน | อย่าแก้ migration เดิม — สร้างไฟล์ใหม่แล้ว `npm run migrate up` (ดูหัวข้อ Migration) |
| Claude แก้ไฟล์เยอะเกินที่ขอ | ขอให้ "แก้เฉพาะไฟล์ X" และใช้ `git diff` ตรวจก่อน commit, ย้อนด้วย `git restore` |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "Claude / Anthropic" (Memory / CLAUDE.md, Best practices) และ "Framework & Library"

---

<p align="center"><a href="../day-1-setup/README.md">⬅️ 🧰 วันที่ 1</a> · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../day-3-testing-security/README.md">🛡️ วันที่ 3 ➡️</a></p>
