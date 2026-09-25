# 🎮 วันที่ 2 — Bootcamp, Docker, App Idea, ฐานข้อมูล, Scaffold + UI

## 🎯 เป้าหมายของวัน

เมื่อจบวันนี้ ผู้เรียนจะ:
- 🎮 **รู้จักโหมด, โมเดล และคำสั่ง `/` ของ Claude Code ที่ต้องใช้** และสร้างคำสั่งของตัวเองได้
- 🌱 **อ่านและใช้คำสั่ง git หลักได้** และรู้ว่าแต่ละคำสั่งตรงกับปุ่มไหนใน GitHub Desktop
- 🐳 ใช้ Docker Desktop และเข้าใจ image/container, port, volume, bind mount, network
- 💡 มี App Idea ที่ตัด scope แล้ว และ repo โปรเจกต์พร้อม `CLAUDE.md`
- 🗄️ เข้าใจ **DBMS** ใช้ **DataGrip หรือ DBeaver** อ่าน SQL พื้นฐานออก และรู้ข้อควรระวัง
- 🏗️ **Scaffold แอป Svelte + Express + PostgreSQL** ตรวจตารางด้วย ER Diagram และมีหน้า UI เชื่อม API แล้ว push ขึ้น GitHub

## ⏰ ลำดับที่สอน (แนะนำ)

| ช่วง | กิจกรรม |
|---|---|
| เช้า | 🩺 ตรวจการบ้าน → 🎮 Claude Code Bootcamp → 🌱 Git Bootcamp → 🐳 Docker Desktop → 🎨 Svelte UI เชื่อม API + Push |
| บ่าย | 💡 App Idea → 📝 CLAUDE.md + repo → 🐳 Docker ลงลึก → 🗄️ DBMS + DataGrip / DBeaver → 🧪 Scaffold + ตรวจ ER Diagram |

> 💡 หัวข้อในหน้านี้เรียงตามลำดับเนื้อหา (Scaffold ข้อ 8 มาก่อน UI ข้อ 9) — ปรับลำดับการสอนได้ตามห้อง · **Lab รวม Claude Code** ทำเป็นการบ้านได้
> **เตรียมก่อนวันที่ 3:** ติดตั้ง VirtualBox, ดาวน์โหลด ISO ของ Ubuntu Server (~3 GB) และติดตั้งแอป **Authenticator** (Google/Microsoft Authenticator หรือ 2FAS) บนมือถือ

---

## 🩺 0. ตรวจการบ้าน

ทุกคนรันตัวตรวจในโฟลเดอร์ repo หลักสูตร:
```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1     # Windows
```
```bash
bash scripts/check-env.sh                                          # macOS / Linux
```
ช่วงเช้าต้องใช้แค่ **VSCode + Claude Code + Git** (ติดตั้งแล้วเมื่อวาน) — ส่วน Docker ต้องพร้อมภายใน 11:25 · VirtualBox ใช้วันที่ 4

---

## 🎮 1. Claude Code Bootcamp

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
cp -r day-2-bootcamp/examples/claude-playground ~/vibe-playground && code ~/vibe-playground
```
```powershell
# Windows PowerShell
Copy-Item -Recurse day-2-bootcamp\examples\claude-playground $HOME\vibe-playground; code $HOME\vibe-playground
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
| 🖐️ **Manual** | อ่านไฟล์เท่านั้น — แก้ไฟล์/รันคำสั่ง ถามทุกครั้ง | ✅ วันที่ 2–3 |
| ✏️ **Edit automatically** | อ่าน + แก้ไฟล์ + คำสั่งไฟล์พื้นฐาน — คำสั่งอื่นยังถาม | ✅ หลัง commit แล้ว |
| 🗺️ **Plan** | อ่าน + วางแผน **ห้ามแก้ไฟล์จนกว่าเราอนุมัติแผน** | ✅ ก่อนงานใหญ่ทุกครั้ง |
| 🤖 **Auto** | ทุกอย่าง โดยมีโมเดลอีกตัวตรวจแต่ละ action เบื้องหลัง | ⚠️ Sprint วันที่ 4 เมื่อ commit แล้ว + มีกฎ deny |
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
- **ใช้เมื่อ:** ก่อนเริ่มงานใหญ่ (Scaffold วันที่ 3, Sprint วันที่ 4), รู้สึกว่าใกล้หมด
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
- ⚠️ `/rewind` ย้อนได้เฉพาะไฟล์ที่ Claude **แก้ผ่านเครื่องมือแก้ไฟล์** — สิ่งที่เกิดจากคำสั่ง shell (เช่น ลบไฟล์ด้วย `rm`, `git commit`) ย้อนไม่ได้ → **git ยังจำเป็นเสมอ** (Git Bootcamp ถัดไป)

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

