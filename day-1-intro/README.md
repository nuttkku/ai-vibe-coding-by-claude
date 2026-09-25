# 🧰 วันที่ 1 — เปิดหลักสูตร + Vibe Coding + ติดตั้งเครื่องมือ

## 🎯 เป้าหมายของวัน

เมื่อจบวันนี้ ผู้เรียนจะ:
- 👋 รู้จักวิทยากรและเพื่อนร่วมรุ่น เห็นภาพรวมว่า 5 วันนี้จะได้อะไร
- 🧠 อธิบายได้ว่า Vibe Coding คืออะไร และต่างจาก "ให้ AI ช่วยเขียนโค้ด" แบบรับผิดชอบอย่างไร
- 💻 มี **VSCode + Claude Code Extension** ที่ล็อกอินแผน Pro แล้ว และสั่งงาน Claude ได้
- 🌱 มี **Git + GitHub Desktop** ที่ตั้งค่าแล้ว และ clone repo ได้
- 📥 รู้ว่าต้องติดตั้งอะไรเพิ่มเป็นการบ้านก่อนวันที่ 2

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–10:00 | 👋 เปิดหลักสูตร + วิทยากรแนะนำตัว + ภาพรวม 5 วัน |
| 10:00–11:30 | 🙋 ผู้อบรมแนะนำตัว (พักระหว่างทาง 15 นาที) |
| 11:30–12:00 | 🎬 วิทยากรสาธิต Vibe Coding สด + ตรวจบัญชีที่ต้องใช้ |
| 13:00–13:45 | 🧠 Vibe Coding คืออะไร |
| 13:45–14:45 | 💻 ติดตั้ง VSCode + Claude Code Extension + ลองสั่งงานครั้งแรก |
| 14:45–15:30 | 🌱 ติดตั้ง Git + GitHub Desktop + ตั้งค่า + clone repo หลักสูตร |
| 15:30–16:00 | 📥 แจกการบ้าน (ติดตั้ง Docker, Node.js, VirtualBox) + ถาม-ตอบ |

---

## 👋 1. เปิดหลักสูตร (09:00–10:00)

### 🧑‍🏫 วิทยากรแนะนำตัว
- ชื่อ, งานที่ทำ, ประสบการณ์กับ AI coding
- เล่าสั้นๆ ว่า repo หลักสูตรนี้เองก็สร้างด้วย Claude Code ภายใต้การกำกับของวิทยากร — เป็นตัวอย่างของสิ่งที่ผู้เรียนจะได้ทำ

### 🗺️ ภาพรวม 5 วัน

| วัน | หัวข้อ | ผลลัพธ์ |
|---|---|---|
| 🧰 1 | เปิดหลักสูตร + Vibe Coding + ติดตั้งเครื่องมือ | VSCode + Claude Code + Git พร้อมใช้ |
| 🎮 2 | Bootcamp, Docker, App Idea, ฐานข้อมูล, Scaffold + UI | ใช้เครื่องมือคล่อง + แอปของตัวเองรันบน Docker มีหน้า UI เชื่อม API ขึ้น GitHub |
| 🏗️ 3 | Server จำลอง + Cloudflare Tunnel + Login + 2FA + RBAC | มี VM ที่เปิดเว็บออกเน็ตได้ + แอปมีระบบล็อกอิน, 2FA และสิทธิ์ตามบทบาท |
| 🚀 4 | Test + Security + Deploy + Sprint + CI/CD | แอปออนไลน์มี URL + Pipeline CI/CD เขียว |
| 🎤 5 | **Demo Day** (ไม่มีการสอน) | ทุกคนนำเสนอผลงาน Vibe Coding ของตัวเอง |

### 📜 กติกาในห้อง
- 🔑 **ห้ามวางรหัสผ่าน / API key / ข้อมูลส่วนบุคคลจริง ลงใน Prompt**
- 👀 **อ่านคำสั่งก่อนกด Yes ทุกครั้ง** — ไม่เข้าใจให้ถาม
- 🤝 ติดตรงไหนถามเพื่อนข้างๆ ก่อน แล้วค่อยยกมือเรียกวิทยากร
- 💰 โควต้า Claude Pro มีจำกัด — ใช้กับงานของหลักสูตรก่อน

---

## 🙋 2. ผู้อบรมแนะนำตัว (10:00–11:30)

คนละ ~2 นาที ตอบ 5 ข้อ (ขึ้นจอไว้):

