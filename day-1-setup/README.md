# 🧰 วันที่ 1 — เตรียมเครื่องมือ + ปูพื้นฐานแนวคิด

## 🎯 เป้าหมายของวัน

เมื่อจบวันนี้ ผู้เรียนจะ:
- 🧠 อธิบายได้ว่า Vibe Coding คืออะไร และต่างจาก "ให้ AI ช่วยเขียนโค้ด" แบบรับผิดชอบอย่างไร
- 🎮 **รู้จักคำสั่ง `/` ของ Claude Code ที่ต้องใช้** — ใช้ทุกวัน (`/clear` `/compact` `/context` `/usage` `/rewind` `/memory` ...), ตั้งค่า/สิทธิ์ (`/permissions` `/status` `/doctor` ...), ขั้นสูง (`/review` `/security-review` `/agents` `/mcp` `/hooks`) และสร้างคำสั่งของตัวเองได้
- 🌱 **อ่านและใช้คำสั่ง git หลักได้** และรู้ว่าแต่ละคำสั่งตรงกับปุ่มไหนใน GitHub Desktop
- 🧰 มีเครื่องมือครบ: VSCode + Claude Code, Git + GitHub Desktop, Docker Desktop (WSL2), Node.js LTS
- 🖥️ มี **Server จำลอง (VirtualBox VM, Ubuntu Server)** ที่ SSH เข้าได้และมี Docker พร้อมใช้ในวันที่ 3 และ 5
- 💡 มี App Idea ของตัวเองเขียนเป็น Prompt พร้อมใช้ในวันที่ 2

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| **ก่อนเรียน** | 📥 ติดตั้งเครื่องมือทั้งหมดตาม [ข้อ 0](#-0-การบ้านก่อนเรียน-ติดตั้งเครื่องมือ) แล้วรัน `check-env` |
| 09:00–09:30 | 🧠 Mindset: Vibe Coding คืออะไร |
| 09:30–09:45 | 🩺 ตรวจเครื่อง (`check-env`) + ล็อกอิน Claude Code |
| 09:45–11:00 | 🎮 **Claude Code Bootcamp** — คำสั่ง `/` ที่ต้องรู้ทีละตัว + ลองกดจริง |
| 11:00–12:00 | 🌱 **Git Bootcamp** — คำสั่ง git ↔ GitHub Desktop |
| 13:00–13:30 | 🐳 Lab: Docker Compose + 🧪 Lab รวม Claude Code (+ แก้เครื่องที่ติดตั้งไม่ผ่าน) |
| 13:30–14:45 | 🖥️ สร้าง VirtualBox VM + ติดตั้ง Docker บน VM + Snapshot |
| 14:45–16:00 | 💡 Workshop: เขียน Prompt App Idea |

> 💡 ช่วงเช้าเป็น **ลงมือทำ 2 ชั่วโมงเต็ม** ไม่ใช่นั่งฟัง — วิทยากรสาธิตทีละคำสั่ง แล้วให้ผู้เรียนกดตามทันที เดินดูทีละเครื่อง
> ผู้เรียนที่ยังติดตั้งไม่เสร็จ ให้จับคู่กับเพื่อนทำ Bootcamp ไปก่อน แล้วค่อยแก้เครื่องช่วง 13:00

---

## 📥 0. การบ้านก่อนเรียน: ติดตั้งเครื่องมือ

ทำให้เสร็จ **ก่อนวันแรก** แล้วรัน `scripts/check-env.ps1` (Windows) หรือ `scripts/check-env.sh` (macOS/Linux) ให้ไม่มี FAIL

<details>
<summary>🟦 <b>VSCode + Claude Code</b></summary>

1. ดาวน์โหลด VSCode จาก <https://code.visualstudio.com> (Windows: ติ๊ก "Add to PATH" และ "Open with Code")
2. สมัคร <https://claude.ai> แล้วอัปเกรดเป็นแผน **Pro** ขึ้นไป (รวมสิทธิ์ Claude Code) — รายละเอียดแผน: <https://www.anthropic.com/pricing>
3. VSCode → Extensions (`Ctrl+Shift+X`) → ค้นหา **"Claude Code"** (ผู้เผยแพร่: Anthropic) → Install → คลิกไอคอน Claude ที่ Sidebar → ล็อกอิน
4. (แนะนำ) ติดตั้ง CLI ด้วย เพื่อใช้ `claude` ใน Terminal ได้ ตามวิธีล่าสุดใน <https://docs.anthropic.com/en/docs/claude-code/setup>

</details>

<details>
<summary>🌱 <b>Git + GitHub Desktop</b></summary>

- Windows: <https://git-scm.com/download/win> (ค่าเริ่มต้น จะได้ Git Bash มาด้วย) · macOS: `xcode-select --install`
- GitHub Desktop: <https://desktop.github.com> แล้วล็อกอินบัญชี GitHub
- ตั้งค่าตัวตน:
  ```bash
  git config --global user.name "ชื่อ นามสกุล"
  git config --global user.email "you@example.com"
  ```

</details>

<details>
<summary>🐧 <b>WSL2 + Docker Desktop</b></summary>

1. Windows: เปิด **PowerShell (Run as Administrator)** → `wsl --install` → รีสตาร์ท → ตรวจ `wsl -l -v` ต้องเห็น VERSION 2
2. ดาวน์โหลด Docker Desktop <https://www.docker.com/products/docker-desktop/> (Windows: ติ๊ก **Use WSL 2**)
3. เปิด Docker Desktop รอ *Engine running* แล้วทดสอบ `docker run --rm hello-world`

> ⚠️ ถ้าเจอ error เรื่อง Virtualization ให้เปิด **Intel VT-x / AMD-V (SVM)** ใน BIOS

</details>

<details>
<summary>🟩 <b>Node.js LTS + PostgreSQL</b></summary>

- ดาวน์โหลด **LTS** (เลขเวอร์ชันคู่) จาก <https://nodejs.org> แล้วตรวจ `node -v` · `npm -v`
- PostgreSQL: **ไม่ต้องติดตั้งลงเครื่อง** ใช้ผ่าน Docker ใน Lab (ถ้าอยากติดตั้งเอง: <https://www.postgresql.org/download/>)
- แนะนำ VSCode Extension **"PostgreSQL"** หรือ **"SQLTools"** ไว้ดูข้อมูล

</details>

<details>
<summary>🖥️ <b>VirtualBox + ISO</b></summary>

ดาวน์โหลด VirtualBox <https://www.virtualbox.org/wiki/Downloads> และ ISO ของ Ubuntu Server LTS <https://ubuntu.com/download/server> (~3 GB) ไว้ในโฟลเดอร์ Downloads — สร้าง VM ในห้องเรียน

</details>

---

## 🧠 1. Mindset: Vibe Coding คืออะไร

คำว่า **"vibe coding"** ถูกบัญญัติโดย Andrej Karpathy (ก.พ. 2025) หมายถึงการเขียนโปรแกรมโดย "บอกสิ่งที่ต้องการ" เป็นภาษาธรรมชาติ แล้วปล่อยให้ AI เขียนโค้ด ผู้พัฒนาเน้นดูผลลัพธ์ ลองรัน แล้วสั่งแก้ต่อ แทนการพิมพ์โค้ดเองทุกบรรทัด

### 🌈 สเปกตรัมของการใช้ AI เขียนโค้ด

```
 Pure Vibe Coding  ←──────────────────────────────→  AI-Assisted Engineering
 "ไม่อ่านโค้ด แค่ดูว่ารันได้"                         "AI เขียน เราอ่าน/ทดสอบ/รับผิดชอบ"
 เหมาะ: prototype, ของเล่น, ทดลองไอเดีย               เหมาะ: งานจริง, ขึ้น production, มีข้อมูลผู้ใช้
```

หลักสูตรนี้ **เริ่มจากฝั่งซ้าย** (เร็ว สนุก ได้ของจริงในวันเดียว) แล้ว **ค่อยๆ ขยับไปฝั่งขวา** ด้วย Test, Security Scan และ CI/CD ในวันที่ 3–4

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

## 🎮 2. Claude Code Bootcamp

**เป้าหมายของช่วงนี้:** รู้จัก **คำสั่ง `/` ทุกตัวที่ผู้ใช้ Claude Code ควรรู้** — ทำอะไร, ใช้ตอนไหน, และได้ลองกดจริงทุกตัว

> 📖 เปิด **[Claude Code Cheat Sheet](../guides/claude-code-commands.md)** ไว้ข้างจอ · พิมพ์ `/` ในช่องแชทเพื่อดูรายการคำสั่งจริงในเวอร์ชันของคุณ (รายชื่ออาจต่างเล็กน้อยตามเวอร์ชัน)
> ⚠️ คำสั่งส่วนใหญ่ใช้ได้ทั้งใน VS Code Extension และ CLI — ถ้าคำสั่งไหน **ไม่ขึ้นใน Extension** ให้เปิด Terminal (`` Ctrl+` ``) พิมพ์ `claude` แล้วใช้ที่นั่น

| ช่วง | เวลา | เนื้อหา |
|---|---|---|
| 🎒 เตรียม | 5 นาที | คัดลอก playground + ปุ่มพื้นฐาน `/` `@` `!` |
| 🚦 โหมด | 10 นาที | Manual / Edit / Plan / Auto / Bypass — **เปลี่ยนเป็น Manual ก่อนเริ่ม** |
| 🧠 โมเดล | 10 นาที | Haiku / Sonnet / Opus / Fable, effort, ค่าใช้จ่ายแบบย่อ |
| ⭐ ระดับ 1 | 30 นาที | 10 คำสั่งที่ใช้ทุกวัน |
| 🔧 ระดับ 2 | 10 นาที | ตั้งค่า, สิทธิ์, แก้ปัญหา |
| 🚀 ระดับ 3 + 🧩 สร้างเอง | 10 นาที | คำสั่งขั้นสูง (รู้จักไว้) + custom command |
| 🧪 Lab รวม | ย้ายไป 13:00 | ใช้ทุกอย่างแก้บั๊กให้ test ผ่าน (ทำคู่กับ Lab Docker) |

### 🎒 เตรียม: playground + ปุ่มพื้นฐาน

คัดลอกโฟลเดอร์ฝึก [`examples/claude-playground/`](examples/claude-playground/) ออกไปไว้ **นอก** repo หลักสูตร แล้วเปิดด้วย VSCode:

```bash
# macOS / Linux / Git Bash
cp -r day-1-setup/examples/claude-playground ~/vibe-playground && code ~/vibe-playground
```
```powershell
# Windows PowerShell
Copy-Item -Recurse day-1-setup\examples\claude-playground $HOME\vibe-playground; code $HOME\vibe-playground
```

ในโฟลเดอร์มี `calc.js` (**บั๊กจงใจ 3 จุด**) และ `calc.test.js` (ตอนนี้ fail 4 ข้อ)

**ตัวอักษรพิเศษ 3 ตัวในช่องพิมพ์** — ต้องรู้ก่อนเริ่ม:

| พิมพ์ | ความหมาย | ลองเลย |
|---|---|---|
| `/` | เปิดเมนูคำสั่ง (พิมพ์ต่อเพื่อกรอง เช่น `/co` → `/compact`, `/context`, `/config`) | พิมพ์ `/` แล้วเลื่อนดูทั้งหมด |
| `@` | อ้างไฟล์ให้ Claude อ่านตรงนั้น | `อธิบาย @calc.js สั้นๆ ยังไม่ต้องแก้` |
| `!` | รันคำสั่ง shell เอง ผลลัพธ์เข้าไปในบทสนทนา | `! npm test` |

และปุ่มที่คู่กับคำสั่ง: **ตัวบอกโหมด** ใต้ช่องพิมพ์ (CLI: `Shift+Tab`) สลับโหมด · **`Esc`** หยุด Claude · **`Esc Esc`** = `/rewind`

---

### 🚦 โหมดทำงาน — Claude ทำอะไรได้เองบ้าง (10 นาที)

> 📖 รายละเอียดเต็ม: **[โหมด · โมเดล · ค่าใช้จ่าย](../guides/modes-models-costs.md#-ส่วนที่-1-โหมดสิทธิ์-permission-modes)**

| โหมด (ชื่อใน VS Code) | Claude ทำได้เองโดยไม่ถาม | ใช้ในหลักสูตร |
|---|---|---|
| 🖐️ **Manual** | อ่านไฟล์เท่านั้น — แก้ไฟล์/รันคำสั่ง ถามทุกครั้ง | ✅ วันที่ 1–2 |
| ✏️ **Edit automatically** | อ่าน + แก้ไฟล์ + คำสั่งไฟล์พื้นฐาน — คำสั่งอื่นยังถาม | ✅ หลัง commit แล้ว |
| 🗺️ **Plan** | อ่าน + วางแผน **ห้ามแก้ไฟล์จนกว่าเราอนุมัติแผน** | ✅ ก่อนงานใหญ่ทุกครั้ง |
| 🤖 **Auto** | ทุกอย่าง โดยมีโมเดลอีกตัวตรวจแต่ละ action เบื้องหลัง | ⚠️ วันที่ 4–5 เมื่อ commit แล้ว + มีกฎ deny |
| ☠️ **Bypass permissions** | ทุกอย่าง ไม่ตรวจอะไร | ❌ ห้ามใช้ |

⚠️ **แผน Pro/Max/Team เริ่มต้นที่ Auto** — Claude จะแก้ไฟล์และรันคำสั่งเองโดยไม่ถาม **ก่อนเริ่มแบบฝึกทั้งหมด ให้คลิกตัวบอกโหมดใต้ช่องพิมพ์ แล้วเลือก Manual** (Extension จำค่าไว้ให้บทสนทนาถัดไป) · ใน Terminal กด `Shift+Tab` จนเห็น `⏸ manual mode on`

🧪 **ลองเลย:** สั่งงานเดียวกัน `เพิ่ม comment อธิบายฟังก์ชัน total ใน @calc.js` ใน 3 โหมด แล้วเทียบกัน
1. **Plan** → ได้แผน แต่ไฟล์ไม่เปลี่ยน → ตอบว่าไม่อนุมัติ
2. **Manual** → Claude ขออนุญาตก่อนแก้ → กด **No** แล้วพิมพ์เหตุผล "ขอเป็นภาษาไทย"
3. **Edit automatically** → แก้ทันทีไม่ถาม → ดูผล แล้ว `/rewind` ย้อนกลับ

💡 กฎ `deny` ใน `.claude/settings.json` (สอนตอน `/permissions`) **บล็อกได้ทุกโหมด** แม้แต่ Auto — จึงเป็นด่านสุดท้ายที่ไว้ใจได้

### 🧠 โมเดลและระดับการคิด — เลือกสมองให้เหมาะกับงาน (10 นาที)

> 📖 รายละเอียดเต็ม รวมราคาและวิธีคิดเงินแต่ละแบบ: **[โหมด · โมเดล · ค่าใช้จ่าย](../guides/modes-models-costs.md#-ส่วนที่-2-โมเดล-models)**

| รุ่น (`/model`) | จุดเด่น | ราคา API ต่อล้าน token (in/out) | ใช้เมื่อ |
|---|---|---|---|
| ⚡ `haiku` (Haiku 4.5) | เร็ว ถูกที่สุด | $1 / $5 | งานเล็กตรงไปตรงมา |
| 🎯 `sonnet` (Sonnet 5) | สมดุล | $2 / $10 | **งานส่วนใหญ่ในหลักสูตร** |
| 🧠 `opus` (Opus 5.5) | คิดลึก — ค่าเริ่มต้นของ Claude Code | $4 / $20 | ออกแบบระบบ, บั๊กยาก |
| 🏆 `fable` (Fable 5.1) | ความสามารถสูงสุด | $10 / $50 | งานยากที่สุด (Pro ต้องใช้ usage credits) |
| ⭐ `opusplan` | Opus ตอนวางแผน → Sonnet ตอนลงมือ | — | วางแผน Sprint แบบประหยัด |

- **Effort** (`/effort`): `low` → `medium` → `high` → `xhigh` → `max` — ยิ่งสูงยิ่งคิดนาน แม่นขึ้น แต่ **token ที่ใช้คิดคิดเงิน/โควต้าเป็น output** (แพงกว่า input 5 เท่า)
- **`ultrathink`** ในข้อความ = ขอให้คิดลึกเฉพาะข้อความนั้น
- รุ่นใหญ่และ effort สูง **กินโควต้า Pro เร็วกว่า** — ค่าเริ่มต้นเป็น Opus ถ้าอยากประหยัดให้ `/model sonnet`

🧪 **ลองเลย:**
1. `/model` → ดูว่าบัญชีคุณเลือกรุ่นไหนได้ และตอนนี้ใช้รุ่นอะไร
2. `/model sonnet` → ถาม `อธิบาย @calc.js ใน 3 บรรทัด` → `/usage` จดตัวเลข
3. `/model opus` → ถามคำถามเดิม → `/usage` อีกครั้ง → เทียบคุณภาพคำตอบกับโควต้าที่ใช้
4. `/effort` ลองเลื่อนดูระดับ แล้วตั้งกลับเป็นค่าเดิม

💰 **ค่าใช้จ่ายแบบย่อ:** แผน Pro ($20/เดือน) = โควต้ารอบ 5 ชั่วโมง + รายสัปดาห์ **ใช้ร่วมกับแชทบน claude.ai** · หมดแล้วรอรีเซ็ต หรือเปิด **usage credits** (จ่ายเพิ่มตามราคา API — ตั้ง spend limit ทุกครั้ง) · แบบ API key จ่ายทุก token ตามจริง — ตารางราคาและตัวอย่างคำนวณอยู่ใน[คู่มือ](../guides/modes-models-costs.md#-ส่วนที่-3-ค่าใช้จ่าย)

---

### ⭐ ระดับ 1 — 10 คำสั่งที่ใช้ทุกวัน

#### `/help` — ดูคำสั่งทั้งหมด
- **ทำอะไร:** แสดงรายการคำสั่งและปุ่มลัดของเวอร์ชันที่ใช้อยู่
- **ใช้เมื่อ:** จำคำสั่งไม่ได้, อยากรู้ว่าเวอร์ชันนี้มีคำสั่งอะไรใหม่
- 🧪 **ลองเลย:** พิมพ์ `/help` แล้วหาว่ามีคำสั่งไหนที่ไม่อยู่ในบทเรียนนี้บ้าง

#### `/init` — ให้ Claude สร้าง `CLAUDE.md`
- **ทำอะไร:** Claude อ่านทั้งโปรเจกต์ แล้วเขียน `CLAUDE.md` สรุปโครงสร้าง คำสั่ง และแนวทางของโปรเจกต์
- **ใช้เมื่อ:** เริ่มโปรเจกต์ใหม่ หรือเปิดโปรเจกต์ที่มีโค้ดอยู่แล้วครั้งแรก
- 🧪 **ลองเลย:** `/init` → เปิดไฟล์ `CLAUDE.md` ที่ได้ อ่านว่า Claude เข้าใจโปรเจกต์ถูกไหม
- ⚠️ ร่างแรกมักยาวเกิน — ตัดให้เหลือแต่กฎที่สำคัญ (Claude อ่านไฟล์นี้ **ทุกรอบ** ยิ่งยาวยิ่งเปลืองโควต้า)

#### `/memory` — แก้ความจำของ Claude
- **ทำอะไร:** เปิดไฟล์ความจำให้แก้ — `CLAUDE.md` ของโปรเจกต์ หรือ `~/.claude/CLAUDE.md` ที่ใช้กับทุกโปรเจกต์
- **ใช้เมื่อ:** ต้องบอก Claude เรื่องเดิมเป็นครั้งที่ 2 → ใส่ลงความจำแทน
- 🧪 **ลองเลย:** `/memory` → เลือกไฟล์โปรเจกต์ → เพิ่ม 2 บรรทัด:
  ```
  - ตอบเป็นภาษาไทยเสมอ
  - ทุกครั้งที่แก้ calc.js ต้องรัน npm test ให้ผ่านก่อนรายงานว่าเสร็จ
  ```
  แล้ว `/clear` และสั่ง `เพิ่มฟังก์ชัน max(prices)` → สังเกตว่า Claude รัน test เอง **โดยไม่ต้องบอก**

#### `/clear` — ล้างบทสนทนา เริ่มงานใหม่ ⭐ ใช้บ่อยที่สุด
- **ทำอะไร:** ลบประวัติแชททั้งหมด (ไฟล์ไม่หาย และ `CLAUDE.md` ยังถูกอ่านเหมือนเดิม)
- **ใช้เมื่อ:** **จบ 1 task ทุกครั้ง** (commit แล้ว → `/clear`), Claude เริ่มสับสนหรือวนแก้บั๊กเดิม
- 🧪 **ลองเลย:** ถาม `ในไฟล์ calc.js มีกี่ฟังก์ชัน` → `/clear` → ถาม `เมื่อกี้ฉันถามอะไร` (Claude จะจำไม่ได้แล้ว)
- 💡 ทำไมสำคัญ: ทุกข้อความใหม่ Claude ต้องอ่านประวัติทั้งหมดซ้ำ — บทสนทนายาว = เปลืองโควต้า + ช้า + สับสน

#### `/compact` — ย่อบทสนทนาแต่ทำงานเดิมต่อ
- **ทำอะไร:** ให้ Claude สรุปประวัติเหลือเฉพาะสาระ ใส่คำแนะนำต่อท้ายได้ว่าให้เก็บอะไร
- **ใช้เมื่อ:** งานยังไม่จบแต่บทสนทนายาวมาก (ต่างจาก `/clear` ที่ใช้ตอน **เปลี่ยน** งาน)
- 🧪 **ลองเลย:** `/compact เก็บเฉพาะเรื่องบั๊กใน calc.js ที่ยังไม่ได้แก้`

#### `/context` — ดูว่าบริบทใช้ไปเท่าไหร่
- **ทำอะไร:** แสดงว่าบริบท (ความจำระยะสั้นของ session) เต็มแค่ไหน และอะไรกินพื้นที่ — ประวัติแชท, `CLAUDE.md`, ไฟล์ที่อ่าน
- **ใช้เมื่อ:** Claude เริ่มลืมกฎ, ตอบช้าลง, ตัดสินใจว่าจะ `/compact` หรือ `/clear`
- 🧪 **ลองเลย:** `/context` → สั่ง `อ่าน @calc.js และ @calc.test.js` → `/context` อีกครั้ง เทียบว่าเพิ่มขึ้นเท่าไหร่

#### `/usage` — ดูโควต้าแผน Pro ที่เหลือ
- **ทำอะไร:** แสดงการใช้งานเทียบกับขีดจำกัดของแผน และเวลาที่จะรีเซ็ต
- **ใช้เมื่อ:** ก่อนเริ่มงานใหญ่ (Scaffold วันที่ 2, Sprint วันที่ 4), รู้สึกว่าใกล้หมด
- 🧪 **ลองเลย:** `/usage` แล้วจดไว้ — ท้ายวันดูอีกครั้งว่าวันนี้ใช้ไปเท่าไหร่
- 💡 ส่วน **Session** ใน `/usage` แสดงเป็นเงิน ($) — สำหรับแผน Pro/Max เป็น **ค่าประเมินตามราคา API ไม่ได้เรียกเก็บจริง** (มีผลจริงเฉพาะผู้ใช้แบบ API key) · หมดโควต้าแล้วอยากทำต่อ: `/usage-credits` · อ่านวิธีประหยัดใน [คู่มือโควต้า](../guides/claude-code-efficiency.md)

#### `/model` · `/effort` — เลือกรุ่นโมเดลและระดับการคิด
- **ทำอะไร:** `/model` สลับรุ่น (`sonnet`, `opus`, `haiku`, `fable`, `opusplan`) · `/effort` ตั้งระดับการคิด (`low` … `max`)
- **ใช้เมื่อ:** ลองแล้วในหัวข้อ 🧠 โมเดล ด้านบน — จำไว้ว่า **`sonnet` สำหรับงานประจำ, `opus` สำหรับงานยาก**
- 🧪 **ลองเลย:** `/model` ดูว่าตอนนี้ใช้รุ่นไหนอยู่ (ถ้ายังเป็น Opus และอยากประหยัดโควต้า → `/model sonnet`)

#### `/rewind` — ปุ่ม Undo ของ AI (หรือกด `Esc Esc`)
- **ทำอะไร:** ย้อนกลับไปจุดก่อนหน้าในบทสนทนา เลือกได้ว่าจะย้อน **เฉพาะแชท**, **เฉพาะโค้ด** หรือ **ทั้งคู่**
- **ใช้เมื่อ:** Claude แก้ไปผิดทาง อยากกลับไปก่อนสั่งคำสั่งนั้นแล้วสั่งใหม่ให้ดีกว่าเดิม
- 🧪 **ลองเลย:**
  1. สั่ง `เปลี่ยนชื่อทุกฟังก์ชันใน calc.js เป็นภาษาไทย` → ดูว่าไฟล์เปลี่ยน
  2. `/rewind` → เลือกข้อความก่อนหน้า → ย้อน **โค้ดและแชท** → ไฟล์กลับเหมือนเดิม
- ⚠️ `/rewind` ย้อนได้เฉพาะไฟล์ที่ Claude **แก้ผ่านเครื่องมือแก้ไฟล์** — สิ่งที่เกิดจากคำสั่ง shell (เช่น ลบไฟล์ด้วย `rm`, `git commit`) ย้อนไม่ได้ → **git ยังจำเป็นเสมอ** (Session 3)

#### `/resume` — กลับไปบทสนทนาเก่า
- **ทำอะไร:** แสดงรายการ session ก่อนหน้าให้เลือกกลับไปทำต่อ (CLI: `claude -c` = ล่าสุด, `claude -r` = เลือก)
- **ใช้เมื่อ:** ปิด VS Code ไปแล้ว, พักเที่ยงกลับมา, อยากย้อนไปดูว่าเคยสั่งอะไร
- 🧪 **ลองเลย:** `/resume` → เลือกบทสนทนาก่อน `/clear` เมื่อกี้ → เห็นประวัติกลับมา

---

### 🔧 ระดับ 2 — ตั้งค่า, สิทธิ์, แก้ปัญหา

#### `/permissions` — กำหนดว่า Claude ทำอะไรได้บ้าง
- **ทำอะไร:** ดู/เพิ่ม/ลบกฎ **allow** (ไม่ต้องถาม) และ **deny** (ห้ามเด็ดขาด) — บันทึกใน `.claude/settings.json`
- **ใช้เมื่อ:** เบื่อกด Yes กับคำสั่งปลอดภัยซ้ำๆ (`npm test`) · ต้องการกันความลับ (`.env`) และคำสั่งอันตราย
- 🧪 **ลองเลย:**
  1. คัดลอก `.env.example` เป็น `.env` (ค่าปลอม)
  2. คัดลอก [`templates/claude/settings.json`](../templates/claude/settings.json) ไปเป็น `.claude/settings.json` ในโฟลเดอร์ฝึก
  3. `/permissions` → เห็นกฎ `Read(./.env)` ใน deny
  4. `/clear` แล้วสั่ง `อ่าน .env แล้วบอกค่า SHOP_API_KEY` → ต้อง **ถูกปฏิเสธ** ✅
- 💡 เวลา Claude ขออนุญาต ตัวเลือก *"Yes, and don't ask again"* ก็คือการเพิ่มกฎ allow ผ่านหน้านี้นั่นเอง

#### `/config` — หน้าตั้งค่า
- **ทำอะไร:** เปิดหน้าตั้งค่า เช่น theme, การแจ้งเตือน, โหมดเริ่มต้น
- 🧪 **ลองเลย:** `/config` เลื่อนดูว่ามีอะไรตั้งได้บ้าง (ยังไม่ต้องเปลี่ยน)

#### `/status` — ตอนนี้ใช้อะไรอยู่
- **ทำอะไร:** แสดงบัญชีที่ล็อกอิน, รุ่นโมเดล, เวอร์ชัน Claude Code, โฟลเดอร์ที่ทำงาน
- **ใช้เมื่อ:** ขอความช่วยเหลือจากวิทยากร (บอกข้อมูลนี้ก่อน), สงสัยว่าล็อกอินบัญชีไหน
- 🧪 **ลองเลย:** `/status`

#### `/doctor` — ตรวจการติดตั้ง
- **ทำอะไร:** ตรวจว่า Claude Code ติดตั้งถูกต้อง, การอัปเดต, config เสียไหม
- **ใช้เมื่อ:** Claude Code ทำงานแปลกๆ, เปิดไม่ขึ้น, คำสั่งหาย
- 🧪 **ลองเลย:** `/doctor` (ใน Terminal)

#### `/login` · `/logout` — สลับบัญชี
- **ใช้เมื่อ:** ล็อกอินผิดบัญชี (เช่น บัญชีฟรีแทน Pro), ใช้เครื่องร่วมกับคนอื่น
- ⚠️ เครื่องของห้องอบรม/เครื่องส่วนกลาง: **`/logout` ทุกครั้งก่อนกลับ**

#### `/add-dir` — ให้เข้าถึงโฟลเดอร์อื่น
- **ทำอะไร:** เพิ่มโฟลเดอร์นอกโปรเจกต์ให้ Claude อ่าน/แก้ได้
- **ใช้เมื่อ:** อยากให้ Claude ดูตัวอย่างจากอีกโปรเจกต์ เช่น repo หลักสูตรนี้
- 🧪 **ลองเลย:** `/add-dir` → เลือกโฟลเดอร์ repo หลักสูตร → `ดู @templates/claude/commands/check.md แล้วอธิบายว่าทำอะไร`

#### `/terminal-setup` · `/ide` — สำหรับคนใช้ CLI ใน Terminal
- `/terminal-setup` — ตั้งให้ `Shift+Enter` ขึ้นบรรทัดใหม่ได้ใน Terminal
- `/ide` — เชื่อม `claude` ใน Terminal เข้ากับ VS Code: เห็นโค้ดที่ highlight และแสดง diff ใน editor

---

### 🚀 ระดับ 3 — รู้จักไว้ ใช้จริงวันที่ 3–5

วิทยากรสาธิตให้ดู 1–2 ตัว ที่เหลือแค่รู้ว่ามี

| คำสั่ง | ทำอะไร | ได้ใช้เมื่อ |
|---|---|---|
| `/review` | ให้ Claude review โค้ดหรือ Pull Request | 🚀 วันที่ 4 ก่อน merge |
| `/security-review` | ตรวจการเปลี่ยนแปลงในมุมความปลอดภัย (injection, ความลับรั่ว, auth) | 🛡️ วันที่ 3 คู่กับ Snyk/ZAP |
| `/agents` | สร้าง/จัดการ **subagent** — ผู้ช่วยเฉพาะทาง เช่น "test writer", "security reviewer" | 🛡️ วันที่ 3–4 |
| `/mcp` | ต่อเครื่องมือภายนอกผ่าน MCP เช่น ให้ Claude เปิดเบราว์เซอร์ดูหน้าเว็บเอง | 🚀 วันที่ 4 Polish UI |
| `/hooks` | ตั้งให้รันคำสั่งอัตโนมัติ เช่น รัน test ทุกครั้งหลัง Claude แก้ไฟล์ | 🚀 วันที่ 4 |
| `/install-github-app` | ติดตั้ง Claude บน GitHub repo ให้ mention `@claude` ใน Issue/PR ได้ | 🚀 วันที่ 4 (เสริม) |
| `/export` | ส่งออกบทสนทนาเป็นไฟล์/คลิปบอร์ด | 🎤 วันที่ 5 แชร์ Prompt/Strategy |
| `/feedback` (หรือ `/bug`) | ส่ง feedback/รายงานปัญหาให้ Anthropic | เมื่อเจอบั๊กของ Claude Code เอง |
| `/exit` | ออกจาก Claude Code (CLI) | — |

🧪 **สาธิต:** `/security-review` บน playground (มี `.env` อยู่ — ดูว่า Claude จะเตือนอะไร)

---

### 🧩 สร้างคำสั่ง `/` ของตัวเอง

Prompt ที่ใช้บ่อยเก็บเป็นคำสั่งได้: ไฟล์ Markdown ใน `.claude/commands/` — **ชื่อไฟล์ = ชื่อคำสั่ง**

1. คัดลอก [`templates/claude/commands/check.md`](../templates/claude/commands/check.md) ไปเป็น `.claude/commands/check.md`
2. พิมพ์ `/` → เห็น `/check` ในรายการ → เรียกใช้ → Claude รัน test, ดู diff แล้วสรุป "พร้อม commit" หรือไม่
3. `$ARGUMENTS` ในไฟล์ = ข้อความที่พิมพ์ตามหลัง เช่น `/check calc.js`
4. commit `.claude/commands/` ขึ้น git → ทั้งทีมได้คำสั่งเดียวกัน

### 🧪 Lab รวม: แก้บั๊กให้ test ผ่านด้วยทุกอย่างที่เรียนมา

```
Shift+Tab → Plan mode →  "วางแผนแก้บั๊กใน @calc.js ให้ test ผ่านทุกข้อ"
อ่านแผน → อนุมัติ → กลับเป็น Manual → อ่านคำสั่งก่อนกด Yes ทุกครั้ง
! npm test                   ← ยืนยันเองว่าผ่าน 5/5
/check                       ← ตรวจก่อน commit
/context  →  /clear          ← จบงาน ล้างบริบท
```

### ✅ จบ Bootcamp ต้องได้

- [ ] อธิบายได้ว่าโหมด Manual / Edit / Plan / Auto ต่างกันอย่างไร และตอนนี้ตัวเองอยู่โหมดไหน
- [ ] เลือกโมเดลให้เหมาะกับงานได้ (`sonnet` งานประจำ, `opus` งานยาก) และรู้ว่าโควต้า Pro ทำงานอย่างไร
- [ ] อธิบายได้ว่า `/clear` ต่างจาก `/compact` อย่างไร และ `/rewind` ต่างจาก git อย่างไร
- [ ] ลองกดคำสั่งระดับ 1 ครบ 10 ตัว และระดับ 2 อย่างน้อย `/permissions` `/status`
- [ ] Claude อ่าน `.env` ไม่ได้ (deny ทำงาน) และมีคำสั่ง `/check` ของตัวเอง
- [ ] `npm test` ผ่าน 5/5

---

## 🌱 3. Git Bootcamp

> 📖 เปิด **[Git Cheat Sheet + GitHub Desktop](../guides/git-commands.md)** ไว้ข้างจอ

**ทำไมต้องรู้คำสั่ง git ทั้งที่ใช้ GitHub Desktop?** เพราะ Claude Code ใช้ git ผ่าน command line — ตอนที่ Claude ขอรัน `git reset --hard` เราต้องรู้ทันทีว่า **งานจะหายทั้งหมด** ก่อนกด Yes · บน VM (วันที่ 5) ไม่มีหน้าจอ · log ของ CI (วันที่ 4) เป็นคำสั่ง git ล้วน

ทุกภารกิจทำใน Terminal **และ** เปิด GitHub Desktop คู่กันไว้ (File → Add local repository → เลือก `~/vibe-playground`) ดูว่าคำสั่งแต่ละตัวทำให้หน้าจอ Desktop เปลี่ยนอย่างไร

### 🧠 ภาพในหัว (5 นาที)

```
 Working directory ──add──► Staging ──commit──► Local repo ──push──► GitHub
   (ไฟล์ที่แก้อยู่)          (checkbox ใน Desktop)   (History)          (เว็บ)
```

### 📦 ภารกิจ 1 — commit แรก (10 นาที)

```bash
cd ~/vibe-playground
git init
git status                  # ไฟล์สีแดง = ยังไม่ถูกติดตาม — สังเกตว่ามี .env ด้วย!
```

สร้าง `.gitignore` ก่อน add (หรือให้ Claude สร้าง):
```
.env
node_modules/
```

```bash
git status                  # .env หายไปจากรายการแล้ว ✅
git add .
git status                  # สีเขียว = อยู่ใน staging
git commit -m "chore: initial playground with fixed calc"
git log --oneline
```

🖥️ **ดูใน Desktop:** แท็บ History มี commit นี้ · แท็บ Changes ว่าง

### 🔍 ภารกิจ 2 — ดูสิ่งที่ Claude แก้ด้วย `git diff` (10 นาที)

1. สั่ง Claude: `เพิ่มฟังก์ชัน min(prices) พร้อม test`
2. **ก่อนเชื่อว่าเสร็จ** ดูด้วยตัวเอง:
   ```bash
   git status                # ไฟล์ไหนถูกแก้
   git diff                  # แก้อะไร บรรทัดไหน (+ เขียว เพิ่ม / - แดง ลบ)
   ```
3. ถ้าพอใจ: `git add .` → `git diff --staged` → `git commit -m "feat: add min"`

🖥️ **ดูใน Desktop:** diff สีเขียว/แดงแบบเดียวกัน — ติ๊ก checkbox = `git add`

### 🧯 ภารกิจ 3 — ย้อนเมื่อ AI แก้พัง (10 นาที)

1. สั่ง Claude ให้ทำอะไรที่เราไม่ต้องการ เช่น `ลบ comment ทั้งหมดใน calc.js และเปลี่ยนชื่อฟังก์ชันเป็นภาษาไทย`
2. ดู `git diff` → ไม่ชอบ → ทิ้ง:
   ```bash
   git restore calc.js       # หรือ git restore . ทุกไฟล์
   git status                # กลับมาสะอาด
   ```
3. เปรียบเทียบกับ `/rewind` ของ Claude Code: **git = ย้อนไฟล์ได้เสมอ** แม้ปิด Claude ไปแล้ว — นี่คือเหตุผลที่ต้อง **commit บ่อย**

🖥️ **ใน Desktop:** คลิกขวา → *Discard changes*

### 🌿 ภารกิจ 4 — branch + merge (10 นาที)

```bash
git switch -c feat/vat
```
สั่ง Claude: `เพิ่มฟังก์ชัน addVat(price) บวก VAT 7% พร้อม test แล้ว commit ให้ด้วย` → **อ่านคำสั่ง git ที่ Claude ขอรันก่อนกด Yes**

```bash
git log --oneline --graph --all     # เห็น branch แยกออกมา
git switch main                     # addVat หายไป (อยู่ใน branch อื่น)
git merge feat/vat                  # รวมกลับ
git log --oneline --graph
```

🖥️ **ใน Desktop:** Current branch → เห็น `feat/vat` · Branch → Merge into current branch

### ☁️ ภารกิจ 5 — ขึ้น GitHub (10 นาที)

1. สร้าง repo ว่างบน GitHub ชื่อ `vibe-playground` (ไม่ต้องติ๊ก README)
2. เชื่อมและ push:
   ```bash
   git remote add origin https://github.com/<user>/vibe-playground.git
   git branch -M main
   git push -u origin main
   ```
   (หรือใน Desktop กด **Publish repository**)
3. เปิดเว็บ GitHub ตรวจว่า **ไม่มีไฟล์ `.env`** ✅
4. ลองแก้ไฟล์บนเว็บ GitHub 1 บรรทัด → กลับมาเครื่อง `git pull` → เห็นการแก้ไขนั้น

### 🚨 ปิดท้าย: คำสั่งที่เห็นแล้วต้องหยุด (5 นาที)

`git reset --hard` · `git push --force` · `git clean -fd` — ถ้า Claude ขอรัน **ตอบ No แล้วถามก่อน** (ใส่ไว้ใน `deny` ของ `settings.json` แล้วตอนเรียน `/permissions`) — รายละเอียดใน [cheat sheet ข้อ 4](../guides/git-commands.md#-4-คำสั่งอันตราย--ถ้า-claude-ขอรัน-ให้หยุดคิดก่อน)

### ✅ จบ Bootcamp ต้องได้

- [ ] repo `vibe-playground` บน GitHub มีอย่างน้อย 3 commit และ **ไม่มี `.env`**
- [ ] อธิบายได้ว่า `status`, `add`, `commit`, `diff`, `restore`, `switch`, `merge`, `push`, `pull` ทำอะไร และตรงกับปุ่มไหนใน Desktop
- [ ] รู้ว่า `reset --hard` และ `push --force` อันตรายอย่างไร

---

## 🧪 4. Lab: ทดสอบรัน Docker Compose

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

### 🎮 ภารกิจเสริม: ให้ Claude อธิบายและแก้
เปิดโฟลเดอร์ `hello-compose` ใน VSCode แล้วลอง Prompt:
```
อธิบาย docker-compose.yml นี้ทีละบรรทัดแบบคนเพิ่งเริ่ม
แล้วเพิ่ม service adminer ที่พอร์ต 8081 เพื่อดูฐานข้อมูลผ่านเว็บ
```

---

## 🖥️ 5. สร้าง Server จำลองด้วย VirtualBox

ทำตามคู่มือ **[virtualbox-vm.md](virtualbox-vm.md)** — สร้าง VM Ubuntu Server, ตั้ง Network (NAT + Host-only), SSH เข้า, ติดตั้ง Docker ด้วย [`examples/vm-setup.sh`](examples/vm-setup.sh) แล้ว Take Snapshot

VM นี้จะเป็นเป้าสแกน Nessus ในวันที่ 3 และเป็นเครื่อง Deploy ในวันที่ 5 (เปิดออกเน็ตด้วย Cloudflare Tunnel โดยไม่ต้องมีโดเมน)

> 💡 ระหว่างรอ Ubuntu ติดตั้ง (~10–15 นาที) ให้กลับไปทำ Lab Docker Compose หรือภารกิจ Git ที่ค้างไว้

---

## 💡 6. Workshop: เขียน Prompt App Idea

แอปที่จะสร้างตลอด 5 วันควร **เล็กพอทำเสร็จ แต่ใหญ่พอให้ได้ใช้ครบ** (UI + API + DB + Login ถ้ามีเวลา)

ใช้แม่แบบ [`templates/app-idea.md`](../templates/app-idea.md) กรอกให้ครบ แล้วลองให้ Claude ช่วยขัดเกลา (ใช้ **Plan mode** ที่เรียนใน Session 2):

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

## ✅ Checklist ท้ายวัน

- [ ] รัน `scripts/check-env.ps1` (หรือ `.sh`) แล้วไม่มี FAIL
- [ ] 🎮 Claude Code Bootcamp: ลองคำสั่ง `/` ระดับ 1–2 ครบ, `npm test` ผ่าน 5/5, มี `CLAUDE.md`, `.claude/settings.json`, `/check`
- [ ] 🌱 Git Bootcamp: repo `vibe-playground` บน GitHub มี ≥ 3 commit ไม่มี `.env`
- [ ] `docker run --rm hello-world` ผ่าน และ `hello-compose` เปิดหน้าเว็บ + query ฐานข้อมูลได้
- [ ] SSH เข้า VM ได้ และ `docker run --rm hello-world` บน VM ผ่าน
- [ ] Take Snapshot `clean-docker` ของ VM แล้ว
- [ ] มีไฟล์ `app-idea.md` ของตัวเองที่ผ่านการขัดเกลากับ Claude แล้ว

## 🛠️ Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| Docker Desktop ค้างที่ "Starting..." | รัน `wsl --update` แล้วรีสตาร์ท Docker Desktop |
| `port is already allocated` | มีโปรแกรมอื่นใช้พอร์ตอยู่ แก้พอร์ตใน `.env` เช่น `WEB_PORT=8090` |
| PostgreSQL ในเครื่องชนพอร์ต 5432 | ใช้ `DB_PORT=5433` ใน `.env` |
| Claude Code ล็อกอินไม่ได้ | ตรวจว่าบัญชีเป็นแผน Pro ขึ้นไป, ลอง Sign out แล้วเข้าใหม่, รัน `/doctor` |
| คำสั่ง `/` บางตัวไม่มีใน Extension | เปิด Terminal ใน VSCode แล้วรัน `claude` ใช้คำสั่งนั้นแทน |
| Claude ยังอ่าน `.env` ได้ | ตรวจว่าไฟล์อยู่ที่ `.claude/settings.json` (มีจุดหน้า `.claude`) แล้ว `/clear` เริ่มใหม่, ดูกฎด้วย `/permissions` |
| `git push` ถามรหัสผ่าน | GitHub ไม่รับรหัสผ่านแล้ว — ล็อกอินผ่าน GitHub Desktop ก่อน (จะตั้ง credential ให้) หรือใช้ Personal Access Token |
| `npm` ไม่พบคำสั่งหลังติดตั้ง Node | ปิดแล้วเปิด VSCode/Terminal ใหม่ (ให้โหลด PATH ใหม่) |
| ปัญหา VirtualBox / VM | ดูตาราง Troubleshooting ใน [virtualbox-vm.md](virtualbox-vm.md#️-troubleshooting) |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "แนวคิด Vibe Coding", "Claude / Anthropic" และ "เครื่องมือพัฒนา"

---

<p align="center">⬅️ — · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../day-2-scaffold/README.md">🏗️ วันที่ 2 ➡️</a></p>
