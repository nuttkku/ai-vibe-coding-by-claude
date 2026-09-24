# 🚀 วันที่ 5 — CI/CD + Sprint + Deploy + Demo

## 🎯 เป้าหมายของวัน

- ⚙️ ให้ Claude เขียน GitHub Actions Workflow: **Test → Snyk → Build → Push Image** (+ ZAP ถ้าทัน)
- 🏃 Sprint 2 ชั่วโมง: ปิด Must have, แก้บั๊ก, Polish ให้พร้อม Demo
- 🌍 Deploy App ขึ้น VM จนได้ **URL ที่เข้าได้จากภายนอก (HTTPS)**
- 🎬 นำเสนอ Demo รายบุคคล พร้อมแชร์ Prompt/Strategy และสิ่งที่เรียนรู้

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–10:00 | ⚙️ GitHub Actions Workflow |
| 10:00–12:00 | 🏃 Sprint: ปิดฟีเจอร์ + Polish + แก้บั๊ก → **Code freeze 12:00** |
| 13:00–14:00 | 🌍 Deploy ขึ้น VirtualBox VM + เปิด URL ด้วย Cloudflare Tunnel + สแกน |
| 14:00–15:30 | 🎬 Demo รายบุคคล (คนละ ~8–10 นาที) |
| 15:30–16:00 | 🤝 แชร์ Prompt/Strategy + สรุปหลักสูตร |
| ตลอดวัน | 🧑‍🏫 วิทยากร Coach รายบุคคล |

> 💡 วันนี้แน่นที่สุด — ใครที่แอปยังไม่เสร็จจากวันที่ 3 ให้ **ตัด scope** ตั้งแต่เช้า (Demo แอปเล็กที่ใช้งานได้จริงดีกว่าแอปใหญ่ที่พัง)

---

## ⚙️ 1. GitHub Actions Workflow

### 🗺️ ภาพรวม Pipeline

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

### 💬 Prompt ให้ Claude เขียน/ปรับ Workflow

```
สร้าง .github/workflows/ci.yml สำหรับโปรเจกต์นี้ โดยใช้ day-5 examples/ci.yml เป็นต้นแบบ:
1. test: รัน backend + frontend test โดยมี postgres service
2. snyk: สแกน backend และ frontend, fail ถ้า severity >= high (ใช้ secret SNYK_TOKEN)
3. zap: docker compose up แล้ว ZAP baseline ที่พอร์ต frontend ของโปรเจกต์นี้
4. build-push: build image backend/frontend แล้ว push ghcr.io เฉพาะ push บน main
ปรับ path, พอร์ต, ชื่อ db ให้ตรงกับโปรเจกต์จริง และอธิบายแต่ละ job สั้นๆ
```

### 🔐 ตั้งค่าใน GitHub
1. Snyk → Account settings → คัดลอก **Auth Token**
2. GitHub repo → Settings → Secrets and variables → Actions → **New repository secret** ชื่อ `SNYK_TOKEN`
3. Push แล้วดูผลที่แท็บ **Actions**

### 🚨 เมื่อ Pipeline แดง
```
GitHub Actions job "<ชื่อ job>" fail ด้วย log นี้:
<วาง log ช่วงที่ error>
หาสาเหตุ แก้ที่ต้นเหตุ (ห้ามปิด test หรือลด threshold ของ security scan)
```

> 💡 เสริม: Claude Code มี GitHub Action ของตัวเอง ให้ mention `@claude` ใน Issue/PR เพื่อให้ช่วยแก้ได้ — ดูเอกสาร Claude Code GitHub Actions ใน [CREDITS.md](../CREDITS.md)

> ⏱️ **เวลาจำกัด 1 ชั่วโมง:** ถ้า job `zap` ยังไม่ผ่าน ให้ปิด job นั้นไว้ก่อน (comment ออก) แล้วให้ `test` → `snyk` → `build-push` เขียวให้ได้ — ZAP สแกนด้วยมือไปแล้วเมื่อวาน

