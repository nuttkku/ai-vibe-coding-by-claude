# วันที่ 5 — Sprint สุดท้าย + Demo

## เป้าหมายของวัน

- ปิด Feature, แก้ Bug, Polish App ให้พร้อมนำเสนอ
- Deploy App ขึ้น Server จริงจนได้ **URL ที่เข้าได้จากภายนอก (HTTPS)**
- นำเสนอ Demo รายบุคคล พร้อมแชร์ Prompt/Strategy และสิ่งที่เรียนรู้

## ตารางเวลา (แนะนำ)

| เวลา | กิจกรรม |
|---|---|
| 09:00–11:00 | Sprint สุดท้าย: ปิด Feature, แก้ Bug, Polish |
| 11:00–12:00 | Code freeze + Pipeline เขียว |
| 13:00–14:00 | Deploy ขึ้น VirtualBox VM + เปิด URL ด้วย Cloudflare Tunnel + สแกน Nessus/ZAP |
| 14:00–15:30 | Demo รายบุคคล (คนละ ~8–10 นาที) |
| 15:30–16:00 | แชร์ Prompt/Strategy + สรุปหลักสูตร |

---

## 1. Sprint สุดท้าย

**กฎ Sprint สุดท้าย:** ไม่เพิ่มฟีเจอร์ใหม่หลัง 11:00 — เวลาที่เหลือใช้ทำให้สิ่งที่มี "เสถียร"

```
ตรวจทั้งโปรเจกต์เพื่อเตรียม demo:
1. รายการฟีเจอร์ใน docs/app-idea.md ที่ยังไม่เสร็จ — อะไรควรตัดทิ้ง
2. จุดที่น่าจะพังระหว่าง demo (input แปลก, ข้อมูลว่าง, network ช้า)
3. ข้อความ error / UI ที่ยังดูไม่เรียบร้อย
เรียงตามผลกระทบต่อ demo แล้วแก้ทีละข้อพร้อม commit
```

---

## 2. Deploy ขึ้น Server จริง

### ทางเลือก — ไม่มีโดเมนก็ได้ URL

| ทางเลือก | ต้องมีอะไร | URL ที่ได้ | เหมาะกับ |
|---|---|---|---|
| **A. VirtualBox VM + Cloudflare Quick Tunnel** (ค่าเริ่มต้นของหลักสูตร) | VM จากวันที่ 1 เท่านั้น — **ไม่ต้องมีโดเมน ไม่ต้องสมัคร Cloudflare** | `https://<สุ่ม>.trycloudflare.com` (เปลี่ยนทุกครั้งที่รีสตาร์ท) | Demo ในห้อง, ทดสอบ |
| B. VM/VPS + Cloudflare Named Tunnel | บัญชี Cloudflare ฟรี + โดเมนที่ใช้ DNS ของ Cloudflare | `https://app.<โดเมนคุณ>` (คงที่) | ใช้ต่อหลังจบหลักสูตร |
| C. VPS สาธารณะ + โดเมน + Caddy | VPS ที่มี Public IP + โดเมน | `https://<โดเมนคุณ>` | Production แบบดั้งเดิม |

**ทำไม Tunnel ถึงไม่ต้องเปิดพอร์ต:** `cloudflared` บน VM เป็นฝ่าย *เชื่อมต่อออกไป* หา Cloudflare เอง แล้ว Cloudflare ส่ง request กลับเข้ามาทางท่อนั้น VM อยู่หลัง NAT ของ VirtualBox หรือ Wi-Fi ห้องอบรมก็ใช้ได้ และ HTTPS จัดการให้โดย Cloudflare

```
ผู้ใช้ ──HTTPS──► Cloudflare ◄══ท่อขาออก══ cloudflared ─► caddy ─┬─► frontend
                                          (ใน VM)               └─► backend ─► db
```

> ⚠️ Quick Tunnel ออกแบบมาสำหรับ **ทดสอบ/Demo** ไม่มีการรับประกัน uptime และจำกัดจำนวน request พร้อมกัน — ถ้าจะใช้งานจริงต่อ ให้ย้ายไปทางเลือก B

