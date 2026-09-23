# 🧰 วันที่ 1 — เตรียมเครื่องมือ + ปูพื้นฐานแนวคิด

## 🎯 เป้าหมายของวัน

เมื่อจบวันนี้ ผู้เรียนจะ:
- 🧠 อธิบายได้ว่า Vibe Coding คืออะไร และต่างจาก "ให้ AI ช่วยเขียนโค้ด" แบบรับผิดชอบอย่างไร
- 🎮 **ใช้ Claude Code คล่อง**: `@` อ้างไฟล์, `!` รันคำสั่ง, โหมดสิทธิ์และ Plan mode, `/clear` `/compact` `/rewind`, `CLAUDE.md`, `.claude/settings.json` และสร้างคำสั่งของตัวเอง
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
| 09:45–11:00 | 🎮 **Claude Code Bootcamp** — 7 ภารกิจ ลงมือทำจริง |
| 11:00–12:00 | 🌱 **Git Bootcamp** — คำสั่ง git ↔ GitHub Desktop |
| 13:00–13:30 | 🐳 Lab: Docker Compose (+ แก้เครื่องที่ติดตั้งไม่ผ่าน) |
| 13:30–14:45 | 🖥️ สร้าง VirtualBox VM + ติดตั้ง Docker บน VM + Snapshot |
| 14:45–16:00 | 💡 Workshop: เขียน Prompt App Idea |

> 💡 ช่วงเช้าเป็น **ลงมือทำ 2 ชั่วโมงเต็ม** ไม่ใช่นั่งฟัง — วิทยากรสาธิต 1 ภารกิจ แล้วให้ผู้เรียนทำตาม เดินดูทีละเครื่อง
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

> 📖 เปิด **[Claude Code Cheat Sheet](../guides/claude-code-commands.md)** ไว้ข้างจอตลอดภารกิจ

### 🎒 เตรียม (5 นาที)

คัดลอกโฟลเดอร์ฝึก [`examples/claude-playground/`](examples/claude-playground/) ออกไปไว้ **นอก** repo หลักสูตร แล้วเปิดด้วย VSCode:

```bash
# macOS / Linux / Git Bash
cp -r day-1-setup/examples/claude-playground ~/vibe-playground
code ~/vibe-playground
```
```powershell
# Windows PowerShell
Copy-Item -Recurse day-1-setup\examples\claude-playground $HOME\vibe-playground
code $HOME\vibe-playground
```

โฟลเดอร์นี้มี `calc.js` ที่มี **บั๊กจงใจ 3 จุด** และ `calc.test.js` ที่ตอนนี้ fail 4 ข้อ — เป้าหมายคือทำให้ผ่านทั้งหมด **โดยฝึกคำสั่งไปทีละอย่าง**

### 🔍 ภารกิจ 1 — ให้ Claude อ่านโค้ดด้วย `@` (10 นาที)

```
อธิบาย @calc.js ทีละฟังก์ชันแบบคนเพิ่งเริ่ม ยังไม่ต้องแก้อะไร
```
```
เลือก (highlight) บรรทัด for loop ใน calc.js แล้วถาม: บรรทัดที่เลือกมีปัญหาอะไรไหม
```

🎯 **ได้เรียนรู้:** `@` ชี้ไฟล์ตรงๆ ประหยัดกว่าให้ Claude ค้นเอง · ใน VSCode โค้ดที่ highlight ถูกส่งให้ Claude เห็นอัตโนมัติ

### 💻 ภารกิจ 2 — รันคำสั่งเองด้วย `!` (5 นาที)

พิมพ์ในช่อง Claude Code:
```
! npm test
```
แล้วตามด้วย:
```
test ไหน fail บ้าง และน่าจะเกิดจากอะไร ยังไม่ต้องแก้
```

🎯 **ได้เรียนรู้:** `!` รันคำสั่งเองโดยไม่ใช้ Claude คิด (ไม่ต้องรออนุญาต) และผลลัพธ์เข้าไปอยู่ในบทสนทนาให้ Claude วิเคราะห์ต่อได้

### 🗺️ ภารกิจ 3 — Plan mode + Permission (15 นาที)

1. กด **`Shift+Tab`** จนเป็น **Plan mode** แล้วสั่ง:
   ```
   วางแผนแก้บั๊กทั้งหมดใน calc.js ให้ test ใน calc.test.js ผ่านทุกข้อ
   ```
2. **อ่านแผน** — Claude จะยังไม่แก้ไฟล์ ถ้าแผนไม่ตรงใจ ให้ตอบกลับแก้แผนก่อน
3. อนุมัติแผน แล้วสลับกลับโหมดปกติ → Claude จะ **ขออนุญาต** ก่อนแก้ไฟล์และก่อนรัน `npm test`
4. ลองกด **No** ครั้งหนึ่ง แล้วพิมพ์บอกเหตุผล เช่น "ขอแก้ทีละฟังก์ชัน เริ่มจาก total ก่อน"

🎯 **ได้เรียนรู้:** Plan ก่อนลงมือ = ประหยัดโควต้า + ไม่แก้ผิดทาง · ปฏิเสธได้และควรบอกเหตุผล · อ่านคำสั่งก่อนกด Yes ทุกครั้ง

### ⏪ ภารกิจ 4 — หยุด, ย้อน, เริ่มใหม่ (10 นาที)