1. ชื่อ + หน่วยงาน/สาขา
2. เคยเขียนโปรแกรมมาแค่ไหน (ไม่เคยเลย / เคยบ้าง / ทำงานด้านนี้)
3. เคยใช้ AI ช่วยทำงานอะไรมาบ้าง
4. **มีปัญหาอะไรในงานหรือชีวิตที่อยากสร้างแอปมาแก้** ← สำคัญ
5. คาดหวังอะไรจาก 5 วันนี้

> 💡 **วิทยากร:** จดข้อ 4 ของทุกคนไว้บนกระดาน — วันที่ 2 ใช้เป็นจุดเริ่มต้นของ Workshop App Idea และช่วยจับกลุ่มคนที่ไอเดียคล้ายกันได้
> จดข้อ 2 ไว้ด้วย เพื่อจับคู่คนมีประสบการณ์กับมือใหม่ตอนทำ Lab

---

## 🎬 3. สาธิต Vibe Coding สด + ตรวจบัญชี (11:30–12:00)

**วิทยากรสาธิต ~15 นาที** — ให้ผู้เรียนเห็นภาพก่อนลงมือเอง เช่น

```
สร้างเว็บหน้าเดียวสำหรับสุ่มชื่อผู้อบรมในห้องนี้ มีปุ่ม "สุ่ม" และรายชื่อแก้ไขได้ ใช้ HTML ไฟล์เดียว
```

ระหว่างสาธิตให้ชี้ให้เห็น: Claude วางแผน → ขออนุญาต → สร้างไฟล์ → เปิดดูผล → สั่งแก้ต่อ ("ขอสีสันสดใสขึ้น", "เพิ่มเสียงตอนสุ่ม")

