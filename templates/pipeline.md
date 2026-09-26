# 🚦 Pipeline Spec: <ชื่อแอป>

> คัดลอกไปไว้ที่ `docs/pipeline.md` ในโปรเจกต์ของตัวเอง แล้วแก้ให้ตรงกับแอป — **ไฟล์นี้คือ "คำสั่ง" ที่ Claude ต้องทำตาม**

## ด่าน (ทำตามลำดับ — ด่านไหนไม่ผ่าน หยุดทันที)

| # | ด่าน | ทำอะไร | ผ่านเมื่อ |
|---|---|---|---|
| 1 | 🧪 Test | รัน unit + integration test ของ backend และ frontend | test ผ่านทุกข้อ |
| 2 | 🛡️ Security | สแกน dependency (`npm audit --audit-level=high` หรือ `snyk test --severity-threshold=high`) ทั้ง backend และ frontend | ไม่มีช่องโหว่ระดับ High ขึ้นไป |
| 3 | 🐳 Build | `docker compose build` | build สำเร็จทุก service |
| 4 | 💨 Smoke | `docker compose up -d --wait` แล้ว `curl` ไปที่ `/api/health` | ได้ HTTP 200 |
| 5 | 🌍 Deploy | SSH เข้า VM → `git pull` → `docker compose up -d --build` → ตรวจ `/api/health` บน VM | ได้ HTTP 200 และ tunnel ยังเป็น URL เดิม |

## กติกา

- ⛔ **Fail fast** — ด่านไหนแดง หยุดทั้ง pipeline ห้ามไปด่านถัดไป
- 🚫 ห้ามข้ามด่าน, ห้ามปิด test, ห้ามลด threshold ของ security scan เพื่อให้ผ่าน
- 🌿 Deploy ได้เฉพาะเมื่ออยู่ branch `main` และไม่มีไฟล์ที่ยังไม่ commit
- 🔑 ไม่มีรหัสผ่าน/ความลับในสคริปต์ — ค่าที่ต้องใช้ (เช่น `DEPLOY_HOST`) อ่านจาก environment
- 📋 พิมพ์ผลแต่ละด่านให้เห็นชัดว่า ✅ ผ่าน / ❌ ไม่ผ่าน และใช้เวลาเท่าไหร่

## วิธีรัน

- CI อย่างเดียว (ไม่ deploy): `bash scripts/pipeline.sh --no-deploy`
- ครบทุกด่าน: `DEPLOY_HOST=<user>@192.168.56.101 bash scripts/pipeline.sh`
