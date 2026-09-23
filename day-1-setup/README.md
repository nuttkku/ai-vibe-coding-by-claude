# วันที่ 1 — เตรียมเครื่องมือ + ปูพื้นฐานแนวคิด

## เป้าหมายของวัน

เมื่อจบวันนี้ ผู้เรียนจะ:
- อธิบายได้ว่า Vibe Coding คืออะไร และต่างจาก "ให้ AI ช่วยเขียนโค้ด" แบบรับผิดชอบอย่างไร
- มีเครื่องมือครบ: VSCode + Claude Code, Git + GitHub Desktop, Docker Desktop (WSL2), Node.js LTS, PostgreSQL
- มี **Server จำลอง (VirtualBox VM, Ubuntu Server)** ที่ SSH เข้าได้และมี Docker พร้อมใช้ในวันที่ 3 และ 5
- รัน Docker Compose ตัวอย่างได้สำเร็จ
- มี App Idea ของตัวเองเขียนเป็น Prompt พร้อมใช้ในวันที่ 2

## ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–09:45 | Mindset: Vibe Coding คืออะไร |
| 09:45–10:30 | ติดตั้ง VSCode + Claude Code Extension + ล็อกอิน Claude Pro |
| 10:30–11:30 | ติดตั้ง Git + GitHub Desktop + Docker Desktop (WSL2) |
| 11:30–12:00 | ติดตั้ง Node.js LTS + PostgreSQL |
| 13:00–14:00 | สร้าง VirtualBox VM (Ubuntu Server) — ระหว่างรอ OS ติดตั้ง ทำ Lab ข้อ 5 ไปพร้อมกัน |
| 14:00–15:00 | Lab: ทดสอบรัน Docker Compose ตัวอย่าง + ติดตั้ง Docker บน VM |
| 15:00–16:00 | Workshop: เขียน Prompt App Idea |

