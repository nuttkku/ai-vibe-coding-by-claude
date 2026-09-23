# 🎮 Claude Code Cheat Sheet

คู่มือสรุปคำสั่ง Claude Code ที่ใช้ตลอดหลักสูตร — เปิดทิ้งไว้ข้างจอได้เลย
Claude Code อัปเดตบ่อย ถ้าคำสั่งไหนไม่มีหรือทำงานต่างไป ให้พิมพ์ `/help` หรือ `/` เพื่อดูรายการจริงในเวอร์ชันของคุณ

> 💡 ใช้ได้ 2 แบบ: **VS Code Extension** (แผง Claude ด้านข้าง — ใช้เป็นหลักในหลักสูตร) และ **CLI** (พิมพ์ `claude` ใน Terminal)
> ทั้งสองแบบใช้บัญชีและ `CLAUDE.md` เดียวกัน คำสั่ง `/` ส่วนใหญ่ใช้ได้ทั้งคู่ — ถ้าคำสั่งไหนไม่มีใน Extension ให้เปิด Terminal ใน VS Code แล้วรัน `claude`

---

## 🧭 1. วงจรการทำงาน 1 รอบ

```
  ┌─► 1. สั่งงาน (Prompt + @ไฟล์)
  │   2. Claude วางแผน / อ่านไฟล์ / เสนอแก้ไข
  │   3. เราอนุญาต หรือ ปฏิเสธ (Permission)
  │   4. ตรวจผล: รันเอง, git diff, test
  │   5. ผ่าน → git commit → /clear
  └── ไม่ผ่าน → บอกสิ่งที่ผิด หรือ Esc Esc ย้อนกลับ
```

## ⌨️ 2. ปุ่มลัดในช่องพิมพ์

