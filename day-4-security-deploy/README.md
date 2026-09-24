# 🚀 วันที่ 4 — Server จำลอง + Nessus + Deploy + Sprint

## 🎯 เป้าหมายของวัน

- 🖥️ มี **Server จำลอง (VirtualBox VM, Ubuntu Server)** ที่ SSH เข้าได้และมี Docker
- 🛰️ สแกนระดับ **Host/Infrastructure ด้วย Nessus** และเห็นผลของการลด attack surface
- 🌍 **Deploy แอปขึ้น VM** และได้ URL HTTPS ผ่าน Cloudflare Tunnel (ไม่ต้องมีโดเมน)
- 🏃 Sprint ปิด Must have + Polish + แก้บั๊ก แล้วอัปเดตขึ้น Server
- 🎤 เตรียมสไลด์และซ้อมนำเสนอสำหรับ **Demo Day (วันที่ 5 — นำเสนอทั้งวัน ไม่มีการสอน)**

> ⚠️ **จริยธรรมและกฎหมาย:** สแกนเฉพาะแอปและเครื่องของตัวเอง หรือที่ได้รับอนุญาตเป็นลายลักษณ์อักษรเท่านั้น
> การสแกนระบบของผู้อื่นโดยไม่ได้รับอนุญาตอาจผิด พ.ร.บ.คอมพิวเตอร์ฯ

## ⏰ ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–09:10 | 📥 เริ่มติดตั้ง Nessus ทิ้งไว้ (โหลด plugin 15–30 นาที) |
| 09:10–10:10 | 🖥️ สร้าง VirtualBox VM + ติดตั้ง Docker บน VM + Snapshot |
| 10:10–11:00 | 🛰️ Nessus: สแกน VM ก่อน/หลังปิดพอร์ต |
| 11:00–12:00 | 🌍 Deploy ขึ้น VM + เปิด URL ด้วย Cloudflare Tunnel |
| 13:00–14:45 | 🏃 Sprint: ปิดฟีเจอร์ + Polish + แก้บั๊ก → **Code freeze 14:45** |
| 14:45–15:30 | 🔄 อัปเดตแอปบน Server + Backup + ทดสอบ URL จริง |
| 15:30–16:00 | 🎤 เตรียมสไลด์ + ซ้อมนำเสนอ |
| ตลอดบ่าย | 🧑‍🏫 วิทยากร Coach รายบุคคล |

---

## 📥 0. เริ่มติดตั้ง Nessus ไว้ก่อน