### 🚀 ระดับ 3 — รู้จักไว้ ใช้จริงวันที่ 3–4

วิทยากรสาธิตให้ดู 1–2 ตัว ที่เหลือแค่รู้ว่ามี

| คำสั่ง | ทำอะไร | ได้ใช้เมื่อ |
|---|---|---|
| `/review` | ให้ Claude review โค้ดหรือ Pull Request | 🚀 Sprint วันที่ 4 ก่อน merge |
| `/security-review` | ตรวจการเปลี่ยนแปลงในมุมความปลอดภัย (injection, ความลับรั่ว, auth) | 🚀 วันที่ 4 คู่กับ Snyk/ZAP |
| `/agents` | สร้าง/จัดการ **subagent** — ผู้ช่วยเฉพาะทาง เช่น "test writer", "security reviewer" | 🏗️ วันที่ 3–4 |
| `/mcp` | ต่อเครื่องมือภายนอกผ่าน MCP เช่น ให้ Claude เปิดเบราว์เซอร์ดูหน้าเว็บเอง | 🚀 วันที่ 4 Polish UI |
| `/hooks` | ตั้งให้รันคำสั่งอัตโนมัติ เช่น รัน test ทุกครั้งหลัง Claude แก้ไฟล์ | 🚀 วันที่ 4 (คู่กับ test) |
| `/install-github-app` | ติดตั้ง Claude บน GitHub repo ให้ mention `@claude` ใน Issue/PR ได้ | 🚀 วันที่ 4 (เสริม คู่กับ CI) |
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

## 🌱 2. Git Bootcamp

> 📖 เปิด **[Git Cheat Sheet + GitHub Desktop](../guides/git-commands.md)** ไว้ข้างจอ

**ทำไมต้องรู้คำสั่ง git ทั้งที่ใช้ GitHub Desktop?** เพราะ Claude Code ใช้ git ผ่าน command line — ตอนที่ Claude ขอรัน `git reset --hard` เราต้องรู้ทันทีว่า **งานจะหายทั้งหมด** ก่อนกด Yes · บน VM (วันที่ 3) ไม่มีหน้าจอ · log ของ CI (วันที่ 4) เป็นคำสั่ง git ล้วน

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

## 🐳 3. Lab: Docker Desktop (ใช้ผ่านหน้าจอ)

วันนี้แค่ **รันได้และดูผ่านหน้าจอ Docker Desktop** — แนวคิด (image, volume, network) และคำสั่งทั้งหมด **ลงลึกบ่ายนี้ (ข้อ 6)**

ใช้ไฟล์ตัวอย่าง [`examples/hello-compose/`](examples/hello-compose/) — มี 2 ส่วน: เว็บ (nginx) และฐานข้อมูล (PostgreSQL)

### ▶️ ขั้นที่ 1 — รันด้วยคำสั่งเดียว

เปิดโฟลเดอร์ `day-2-bootcamp/examples/hello-compose` ใน VSCode แล้ว **ให้ Claude รันให้** (อยู่ในโหมด Manual — อ่านคำสั่งก่อนกด Yes):

```
คัดลอก .env.example เป็น .env แล้วรัน docker compose up -d ในโฟลเดอร์นี้
```

หรือพิมพ์เองใน Terminal:
```bash
cp .env.example .env        # Windows PowerShell: copy .env.example .env
docker compose up -d
```

