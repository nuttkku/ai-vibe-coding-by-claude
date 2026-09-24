# 🌱 Git Cheat Sheet + GitHub Desktop

ในห้องเรียนเราใช้ **GitHub Desktop** เป็นหลัก แต่ต้อง **อ่านคำสั่ง git ออก** เพราะ:

1. 🤖 **Claude Code ใช้ git ผ่าน command line** — ตอน Claude ขออนุญาตรัน `git reset --hard` เราต้องรู้ว่าจะเกิดอะไรขึ้นก่อนกด Yes
2. 🖥️ **Server/VM ไม่มีหน้าจอ** — วันที่ 4 ต้องทำงานบน VM ผ่าน SSH
3. ⚙️ **Log ของ GitHub Actions** เป็นคำสั่ง git ทั้งหมด — อ่านไม่ออก = แก้ CI ไม่ได้
4. 🧯 **ตอนมีปัญหา** คำตอบบนอินเทอร์เน็ตและคำอธิบายของ Claude เป็นคำสั่ง git เสมอ

---

## 🧠 1. ภาพในหัว: ของอยู่ 4 ที่

```
 Working directory  ──git add──►  Staging area  ──git commit──►  Local repo  ──git push──►  GitHub (remote)
 (ไฟล์ที่เราแก้อยู่)               (เตรียมจะ commit)               (ประวัติในเครื่อง)             (ประวัติบนเว็บ)
        ▲                                                                │                         │
        └──────────────── git restore ◄──────────────────────────────────┘ ◄──── git pull ─────────┘
```

GitHub Desktop ซ่อน **Staging area** ไว้ในรูปของ **checkbox หน้าไฟล์** — ไฟล์ที่ติ๊ก = ไฟล์ที่ถูก `git add`

## 🔄 2. คำสั่ง ↔ ปุ่มใน GitHub Desktop

| งาน | คำสั่ง git | GitHub Desktop |
|---|---|---|
| ตั้งชื่อ/อีเมล | `git config --global user.name "ชื่อ"` | File → Options → Git |
| สร้าง repo ใหม่ | `git init` | File → New repository |
| ดาวน์โหลด repo | `git clone <url>` | File → Clone repository |
| ดูว่าแก้อะไรไป | `git status` | แท็บ **Changes** (รายการไฟล์ซ้ายมือ) |
| ดูรายละเอียดที่แก้ | `git diff` | คลิกไฟล์ในแท็บ Changes (เขียว = เพิ่ม, แดง = ลบ) |
| เลือกไฟล์จะ commit | `git add <file>` / `git add .` | ติ๊ก checkbox หน้าไฟล์ |
| บันทึกจุด | `git commit -m "ข้อความ"` | กรอก Summary → **Commit to main** |
| ดูประวัติ | `git log --oneline` | แท็บ **History** |
| ส่งขึ้น GitHub | `git push` | **Push origin** |
| ดึงของใหม่ | `git pull` | **Fetch origin** → **Pull origin** |
| ทิ้งการแก้ไขไฟล์ | `git restore <file>` | คลิกขวาที่ไฟล์ → **Discard changes** |
| สร้าง branch | `git switch -c feat/login` | Current branch → **New branch** |
| สลับ branch | `git switch main` | Current branch → เลือก branch |
| รวม branch | `git merge feat/login` | Branch → **Merge into current branch** |
| เก็บงานไว้ชั่วคราว | `git stash` / `git stash pop` | คลิกขวาที่ Changes → **Stash all changes** |
| ย้อน commit แบบปลอดภัย | `git revert <commit>` | History → คลิกขวา → **Revert changes in commit** |
| เปิด Pull Request | (ผ่านเว็บ หรือ `gh pr create`) | **Create Pull Request** |

## 📋 3. คำสั่งที่ต้องจำ (เรียงตามความถี่)

```bash
git status                     # ⭐ ใช้บ่อยที่สุด — ตอนนี้อยู่ branch ไหน แก้อะไรไปบ้าง
git diff                       # ดูสิ่งที่แก้แต่ยังไม่ add
git diff --staged              # ดูสิ่งที่ add แล้ว (จะเข้า commit)
git add <file>                 # เลือกไฟล์ (หรือ git add . = ทุกไฟล์ — ระวัง .env!)
git commit -m "feat: add booking form"
git log --oneline --graph -10  # ประวัติ 10 commit ล่าสุด แบบสั้น + เส้น branch
git push                       # ส่งขึ้น GitHub
git pull                       # ดึงของใหม่ลงมา
git restore <file>             # ทิ้งการแก้ไขที่ยังไม่ commit (กู้ไม่ได้!)
git restore --staged <file>    # เอาไฟล์ออกจาก staging (ไฟล์ยังอยู่)
git switch -c <branch>         # สร้าง branch ใหม่และสลับไป
git switch <branch>            # สลับ branch
git show <commit>              # ดูว่า commit นั้นแก้อะไร
git remote -v                  # ดูว่าต่อกับ GitHub repo ไหน
```