> วันแรกแน่นที่สุด ให้ผู้เรียน **ดาวน์โหลดตัวติดตั้งทั้งหมดและ ISO ของ Ubuntu Server ไว้ล่วงหน้า** (ดูรายการใน [README หลัก](../README.md#สิ่งที่ต้องเตรียมก่อนเข้าเรียน))

---

## 1. Mindset: Vibe Coding คืออะไร

คำว่า **"vibe coding"** ถูกบัญญัติโดย Andrej Karpathy (ก.พ. 2025) หมายถึงการเขียนโปรแกรมโดย "บอกสิ่งที่ต้องการ" เป็นภาษาธรรมชาติ แล้วปล่อยให้ AI เขียนโค้ด ผู้พัฒนาเน้นดูผลลัพธ์ ลองรัน แล้วสั่งแก้ต่อ แทนการพิมพ์โค้ดเองทุกบรรทัด

### สเปกตรัมของการใช้ AI เขียนโค้ด

```
 Pure Vibe Coding  ←──────────────────────────────→  AI-Assisted Engineering
 "ไม่อ่านโค้ด แค่ดูว่ารันได้"                         "AI เขียน เราอ่าน/ทดสอบ/รับผิดชอบ"
 เหมาะ: prototype, ของเล่น, ทดลองไอเดีย               เหมาะ: งานจริง, ขึ้น production, มีข้อมูลผู้ใช้
```

หลักสูตรนี้ **เริ่มจากฝั่งซ้าย** (เร็ว สนุก ได้ของจริงในวันเดียว) แล้ว **ค่อยๆ ขยับไปฝั่งขวา** ด้วย Test, Security Scan และ CI/CD ในวันที่ 3–4

### หลัก 5 ข้อของ Vibe Coder ที่ดี

1. **คุณคือ Product Owner + Reviewer** — Claude คือนักพัฒนาที่เร็วมาก แต่ไม่รู้ว่าคุณต้องการอะไรถ้าไม่บอก
2. **บริบทคือทุกอย่าง** — `CLAUDE.md`, ไฟล์ตัวอย่าง, error message เต็มๆ ช่วยได้มากกว่า Prompt ยาวๆ
3. **ทีละก้าวเล็กๆ + Commit บ่อย** — ถ้า AI พาหลงทาง ย้อนกลับได้ทันที
4. **เชื่อแต่ตรวจสอบ (Trust, but verify)** — รันจริง, ดู Test, ดูผลสแกน ไม่ใช่เชื่อคำว่า "เสร็จแล้ว"
5. **ความลับไม่เข้า Prompt/Repo** — รหัสผ่าน, API key อยู่ใน `.env` และ `.gitignore` เสมอ

### กิจกรรมอภิปราย (10 นาที)
- งานแบบไหนที่คุณจะ "vibe" ได้เต็มที่? งานแบบไหนที่ต้องอ่านโค้ดทุกบรรทัด?
- ถ้าแอปที่ AI เขียนมีช่องโหว่แล้วข้อมูลรั่ว ใครรับผิดชอบ?

---

## 2. ติดตั้ง VSCode + Claude Code

### 2.1 VSCode
ดาวน์โหลดจาก <https://code.visualstudio.com> ติดตั้งแบบค่าเริ่มต้น (Windows: ติ๊ก "Add to PATH" และ "Open with Code")

### 2.2 สมัคร Claude Pro
สมัครที่ <https://claude.ai> แล้วอัปเกรดเป็นแผน **Pro** (หรือสูงกว่า) — แผนนี้รวมสิทธิ์ใช้ Claude Code
ดูรายละเอียดแผนล่าสุดที่ <https://www.anthropic.com/pricing>

### 2.3 Claude Code Extension
1. เปิด VSCode → Extensions (`Ctrl+Shift+X`) → ค้นหา **"Claude Code"** (ผู้เผยแพร่: Anthropic)
2. กด Install แล้วคลิกไอคอน Claude ที่ Sidebar
3. ล็อกอินด้วยบัญชี Claude Pro ตามที่หน้าจอแนะนำ

> ติดตั้ง CLI เพิ่มได้ (ใช้ใน Terminal ได้ด้วย) ตามวิธีล่าสุดในเอกสาร: <https://docs.anthropic.com/en/docs/claude-code/setup>

### 2.4 ทดสอบ
เปิดโฟลเดอร์ว่างใน VSCode แล้วพิมพ์ใน Claude Code:

```
สร้างไฟล์ hello.js ที่พิมพ์ "Hello Vibe Coding" แล้วรันให้ดู
```

ถ้า Claude ขออนุญาตสร้างไฟล์/รันคำสั่ง แล้วเห็นผลลัพธ์ = พร้อม ✅

### 2.5 ใช้ให้คุ้มโควต้า
แผน Pro มีขีดจำกัดการใช้งานเป็นรอบเวลา และ 5 วันนี้จะใช้หนัก — อ่าน **[guides/claude-code-efficiency.md](../guides/claude-code-efficiency.md)** (10 นาที) ให้รู้จัก `/clear`, `/compact`, Plan mode และ Plan B เมื่อโควต้าหมด

---

## 3. ติดตั้ง Git + GitHub Desktop + Docker Desktop

### 3.1 Git
- Windows: <https://git-scm.com/download/win> (ติดตั้งค่าเริ่มต้น จะได้ Git Bash มาด้วย)
- macOS: `xcode-select --install` หรือ `brew install git`

ตั้งค่าตัวตน:
```bash
git config --global user.name "ชื่อ นามสกุล"
git config --global user.email "you@example.com"
```

### 3.2 GitHub Desktop
ดาวน์โหลด <https://desktop.github.com> แล้วล็อกอินบัญชี GitHub — ใช้สำหรับผู้ที่ยังไม่ถนัด Git command line

### 3.3 เปิด WSL2 (เฉพาะ Windows)
เปิด **PowerShell (Run as Administrator)**:
```powershell
wsl --install
```
รีสตาร์ทเครื่อง แล้วตรวจสอบ:
```powershell
wsl --status
wsl -l -v
```
ต้องเห็น `Default Version: 2`

> ถ้าเจอ error เรื่อง Virtualization ให้เปิด **Intel VT-x / AMD-V (SVM)** ใน BIOS

### 3.4 Docker Desktop
1. ดาวน์โหลด <https://www.docker.com/products/docker-desktop/>
2. Windows: ติ๊ก **"Use WSL 2 instead of Hyper-V"** ตอนติดตั้ง
3. เปิด Docker Desktop รอจนสถานะเป็น *Engine running*
4. ทดสอบ:
```bash
docker version
docker run --rm hello-world
```

---

## 4. ติดตั้ง Node.js LTS + PostgreSQL

### 4.1 Node.js LTS
ดาวน์โหลดเวอร์ชัน **LTS** จาก <https://nodejs.org> แล้วตรวจสอบ:
```bash
node -v
npm -v
```

### 4.2 PostgreSQL
เลือก **ทางใดทางหนึ่ง**:

**ทาง A (แนะนำ) — รันผ่าน Docker** ไม่ต้องติดตั้งลงเครื่อง ใช้ใน Lab ข้อ 5 ได้เลย

**ทาง B — ติดตั้งลงเครื่อง** จาก <https://www.postgresql.org/download/> (Windows installer จะมี pgAdmin มาด้วย) จำรหัสผ่านของ user `postgres` ไว้

> แนะนำติดตั้ง Extension **"PostgreSQL"** หรือ **"SQLTools"** ใน VSCode ไว้ดูข้อมูลในฐานข้อมูล

---

## 5. Lab: ทดสอบรัน Docker Compose

ใช้ไฟล์ตัวอย่างใน [`examples/hello-compose/`](examples/hello-compose/) — มี 2 service: เว็บ (nginx) และฐานข้อมูล (PostgreSQL)

```bash
cd day-1-setup/examples/hello-compose
cp .env.example .env        # Windows PowerShell: copy .env.example .env
docker compose up -d
docker compose ps
```

ตรวจสอบ:
- เปิด <http://localhost:8080> ต้องเห็นหน้า "Hello Vibe Coding"
- ทดสอบฐานข้อมูล:
  ```bash
  docker compose exec db psql -U app -d appdb -c "SELECT * FROM greetings;"
  ```

ปิดระบบ:
```bash
docker compose down        # เก็บข้อมูลไว้
docker compose down -v     # ลบข้อมูลใน volume ด้วย
```

### ภารกิจเสริม: ให้ Claude อธิบายและแก้
เปิดโฟลเดอร์ `hello-compose` ใน VSCode แล้วลอง Prompt:
```
อธิบาย docker-compose.yml นี้ทีละบรรทัดแบบคนเพิ่งเริ่ม
แล้วเพิ่ม service adminer ที่พอร์ต 8081 เพื่อดูฐานข้อมูลผ่านเว็บ
```

---

## 6. สร้าง Server จำลองด้วย VirtualBox

ทำตามคู่มือ **[virtualbox-vm.md](virtualbox-vm.md)** — สร้าง VM Ubuntu Server, ตั้ง Network (NAT + Host-only), SSH เข้า, ติดตั้ง Docker ด้วย [`examples/vm-setup.sh`](examples/vm-setup.sh) แล้ว Take Snapshot

VM นี้จะเป็นเป้าสแกน Nessus ในวันที่ 3 และเป็นเครื่อง Deploy ในวันที่ 5 (เปิดออกเน็ตด้วย Cloudflare Tunnel โดยไม่ต้องมีโดเมน)

---

## 7. Workshop: เขียน Prompt App Idea

แอปที่จะสร้างตลอด 5 วันควร **เล็กพอทำเสร็จ แต่ใหญ่พอให้ได้ใช้ครบ** (UI + API + DB + Login ถ้ามีเวลา)

ใช้แม่แบบ [`templates/app-idea.md`](../templates/app-idea.md) กรอกให้ครบ แล้วลองให้ Claude ช่วยขัดเกลา:

```
นี่คือไอเดียแอปของฉัน: <วางเนื้อหา app-idea.md>

ช่วย:
1. ถามคำถามที่ยังไม่ชัดเจนไม่เกิน 5 ข้อ
2. ตัด scope ให้ทำเสร็จได้ใน 3 วัน (Sprint 1–3) ด้วย Svelte + Express + PostgreSQL
3. เสนอ data model (ตาราง/คอลัมน์) และรายการ API endpoint
ยังไม่ต้องเขียนโค้ด
```

ตัวอย่างไอเดียที่เหมาะ: ระบบจองห้องประชุม, ระบบยืม-คืนอุปกรณ์, บันทึกรายรับรายจ่าย, คลังข้อสอบ, ระบบรับเรื่องร้องเรียน, แอปจัดการ Todo ของทีม

---

## Checklist ท้ายวัน

- [ ] รัน `scripts/check-env.ps1` (หรือ `.sh`) แล้วไม่มี FAIL
- [ ] Claude Code ใน VSCode ตอบและสร้างไฟล์ได้
- [ ] `git --version` และล็อกอิน GitHub Desktop แล้ว
- [ ] `wsl -l -v` แสดง VERSION 2 (Windows)
- [ ] `docker run --rm hello-world` ผ่าน
- [ ] `node -v` แสดงเวอร์ชัน LTS
- [ ] `hello-compose` เปิดหน้าเว็บและ query ฐานข้อมูลได้
- [ ] SSH เข้า VM ได้ และ `docker run --rm hello-world` บน VM ผ่าน
- [ ] Take Snapshot `clean-docker` ของ VM แล้ว
- [ ] มีไฟล์ `app-idea.md` ของตัวเองที่ผ่านการขัดเกลากับ Claude แล้ว

## Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| Docker Desktop ค้างที่ "Starting..." | รัน `wsl --update` แล้วรีสตาร์ท Docker Desktop |
| `port is already allocated` | มีโปรแกรมอื่นใช้พอร์ตอยู่ แก้พอร์ตใน `.env` เช่น `WEB_PORT=8090` |
| PostgreSQL ในเครื่องชนพอร์ต 5432 | ใช้ `DB_PORT=5433` ใน `.env` |
| Claude Code ล็อกอินไม่ได้ | ตรวจว่าบัญชีเป็นแผน Pro ขึ้นไป, ลอง Sign out แล้วเข้าใหม่ |
| `npm` ไม่พบคำสั่งหลังติดตั้ง Node | ปิดแล้วเปิด VSCode/Terminal ใหม่ (ให้โหลด PATH ใหม่) |
| ปัญหา VirtualBox / VM | ดูตาราง Troubleshooting ใน [virtualbox-vm.md](virtualbox-vm.md#troubleshooting) |

## อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "แนวคิด Vibe Coding", "Claude / Anthropic" และ "เครื่องมือพัฒนา"