### 🖱️ ขั้นที่ 2 — สำรวจใน Docker Desktop

เปิด Docker Desktop แล้วทำตามทีละข้อ (ชื่อเมนูอาจต่างเล็กน้อยตามเวอร์ชัน):

| # | ทำอะไร | ต้องเห็น |
|---|---|---|
| 1 | เมนู **Containers** | กลุ่มชื่อ `hello-compose` มี 2 ตัว: `web` และ `db` สถานะเขียว (Running) |
| 2 | คลิกลิงก์พอร์ต **8080:80** ที่แถว `web` | เบราว์เซอร์เปิดหน้า "Hello Vibe Coding" 🎉 |
| 3 | คลิกที่ `db` → แท็บ **Logs** | บรรทัด `database system is ready to accept connections` |
| 4 | แท็บ **Exec** (หรือ Terminal) ของ `db` แล้วพิมพ์ `psql -U app -d appdb -c "SELECT * FROM greetings;"` | ข้อความ 2 แถวจากฐานข้อมูล |
| 5 | กลับไปหน้า Containers กดปุ่ม **Stop** ที่กลุ่ม `hello-compose` | สถานะเป็นสีเทา · รีเฟรชเว็บ → เปิดไม่ได้ |
| 6 | กด **Start** อีกครั้ง | เว็บกลับมา ข้อมูลใน DB ยังอยู่ |
| 7 | เมนู **Images** | `nginx` และ `postgres` ที่ดาวน์โหลดมา |
| 8 | เมนู **Volumes** | `hello-compose_db-data` — ที่เก็บข้อมูลของ DB (อธิบายในข้อ 6) |

> 💡 ภาพรวมแบบง่าย: **Image** = ตัวติดตั้งโปรแกรม · **Container** = โปรแกรมที่กำลังรัน · **Volume** = ที่เก็บข้อมูล · **8080:80** = เปิดเครื่องเราพอร์ต 8080 แล้วส่งต่อเข้าโปรแกรม — รายละเอียดในข้อ 6

### 🎮 ขั้นที่ 3 — ให้ Claude อธิบาย

```
อธิบาย @docker-compose.yml นี้แบบคนเพิ่งเริ่ม ไม่เกิน 10 บรรทัด ยังไม่ต้องแก้อะไร
```

เก็บไว้รันต่อได้ **ปล่อยรันไว้** — ข้อ 6 และ 7 จะใช้ hello-compose ต่อ (ทดลอง volume และเชื่อมต่อฐานข้อมูล) ด้วย DataGrip/DBeaver · **อย่ากด Delete ที่ Volumes**

---

## 💡 4. Workshop: เขียน Prompt App Idea

แอปที่จะสร้างควร **เล็กพอทำเสร็จ แต่ใหญ่พอให้ได้ใช้ครบ** (UI + API + DB) — เริ่มจาก "ปัญหาที่อยากแก้" ที่แต่ละคนเล่าตอนแนะนำตัววันที่ 1

> ⚠️ เวลาสร้างแอปจริงมี **วันนี้ (scaffold + UI) + บ่ายวันที่ 3 (เพิ่ม Login + MFA) + วันที่ 4 (ทำต่อ + Sprint 1 ชั่วโมง)** แล้ววันที่ 5 นำเสนอ — ระบบ Login/MFA ไม่ต้องใส่ใน Must have เพราะทุกคนทำวันที่ 3 — ให้ Must have มีแค่ 1 resource หลัก + CRUD + ฟีเจอร์เด่น 1 อย่าง

ใช้แม่แบบ [`templates/app-idea.md`](../templates/app-idea.md) กรอกให้ครบ แล้วลองให้ Claude ช่วยขัดเกลา (ใช้ **Plan mode** ที่เรียนช่วงเช้า):