| พิมพ์ / กด | ทำอะไร | ตัวอย่าง |
|---|---|---|
| `@` | อ้างไฟล์หรือโฟลเดอร์ ให้ Claude อ่านตรงนั้นเลย | `อธิบาย @src/calc.js` |
| `/` | เปิดรายการคำสั่ง | `/clear` |
| `!` | **Bash mode** — รันคำสั่ง shell เอง ผลลัพธ์เข้าไปในบทสนทนาให้ Claude เห็น | `! npm test` |
| `Esc` | **หยุด** Claude ทันที (งานที่ทำไปแล้วยังอยู่) | เห็นว่าไปผิดทาง |
| `Esc` `Esc` | **ย้อนกลับ** ไปข้อความก่อนหน้า (เลือกได้ว่าจะย้อนโค้ดด้วยไหม) | แก้พังแล้วอยากเริ่มใหม่ |
| `Shift+Tab` | **สลับโหมด** (CLI): Auto → Manual → Edit → Plan → … (VS Code: คลิกตัวบอกโหมดใต้ช่องพิมพ์) | ก่อนงานใหญ่ ให้สลับเป็น Plan |
| `Alt+T` / `Option+T` | เปิด/ปิด thinking (Opus 5.5, Fable ปิดไม่ได้) | |
| `Ctrl+O` | ดูรายละเอียด/ความคิดของ Claude (verbose) | |
| `↑` / `↓` | เรียก Prompt เก่ากลับมา | แก้ Prompt แล้วส่งใหม่ |
| `Ctrl+V` / ลากไฟล์ | แนบรูป (screenshot หน้าจอ, error) | "หน้านี้ปุ่มเบี้ยว ดูรูป" |
| `Shift+Enter` หรือ `\` + `Enter` | ขึ้นบรรทัดใหม่โดยยังไม่ส่ง | Prompt หลายบรรทัด (ใน Terminal อาจต้องรัน `/terminal-setup` ก่อน) |
| `Ctrl+C` | ยกเลิกสิ่งที่พิมพ์ / กดซ้ำเพื่อออก (CLI) | |

## 🚦 3. โหมดสิทธิ์ (Permission modes)

| โหมด | Claude ทำอะไรได้เอง | ใช้เมื่อ |
|---|---|---|
| 🖐️ **Manual** (`default`) | อ่านไฟล์ได้ — แก้ไฟล์และรันคำสั่ง **ต้องถามก่อน** | ผู้เริ่มต้น, งานสำคัญ — ใช้วันที่ 1–2 |
| ✏️ **Edit automatically** (`acceptEdits`) | แก้ไฟล์ + คำสั่งไฟล์พื้นฐานได้เลย — คำสั่งอื่นยังถาม | งานที่ไว้ใจได้ + commit ไว้แล้ว ย้อนด้วย git ได้ |
| 🗺️ **Plan** (`plan`) | อ่านและวางแผน **ห้ามแก้ไฟล์จนกว่าอนุมัติแผน** | ก่อนงานใหญ่ทุกครั้ง |
| 🤖 **Auto** (`auto`) | ทุกอย่าง มี classifier ตรวจเบื้องหลัง — **ค่าเริ่มต้นของแผน Pro/Max/Team** | งานยาว วันที่ 4–5 เมื่อ commit แล้ว + มีกฎ deny |
| 🔒 **Don't ask** (`dontAsk`) | เฉพาะที่อยู่ใน allow list — อย่างอื่นปฏิเสธทันที | CI / script |
| ☠️ **Bypass** (`bypassPermissions`) | ทำทุกอย่างไม่ตรวจ | ❌ **ห้ามใช้ในหลักสูตร** — ใช้เฉพาะใน container/VM ที่พังได้ |

> ⚠️ แผน Pro/Max/Team **เริ่มที่ Auto** — เปลี่ยนเป็น Manual ได้ที่ตัวบอกโหมดใต้ช่องพิมพ์ (VS Code) หรือ `Shift+Tab` (CLI) · รายละเอียด: [โหมด · โมเดล · ค่าใช้จ่าย](modes-models-costs.md)

เมื่อ Claude ขออนุญาต จะมีตัวเลือกประมาณ: **Yes** (ครั้งนี้), **Yes, and don't ask again** (จำไว้สำหรับคำสั่งแบบนี้), **No** (ปฏิเสธ + บอกเหตุผลให้ Claude ทำแบบอื่น)

> ⚠️ กฎของหลักสูตร: **อ่านคำสั่งก่อนกด Yes ทุกครั้ง** ถ้าไม่เข้าใจให้ตอบ No แล้วถาม "คำสั่งนี้ทำอะไร"

## 📋 4. Slash commands ที่ใช้บ่อย

คำอธิบายทีละคำสั่งพร้อมแบบฝึก อยู่ใน [บทเรียนวันที่ 1 Session 2](../day-1-setup/README.md#-2-claude-code-bootcamp)

### ⭐ ใช้ทุกวัน

| คำสั่ง | ทำอะไร |
|---|---|
| `/help` | ดูคำสั่งทั้งหมดในเวอร์ชันที่ใช้อยู่ |
| `/clear` | ล้างบทสนทนา เริ่มงานใหม่ — **ใช้บ่อยที่สุด** ทุกครั้งที่จบ task |
| `/compact` | สรุปบทสนทนาให้สั้นลงแต่ทำงานเดิมต่อ ใส่คำแนะนำได้ เช่น `/compact เก็บเฉพาะเรื่อง bug การจอง` |
| `/init` | ให้ Claude อ่านโปรเจกต์แล้วสร้าง `CLAUDE.md` ร่างแรก |
| `/memory` | เปิดแก้ไฟล์ `CLAUDE.md` (ความจำของโปรเจกต์) |
| `/model` | เลือกรุ่นโมเดล (`sonnet`, `opus`, `haiku`, `fable`, `opusplan`) |
| `/effort` | ตั้งระดับการคิด `low`/`medium`/`high`/`xhigh`/`max` |
| `/rewind` | ย้อนบทสนทนาและ/หรือโค้ดกลับไปจุดก่อนหน้า (เหมือน `Esc Esc`) |
| `/resume` | กลับไปบทสนทนาเก่า |

### 🔍 ตรวจสอบสถานะ

| คำสั่ง | ทำอะไร |
|---|---|
| `/context` | ดูว่าบริบทใช้ไปเท่าไหร่ อะไรกินพื้นที่ |
| `/usage` | ดูโควต้าที่ใช้ไปของแผน + ค่าใช้จ่ายประเมินของ session (เงินจริงเฉพาะผู้ใช้ API key) |
| `/usage-credits` | เปิดหน้าตั้งค่า usage credits (จ่ายเพิ่มเมื่อโควต้าหมด) |
| `/status` | ดูบัญชี, รุ่นโมเดล, เวอร์ชัน |
| `/doctor` | ตรวจการติดตั้ง Claude Code เมื่อมีปัญหา |

### ⚙️ ตั้งค่า

| คำสั่ง | ทำอะไร |
|---|---|
| `/permissions` | ดู/แก้กฎ allow/deny ว่า Claude ทำอะไรได้บ้าง |
| `/config` | เปิดหน้าตั้งค่า |
| `/add-dir` | ให้ Claude เข้าถึงโฟลเดอร์อื่นนอกโปรเจกต์ |
| `/login` / `/logout` | สลับบัญชี |
| `/terminal-setup` | ตั้ง `Shift+Enter` ให้ขึ้นบรรทัดใหม่ใน Terminal |
| `/ide` | เชื่อม `claude` ใน Terminal กับ VS Code (เห็นโค้ดที่เลือก + diff ใน editor) |

### 🚀 ขั้นสูง (ใช้วันที่ 3–5)

| คำสั่ง | ทำอะไร |
|---|---|
| `/review` | ให้ Claude review โค้ด / Pull Request |
| `/security-review` | ตรวจการเปลี่ยนแปลงในมุมความปลอดภัย |
| `/agents` | จัดการ subagent (ผู้ช่วยเฉพาะทาง เช่น reviewer) |
| `/mcp` | จัดการ MCP server (ต่อเครื่องมือภายนอก เช่น เบราว์เซอร์) |
| `/hooks` | ตั้งให้รันคำสั่งอัตโนมัติ เช่น รัน test ทุกครั้งหลังแก้ไฟล์ |
| `/install-github-app` | ติดตั้ง Claude บน GitHub repo ให้ mention `@claude` ใน Issue/PR ได้ |
| `/export` | ส่งออกบทสนทนา (ใช้แชร์ Prompt ในวันที่ 5) |
| `/feedback` (หรือ `/bug`) | รายงานปัญหาของ Claude Code ให้ Anthropic |
| `/exit` | ออกจาก Claude Code (CLI) |

## 💻 5. คำสั่ง CLI (ใน Terminal)

```bash
claude                          # เริ่ม session แบบโต้ตอบในโฟลเดอร์ปัจจุบัน
claude "อธิบายโปรเจกต์นี้"         # เริ่มพร้อม Prompt แรก
claude -c                       # ทำต่อจากบทสนทนาล่าสุด (continue)
claude -r                       # เลือกบทสนทนาเก่าที่จะกลับไปทำต่อ (resume)
claude -p "สรุป git log วันนี้"     # โหมดไม่โต้ตอบ: ตอบแล้วจบ (ใช้ใน script ได้)
cat error.log | claude -p "หาสาเหตุ"   # ส่งข้อมูลเข้าทาง pipe
claude --permission-mode plan   # เริ่มใน Plan mode
claude --version                # ดูเวอร์ชัน
claude update                   # อัปเดต
```

## 🧠 6. ความจำ: `CLAUDE.md`

| ไฟล์ | ใช้กับ | ใส่อะไร |
|---|---|---|
| `./CLAUDE.md` | โปรเจกต์นี้ (commit ขึ้น git ให้ทีมใช้ร่วมกัน) | stack, คำสั่ง, กฎของโปรเจกต์ |
| `~/.claude/CLAUDE.md` | ทุกโปรเจกต์ของเรา | ความชอบส่วนตัว เช่น "ตอบเป็นภาษาไทย" |

- สร้างร่างแรก: `/init` · แก้: `/memory` หรือเปิดไฟล์แก้เอง
- **กฎทอง:** ถ้าต้องบอก Claude เรื่องเดิมเป็นครั้งที่ 2 → ใส่ลง `CLAUDE.md`

## 🔐 7. ตั้งกฎความปลอดภัย: `.claude/settings.json`

วางไว้ในโปรเจกต์ (commit ได้) — แม่แบบ: [`templates/claude/settings.json`](../templates/claude/settings.json)

```json
{
  "permissions": {
    "allow": ["Bash(npm test:*)", "Bash(npm run lint:*)", "Bash(git status)", "Bash(git diff:*)"],
    "deny":  ["Read(./.env)", "Read(./.env.*)", "Bash(git push --force:*)", "Bash(rm -rf:*)"]
  }
}
```

- `allow` = ไม่ต้องถามทุกครั้ง (คำสั่งปลอดภัยที่ใช้บ่อย)
- `deny` = ห้ามเด็ดขาด แม้เรากด Yes เผลอ — **ห้ามอ่าน `.env` เสมอ**
- ตั้งค่าส่วนตัวที่ไม่อยาก commit ใส่ `.claude/settings.local.json`

## 🧩 8. สร้างคำสั่งของตัวเอง (Custom slash command)

สร้างไฟล์ Markdown ใน `.claude/commands/` ชื่อไฟล์ = ชื่อคำสั่ง — แม่แบบ: [`templates/claude/commands/check.md`](../templates/claude/commands/check.md)

```
.claude/commands/check.md   →   พิมพ์ /check ใน Claude Code
```

เนื้อหาในไฟล์คือ Prompt ที่จะถูกส่งเมื่อเรียกคำสั่ง ใช้ `$ARGUMENTS` รับข้อความที่พิมพ์ตามหลังได้ เช่น `/check backend`

## 🆚 9. VS Code Extension — จุดที่ต่างจาก CLI

- **โค้ดที่เลือก (highlight) ใน editor** ถูกส่งให้ Claude เห็นอัตโนมัติ — เลือกบรรทัดแล้วถาม "ตรงนี้ผิดอะไร" ได้เลย
- การแก้ไฟล์แสดงเป็น **diff** ให้กดยอมรับ/ปฏิเสธ — อ่าน diff ทุกครั้ง
- เปิดหลายบทสนทนาเป็นแท็บได้ — แต่ **อย่าให้ 2 แท็บแก้ไฟล์เดียวกันพร้อมกัน**
- สลับโหมด (Manual / Edit automatically / Plan / Auto) ได้จาก **ตัวบอกโหมดใต้ช่องพิมพ์** — Extension จำโหมดล่าสุดไว้ให้บทสนทนาถัดไป

---

📚 อ้างอิง: Claude Code Docs (CLI reference, Interactive mode, Slash commands, Settings, Memory) — ดู [CREDITS.md](../CREDITS.md)