---

## 🏃 2. Sprint — ปิดฟีเจอร์ + Polish + แก้บั๊ก (10:00–12:00)

**เป้าหมาย:** ฟีเจอร์ "Must have" จาก `docs/app-idea.md` ทำงานได้ครบวงจร พร้อม Demo — **Code freeze 12:00** หลังจากนี้ไม่เพิ่มฟีเจอร์ใหม่

**ลำดับความสำคัญ** (ทำจากบนลงล่าง หมดเวลาตรงไหนหยุดตรงนั้น):
1. 🔴 Must have ที่ยังไม่เสร็จ
2. 🐞 บั๊กที่จะทำให้ Demo พัง
3. 💅 Polish UI (responsive, empty/loading/error state)
4. 🟡 Should have — ถ้ามีเวลาเหลือจริงๆ เท่านั้น

### 🔄 วิธีทำงานแบบ Sprint กับ Claude

1. **วางแผน (Plan mode)** — ให้ Claude เสนอแผนก่อน ยังไม่แก้โค้ด
   ```
   อ่าน docs/app-idea.md หัวข้อ Must have
   วางแผน Sprint (2 ชั่วโมง) เป็น task ย่อยที่แต่ละ task commit ได้เอง เรียงตามลำดับความสำคัญ
   ระบุไฟล์ที่ต้องแก้, migration DB, endpoint, หน้าจอ, และ test ของแต่ละ task
   ```
2. **ทำทีละ task** → รัน test → commit → `/clear` ก่อนเริ่ม task ถัดไป (ประหยัดโควต้า — ดู [guides/claude-code-efficiency.md](../guides/claude-code-efficiency.md))
   ```
   ทำ task 1: <ชื่อ task> ตามแผน เขียน test ด้วย รันให้ผ่านแล้วสรุปสิ่งที่เปลี่ยน
   ```
3. **Review เอง** ด้วย `git diff` ก่อน commit ทุกครั้ง — ถ้า task เปลี่ยน schema ต้องเห็น **ไฟล์ migration ใหม่** ใน diff (ไม่ใช่การแก้ไฟล์เดิม)
4. **Push** → ดู Pipeline เขียว

### 🌿 แนวทาง Feature Branch (แนะนำ)
```bash
git switch -c feat/booking-create
# ... ทำงาน ...
git push -u origin feat/booking-create
```
แล้วเปิด Pull Request → CI รัน → Merge เมื่อเขียว

### 💅 Polish UI
```
ปรับ UI ทั้งแอปให้:
- responsive บนมือถือ (กว้าง 375px ต้องใช้งานได้)
- มี empty state, loading state, error state ทุกหน้า
- ปุ่มและฟอร์มเข้าถึงได้ด้วยคีย์บอร์ด มี label ครบ
- ใช้สีและระยะห่างให้สม่ำเสมอ (สร้าง CSS variables กลาง)
ไม่ต้องเพิ่ม UI library ใหม่
```

### 🐞 แก้ Bug อย่างเป็นระบบ
1. เขียนขั้นตอนทำให้เกิดบั๊ก (Reproduce steps)
2. ให้ Claude **เขียน test ที่ fail ก่อน** แล้วค่อยแก้ให้ test ผ่าน
   ```
   บั๊ก: <อธิบาย> ขั้นตอน: 1... 2... 3...
   เขียน test ที่ reproduce บั๊กนี้ (ต้อง fail) แล้วแก้โค้ดให้ผ่าน
   ```

### 🏁 ตรวจก่อน Code freeze (11:30)