```
นี่คือไอเดียแอปของฉัน: <วางเนื้อหา app-idea.md>

ช่วย:
1. ถามคำถามที่ยังไม่ชัดเจนไม่เกิน 5 ข้อ
2. ตัด scope ให้ Must have ทำเสร็จได้ภายในวันที่ 4 (scaffold + UI + Sprint รวม ~5 ชั่วโมง) ด้วย Svelte + Express + PostgreSQL
3. เสนอ data model (ตาราง/คอลัมน์) และรายการ API endpoint
ยังไม่ต้องเขียนโค้ด
```

ตัวอย่างไอเดียที่เหมาะ: ระบบจองห้องประชุม, ระบบยืม-คืนอุปกรณ์, บันทึกรายรับรายจ่าย, คลังข้อสอบ, ระบบรับเรื่องร้องเรียน, แอปจัดการ Todo ของทีม

---

## 📝 5. CLAUDE.md + เตรียม repo โปรเจกต์

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

### 🎒 เตรียม repo โปรเจกต์ของตัวเอง (พร้อมเริ่ม Scaffold ในข้อ 8)

1. สร้าง repo ใหม่บน GitHub (เช่น `room-booking`) แบบ Private หรือ Public — ติ๊ก *Add README* และ `.gitignore` = Node
2. Clone ลงเครื่องด้วย GitHub Desktop แล้วเปิดใน VSCode
3. คัดลอก [`templates/CLAUDE.md.template`](../templates/CLAUDE.md.template) มาเป็น `CLAUDE.md` แล้วแก้ส่วน `<...>` ให้ตรงกับแอปของตัวเอง (ให้ Claude ช่วยได้: `อ่าน docs/app-idea.md แล้วช่วยกรอก CLAUDE.md ส่วน Project ให้กระชับ`)
4. วาง `app-idea.md` จาก Workshop ไว้ใน `docs/app-idea.md`
5. คัดลอก [`templates/claude/settings.json`](../templates/claude/settings.json) ไปเป็น `.claude/settings.json`
6. Commit + Push: `chore: add CLAUDE.md, app idea and claude settings`

---

## 🐳 6. Docker ลงลึก

ช่วงเช้าเราใช้ Docker ผ่านหน้าจอ ใน Scaffold (ข้อ 8) Claude จะสร้าง **Dockerfile + docker-compose.yml** ของแอปจริงให้ — ผู้เรียนต้อง **อ่านออกและแก้ปัญหาได้**

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

## 🗄️ 7. ฐานข้อมูล (DBMS) + DataGrip / DBeaver

แอปที่จะสร้างเก็บข้อมูลใน **PostgreSQL** — ก่อนให้ Claude สร้างตารางให้ ผู้เรียนต้อง **เปิดดูข้อมูลเองได้ อ่าน SQL ออก และรู้ว่าอะไรอันตราย**

> 📖 ใช้ PostgreSQL จาก `hello-compose` (ข้อ 3) ที่รันอยู่ — ไม่ต้องติดตั้ง PostgreSQL ลงเครื่อง

### 🧠 DBMS คืออะไร

**DBMS (Database Management System)** = โปรแกรมที่เก็บและจัดการข้อมูลให้ค้นหา/แก้ไขได้เร็วและปลอดภัย หลายคนใช้พร้อมกันได้ · หลักสูตรนี้ใช้ **PostgreSQL** ซึ่งเป็นแบบ **Relational** (ข้อมูลเป็นตาราง เชื่อมกันด้วย key)

```
 ┌───────────── Client (ผู้ใช้ฐานข้อมูล) ─────────────┐
 │  DataGrip · DBeaver · psql · Backend ของแอปเรา   │
 └──────────────────────┬─────────────────────────┘
                        │ เชื่อมผ่าน host:port + user/password
                        ▼
          PostgreSQL Server (รันใน container "db")
                        │
                        ▼
          Volume "db-data" (ไฟล์ข้อมูลจริง)
```

