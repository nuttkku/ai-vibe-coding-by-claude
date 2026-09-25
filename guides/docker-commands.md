# 🐳 Docker Cheat Sheet

คู่มืออ้างอิงสำหรับบ่ายวันที่ 2 เป็นต้นไป — ช่วงเช้าวันที่ 2 ใช้แค่หน้าจอ Docker Desktop

---

## 🧠 1. ภาพในหัว

```
 Dockerfile  ──docker build──►  Image  ──docker run──►  Container
 (สูตรอาหาร)                    (อาหารแช่แข็ง)            (อาหารที่อุ่นแล้วกำลังกิน)
                                 เก็บไว้ใช้ซ้ำได้            สร้าง/ลบได้หลายจาน จากแพ็กเดียวกัน
```

| คำ | ความหมาย | ตัวอย่างในหลักสูตร |
|---|---|---|
| **Image** | แม่แบบที่ติดตั้งโปรแกรมไว้พร้อม (อ่านอย่างเดียว) | `postgres:17-alpine`, `nginx:alpine` |
| **Container** | โปรแกรมที่กำลังรันจาก image — ลบทิ้งแล้วสร้างใหม่ได้เสมอ | `hello-compose-db-1` |
| **Port mapping** `8080:80` | **พอร์ตเครื่องเรา : พอร์ตใน container** | เปิด `localhost:8080` → ไปถึง nginx พอร์ต 80 |
| **Named volume** | ที่เก็บข้อมูลที่ Docker ดูแล **อยู่รอดแม้ลบ container** | `db-data:/var/lib/postgresql/data` |
| **Bind mount** | ผูกโฟลเดอร์ในเครื่องเราเข้า container — แก้ไฟล์แล้วเห็นผลทันที | `./html:/usr/share/nginx/html` |
| **Network** | service ใน compose เดียวกันคุยกันด้วย **ชื่อ service** | backend ต่อ DB ที่ host `db` (ไม่ใช่ `localhost`) |
| **Compose** | ไฟล์ `docker-compose.yml` ที่บอกว่ามี service อะไรบ้าง รันพร้อมกันด้วยคำสั่งเดียว | frontend + backend + db |

> 💡 **`localhost` ใน container = ตัว container เอง** ไม่ใช่เครื่องเรา — นี่คือสาเหตุ error อันดับหนึ่ง (`ECONNREFUSED`) ตอน Scaffold

## ⭐ 2. คำสั่ง Compose (ใช้ทุกวัน)

รันในโฟลเดอร์ที่มี `docker-compose.yml`

| คำสั่ง | ทำอะไร | Docker Desktop |
|---|---|---|
| `docker compose up -d` | สร้างและรันทุก service เบื้องหลัง (`-d` = ไม่ค้างหน้าจอ) | — |
| `docker compose up -d --build` | build image ใหม่ก่อนรัน — **ใช้หลังแก้ Dockerfile หรือโค้ดที่ copy เข้า image** | — |
| `docker compose ps` | ดูว่า service ไหนรันอยู่ สถานะ healthy ไหม พอร์ตอะไร | Containers |
| `docker compose logs -f backend` | ดู log ของ service แบบต่อเนื่อง (`Ctrl+C` ออก) | คลิก container → Logs |
| `docker compose logs --tail 50 backend` | ดู log 50 บรรทัดล่าสุด — **ใช้วางให้ Claude ดูตอนมี error** | |
| `docker compose exec db psql -U app -d appdb` | เข้าไปรันคำสั่งใน container ที่รันอยู่ | คลิก container → Exec |
| `docker compose restart backend` | รีสตาร์ท service เดียว | ปุ่ม Restart |
| `docker compose stop` / `start` | หยุด/รันต่อ โดยไม่ลบอะไร | ปุ่ม Stop / Start |
| `docker compose down` | หยุดและ **ลบ container + network** — **ข้อมูลใน volume ยังอยู่** | ปุ่ม Delete (ที่ stack) |
| `docker compose down -v` | ลบทุกอย่าง **รวม volume** — ⚠️ **ข้อมูลใน DB หายหมด** | Volumes → Delete |
| `docker compose config` | ตรวจว่าไฟล์ compose + `.env` ถูกต้อง แสดงผลหลังแทนค่าตัวแปร | |
| `docker compose pull` | ดึง image เวอร์ชันล่าสุด | |

## 🔧 3. คำสั่ง Docker เดี่ยว

| คำสั่ง | ทำอะไร |
|---|---|
| `docker ps` | container ที่รันอยู่ (`-a` = รวมที่หยุดแล้ว) |
| `docker images` | image ที่มีในเครื่อง |
| `docker logs -f <container>` | log ของ container |
| `docker exec -it <container> sh` | เปิด shell ใน container (`exit` ออก) |
| `docker run --rm -p 8080:80 nginx:alpine` | รัน container ชั่วคราว (`--rm` = ลบเมื่อหยุด) |
| `docker build -t myapp .` | build image จาก Dockerfile ในโฟลเดอร์ปัจจุบัน |
| `docker stop <container>` / `docker rm <container>` | หยุด / ลบ container |
| `docker volume ls` | ดู volume ทั้งหมด |
| `docker system df` | ดูว่า Docker ใช้พื้นที่ดิสก์ไปเท่าไหร่ |
| `docker system prune` | ลบ container ที่หยุดแล้ว, network ที่ไม่ใช้, image ที่ไม่มีชื่อ — ถามยืนยันก่อน |