```
ตรวจทั้งโปรเจกต์เพื่อเตรียม demo:
1. รายการฟีเจอร์ใน docs/app-idea.md ที่ยังไม่เสร็จ — อะไรควรตัดทิ้ง
2. จุดที่น่าจะพังระหว่าง demo (input แปลก, ข้อมูลว่าง, network ช้า)
3. ข้อความ error / UI ที่ยังดูไม่เรียบร้อย
เรียงตามผลกระทบต่อ demo แล้วแก้ทีละข้อพร้อม commit
```

### 🧑‍🏫 Coach รายบุคคล — คำถามที่วิทยากรใช้ถาม (ตลอดช่วง Sprint)

- ตอนนี้ติดอะไรอยู่? ลองให้ Claude ทำไปแล้วกี่รอบ? Prompt ล่าสุดคืออะไร?
- `CLAUDE.md` ของคุณมีกฎที่ช่วยเรื่องนี้หรือยัง?
- Scope ยังพอดีกับเวลาที่เหลือไหม? อะไรตัดได้?
- โควต้า Claude เหลือเท่าไหร่? ถ้าใกล้หมด ใช้ Plan B ในคู่มือโควต้า (จับคู่, เตรียม Prompt ไว้ก่อน, ทำงานที่ไม่ต้องใช้ AI)
- Pipeline เขียวหรือยัง? ถ้าแดง แดงที่ job ไหน?

---

## 🌍 3. Deploy ขึ้น Server จริง (13:00–14:00)

### 🧭 ทางเลือก — ไม่มีโดเมนก็ได้ URL

| ทางเลือก | ต้องมีอะไร | URL ที่ได้ | เหมาะกับ |
|---|---|---|---|
| **A. VirtualBox VM + Cloudflare Quick Tunnel** (ค่าเริ่มต้นของหลักสูตร) | VM จากวันที่ 4 เท่านั้น — **ไม่ต้องมีโดเมน ไม่ต้องสมัคร Cloudflare** | `https://<สุ่ม>.trycloudflare.com` (เปลี่ยนทุกครั้งที่รีสตาร์ท) | Demo ในห้อง, ทดสอบ |
| B. VM/VPS + Cloudflare Named Tunnel | บัญชี Cloudflare ฟรี + โดเมนที่ใช้ DNS ของ Cloudflare | `https://app.<โดเมนคุณ>` (คงที่) | ใช้ต่อหลังจบหลักสูตร |
| C. VPS สาธารณะ + โดเมน + Caddy | VPS ที่มี Public IP + โดเมน | `https://<โดเมนคุณ>` | Production แบบดั้งเดิม |

**ทำไม Tunnel ถึงไม่ต้องเปิดพอร์ต:** `cloudflared` บน VM เป็นฝ่าย *เชื่อมต่อออกไป* หา Cloudflare เอง แล้ว Cloudflare ส่ง request กลับเข้ามาทางท่อนั้น VM อยู่หลัง NAT ของ VirtualBox หรือ Wi-Fi ห้องอบรมก็ใช้ได้ และ HTTPS จัดการให้โดย Cloudflare

```
ผู้ใช้ ──HTTPS──► Cloudflare ◄══ท่อขาออก══ cloudflared ─► caddy ─┬─► frontend
                                          (ใน VM)               └─► backend ─► db
```

> ⚠️ Quick Tunnel ออกแบบมาสำหรับ **ทดสอบ/Demo** ไม่มีการรับประกัน uptime และจำกัดจำนวน request พร้อมกัน — ถ้าจะใช้งานจริงต่อ ให้ย้ายไปทางเลือก B

ไฟล์ตัวอย่าง: [`docker-compose.prod.yml`](examples/docker-compose.prod.yml), [`Caddyfile`](examples/Caddyfile), [`.env.example`](examples/.env.example), [`docker-compose.domain.yml`](examples/docker-compose.domain.yml) (เฉพาะทางเลือก C)

### 🅰️ ขั้นตอน A: VM + Cloudflare Quick Tunnel

