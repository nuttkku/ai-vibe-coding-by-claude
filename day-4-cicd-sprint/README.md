# วันที่ 4 — CI/CD + Sprint พัฒนาฟีเจอร์

## เป้าหมายของวัน

- ให้ Claude เขียน GitHub Actions Workflow: **Test → Snyk/ZAP → Build → Push Image**
- Sprint 1: สร้าง Core Feature ครบวงจร (UI + API + DB)
- Sprint 2: Feature เสริม, Polish UI, แก้ Bug
- ทุกการเปลี่ยนแปลงผ่าน CI/CD Pipeline สีเขียว

## ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–10:30 | GitHub Actions Workflow |
| 10:30–12:00 | Sprint 1: Core Feature |
| 13:00–14:30 | Sprint 1 (ต่อ) + Review |
| 14:30–15:30 | Sprint 2: Feature เสริม, Polish, Bug |
| 15:30–16:00 | Test + Security Scan + Push ผ่าน Pipeline |
| ตลอดวัน | วิทยากร Coach รายบุคคล |

---

## 1. GitHub Actions Workflow

### ภาพรวม Pipeline

```
push / PR
   │
   ▼
 [test] ── unit + integration (มี Postgres service)
   │
   ├──► [snyk] ── dependency scan (fail ถ้ามี High ขึ้นไป)
   └──► [zap]  ── เปิดแอปด้วย docker compose แล้ว baseline scan
           │
           ▼
     [build-push] ── build image → push ghcr.io (เฉพาะ main)
```

ตัวอย่างเต็ม: [`examples/ci.yml`](examples/ci.yml) — **คัดลอกไปไว้ที่ `.github/workflows/ci.yml` ในโปรเจกต์ของตัวเอง**

### Prompt ให้ Claude เขียน/ปรับ Workflow

```
สร้าง .github/workflows/ci.yml สำหรับโปรเจกต์นี้ โดยใช้ day-4 examples/ci.yml เป็นต้นแบบ:
1. test: รัน backend + frontend test โดยมี postgres service
2. snyk: สแกน backend และ frontend, fail ถ้า severity >= high (ใช้ secret SNYK_TOKEN)
3. zap: docker compose up แล้ว ZAP baseline ที่พอร์ต frontend ของโปรเจกต์นี้
4. build-push: build image backend/frontend แล้ว push ghcr.io เฉพาะ push บน main
ปรับ path, พอร์ต, ชื่อ db ให้ตรงกับโปรเจกต์จริง และอธิบายแต่ละ job สั้นๆ
```

### ตั้งค่าใน GitHub
1. Snyk → Account settings → คัดลอก **Auth Token**
2. GitHub repo → Settings → Secrets and variables → Actions → **New repository secret** ชื่อ `SNYK_TOKEN`
3. Push แล้วดูผลที่แท็บ **Actions**

### เมื่อ Pipeline แดง
```
GitHub Actions job "<ชื่อ job>" fail ด้วย log นี้:
<วาง log ช่วงที่ error>
หาสาเหตุ แก้ที่ต้นเหตุ (ห้ามปิด test หรือลด threshold ของ security scan)
```

> 💡 เสริม: Claude Code มี GitHub Action ของตัวเอง ให้ mention `@claude` ใน Issue/PR เพื่อให้ช่วยแก้ได้ — ดูเอกสาร Claude Code GitHub Actions ใน [CREDITS.md](../CREDITS.md)

---

## 2. Sprint 1 — Core Feature

**เป้าหมาย:** ฟีเจอร์ "Must have" จาก `app-idea.md` ทำงานได้ครบวงจร

### วิธีทำงานแบบ Sprint กับ Claude

1. **วางแผน (Plan mode)** — ให้ Claude เสนอแผนก่อน ยังไม่แก้โค้ด
   ```
   อ่าน docs/app-idea.md หัวข้อ Must have
   วางแผน Sprint 1 เป็น task ย่อยที่แต่ละ task commit ได้เอง
   ระบุไฟล์ที่ต้องแก้, migration DB, endpoint, หน้าจอ, และ test ของแต่ละ task
   ```
