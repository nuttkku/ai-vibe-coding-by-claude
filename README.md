# 🤖 AI Vibe Coding ด้วย Claude (หลักสูตร 5 วัน)

![Days](https://img.shields.io/badge/%E0%B8%AB%E0%B8%A5%E0%B8%B1%E0%B8%81%E0%B8%AA%E0%B8%B9%E0%B8%95%E0%B8%A3-5_%E0%B8%A7%E0%B8%B1%E0%B8%99-ff7a59) ![Stack](https://img.shields.io/badge/stack-Svelte_%C2%B7_Express_%C2%B7_PostgreSQL-4f46e5) ![Code: MIT](https://img.shields.io/badge/code-MIT-22c55e) ![Content: CC BY-NC-SA 4.0](https://img.shields.io/badge/content-CC_BY--NC--SA_4.0-f59e0b)

✨ หลักสูตรเชิงปฏิบัติการ สร้างเว็บแอปจริงตั้งแต่เริ่มจนถึง Deploy ได้ URL โดยใช้ **Claude Code** เป็นคู่หูเขียนโค้ด
🏗️ Scaffold → 🎨 UI/API/DB → 🧪 Testing → 🛡️ Security Scan → ⚙️ CI/CD → 🌍 Deploy → 🎤 Demo

> 📌 **ผู้จัดทำหลักสูตร:** Wanut Padee (wanut@kku.ac.th)
> **License:** โค้ดใช้ [MIT](LICENSE) · เนื้อหาการสอนใช้ [CC BY-NC-SA 4.0 (เพื่อการศึกษา)](LICENSE-EDU.md) · ดู [CREDITS.md](CREDITS.md) สำหรับแหล่งอ้างอิง

---

## 🎁 ผู้เรียนจะได้อะไร

- 🧠 เข้าใจแนวคิด Vibe Coding และรู้ว่าเมื่อไหร่ควร "ปล่อยให้ AI ขับ" เมื่อไหร่ต้อง "จับพวงมาลัยเอง"
- 🎮 ใช้ Claude Code คล่อง: `@` `!` Plan mode `/rewind` `/clear` `CLAUDE.md` permission และคำสั่งของตัวเอง
- 🌱 ใช้ git ได้ทั้ง command line และ GitHub Desktop — อ่านคำสั่ง git ที่ Claude ขอรันออก
- 📝 เขียน `CLAUDE.md` และ Prompt ที่ทำให้ Claude สร้างโค้ดได้ตรงใจ
- 🏗️ สร้างแอป **Svelte + Express + PostgreSQL** รันด้วย **Docker Compose**
- 🧪 ให้ Claude เขียน Unit/Integration Test และอ่านผลเพื่อแก้บั๊ก
- 🛡️ สแกนความปลอดภัยด้วย **Snyk**, **OWASP ZAP**, **Nessus**
- ⚙️ สร้าง Pipeline **GitHub Actions**: Test → Security Scan → Build → Push Image
- 🌍 สร้าง Server จำลองด้วย **VirtualBox** แล้ว Deploy แอปขึ้นไป เปิดสู่อินเทอร์เน็ตด้วย **Cloudflare Tunnel** (ไม่ต้องมีโดเมน) และนำเสนอ Demo พร้อม URL

## 🗓️ ตารางหลักสูตร

| วัน | หัวข้อ | เนื้อหา |
|---|---|---|
| 🧰 1 | [เปิดหลักสูตร + Vibe Coding + ติดตั้งเครื่องมือ](day-1-intro/README.md) | เช้า: เปิดหลักสูตร, แนะนำตัวผู้สอนและผู้อบรม, สาธิตสด · บ่าย: Vibe Coding คืออะไร, ติดตั้ง **VSCode + Claude Code Extension** และ **Git + GitHub Desktop** · การบ้าน: ติดตั้ง Docker, Node.js, VirtualBox |
| 🎮 2 | [Claude Code + Git Bootcamp](day-2-bootcamp/README.md) | **🎮 Claude Code Bootcamp** (โหมด, โมเดล, คำสั่ง `/`), **🌱 Git Bootcamp** (คำสั่ง git ↔ GitHub Desktop), Docker Desktop ผ่านหน้าจอ, Workshop App Idea, `CLAUDE.md` + เตรียม repo โปรเจกต์ |
| 🏗️ 3 | [สร้าง Scaffold โปรเจกต์จริง](day-3-scaffold/README.md) | **🐳 Docker ลงลึก** (image, volume, network, คำสั่ง compose), Scaffold Svelte + Express + Docker Compose จาก Prompt เดียว, UI เชื่อม API, ทดสอบ E2E, Push ขึ้น GitHub |
| 🛡️ 4 | [Testing, Security + Server จำลอง](day-4-testing-security/README.md) | Unit + Integration Test + อ่าน Report, Snyk, OWASP ZAP, สร้าง **VirtualBox VM**, Nessus (สแกน VM ของตัวเอง) |
| 🚀 5 | [CI/CD + Sprint + Deploy + Demo](day-5-cicd-deploy-demo/README.md) | GitHub Actions Workflow, Sprint 2 ชั่วโมง (ปิดฟีเจอร์ + Polish), Deploy ขึ้น VM + **Cloudflare Tunnel** ได้ URL HTTPS, Demo รายบุคคล, แชร์ Prompt/Strategy |

## 📂 โครงสร้าง Repository

```
.
├── day-1-intro/              # วันที่ 1: เปิดหลักสูตร + Vibe Coding + ติดตั้ง VSCode/Claude Code/Git
├── day-2-bootcamp/           # วันที่ 2: Claude Code + Git Bootcamp, Docker, App Idea, CLAUDE.md
│   └── examples/                 # claude-playground/, hello-compose/
├── day-3-scaffold/           # วันที่ 3: Docker ลงลึก + Scaffold โปรเจกต์
├── day-4-testing-security/   # วันที่ 4: Test + Snyk/ZAP + VM + Nessus
│   ├── virtualbox-vm.md          # คู่มือสร้าง Server จำลอง (Ubuntu VM)
│   └── examples/                 # zap-rules.tsv, security-notes.md, vm-setup.sh
├── day-5-cicd-deploy-demo/   # วันที่ 5: GitHub Actions + Sprint + Deploy + Demo
│   └── examples/                 # ci.yml, docker-compose.prod.yml, Caddyfile, backup/restore
├── guides/                   # Cheat sheet Claude Code, Git, Docker, โหมด·โมเดล·ค่าใช้จ่าย, คู่มือโควต้า
├── scripts/                  # check-env.ps1 / check-env.sh ตรวจเครื่องก่อนเรียน
├── templates/                # แม่แบบ CLAUDE.md, App Idea, Demo
├── prompts/                  # คลัง Prompt ที่ใช้ตลอดหลักสูตร
├── CLAUDE.md                 # คำแนะนำสำหรับ Claude เมื่อช่วยแก้ไข repo นี้
├── CREDITS.md                # แหล่งอ้างอิงและเครดิต
├── LICENSE                   # MIT (โค้ด)
└── LICENSE-EDU.md            # CC BY-NC-SA 4.0 (เนื้อหาการสอน)
```

## 🎒 สิ่งที่ต้องเตรียมก่อนเข้าเรียน

- คอมพิวเตอร์ Windows 10/11 (รองรับ WSL2), macOS (Intel) หรือ Linux — **RAM 16 GB ขึ้นไป** (ต้องเปิด Docker Desktop และ VM พร้อมกัน), พื้นที่ว่าง ≥ 60 GB, เปิด Virtualization ใน BIOS แล้ว
- บัญชี [GitHub](https://github.com) และบัญชี [Claude](https://claude.ai) แผน Pro ขึ้นไป (เพื่อใช้ Claude Code)
- บัญชี [Snyk](https://snyk.io) (ฟรี) — ใช้วันที่ 4–5
- Activation Code ของ [Nessus Essentials](https://www.tenable.com/products/nessus/nessus-essentials) (ฟรี, ส่งทางอีเมล) — ใช้วันที่ 4
- สิทธิ์ Admin บนเครื่อง (สำหรับติดตั้ง Docker/WSL2/VirtualBox)
- 📥 วันที่ 1 ติดตั้ง VSCode + Claude Code + Git ในห้อง · Docker, Node.js, VirtualBox เป็น **การบ้านก่อนวันที่ 2** ตาม [วันที่ 1 ข้อ 7](day-1-intro/README.md#-7-การบ้านก่อนวันที่-2-15301600)
- **ไม่ต้องมีโดเมนและไม่ต้องมีบัญชี Cloudflare** — วันที่ 5 ใช้ Cloudflare Quick Tunnel ได้ URL `*.trycloudflare.com` ฟรี

📦 **ดาวน์โหลดไว้ล่วงหน้าได้เลย** (ไฟล์ใหญ่ ห้องอบรมอาจเน็ตช้า): VSCode, Git, GitHub Desktop, Docker Desktop, Node.js LTS, [VirtualBox](https://www.virtualbox.org/wiki/Downloads), ISO ของ [Ubuntu Server LTS](https://ubuntu.com/download/server) (~3 GB)

> ⚠️ Mac ชิป Apple Silicon (M1–M4): VirtualBox รองรับได้จำกัด ให้ใช้ [UTM](https://mac.getutm.app) หรือ Multipass สร้าง Ubuntu VM แทน ขั้นตอนหลังจากนั้นเหมือนกัน

### 🩺 ตรวจความพร้อมของเครื่อง

หลังทำการบ้านติดตั้งเครื่องมือแล้ว ให้รันสคริปต์ตรวจก่อนวันที่ 2 (อ่านอย่างเดียว ไม่แก้ไขอะไรในเครื่อง):

```powershell
# Windows (PowerShell)
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
```
```bash
# macOS / Linux
bash scripts/check-env.sh
```

🔴 แก้ทุกข้อที่เป็น **FAIL** ก่อนวันที่ 2 ส่วน **WARN** ถามวิทยากรได้
สคริปต์จะตรวจ: RAM, พื้นที่ดิสก์, Virtualization, Git, Node.js LTS, VS Code, Claude Code, WSL2, Docker, VirtualBox, ISO ของ Ubuntu, พอร์ตที่ใช้ใน Lab และการเชื่อมต่อ GitHub / Docker Hub / Claude / Cloudflare

รายละเอียดการติดตั้งทีละขั้นอยู่ที่ [วันที่ 1](day-1-intro/README.md)

## 🧭 วิธีใช้ Repo นี้

👩‍🎓 **ผู้เรียน:** Fork หรือ Clone repo นี้ไว้อ่านประกอบ แล้วสร้าง **repo แยก** สำหรับโปรเจกต์ของตัวเอง (สร้างท้ายวันที่ 2) คัดลอกไฟล์จาก `templates/` และ `day-*/examples/` ไปใช้ได้เลย

🧑‍🏫 **วิทยากร:** แต่ละวันมีตารางเวลา, เป้าหมาย, Checklist และ Prompt ตัวอย่าง ปรับเวลาได้ตามกลุ่มผู้เรียน — ส่ง `scripts/check-env.*` ให้ผู้เรียนรันเป็นการบ้านหลังวันที่ 1 และอ่าน [guides/claude-code-efficiency.md](guides/claude-code-efficiency.md) เพื่อเตรียมรับมือเมื่อผู้เรียนใช้โควต้า Claude หมด

## ⚖️ License

Repo นี้ใช้ **dual license**:

| ส่วน | License | ตัวอย่างไฟล์ |
|---|---|---|
| โค้ด, config, workflow, template ที่นำไปรันได้ | [MIT](LICENSE) | `*.yml`, `*.sh`, `*.ps1`, `*.sql`, `Caddyfile`, `templates/CLAUDE.md.template` |
| เนื้อหาการสอน (บทเรียน, คำอธิบาย, แบบฝึกหัด, รูปภาพ) | [CC BY-NC-SA 4.0](LICENSE-EDU.md) | `day-*/README.md`, `guides/*.md`, `prompts/*.md` |

🏫 นำไปใช้สอนในสถาบันการศึกษา/อบรมที่ไม่แสวงหากำไรได้ทันทีโดยให้เครดิต — หากต้องการใช้เชิงพาณิชย์ (เช่น อบรมเก็บเงิน) กรุณาติดต่อผู้จัดทำ

ชื่อทางการค้าที่กล่าวถึง (Claude, Anthropic, Docker, GitHub, VirtualBox, Ubuntu, Cloudflare, Snyk, Nessus ฯลฯ) เป็นของเจ้าของแต่ละราย หลักสูตรนี้ไม่มีส่วนเกี่ยวข้องหรือได้รับการรับรองจากบริษัทเหล่านั้น