1. **เปิด VM** จากวันที่ 4 แล้ว SSH เข้า (`ssh <user>@192.168.56.101`) — ถ้า VM พัง ย้อน Snapshot `clean-docker`
2. **คัดลอกไฟล์** ขึ้น VM:
   ```bash
   ssh <user>@192.168.56.101 "mkdir -p ~/app"
   scp docker-compose.prod.yml Caddyfile .env.example backup.sh restore.sh <user>@192.168.56.101:~/app/
   ```
3. **ตั้งค่า** บน VM: `cd ~/app && cp .env.example .env && nano .env` (ใส่ `IMAGE_PREFIX` และรหัสผ่าน DB)
4. **ล็อกอิน GHCR** (ถ้า image เป็น private): สร้าง Personal Access Token สิทธิ์ `read:packages` แล้ว
   ```bash
   echo <TOKEN> | docker login ghcr.io -u <github-user> --password-stdin
   ```
5. **รัน:**
   ```bash
   docker compose -f docker-compose.prod.yml --profile quick pull
   docker compose -f docker-compose.prod.yml --profile quick up -d
   ```
6. **เอา URL:**
   ```bash
   docker compose -f docker-compose.prod.yml logs tunnel-quick | grep trycloudflare.com
   ```
   เปิด `https://<สุ่ม>.trycloudflare.com` จากมือถือ (ปิด Wi-Fi ใช้ 4G) เพื่อยืนยันว่าเข้าจากภายนอกได้ 🎉

   ตาราง DB ถูกสร้างอัตโนมัติ เพราะ container backend รัน `npm run migrate up` ก่อน start (ตั้งไว้ตั้งแต่วันที่ 3) — ตรวจได้ด้วย
   `docker compose -f docker-compose.prod.yml logs backend | head -20`

> ⚠️ URL ของ Quick Tunnel จะเปลี่ยนเมื่อ container `tunnel-quick` รีสตาร์ท — **อย่ารีสตาร์ทหลังส่ง URL ให้ผู้ชม Demo แล้ว** อัปเดตแอปด้วย `docker compose ... up -d frontend backend` แทน

### 🅱️ ทางเลือก B: Named Tunnel (มีโดเมน, URL คงที่)
1. เพิ่มโดเมนเข้า Cloudflare (เปลี่ยน nameserver ตามที่ Cloudflare บอก)
2. Cloudflare Dashboard → **Zero Trust → Networks → Tunnels → Create a tunnel** (ชนิด Cloudflared) → คัดลอก **token**
3. ตั้ง **Public Hostname** เช่น `app.example.com` → Service `http://caddy:80`
4. บน VM: ใส่ `TUNNEL_TOKEN=<token>` ใน `.env` แล้ว
   ```bash
   docker compose -f docker-compose.prod.yml --profile named up -d
   ```