| คำ | ความหมาย | เทียบกับ Excel |
|---|---|---|
| **Database** | ที่เก็บข้อมูลของแอปหนึ่งตัว (`appdb`) | ไฟล์ Excel 1 ไฟล์ |
| **Table** | ชุดข้อมูลเรื่องเดียวกัน (`greetings`, `bookings`) | Sheet |
| **Row / Column** | ข้อมูล 1 รายการ / คุณสมบัติ 1 อย่าง | แถว / คอลัมน์ |
| **Primary Key (PK)** | คอลัมน์ที่ไม่ซ้ำ ใช้ระบุแถว (`id`) | เลขที่แถวที่ห้ามซ้ำ |
| **Foreign Key (FK)** | คอลัมน์ที่ชี้ไปหา PK ของอีกตาราง (`bookings.room_id → rooms.id`) | VLOOKUP ที่บังคับให้ต้องมีจริง |
| **Constraint** | กฎของข้อมูล: `NOT NULL`, `UNIQUE`, `CHECK` | Data validation |
| **Index** | สารบัญช่วยค้นหาเร็ว | ฟิลเตอร์ที่เตรียมไว้ล่วงหน้า |
| **Transaction** | ชุดคำสั่งที่ "สำเร็จทั้งหมด หรือไม่เกิดอะไรเลย" (`COMMIT` / `ROLLBACK`) | ไม่มี — Excel บันทึกทีละช่อง |

### 🧰 เลือกเครื่องมือ: DataGrip หรือ DBeaver

| | 🟣 **DataGrip** | 🦫 **DBeaver Community** |
|---|---|---|
| ผู้พัฒนา | JetBrains | DBeaver (open source) |
| ราคา | **ฟรีสำหรับการใช้งานที่ไม่ใช่การค้า** (เรียน, งานอดิเรก, open source) — ต่ออายุทุกปี และต้องยอมให้เก็บ telemetry · ใช้เชิงพาณิชย์ต้องซื้อ | **ฟรี** (open source) |
| จุดเด่น | เติมคำ SQL อัตโนมัติฉลาดมาก, refactor, หน้าตาเดียวกับ IDE ของ JetBrains | เบา, รองรับฐานข้อมูลเยอะ, ER Diagram ใช้ง่าย |
| ดาวน์โหลด | <https://www.jetbrains.com/datagrip/> | <https://dbeaver.io/download/> |

> 💡 เลือกตัวใดตัวหนึ่งก็พอ แนวคิดเหมือนกัน — ครั้งแรกที่เชื่อมต่อ ทั้งสองตัวจะขอ **ดาวน์โหลด driver ของ PostgreSQL** ให้กดยอมรับ (ชื่อเมนูอาจต่างเล็กน้อยตามเวอร์ชัน)

### 🔌 เชื่อมต่อกับ hello-compose

| ช่อง | ค่า |
|---|---|
| Host | `localhost` |
| Port | `5432` (หรือค่า `DB_PORT` ใน `.env` ถ้าเปลี่ยน) |
| Database | `appdb` |
| User | `app` |
| Password | ค่า `POSTGRES_PASSWORD` ใน `.env` (ตัวอย่าง: `change-me`) |

- **DataGrip:** `+` → **Data Source** → **PostgreSQL** → กรอกตามตาราง → **Download missing driver files** → **Test Connection** → **OK** → เปิด **Query Console**
- **DBeaver:** **Database → New Database Connection** → **PostgreSQL** → กรอกตามตาราง → **Test Connection** (ยอมให้โหลด driver) → **Finish** → คลิกขวาที่ connection → **SQL Editor → Open SQL script**

รัน SQL: เอาเคอร์เซอร์ไว้ที่คำสั่งแล้วกด **`Ctrl+Enter`** (ทั้งสองโปรแกรม)

### ✍️ SQL พื้นฐานที่ต้องอ่านออก

Claude จะเขียน SQL ให้ แต่เราต้อง **อ่านออกว่ามันทำอะไร** ก่อนกดรัน