## 🚨 4. คำสั่งอันตราย — ถ้า Claude ขอรัน ให้หยุดคิดก่อน

| คำสั่ง | ผลที่เกิด | ทางที่ปลอดภัยกว่า |
|---|---|---|
| `git reset --hard` | **ลบงานที่ยังไม่ commit ทิ้งทั้งหมด** กู้คืนไม่ได้ | `git stash` (เก็บไว้ก่อน) |
| `git push --force` | **เขียนทับประวัติบน GitHub** งานคนอื่นหายได้ | `git push --force-with-lease` หรือถามวิทยากร |
| `git clean -fd` | ลบไฟล์ที่ git ไม่ได้ติดตามทั้งหมด (รวมไฟล์ใหม่ที่ยังไม่ add) | `git clean -n` ดูก่อนว่าจะลบอะไร |
| `git checkout -- .` / `git restore .` | ทิ้งการแก้ไขทุกไฟล์ | restore ทีละไฟล์ |
| `git rebase` | เขียนประวัติใหม่ | ในหลักสูตรนี้ใช้ `merge` พอ |

> ⚠️ แนะนำใส่ `"Bash(git push --force:*)"` และ `"Bash(git reset --hard:*)"` ไว้ใน `deny` ของ `.claude/settings.json` (ดู [claude-code-commands.md](claude-code-commands.md))

## ✍️ 5. เขียน commit message ให้ดี (Conventional Commits)

```
<type>: <สรุปสั้นๆ ว่าทำอะไร>

feat: add booking form          ← ฟีเจอร์ใหม่
fix: prevent double booking     ← แก้บั๊ก
test: add integration tests     ← เพิ่ม test
docs: update README             ← เอกสาร
chore: scaffold project         ← งานเบ็ดเตล็ด/ตั้งค่า
refactor: split booking routes  ← ปรับโครงสร้างโดยไม่เปลี่ยนการทำงาน
```

ให้ Claude ช่วยเขียนได้: `สรุปสิ่งที่เปลี่ยนแปลงใน git diff --staged แล้วเขียน commit message แบบ Conventional Commits`

## 🙈 6. `.gitignore` — ไฟล์ที่ห้ามขึ้น git

```gitignore
.env
node_modules/
dist/
coverage/
*.log
zap-report.*
```

ตรวจก่อน push ทุกครั้ง: `git status` ต้อง **ไม่เห็น** `.env`
เผลอ commit `.env` ไปแล้ว? → **เปลี่ยนรหัสผ่าน/token นั้นทันที** (ลบออกจาก git ไม่พอ เพราะยังอยู่ในประวัติ) แล้วค่อย `git rm --cached .env`

## 🧯 7. แก้สถานการณ์ที่เจอบ่อย

| สถานการณ์ | ทางแก้ |
|---|---|
| Claude แก้พังหลายไฟล์ ยังไม่ commit | `git restore .` (หรือ Discard all ใน Desktop) — หรือ `Esc Esc` / `/rewind` ใน Claude Code |
| commit ไปแล้วแต่ข้อความผิด (ยังไม่ push) | `git commit --amend -m "ข้อความใหม่"` |
| commit ไปแล้ว push แล้ว อยากย้อน | `git revert <commit>` (สร้าง commit ใหม่ที่หักล้าง — ปลอดภัย) |
| push ไม่ได้ `rejected (fetch first)` | `git pull` ก่อน แล้วค่อย `git push` |
| เจอ **merge conflict** | เปิดไฟล์ใน VS Code → เลือก *Accept Current / Incoming / Both* → `git add` → `git commit` — หรือให้ Claude ช่วย: `แก้ merge conflict ในไฟล์นี้ โดยเก็บทั้งสองฟีเจอร์ไว้` |
| ไม่รู้ว่าอยู่ branch ไหน | `git status` บรรทัดแรก หรือดูที่ Current branch ใน Desktop |

---

📚 อ้างอิง: Pro Git Book, GitHub Desktop Docs, Learn Git Branching — ดู [CREDITS.md](../CREDITS.md)