## 📄 4. อ่าน `docker-compose.yml` ให้ออก

```yaml
services:
  db:                                   # ชื่อ service = ชื่อ host ที่ service อื่นใช้ต่อ
    image: postgres:17-alpine           # ใช้ image สำเร็จรูป
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}   # ดึงค่าจากไฟล์ .env
    volumes:
      - db-data:/var/lib/postgresql/data        # named volume: ข้อมูลอยู่รอด
    healthcheck:                                # บอกวิธีเช็กว่า "พร้อมใช้งาน"
      test: ["CMD-SHELL", "pg_isready -U app"]

  backend:
    build: ./backend                    # build จาก Dockerfile ใน ./backend
    ports:
      - "3000:3000"                     # เครื่องเรา:container
    environment:
      DATABASE_URL: postgres://app:${POSTGRES_PASSWORD}@db:5432/appdb   # ต่อ host "db"
    depends_on:
      db:
        condition: service_healthy      # รอ db พร้อมก่อนค่อยรัน backend

volumes:
  db-data:                              # ประกาศ named volume
```

## 🏗️ 5. อ่าน `Dockerfile` ให้ออก

```dockerfile
FROM node:lts-alpine          # เริ่มจาก image ที่มี Node.js
WORKDIR /app                  # โฟลเดอร์ทำงานใน container
COPY package*.json ./         # copy ไฟล์ dependency ก่อน (ให้ cache ทำงาน)
RUN npm ci                    # ติดตั้ง dependency ตอน build
COPY . .                      # copy โค้ดทั้งหมด
EXPOSE 3000                   # บอกว่าแอปฟังพอร์ต 3000 (เป็นเอกสาร ไม่ได้เปิดพอร์ตจริง)
CMD ["node", "src/server.js"] # คำสั่งที่รันเมื่อ container เริ่ม
```

> 💡 แก้โค้ดแล้วแต่ container ยังรันโค้ดเก่า = ลืม `--build` (เพราะโค้ดถูก copy ลง image ตอน build) — ตอน dev ใช้ bind mount แทนได้

## 🚨 6. คำสั่งอันตราย — ถ้า Claude ขอรัน ให้หยุดคิดก่อน

| คำสั่ง | ผลที่เกิด | ทางที่ปลอดภัยกว่า |
|---|---|---|
| `docker compose down -v` | **ลบข้อมูลใน DB ทั้งหมด** | `docker compose down` (ไม่มี `-v`) · backup ก่อนด้วย `pg_dump` |
| `docker system prune -a --volumes` | ลบ image ทั้งหมดที่ไม่ได้ใช้ + **volume ทั้งหมดที่ไม่ได้ใช้** (รวม DB ของโปรเจกต์อื่นที่ปิดอยู่) | `docker system prune` (ไม่มี `-a --volumes`) |
| `docker volume rm <volume>` | ลบข้อมูลใน volume นั้นถาวร | ตรวจชื่อให้แน่ใจ + backup |
| `docker rm -f $(docker ps -aq)` | ลบ container ทุกตัวในเครื่อง | ลบเฉพาะของโปรเจกต์ด้วย `docker compose down` |

> ⚠️ แม่แบบ [`templates/claude/settings.json`](../templates/claude/settings.json) ใส่ `docker compose down -v` และ `docker system prune` ไว้ใน `deny` แล้ว

## 🧯 7. แก้ปัญหาที่เจอบ่อย

| อาการ | สาเหตุ / วิธีแก้ |
|---|---|
| `Cannot connect to the Docker daemon` | Docker Desktop ยังไม่เปิด — เปิดแล้วรอ *Engine running* |
| `port is already allocated` | มีโปรแกรมอื่นใช้พอร์ตนั้น — เปลี่ยนพอร์ตฝั่งซ้ายใน `.env` เช่น `WEB_PORT=8090` |
| backend `ECONNREFUSED 127.0.0.1:5432` | ใช้ `localhost` ใน container — เปลี่ยนเป็นชื่อ service `db` |
| backend รันก่อน DB พร้อม แล้ว crash | เพิ่ม `healthcheck` ให้ db และ `depends_on: condition: service_healthy` |
| แก้โค้ดแล้วไม่เปลี่ยน | `docker compose up -d --build` หรือใช้ bind mount ตอน dev |
| แก้ `init.sql` แล้วตารางไม่เปลี่ยน | init script รันเฉพาะตอน volume ว่าง — ใช้ migration (วันที่ 3) หรือ `down -v` ถ้ายอมให้ข้อมูลหาย |
| ดิสก์เต็ม | `docker system df` ดูก่อน แล้ว `docker system prune` |
| container ขึ้น `Exited (1)` | `docker compose logs <service>` ดูบรรทัดสุดท้าย แล้ววางให้ Claude |

---

📚 อ้างอิง: Docker Docs (Get started, Compose file reference, Volumes, CLI reference) — ดู [CREDITS.md](../CREDITS.md)