ไฟล์ตัวอย่าง: [`docker-compose.prod.yml`](examples/docker-compose.prod.yml), [`Caddyfile`](examples/Caddyfile), [`.env.example`](examples/.env.example), [`docker-compose.domain.yml`](examples/docker-compose.domain.yml) (เฉพาะทางเลือก C)

### ขั้นตอน A: VM + Cloudflare Quick Tunnel

1. **เปิด VM** จากวันที่ 1 แล้ว SSH เข้า (`ssh <user>@192.168.56.101`) — ถ้า VM พัง ย้อน Snapshot `clean-docker`
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

> URL ของ Quick Tunnel จะเปลี่ยนเมื่อ container `tunnel-quick` รีสตาร์ท — **อย่ารีสตาร์ทหลังส่ง URL ให้ผู้ชม Demo แล้ว** อัปเดตแอปด้วย `docker compose ... up -d frontend backend` แทน

### ทางเลือก B: Named Tunnel (มีโดเมน, URL คงที่)
1. เพิ่มโดเมนเข้า Cloudflare (เปลี่ยน nameserver ตามที่ Cloudflare บอก)
2. Cloudflare Dashboard → **Zero Trust → Networks → Tunnels → Create a tunnel** (ชนิด Cloudflared) → คัดลอก **token**
3. ตั้ง **Public Hostname** เช่น `app.example.com` → Service `http://caddy:80`
4. บน VM: ใส่ `TUNNEL_TOKEN=<token>` ใน `.env` แล้ว
   ```bash
   docker compose -f docker-compose.prod.yml --profile named up -d
   ```