```sql
-- อ่านข้อมูล
SELECT * FROM greetings;
SELECT message, created_at FROM greetings WHERE message LIKE '%Claude%' ORDER BY created_at DESC;
SELECT COUNT(*) FROM greetings;

-- เพิ่ม / แก้ / ลบ (⚠️ UPDATE และ DELETE ต้องมี WHERE เสมอ)
INSERT INTO greetings (message) VALUES ('ข้อความของฉัน');
UPDATE greetings SET message = 'แก้แล้ว' WHERE id = 3;
DELETE FROM greetings WHERE id = 3;

-- สร้างตารางที่มีความสัมพันธ์ (ตัวอย่างระบบจองห้อง)
CREATE TABLE rooms (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  capacity INTEGER NOT NULL CHECK (capacity > 0)
);
CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  room_id INTEGER NOT NULL REFERENCES rooms(id),   -- Foreign Key
  booked_by TEXT NOT NULL,
  starts_at TIMESTAMPTZ NOT NULL
);

-- รวมข้อมูลสองตาราง
SELECT r.name, b.booked_by, b.starts_at
FROM bookings b JOIN rooms r ON r.id = b.room_id
ORDER BY b.starts_at;
```

### 🤖 ให้ Claude ช่วยเรื่อง SQL

```
อธิบาย SQL นี้ทีละบรรทัดแบบคนเพิ่งเริ่ม และบอกว่ามีความเสี่ยงอะไรไหม:
<วาง SQL>
```
```
ตาราง greetings มีคอลัมน์ id, message, created_at
เขียน SQL สำหรับ PostgreSQL นับจำนวนข้อความต่อวัน เรียงจากวันล่าสุด
```

### ⚠️ สิ่งที่ควรรู้ก่อนใช้ในงานจริง

1. 🎯 **`UPDATE` / `DELETE` ต้องมี `WHERE` เสมอ** — ไม่มี = แก้/ลบ **ทุกแถว** · ก่อนรันให้ `SELECT` ด้วยเงื่อนไขเดียวกันดูก่อนว่าโดนกี่แถว (ทั้งสองโปรแกรมจะเตือนถ้าไม่มี WHERE — อย่ากดข้าม)
2. 🔄 **Auto-commit vs Manual transaction** — ค่าเริ่มต้นรันแล้วบันทึกทันที · ตอนทดลองแก้ข้อมูลให้สลับเป็น **Manual** (DataGrip: ตัวเลือก **Tx: Auto/Manual** บนแถบเครื่องมือของ Console · DBeaver: ปุ่ม **Auto-Commit** บนแถบเครื่องมือ) แล้วค่อยกด **Commit** หรือ **Rollback**
3. 🗃️ **อย่าแก้โครงสร้างตาราง (schema) ด้วย GUI ในโปรเจกต์จริง** — การเพิ่มคอลัมน์ด้วยการคลิกไม่ถูกบันทึกไว้ที่ไหน เพื่อน, CI และ Server จะไม่ได้ตาม · ใช้ **Migration** แทน (Scaffold ในข้อ 8 ใช้ node-pg-migrate — ดูหัวข้อ Migration ในข้อ 8) · ใช้ GUI แค่ **ดู** และ **ตรวจ** schema ที่ Claude สร้าง
4. 🗺️ **ใช้ ER Diagram ตรวจงานของ Claude** — DBeaver: เปิดตาราง → แท็บ **ER Diagram** · DataGrip: คลิกขวาที่ schema → **Diagrams → Show Diagram** · ดูว่า PK/FK ถูกไหม ก่อนเขียนโค้ดต่อ
5. 🔑 **รหัสผ่าน** — อย่าใช้รหัสผ่านจริงใน Lab, อย่า commit ไฟล์ตั้งค่าของ DataGrip (`.idea/`) หรือ DBeaver ที่เก็บ connection ไว้ · ถ้าเชื่อม DB ของคนอื่น/ของจริง ใช้ **บัญชีสิทธิ์อ่านอย่างเดียว**
6. 🌐 **DB บน Server ห้ามเปิดพอร์ต 5432 สู่ภายนอก** — ถ้าต้องดูข้อมูลบน VM ให้ใช้แท็บ **SSH** (SSH tunnel) ในการตั้งค่า connection ของทั้งสองโปรแกรม (จะเห็นผลตอนสแกน Nessus วันที่ 4)
7. 💾 **ข้อมูลอยู่ใน Docker volume** — `docker compose down -v` = ข้อมูลหาย · Export ด้วยคลิกขวาที่ตาราง → **Export Data** (CSV/SQL) ก่อนทดลองอะไรเสี่ยงๆ
8. 🪪 **ห้ามใช้ข้อมูลส่วนบุคคลจริง** (ชื่อ-เบอร์โทร-เลขบัตรของคนจริง) ใน Lab — ใช้ข้อมูลสมมติ (PDPA)