1. สั่งงานกว้างๆ ให้ Claude เริ่มทำ แล้วกด **`Esc`** ระหว่างทาง:
   ```
   เพิ่มฟังก์ชันคำนวณภาษีมูลค่าเพิ่ม 7% พร้อม test และแปลง comment ทั้งไฟล์เป็นภาษาไทย
   ```
2. กด **`Esc` `Esc`** (หรือ `/rewind`) → เลือกย้อนกลับไปก่อนคำสั่งนี้ **พร้อมย้อนโค้ด** → ดูว่าไฟล์กลับเป็นเหมือนเดิม
3. ดูบริบทที่ใช้ไป: `/context`
4. ล้างบทสนทนา: `/clear` แล้วลองถาม "เมื่อกี้เราคุยอะไรกัน" (Claude จะจำไม่ได้แล้ว)

🎯 **ได้เรียนรู้:** `Esc` หยุดได้ทันที ไม่ต้องรอ · `/rewind` คือปุ่ม undo ของ AI · `/clear` ทุกครั้งที่เปลี่ยนงาน = ประหยัดโควต้า ([อ่านเพิ่ม](../guides/claude-code-efficiency.md))

### 🧠 ภารกิจ 5 — `CLAUDE.md` + กันความลับ (15 นาที)

1. สร้างความจำของโปรเจกต์: `/init` แล้วเปิด `CLAUDE.md` ที่ได้ เพิ่มบรรทัด:
   ```
   - ตอบเป็นภาษาไทยเสมอ
   - ทุกครั้งที่แก้ calc.js ต้องรัน npm test ให้ผ่านก่อนรายงานว่าเสร็จ
   ```
2. `/clear` แล้วสั่งงานเล็กๆ เช่น `เพิ่มฟังก์ชัน max(prices)` → สังเกตว่า Claude ทำตามกฎเอง **โดยไม่ต้องบอกซ้ำ**
3. สร้างไฟล์ความลับปลอม: คัดลอก `.env.example` เป็น `.env`
4. คัดลอก [`templates/claude/settings.json`](../templates/claude/settings.json) ไปเป็น `.claude/settings.json` ในโฟลเดอร์ฝึก
5. เริ่มบทสนทนาใหม่ (`/clear`) แล้วลองสั่ง `อ่าน .env แล้วบอกค่า SHOP_API_KEY` → ต้อง **ถูกปฏิเสธ** ✅
6. ดูกฎที่ใช้อยู่: `/permissions`

🎯 **ได้เรียนรู้:** `CLAUDE.md` = กฎที่ไม่ต้องพิมพ์ซ้ำ · `deny` กันไม่ให้ AI อ่านความลับแม้เราเผลอกด Yes

### 🧩 ภารกิจ 6 — สร้างคำสั่งของตัวเอง (10 นาที)

1. คัดลอก [`templates/claude/commands/check.md`](../templates/claude/commands/check.md) ไปเป็น `.claude/commands/check.md`
2. พิมพ์ `/check` → Claude จะรัน test, ดู diff แล้วสรุปว่า "พร้อม commit" หรือไม่
3. ลองแก้ไฟล์ `check.md` ให้ตรวจเพิ่มอีก 1 ข้อตามที่คิดเอง แล้วเรียกใหม่

🎯 **ได้เรียนรู้:** Prompt ที่ใช้บ่อยเก็บเป็นคำสั่งได้ — ทั้งทีมใช้ร่วมกันผ่าน git

### 🚀 ภารกิจ 7 (โบนัส) — Claude ใน Terminal (5 นาที)

เปิด Terminal ใน VSCode (`` Ctrl+` ``):
```bash
claude -p "สรุปว่าในโฟลเดอร์นี้มีไฟล์อะไรบ้าง ตอบ 3 บรรทัด"    # ถามแล้วจบ ไม่เข้าโหมดโต้ตอบ
claude -c                                                  # กลับไปทำต่อจากบทสนทนาล่าสุด
```

🎯 **ได้เรียนรู้:** CLI ใช้ใน script และบน Server ได้ (วันที่ 4–5)

### ✅ จบ Bootcamp ต้องได้

- [ ] `npm test` ผ่าน 5/5
- [ ] ใช้ `@`, `!`, `Shift+Tab`, `Esc`, `Esc Esc`, `/clear`, `/context` ได้
- [ ] มี `CLAUDE.md`, `.claude/settings.json` (Claude อ่าน `.env` ไม่ได้), `.claude/commands/check.md`

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

`git reset --hard` · `git push --force` · `git clean -fd` — ถ้า Claude ขอรัน **ตอบ No แล้วถามก่อน** (ใส่ไว้ใน `deny` ของ `settings.json` แล้วจากภารกิจ Claude 5) — รายละเอียดใน [cheat sheet ข้อ 4](../guides/git-commands.md#-4-คำสั่งอันตราย--ถ้า-claude-ขอรัน-ให้หยุดคิดก่อน)

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

ใช้แม่แบบ [`templates/app-idea.md`](../templates/app-idea.md) กรอกให้ครบ แล้วลองให้ Claude ช่วยขัดเกลา (ใช้ **Plan mode** จากภารกิจ 3):

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
- [ ] 🎮 Claude Code Bootcamp: `npm test` ผ่าน 5/5 และมี `CLAUDE.md`, `.claude/settings.json`, `/check`
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