### ทางเลือก C: VPS สาธารณะ + โดเมน + Caddy
1. ตั้ง A record ของโดเมน → Public IP ของ VPS, เปิด firewall 22/80/443
2. ใส่ `SITE_ADDRESS=<โดเมน>` ใน `.env` (Caddy จะขอใบรับรอง Let's Encrypt ให้เอง)
3. `docker compose -f docker-compose.prod.yml -f docker-compose.domain.yml up -d`

### อัปเดตเวอร์ชันใหม่ + Backup ก่อนทุกครั้ง

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

> **ก่อน Demo:** รัน `bash backup.sh` 1 ครั้ง และลอง `restore.sh` กับไฟล์นั้นให้แน่ใจว่าใช้ได้ — backup ที่ไม่เคยลอง restore ถือว่ายังไม่มี backup
> ไฟล์ backup อยู่บน VM เครื่องเดียวกัน — ถ้าจะใช้งานจริงต่อ ให้คัดลอกออกไปเก็บที่อื่นด้วย (`scp` กลับมาเครื่องตัวเอง)

### ให้ Claude ช่วย Deploy
```
ช่วยเตรียม deploy โปรเจกต์นี้ขึ้น VirtualBox VM (Ubuntu Server, มี Docker แล้ว)
และเปิดออกอินเทอร์เน็ตด้วย Cloudflare Quick Tunnel โดยใช้ day-5 examples เป็นต้นแบบ:
- ปรับพอร์ต backend/frontend ใน Caddyfile ให้ตรงกับ Dockerfile จริง
- สร้าง scripts/deploy.sh ที่ scp ไฟล์ขึ้น VM, pull image ล่าสุด, up -d และพิมพ์ URL trycloudflare ออกมา
- อัปเดต frontend/backend โดยไม่รีสตาร์ท tunnel (URL ต้องไม่เปลี่ยน)
ห้ามใส่ความลับใดๆ ลงไฟล์ที่ commit
```

> ⚠️ **อย่าวางรหัสผ่าน SSH หรือ Tunnel token ลงใน Prompt** — ใช้ SSH key และอนุญาตคำสั่งทีละคำสั่ง

### (เสริม) Deploy อัตโนมัติจาก CI
VM ใน VirtualBox อยู่หลัง NAT ทำให้ GitHub Actions SSH เข้ามาไม่ได้ ทางออกที่ง่าย: ตั้ง cron บน VM ให้รัน `docker compose -f docker-compose.prod.yml pull frontend backend && docker compose -f docker-compose.prod.yml up -d frontend backend` ทุก 5 นาที เพื่อดึง image ใหม่จาก GHCR เอง (ให้ Claude ช่วยเขียน crontab)
(ทางเลือก C ใช้ job SSH จาก CI ได้ตรงๆ โดยเก็บ SSH key ใน GitHub Secrets)

### สแกน Production
- **ZAP baseline** กับ URL ของ Tunnel (ของตัวเองเท่านั้น) — Cloudflare อาจ rate-limit ถ้าสแกนหนัก ใช้ baseline ไม่ใช่ full scan
- **Nessus Basic Network Scan** กับ IP Host-only ของ VM — ควรเห็นเฉพาะพอร์ต **22** เปิด (Caddy bind แค่ `127.0.0.1`, Postgres ไม่ publish) เทียบกับผลสแกนวันที่ 3

---

## 3. Demo รายบุคคล

ใช้แม่แบบ [`templates/demo-presentation.md`](../templates/demo-presentation.md)

| ส่วน | เวลา |
|---|---|
| ปัญหาและผู้ใช้ | 1 นาที |
| Live Demo บน URL จริง | 3 นาที |
| เบื้องหลัง: Architecture, CI/CD, Test, Security | 2 นาที |
| Prompt/Strategy ที่ได้ผล | 2 นาที |
| สิ่งที่เรียนรู้ + ถาม-ตอบ | 1–2 นาที |

### เกณฑ์ประเมิน (แนะนำ)

| หัวข้อ | น้ำหนัก |
|---|---|
| แอปทำงานได้บน URL จริง (HTTPS) | 25% |
| ฟีเจอร์ตรงกับ App Idea และแก้ปัญหาได้จริง | 20% |
| Test + CI/CD Pipeline เขียว | 20% |
| Security: ผลสแกนและการแก้ไข | 15% |
| การนำเสนอ + แชร์ Prompt/Strategy | 20% |

---

## 4. แชร์ Prompt/Strategy + สิ่งที่เรียนรู้

ให้ผู้เรียนแต่ละคนเพิ่ม Prompt ที่ได้ผลที่สุด 1–3 อันลงใน [`prompts/`](../prompts/) ผ่าน Pull Request (ถ้าต้องการแบ่งปันกับรุ่นต่อไป)

คำถามสะท้อนคิด:
- ตอนไหนที่ "vibe" ได้ผลดีที่สุด? ตอนไหนต้องหยุดอ่านโค้ดเอง?
- ถ้าเริ่มใหม่ จะเขียน `CLAUDE.md` ต่างไปอย่างไร?
- Security finding ที่ทำให้ประหลาดใจที่สุดคืออะไร?

---

## Checklist ท้ายวัน (และท้ายหลักสูตร)

- [ ] แอปเข้าได้ที่ URL ของ Cloudflare Tunnel (หรือโดเมนของตัวเอง) จากเครือข่ายภายนอก เช่น มือถือที่ใช้ 4G
- [ ] Pipeline บน `main` เขียว, image ล่าสุดคือที่ deploy อยู่
- [ ] Backup DB แล้ว และทดลอง restore สำเร็จ 1 ครั้ง
- [ ] Postgres ไม่เปิดพอร์ตออกภายนอก (ยืนยันด้วย Nessus/`nmap` ของตัวเอง)
- [ ] README ของโปรเจกต์มี URL, วิธีรัน, สถาปัตยกรรม
- [ ] นำเสนอ Demo แล้ว
- [ ] แชร์ Prompt/Strategy อย่างน้อย 1 อัน

## อ้างอิง
ดู [CREDITS.md](../CREDITS.md) หัวข้อ "CI/CD & Deploy"