### 🧪 Lab (20 นาที)

1. เชื่อมต่อ `appdb` ด้วย DataGrip หรือ DBeaver → `SELECT * FROM greetings;` ต้องเห็น 2 แถว
2. `INSERT` ข้อความของตัวเอง → เปิดเว็บ <http://localhost:8080> ไม่เปลี่ยน (หน้าเว็บ hello-compose เป็น HTML นิ่ง ไม่ได้อ่าน DB — แอปจริงในข้อ 8 จะอ่าน)
3. สลับเป็น **Manual transaction** → `DELETE FROM greetings WHERE id = 1;` → `SELECT` ดูว่าหาย → **Rollback** → `SELECT` อีกครั้ง ข้อมูลกลับมา ✅
4. สร้างตาราง `rooms` และ `bookings` จากตัวอย่างด้านบน → เปิด **ER Diagram** ดูเส้นเชื่อม FK → `DROP TABLE bookings; DROP TABLE rooms;` (ลองได้เพราะเป็น Lab — โปรเจกต์จริงใช้ Migration)
5. ถาม Claude ให้เขียน query นับข้อความต่อวัน → อ่านให้เข้าใจก่อน → รันดู

---

## 🧪 8. Lab: Scaffold จาก Prompt เดียว

### 🎒 เตรียม
เปิด repo โปรเจกต์ที่สร้างในข้อ 5 ใน VSCode แล้วตรวจว่ามีครบ:
- `CLAUDE.md` (กรอกส่วน `<...>` แล้ว) — ยังไม่มี: กลับไป [ข้อ 5](#-5-claudemd--เตรียม-repo-โปรเจกต์)
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

hello-compose (ข้อ 3) ใช้ `init.sql` ซึ่ง **รันแค่ครั้งแรกตอน volume ของ Postgres ยังว่าง** — พอ Sprint วันที่ 4 ต้องเพิ่มคอลัมน์ แก้ `init.sql` ไปก็ไม่มีผล ต้องลบข้อมูลทิ้ง (`down -v`) ซึ่งทำบน Server จริงไม่ได้

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

> 💡 เป้าหมาย: `docker compose up -d --build` ขึ้นครบ 3 service และ `/api/health` ตอบ 200 แล้ว commit + push — แล้วค่อยไปต่อ UI (ข้อ 9)

---

## 🎨 9. Lab: Svelte UI เชื่อม API

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

- [ ] รัน `check-env` แล้วไม่มี FAIL
- [ ] 🎮 รู้ว่าตัวเองอยู่โหมดไหน, ลองคำสั่ง `/` ระดับ 1–2 ครบ, มี `/check`
- [ ] 🌱 repo `vibe-playground` บน GitHub มี ≥ 3 commit ไม่มี `.env`
- [ ] 🐳 อธิบายได้ว่า `down` กับ `down -v` ต่างกันอย่างไร
- [ ] 💡 repo โปรเจกต์มี `docs/app-idea.md` (ตัด scope แล้ว), `CLAUDE.md`, `.claude/settings.json`
- [ ] 🗄️ เชื่อมต่อ DB ด้วย DataGrip หรือ DBeaver ได้, อ่าน SQL พื้นฐานออก, ลอง Rollback สำเร็จ
- [ ] 🏗️ `docker compose up -d --build` ขึ้นครบ 3 service, `/api/health` ตอบ 200, ER Diagram ตรงกับ data model
- [ ] 🎨 หน้าเว็บแสดงรายการจาก API ได้ และ push ขึ้น GitHub แล้ว ไม่มี `.env`
- [ ] 🖥️ ติดตั้ง VirtualBox + มี ISO ของ Ubuntu Server + แอป Authenticator บนมือถือ พร้อมสำหรับวันที่ 3

## 🛠️ Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| Docker Desktop ค้างที่ "Starting..." | รัน `wsl --update` แล้วรีสตาร์ท Docker Desktop |
| `port is already allocated` | มีโปรแกรมอื่นใช้พอร์ตอยู่ แก้พอร์ตใน `.env` เช่น `WEB_PORT=8090` |
| Claude Code ล็อกอินไม่ได้ | ตรวจว่าบัญชีเป็นแผน Pro ขึ้นไป, ลอง Sign out แล้วเข้าใหม่, รัน `/doctor` |
| คำสั่ง `/` บางตัวไม่มีใน Extension | เปิด Terminal ใน VSCode แล้วรัน `claude` ใช้คำสั่งนั้นแทน |
| Claude ยังอ่าน `.env` ได้ | ตรวจว่าไฟล์อยู่ที่ `.claude/settings.json` (มีจุดหน้า `.claude`) แล้ว `/clear` เริ่มใหม่, ดูกฎด้วย `/permissions` |
| `git push` ถามรหัสผ่าน | GitHub ไม่รับรหัสผ่านแล้ว — ล็อกอินผ่าน GitHub Desktop ก่อน (จะตั้ง credential ให้) หรือใช้ Personal Access Token |
| `npm` ไม่พบคำสั่งหลังติดตั้ง Node | ปิดแล้วเปิด VSCode/Terminal ใหม่ (ให้โหลด PATH ใหม่) |
| Claude แก้ไฟล์เยอะเกินที่ขอ | ขอให้ "แก้เฉพาะไฟล์ X" และใช้ `git diff` ตรวจก่อน commit, ย้อนด้วย `git restore` |
| DataGrip/DBeaver: `Connection refused` | hello-compose ยังไม่รัน (`docker compose ps`) หรือพอร์ตไม่ตรง — ดู `DB_PORT` ใน `.env` |
| `password authentication failed for user "app"` | ใช้รหัสผ่านจาก `.env` · ถ้าเปลี่ยนรหัสใน `.env` หลังรันครั้งแรก ต้อง `docker compose down -v` แล้ว `up -d` ใหม่ (รหัสถูกตั้งตอนสร้าง volume ครั้งแรก) |
| ดาวน์โหลด driver ไม่ได้ | เน็ตของหน่วยงานบล็อก — ลองเครือข่ายอื่น หรือให้วิทยากรแจกไฟล์ driver |
| PostgreSQL ในเครื่องชนพอร์ต 5432 | ใช้ `DB_PORT=5433` ใน `.env` แล้วเชื่อมต่อพอร์ต 5433 |
| คำสั่ง docker อื่นๆ / container `Exited` / ดิสก์เต็ม | ดู [Docker Cheat Sheet ข้อ 7](../guides/docker-commands.md#-7-แก้ปัญหาที่เจอบ่อย) |
| Backend ต่อ DB ไม่ได้ (`ECONNREFUSED`) | ใน Docker ต้องใช้ host ชื่อ service (`db`) ไม่ใช่ `localhost`, และใช้ `depends_on: condition: service_healthy` |
| แก้โค้ดแล้วไม่เปลี่ยน | รัน `docker compose up -d --build` หรือใช้ volume mount ตอน dev |
| แก้ schema แล้วตารางไม่เปลี่ยน | อย่าแก้ migration เดิม — สร้างไฟล์ใหม่แล้ว `npm run migrate up` (ดูหัวข้อ Migration) |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "Claude / Anthropic", "เครื่องมือพัฒนา", "ฐานข้อมูล" และ "Framework & Library"

---

<p align="center"><a href="../day-1-intro/README.md">⬅️ 🧰 วันที่ 1</a> · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../day-3-server-auth/README.md">🏗️ วันที่ 3 ➡️</a></p>