### 🌐 ทางเลือก C: VPS สาธารณะ + โดเมน + Caddy
1. ตั้ง A record ของโดเมน → Public IP ของ VPS, เปิด firewall 22/80/443
2. ใส่ `SITE_ADDRESS=<โดเมน>` ใน `.env` (Caddy จะขอใบรับรอง Let's Encrypt ให้เอง)
3. `docker compose -f docker-compose.prod.yml -f docker-compose.domain.yml up -d`

### 💾 อัปเดตเวอร์ชันใหม่ + Backup ก่อนทุกครั้ง

เมื่อ CI push image ใหม่ (อาจมี migration ใหม่ที่เปลี่ยน schema) ให้ **backup ก่อนเสมอ**:

```bash
cd ~/app
bash backup.sh                                                  # ได้ไฟล์ใน backups/
docker compose -f docker-compose.prod.yml pull frontend backend
docker compose -f docker-compose.prod.yml up -d frontend backend   # backend รัน migration ใหม่ตอน start
```

ถ้า migration ใหม่ทำข้อมูลพัง ย้อนกลับด้วย:
```bash
bash restore.sh backups/<ไฟล์ล่าสุดก่อนอัปเดต>.dump
```

ไฟล์: [`backup.sh`](examples/backup.sh) (เก็บ 7 ไฟล์ล่าสุด, ตั้ง cron รายวันได้), [`restore.sh`](examples/restore.sh) (ถามยืนยันก่อนเขียนทับ)

> 💡 **ก่อน Demo:** รัน `bash backup.sh` 1 ครั้ง และลอง `restore.sh` กับไฟล์นั้นให้แน่ใจว่าใช้ได้ — backup ที่ไม่เคยลอง restore ถือว่ายังไม่มี backup
> ไฟล์ backup อยู่บน VM เครื่องเดียวกัน — ถ้าจะใช้งานจริงต่อ ให้คัดลอกออกไปเก็บที่อื่นด้วย (`scp` กลับมาเครื่องตัวเอง)

### 🤖 ให้ Claude ช่วย Deploy
```
ช่วยเตรียม deploy โปรเจกต์นี้ขึ้น VirtualBox VM (Ubuntu Server, มี Docker แล้ว)
และเปิดออกอินเทอร์เน็ตด้วย Cloudflare Quick Tunnel โดยใช้ day-5 examples เป็นต้นแบบ:
- ปรับพอร์ต backend/frontend ใน Caddyfile ให้ตรงกับ Dockerfile จริง
- สร้าง scripts/deploy.sh ที่ scp ไฟล์ขึ้น VM, pull image ล่าสุด, up -d และพิมพ์ URL trycloudflare ออกมา
- อัปเดต frontend/backend โดยไม่รีสตาร์ท tunnel (URL ต้องไม่เปลี่ยน)
ห้ามใส่ความลับใดๆ ลงไฟล์ที่ commit
```

> ⚠️ **อย่าวางรหัสผ่าน SSH หรือ Tunnel token ลงใน Prompt** — ใช้ SSH key และอนุญาตคำสั่งทีละคำสั่ง

### 🔁 (เสริม) Deploy อัตโนมัติจาก CI
VM ใน VirtualBox อยู่หลัง NAT ทำให้ GitHub Actions SSH เข้ามาไม่ได้ ทางออกที่ง่าย: ตั้ง cron บน VM ให้รัน `docker compose -f docker-compose.prod.yml pull frontend backend && docker compose -f docker-compose.prod.yml up -d frontend backend` ทุก 5 นาที เพื่อดึง image ใหม่จาก GHCR เอง (ให้ Claude ช่วยเขียน crontab)
(ทางเลือก C ใช้ job SSH จาก CI ได้ตรงๆ โดยเก็บ SSH key ใน GitHub Secrets)

### 🔎 สแกน Production
- **ZAP baseline** กับ URL ของ Tunnel (ของตัวเองเท่านั้น) — Cloudflare อาจ rate-limit ถ้าสแกนหนัก ใช้ baseline ไม่ใช่ full scan
- **Nessus Basic Network Scan** กับ IP Host-only ของ VM — ควรเห็นเฉพาะพอร์ต **22** เปิด (Caddy bind แค่ `127.0.0.1`, Postgres ไม่ publish) เทียบกับผลสแกนวันที่ 4

---

## 🎬 4. Demo รายบุคคล (14:00–15:30)

ใช้แม่แบบ [`templates/demo-presentation.md`](../templates/demo-presentation.md)

| ส่วน | เวลา |
|---|---|
| ปัญหาและผู้ใช้ | 1 นาที |
| Live Demo บน URL จริง | 3 นาที |
| เบื้องหลัง: Architecture, CI/CD, Test, Security | 2 นาที |
| Prompt/Strategy ที่ได้ผล | 2 นาที |
| สิ่งที่เรียนรู้ + ถาม-ตอบ | 1–2 นาที |

### 🏆 เกณฑ์ประเมิน (แนะนำ)

| หัวข้อ | น้ำหนัก |
|---|---|
| แอปทำงานได้บน URL จริง (HTTPS) | 25% |
| ฟีเจอร์ตรงกับ App Idea และแก้ปัญหาได้จริง | 20% |
| Test + CI/CD Pipeline เขียว | 20% |
| Security: ผลสแกนและการแก้ไข | 15% |
| การนำเสนอ + แชร์ Prompt/Strategy | 20% |

---

## 🤝 5. แชร์ Prompt/Strategy + สิ่งที่เรียนรู้ (15:30–16:00)

ให้ผู้เรียนแต่ละคนเพิ่ม Prompt ที่ได้ผลที่สุด 1–3 อันลงใน [`prompts/`](../prompts/) ผ่าน Pull Request (ถ้าต้องการแบ่งปันกับรุ่นต่อไป)

คำถามสะท้อนคิด:
- ตอนไหนที่ "vibe" ได้ผลดีที่สุด? ตอนไหนต้องหยุดอ่านโค้ดเอง?
- ถ้าเริ่มใหม่ จะเขียน `CLAUDE.md` ต่างไปอย่างไร?
- Security finding ที่ทำให้ประหลาดใจที่สุดคืออะไร?

---

## ✅ Checklist ท้ายวัน (และท้ายหลักสูตร)

- [ ] `.github/workflows/ci.yml` อยู่ในโปรเจกต์ และ Pipeline บน `main` เป็นสีเขียว
- [ ] มี image ใน GitHub Packages (ghcr.io) และเป็นตัวเดียวกับที่ deploy อยู่
- [ ] ฟีเจอร์ Must have ใช้งานได้ครบ และ UI ใช้งานได้บนมือถือ
- [ ] การเปลี่ยน schema ทุกครั้งอยู่ใน migration ใหม่
- [ ] แอปเข้าได้ที่ URL ของ Cloudflare Tunnel (หรือโดเมนของตัวเอง) จากเครือข่ายภายนอก เช่น มือถือที่ใช้ 4G
- [ ] Backup DB แล้ว และทดลอง restore สำเร็จ 1 ครั้ง
- [ ] Postgres ไม่เปิดพอร์ตออกภายนอก (ยืนยันด้วย Nessus/`nmap` ของตัวเอง)
- [ ] README ของโปรเจกต์มี URL, วิธีรัน, สถาปัตยกรรม
- [ ] นำเสนอ Demo แล้ว และแชร์ Prompt/Strategy อย่างน้อย 1 อัน

## 🛠️ Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| Snyk job fail `Authentication error` | ตรวจชื่อ secret ต้องเป็น `SNYK_TOKEN` ตรงตัว |
| ZAP job เชื่อมต่อแอปไม่ได้ | ใช้ `docker compose up -d --wait` และตรวจว่ามี healthcheck, พอร์ต target ถูก |
| Push image `denied: permission_denied` | ต้องมี `permissions: packages: write` ใน job |
| CI fail ที่ `migrate up` | มักเกิดจากแก้ไฟล์ migration เดิม หรือ migration พึ่งข้อมูลที่ไม่มีใน DB ว่าง — สร้าง migration ใหม่แทน |
| Test ผ่านในเครื่องแต่ fail ใน CI | ตรวจ env var ที่ใช้ในเครื่องแต่ไม่ได้ตั้งใน CI, และ `npm ci` ต้องมี `package-lock.json` |
| Quick Tunnel URL เปลี่ยน | container `tunnel-quick` ถูกรีสตาร์ท — ดู URL ใหม่จาก `logs tunnel-quick` และอย่ารีสตาร์ทหลังส่ง URL ให้ผู้ชมแล้ว |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "CI/CD & Deploy" และ "Security"

---

<p align="center"><a href="../day-4-testing-security/README.md">⬅️ 🛡️ วันที่ 4</a> · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../prompts/community.md">🎉 จบหลักสูตร — แชร์ Prompt ของคุณ</a></p>