2. **ทำทีละ task** → รัน test → commit → `/clear` ก่อนเริ่ม task ถัดไป (ประหยัดโควต้า — ดู [guides/claude-code-efficiency.md](../guides/claude-code-efficiency.md))
   ```
   ทำ task 1: <ชื่อ task> ตามแผน เขียน test ด้วย รันให้ผ่านแล้วสรุปสิ่งที่เปลี่ยน
   ```
3. **Review เอง** ด้วย `git diff` ก่อน commit ทุกครั้ง — ถ้า task เปลี่ยน schema ต้องเห็น **ไฟล์ migration ใหม่** ใน diff (ไม่ใช่การแก้ไฟล์เดิม)
4. **Push** → ดู Pipeline เขียว

### แนวทาง Feature Branch (แนะนำ)
```bash
git switch -c feat/booking-create
# ... ทำงาน ...
git push -u origin feat/booking-create
```
แล้วเปิด Pull Request → CI รัน → Merge เมื่อเขียว

---

## 3. Sprint 2 — Feature เสริม, Polish UI, แก้ Bug

### Polish UI
```
ปรับ UI ทั้งแอปให้:
- responsive บนมือถือ (กว้าง 375px ต้องใช้งานได้)
- มี empty state, loading state, error state ทุกหน้า
- ปุ่มและฟอร์มเข้าถึงได้ด้วยคีย์บอร์ด มี label ครบ
- ใช้สีและระยะห่างให้สม่ำเสมอ (สร้าง CSS variables กลาง)
ไม่ต้องเพิ่ม UI library ใหม่
```

### แก้ Bug อย่างเป็นระบบ
1. เขียนขั้นตอนทำให้เกิดบั๊ก (Reproduce steps)
2. ให้ Claude **เขียน test ที่ fail ก่อน** แล้วค่อยแก้ให้ test ผ่าน
   ```
   บั๊ก: <อธิบาย> ขั้นตอน: 1... 2... 3...
   เขียน test ที่ reproduce บั๊กนี้ (ต้อง fail) แล้วแก้โค้ดให้ผ่าน
   ```

---

## 4. Coach รายบุคคล — คำถามที่วิทยากรใช้ถาม

- ตอนนี้ติดอะไรอยู่? ลองให้ Claude ทำไปแล้วกี่รอบ? Prompt ล่าสุดคืออะไร?
- `CLAUDE.md` ของคุณมีกฎที่ช่วยเรื่องนี้หรือยัง?
- Scope ยังพอดีกับเวลาที่เหลือไหม? อะไรตัดได้?
- โควต้า Claude เหลือเท่าไหร่? ถ้าใกล้หมด ใช้ Plan B ในคู่มือโควต้า (จับคู่, เตรียม Prompt ไว้ก่อน, ทำงานที่ไม่ต้องใช้ AI)
- Pipeline เขียวหรือยัง? ถ้าแดง แดงที่ job ไหน?

---

## Checklist ท้ายวัน

- [ ] `.github/workflows/ci.yml` อยู่ในโปรเจกต์ และรันครบ 4 job
- [ ] Pipeline บน `main` เป็นสีเขียว
- [ ] มี image ใน GitHub Packages (ghcr.io)
- [ ] ฟีเจอร์ Must have ใช้งานได้ครบ
- [ ] UI ใช้งานได้บนมือถือ
- [ ] Bug ที่พบถูกแก้พร้อม test
- [ ] การเปลี่ยน schema ทุกครั้งอยู่ใน migration ใหม่ และ `npm run migrate down` ย้อนได้

## Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| Snyk job fail `Authentication error` | ตรวจชื่อ secret ต้องเป็น `SNYK_TOKEN` ตรงตัว |
| ZAP job เชื่อมต่อแอปไม่ได้ | ใช้ `docker compose up -d --wait` และตรวจว่ามี healthcheck, พอร์ต target ถูก |
| Push image `denied: permission_denied` | ต้องมี `permissions: packages: write` ใน job |
| CI fail ที่ `migrate up` | มักเกิดจากแก้ไฟล์ migration เดิม หรือ migration พึ่งข้อมูลที่ไม่มีใน DB ว่าง — สร้าง migration ใหม่แทน |
| Test ผ่านในเครื่องแต่ fail ใน CI | ตรวจ env var ที่ใช้ในเครื่องแต่ไม่ได้ตั้งใน CI, และ `npm ci` ต้องมี `package-lock.json` |

## อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "CI/CD & Deploy" และ "Security"