Nessus ต้องโหลด plugin นาน — ทำ **ขั้นที่ 1–3 ของ [ข้อ 2](#️-2-nessus--สแกน-infrastructurehost)** แล้วปล่อยทิ้งไว้ — ระหว่างสร้าง VM จะโหลดเสร็จพอดี

---

## 🖥️ 1. สร้าง Server จำลองด้วย VirtualBox

ทำตามคู่มือ **[virtualbox-vm.md](virtualbox-vm.md)** — สร้าง VM Ubuntu Server, ตั้ง Network (NAT + Host-only), SSH เข้า, ติดตั้ง Docker ด้วย [`examples/vm-setup.sh`](examples/vm-setup.sh) แล้ว Take Snapshot

VM นี้คือ "Server จริง" ของเรา: เป็นเป้าสแกน Nessus และเป็นเครื่อง Deploy ในวันนี้ (เปิดออกเน็ตด้วย Cloudflare Tunnel โดยไม่ต้องมีโดเมน)

> 💡 ระหว่างรอ Ubuntu ติดตั้ง (~10–15 นาที) ให้เช็กว่า Nessus โหลด plugin เสร็จหรือยัง หรือดูว่า Pipeline จากเมื่อวานเขียวไหม

---

## 🛰️ 2. Nessus — สแกน Infrastructure/Host

Nessus ตรวจระดับ **เครื่อง/เซิร์ฟเวอร์**: พอร์ตที่เปิด, บริการที่ล้าสมัย, config ที่ไม่ปลอดภัย

### 📥 ติดตั้ง Nessus Essentials (ฟรี, สูงสุด 16 IP)
1. ขอ Activation Code ที่ <https://www.tenable.com/products/nessus/nessus-essentials>
2. รันผ่าน Docker:
   ```bash
   docker run -d --name nessus -p 8834:8834 tenable/nessus:latest-ubuntu
   ```
3. เปิด <https://localhost:8834> (ยอมรับ certificate) → เลือก *Nessus Essentials* → ใส่ Activation Code
4. รอดาวน์โหลด plugin (อาจใช้ 15–30 นาที — **เริ่มไว้ตั้งแต่ต้นวัน** ตามข้อ 0)

### 🔎 สแกน
- New Scan → **Basic Network Scan**
- Target: **IP Host-only ของ VM** ที่สร้างในข้อ 1 (เช่น `192.168.56.101`) — เป็นเครื่องของเราเอง สแกนได้อย่างปลอดภัย
- ดูผลตาม Severity: Critical → High → Medium

### 🧪 Lab: เห็นผลต่างก่อน/หลัง
1. คัดลอก `day-2-bootcamp/examples/hello-compose` ขึ้น VM (`scp -r`) แล้วรัน `docker compose up -d` บน VM (ซึ่ง **เปิดพอร์ต Postgres 5432 ออกมา**) แล้วสแกนรอบที่ 1
2. ให้ Claude ช่วยแก้ compose ให้ Postgres ไม่ publish port และปิดบริการที่ไม่จำเป็น แล้วสแกนรอบที่ 2
3. เปรียบเทียบ: พอร์ต/finding ไหนหายไป — นี่คือหลัก *ลด attack surface* ที่จะใช้ตอน deploy ในข้อ 3

> ⚠️ ข้อควรรู้: พอร์ตที่ Docker publish (`ports:`) **ข้าม firewall `ufw`** ของ Ubuntu ได้ การปิดพอร์ตจึงต้องทำที่ compose ด้วย ไม่ใช่แค่ที่ firewall

### 🤖 ให้ Claude ช่วยตีความ
```
นี่คือ finding จาก Nessus (export เป็น CSV): <วาง>
สรุปเป็นภาษาไทย: ความเสี่ยงคืออะไร, เกี่ยวกับแอปเราหรือเป็นของ OS/เครื่อง, วิธีแก้
```

---

## 🧅 สรุป: 3 ชั้นของการสแกน

| ชั้น | เครื่องมือ | หาอะไร | เมื่อไหร่ |
|---|---|---|---|
| Code/Dependency | Snyk, npm audit | package มีช่องโหว่, โค้ดไม่ปลอดภัย | ทุก commit (CI) |
| Running App | OWASP ZAP | header, XSS, cookie, misconfig ของเว็บ | ทุก deploy (CI) |
| Host/Network | Nessus | พอร์ต, บริการ, OS patch | ก่อนขึ้น production + ตามรอบ |

---

## 🌍 3. Deploy ขึ้น Server จริง

### 🧭 ทางเลือก — ไม่มีโดเมนก็ได้ URL

| ทางเลือก | ต้องมีอะไร | URL ที่ได้ | เหมาะกับ |
|---|---|---|---|
| **A. VirtualBox VM + Cloudflare Quick Tunnel** (ค่าเริ่มต้นของหลักสูตร) | VM ที่สร้างเมื่อเช้าเท่านั้น — **ไม่ต้องมีโดเมน ไม่ต้องสมัคร Cloudflare** | `https://<สุ่ม>.trycloudflare.com` (เปลี่ยนทุกครั้งที่รีสตาร์ท) | Demo ในห้อง, ทดสอบ |
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

1. **เปิด VM** ที่สร้างเมื่อเช้า แล้ว SSH เข้า (`ssh <user>@192.168.56.101`) — ถ้า VM พัง ย้อน Snapshot `clean-docker`
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

   ตาราง DB ถูกสร้างอัตโนมัติ เพราะ container backend รัน `npm run migrate up` ก่อน start (ตั้งไว้ตั้งแต่วันที่ 2) — ตรวจได้ด้วย
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
และเปิดออกอินเทอร์เน็ตด้วย Cloudflare Quick Tunnel โดยใช้ day-4 examples เป็นต้นแบบ:
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
- **Nessus Basic Network Scan** กับ IP Host-only ของ VM — ควรเห็นเฉพาะพอร์ต **22** เปิด (Caddy bind แค่ `127.0.0.1`, Postgres ไม่ publish) เทียบกับผลสแกนในข้อ 2

---

## 🏃 4. Sprint — ปิดฟีเจอร์ + Polish + แก้บั๊ก

**เป้าหมาย:** ฟีเจอร์ "Must have" จาก `docs/app-idea.md` ทำงานได้ครบวงจร พร้อม Demo — **Code freeze 14:45** หลังจากนี้ไม่เพิ่มฟีเจอร์ใหม่

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

### 🏁 ตรวจก่อน Code freeze (14:30)

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

## 🎤 5. อัปเดต Server + เตรียมนำเสนอ

### 🔄 อัปเดตแอปบน Server (14:45–15:30)
1. Push งาน Sprint → รอ Pipeline เขียว → image ใหม่ขึ้น ghcr.io
2. บน VM: `bash backup.sh` → `pull` + `up -d frontend backend` (ดู [ข้อ 3](#-3-deploy-ขึ้น-server-จริง) หัวข้อ Backup) — **อย่ารีสตาร์ท tunnel** URL จะเปลี่ยน
3. เปิด URL จากมือถือ (4G) ไล่ flow หลักที่จะ Demo ให้ผ่านทั้งหมด
4. ทดลอง `restore.sh` 1 ครั้ง ให้แน่ใจว่า backup ใช้ได้

### 🎬 เตรียมสไลด์ + ซ้อม (15:30–16:00)
- กรอกแม่แบบ [`templates/demo-presentation.md`](../templates/demo-presentation.md) — ท้ายไฟล์มี **รูปแบบ 10 นาที, เกณฑ์ประเมิน, สิ่งที่ต้องเช็กเช้าวันนำเสนอ และแผนสำรอง** · ให้ Claude ช่วยร่างจาก `git log` และ `docs/app-idea.md` ได้:
  ```
  อ่าน docs/app-idea.md, README.md และ git log --oneline แล้วช่วยกรอก templates/demo-presentation.md
  สำหรับนำเสนอ 8 นาที เน้นปัญหา → Demo → เบื้องหลัง → Prompt ที่ได้ผล ภาษาไทย กระชับ
  ```
- เลือก **Prompt/Strategy ที่ได้ผลที่สุด 1–3 อัน** ไว้แชร์ (ใช้ `/export` ดึงบทสนทนาได้)
- ซ้อมกับเพื่อนข้างๆ 1 รอบ จับเวลา 8 นาที
- 📌 จด URL + ลิงก์ repo + ลิงก์ GitHub Actions run ล่าสุด ไว้ในสไลด์

> ⚠️ **คืนนี้:** เปิด VM ค้างไว้ หรือถ้าต้องปิดเครื่อง พรุ่งนี้เช้าต้องเปิด VM แล้วดู URL ใหม่จาก `logs tunnel-quick` (Quick Tunnel เปลี่ยน URL ทุกครั้งที่เริ่มใหม่)

---

## ✅ Checklist ท้ายวัน (พร้อมสำหรับ Demo Day)

- [ ] 🖥️ SSH เข้า VM ได้ และ Take Snapshot `clean-docker` แล้ว
- [ ] 🛰️ Nessus สแกน VM ได้ 2 รอบ (ก่อน/หลังปิดพอร์ต) และเห็นความต่าง
- [ ] 🌍 แอปเข้าได้ที่ URL ของ Cloudflare Tunnel จากเครือข่ายภายนอก เช่น มือถือที่ใช้ 4G
- [ ] 🏃 ฟีเจอร์ Must have ใช้งานได้ครบ, UI ใช้บนมือถือได้, schema เปลี่ยนผ่าน migration ใหม่เท่านั้น
- [ ] ⚙️ Pipeline บน `main` เขียว และ image ล่าสุดคือตัวที่ deploy อยู่
- [ ] 💾 Backup DB แล้ว และทดลอง restore สำเร็จ 1 ครั้ง
- [ ] 🔒 Postgres ไม่เปิดพอร์ตออกภายนอก
- [ ] 📄 README ของโปรเจกต์มี URL, วิธีรัน, สถาปัตยกรรม
- [ ] 🎤 สไลด์ Demo พร้อม และซ้อมจับเวลาแล้ว

## 🛠️ Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| ปัญหา VirtualBox / VM | ดูตาราง Troubleshooting ใน [virtualbox-vm.md](virtualbox-vm.md#️-troubleshooting) |
| Nessus ยังโหลด plugin ไม่เสร็จตอนบ่าย | สร้าง VM ต่อไปก่อน · ถ้าไม่ทันจริง ใช้ `nmap` สแกนพอร์ต VM ของตัวเองแทนชั่วคราว |
| Quick Tunnel URL เปลี่ยน | container `tunnel-quick` ถูกรีสตาร์ท — ดู URL ใหม่จาก `logs tunnel-quick` และอย่ารีสตาร์ทหลังส่ง URL ให้ผู้ชมแล้ว |

## 📚 อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "Security", "CI/CD & Deploy" และ "เครื่องมือพัฒนา" (VirtualBox, Ubuntu)

---

<p align="center"><a href="../day-3-build-test/README.md">⬅️ 🏗️ วันที่ 3</a> · <a href="../README.md">🏠 หน้าหลัก</a> · <a href="../templates/demo-presentation.md">🎤 วันที่ 5: Demo Day ➡️</a></p>