**ตรวจบัญชีที่ต้องใช้บ่ายนี้** (ให้ทุกคนเปิดดูในมือถือหรือเบราว์เซอร์):
- [ ] บัญชี [Claude](https://claude.ai) แผน **Pro** ขึ้นไป ล็อกอินได้
- [ ] บัญชี [GitHub](https://github.com) ล็อกอินได้
- [ ] สิทธิ์ Admin บนเครื่อง (ติดตั้งโปรแกรมได้)

---

## 🧠 4. Vibe Coding คืออะไร (13:00–13:45)

คำว่า **"vibe coding"** ถูกบัญญัติโดย Andrej Karpathy (ก.พ. 2025) หมายถึงการเขียนโปรแกรมโดย "บอกสิ่งที่ต้องการ" เป็นภาษาธรรมชาติ แล้วปล่อยให้ AI เขียนโค้ด ผู้พัฒนาเน้นดูผลลัพธ์ ลองรัน แล้วสั่งแก้ต่อ แทนการพิมพ์โค้ดเองทุกบรรทัด

### 🌈 สเปกตรัมของการใช้ AI เขียนโค้ด

```
 Pure Vibe Coding  ←──────────────────────────────→  AI-Assisted Engineering
 "ไม่อ่านโค้ด แค่ดูว่ารันได้"                         "AI เขียน เราอ่าน/ทดสอบ/รับผิดชอบ"
 เหมาะ: prototype, ของเล่น, ทดลองไอเดีย               เหมาะ: งานจริง, ขึ้น production, มีข้อมูลผู้ใช้
```

หลักสูตรนี้ **เริ่มจากฝั่งซ้าย** (เร็ว สนุก ได้ของจริง) แล้ว **ค่อยๆ ขยับไปฝั่งขวา** ด้วย Test, Security Scan และ CI/CD ในวันที่ 4–5

### 🌟 หลัก 5 ข้อของ Vibe Coder ที่ดี

1. **คุณคือ Product Owner + Reviewer** — Claude คือนักพัฒนาที่เร็วมาก แต่ไม่รู้ว่าคุณต้องการอะไรถ้าไม่บอก
2. **บริบทคือทุกอย่าง** — `CLAUDE.md`, ไฟล์ตัวอย่าง, error message เต็มๆ ช่วยได้มากกว่า Prompt ยาวๆ
3. **ทีละก้าวเล็กๆ + Commit บ่อย** — ถ้า AI พาหลงทาง ย้อนกลับได้ทันที
4. **เชื่อแต่ตรวจสอบ (Trust, but verify)** — รันจริง, ดู Test, ดูผลสแกน ไม่ใช่เชื่อคำว่า "เสร็จแล้ว"
5. **ความลับไม่เข้า Prompt/Repo** — รหัสผ่าน, API key อยู่ใน `.env` และ `.gitignore` เสมอ

### 🗣️ กิจกรรมอภิปราย (10 นาที)
- งานแบบไหนที่คุณจะ "vibe" ได้เต็มที่? งานแบบไหนที่ต้องอ่านโค้ดทุกบรรทัด?
- ถ้าแอปที่ AI เขียนมีช่องโหว่แล้วข้อมูลรั่ว ใครรับผิดชอบ?

---

## 💻 5. ติดตั้ง VSCode + Claude Code (13:45–14:45)

### 🟦 5.1 VSCode
ดาวน์โหลดจาก <https://code.visualstudio.com> ติดตั้งแบบค่าเริ่มต้น (Windows: ติ๊ก **"Add to PATH"** และ **"Open with Code"**)

### 🧩 5.2 Claude Code Extension
1. เปิด VSCode → Extensions (`Ctrl+Shift+X`) → ค้นหา **"Claude Code"** (ผู้เผยแพร่: **Anthropic**) ⚠️ ระวัง extension ปลอมชื่อคล้ายกัน
2. กด **Install** แล้วคลิกไอคอน Claude ที่ Sidebar
3. ล็อกอินด้วยบัญชี Claude **Pro** ตามที่หน้าจอแนะนำ
4. (แนะนำ) ติดตั้ง CLI ด้วย เพื่อใช้ `claude` ใน Terminal ได้ ตามวิธีล่าสุดใน <https://docs.anthropic.com/en/docs/claude-code/setup>

### 🖐️ 5.3 เปลี่ยนเป็นโหมด Manual ก่อนใช้งาน
แผน Pro เริ่มต้นที่โหมด **Auto** (Claude ทำเองโดยไม่ถาม) — สำหรับผู้เริ่มต้นให้ **คลิกตัวบอกโหมดใต้ช่องพิมพ์ แล้วเลือก Manual** เพื่อให้ Claude ขออนุญาตทุกครั้งก่อนแก้ไฟล์หรือรันคำสั่ง (รายละเอียดทุกโหมดเรียนวันที่ 2)

### 🔍 5.4 ลองสั่งงานครั้งแรก
สร้างโฟลเดอร์ว่าง เช่น `~/first-vibe` → เปิดด้วย VSCode (File → Open Folder) → พิมพ์ในช่อง Claude:

```
สร้างไฟล์ hello.html ที่แสดงคำว่า "สวัสดี Vibe Coding" ตัวใหญ่กลางจอ พื้นหลังไล่สี แล้วบอกวิธีเปิดดู
```

สังเกต: Claude **ขออนุญาต** ก่อนสร้างไฟล์ → กด Yes → เปิด `hello.html` ในเบราว์เซอร์ → สั่งแก้ต่อ 2–3 รอบ เช่น
```
เพิ่มนาฬิกาบอกเวลาปัจจุบันใต้ข้อความ
```

✅ เห็นหน้าเว็บของตัวเอง = Claude Code พร้อมใช้

---

## 🌱 6. ติดตั้ง Git + GitHub Desktop (14:45–15:30)

### 📥 6.1 ติดตั้ง
- **Git** — Windows: <https://git-scm.com/download/win> (ติดตั้งค่าเริ่มต้น จะได้ Git Bash มาด้วย) · macOS: `xcode-select --install`
- **GitHub Desktop** — <https://desktop.github.com> แล้ว **ล็อกอินบัญชี GitHub** (File → Options → Accounts)

### ⚙️ 6.2 ตั้งค่าตัวตน
เปิด Terminal ใน VSCode (`` Ctrl+` ``):
```bash
git --version
git config --global user.name "ชื่อ นามสกุล"
git config --global user.email "you@example.com"     # ใช้อีเมลเดียวกับบัญชี GitHub
```

### 📦 6.3 Clone repo หลักสูตร
GitHub Desktop → **File → Clone repository → URL** → วาง URL ของ repo หลักสูตร → เลือกที่เก็บ → **Clone** → **Open in Visual Studio Code**

ลองถาม Claude ใน repo ที่เพิ่ง clone:
```
repo นี้คืออะไร มีโฟลเดอร์อะไรบ้าง สรุปสั้นๆ 5 บรรทัด
```

> 💡 วันนี้แค่ติดตั้งและ clone ได้ — คำสั่ง git (`commit`, `diff`, `branch`, `push` …) และการใช้คู่กับ GitHub Desktop เรียนเต็มๆ ใน **Git Bootcamp วันที่ 2**

---

## 📥 7. การบ้านก่อนวันที่ 2 (15:30–16:00)

ติดตั้งที่บ้าน/ที่ทำงานให้เสร็จ **ก่อนเช้าวันที่ 2** (ไฟล์ใหญ่ ใช้เวลาดาวน์โหลด):

<details>
<summary>🐧 <b>WSL2 + Docker Desktop</b></summary>

1. Windows: เปิด **PowerShell (Run as Administrator)** → `wsl --install` → รีสตาร์ท → ตรวจ `wsl -l -v` ต้องเห็น VERSION 2
2. ดาวน์โหลด Docker Desktop <https://www.docker.com/products/docker-desktop/> (Windows: ติ๊ก **Use WSL 2**)
3. เปิด Docker Desktop รอ *Engine running* แล้วทดสอบ `docker run --rm hello-world`

> ⚠️ ถ้าเจอ error เรื่อง Virtualization ให้เปิด **Intel VT-x / AMD-V (SVM)** ใน BIOS

</details>

<details>
<summary>🟩 <b>Node.js LTS</b></summary>

ดาวน์โหลด **LTS** (เลขเวอร์ชันคู่) จาก <https://nodejs.org> แล้วตรวจ `node -v` · `npm -v` — PostgreSQL **ไม่ต้องติดตั้ง** ใช้ผ่าน Docker

</details>

<details>
<summary>🖥️ <b>VirtualBox + ISO ของ Ubuntu Server</b> (ใช้เช้าวันที่ 3)</summary>

ดาวน์โหลด VirtualBox <https://www.virtualbox.org/wiki/Downloads> และ ISO ของ Ubuntu Server LTS <https://ubuntu.com/download/server> (~3 GB) ไว้ในโฟลเดอร์ Downloads

</details>

<details>
<summary>📝 <b>บัญชีที่ต้องสมัครล่วงหน้า</b></summary>

- [Snyk](https://snyk.io) (ฟรี) — ใช้วันที่ 4
- Activation Code ของ [Nessus Essentials](https://www.tenable.com/products/nessus/nessus-essentials) (ฟรี ส่งทางอีเมล) — ใช้วันที่ 4

</details>

**ติดตั้งเสร็จแล้วรันตัวตรวจ** (อยู่ใน repo หลักสูตรที่ clone ไว้):
```powershell
# Windows
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
```
```bash
# macOS / Linux
bash scripts/check-env.sh
```
แก้ข้อที่เป็น **FAIL** ให้หมด — ถ้าแก้ไม่ได้ จดข้อความไว้ถามวิทยากรเช้าวันที่ 2

---

## ✅ Checklist ท้ายวัน

- [ ] แนะนำตัวแล้ว และบอก "ปัญหาที่อยากสร้างแอปมาแก้" ได้ 1 เรื่อง
- [ ] Claude Code Extension ล็อกอินแผน Pro แล้ว อยู่ในโหมด **Manual**
- [ ] สร้าง `hello.html` ด้วย Claude และสั่งแก้ต่อได้
- [ ] `git --version` ขึ้นเวอร์ชัน และตั้ง `user.name` / `user.email` แล้ว
- [ ] ล็อกอิน GitHub Desktop และ clone repo หลักสูตรได้
- [ ] รู้ว่าการบ้านมีอะไร (Docker, Node.js, VirtualBox + ISO, สมัคร Snyk/Nessus, รัน `check-env`)

## 🛠️ Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| หา Extension "Claude Code" ไม่เจอ / มีหลายตัว | เลือกตัวที่ผู้เผยแพร่เป็น **Anthropic** เท่านั้น |
| Claude Code ล็อกอินไม่ได้ | ตรวจว่าบัญชีเป็นแผน Pro ขึ้นไป, Sign out แล้วเข้าใหม่, ปิด-เปิด VSCode |
| Claude ทำไปเองโดยไม่ถาม | ยังอยู่โหมด Auto — คลิกตัวบอกโหมดใต้ช่องพิมพ์ → Manual |
| `git` ไม่พบคำสั่ง | ปิดแล้วเปิด VSCode/Terminal ใหม่ (ให้โหลด PATH ใหม่) |
| GitHub Desktop ขึ้น author ผิดคน | ตั้ง `git config --global user.email` ให้ตรงกับบัญชี GitHub |
| เครื่องของหน่วยงานติดตั้งโปรแกรมไม่ได้ | ขอสิทธิ์ Admin จากฝ่ายไอที หรือจับคู่ใช้เครื่องเพื่อนไปก่อน |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "แนวคิด Vibe Coding", "Claude / Anthropic" และ "เครื่องมือพัฒนา"

---

<p align="center">⬅️ — · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../day-2-bootcamp/README.md">🎮 วันที่ 2 ➡️</a></p>
