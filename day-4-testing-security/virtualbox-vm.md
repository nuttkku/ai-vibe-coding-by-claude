# 🖥️ สร้าง Server จำลองด้วย VirtualBox (Ubuntu Server)

VM นี้คือ "Server จริง" ของผู้เรียนตลอดหลักสูตร:

| วัน | ใช้ VM ทำอะไร |
|---|---|
| 4 (บ่าย) | สร้าง VM, ติดตั้ง Docker, SSH เข้าได้ |
| 4 (บ่าย) | เป้าหมายสแกน **Nessus** (เครื่องของตัวเอง — สแกนได้โดยไม่ผิดกฎ) |
| 5 | **Deploy** แอปขึ้น VM แล้วเปิดสู่อินเทอร์เน็ตด้วย **Cloudflare Tunnel** |

> 💡 **ทำก่อนเข้าเรียน (Pre-course):** ดาวน์โหลด VirtualBox และไฟล์ ISO ของ Ubuntu Server LTS (~3 GB) ไว้ล่วงหน้า เพื่อไม่ให้เครือข่ายในห้องอบรมช้า

## 📐 สเปกแนะนำ

| รายการ | ค่า |
|---|---|
| OS | Ubuntu Server LTS ล่าสุด (<https://ubuntu.com/download/server>) |
| CPU | 2 vCPU |
| RAM | 2–4 GB |
| Disk | 25 GB (Dynamically allocated) |
| Network | Adapter 1 = **NAT** (ออกเน็ต), Adapter 2 = **Host-only** (เครื่องเรา ↔ VM) |

เครื่องผู้เรียนควรมี RAM 16 GB เพราะต้องเปิด Docker Desktop และ VM พร้อมกัน

## 📥 1. ติดตั้ง VirtualBox

ดาวน์โหลดจาก <https://www.virtualbox.org/wiki/Downloads> ติดตั้งแบบค่าเริ่มต้น

> 💡 **Windows + WSL2/Docker Desktop:** VirtualBox เวอร์ชันใหม่ใช้งานร่วมกับ Hyper-V/WSL2 ได้ (ผ่าน Windows Hypervisor Platform) แต่ VM อาจช้าลงบ้าง ถ้าเห็นไอคอนเต่าสีเขียว 🐢 ที่มุมหน้าต่าง VM แปลว่ากำลังรันผ่านโหมดนี้ ใช้งานในหลักสูตรได้ปกติ

## 🔌 2. สร้าง Host-only Network

VirtualBox → **File → Tools → Network Manager** → แท็บ *Host-only Networks* → **Create**
ค่าเริ่มต้นมักเป็น `192.168.56.1/24` (เครื่องเรา = `192.168.56.1`)

## 🏗️ 3. สร้าง VM

1. **New** → ตั้งชื่อ `vibe-server` → เลือกไฟล์ ISO → ติ๊ก **Skip Unattended Installation**
2. ตั้ง RAM, CPU, Disk ตามตารางด้านบน
3. **Settings → Network**
   - Adapter 1: *NAT*
   - Adapter 2: เปิดใช้งาน → *Host-only Adapter* → เลือก network ที่สร้างในข้อ 2
4. **Start** แล้วติดตั้ง Ubuntu:
   - Network: ทั้งสอง interface ใช้ DHCP ได้
   - **ติ๊ก Install OpenSSH server**
   - ไม่ต้องเลือก snap เสริมใดๆ (จะติดตั้ง Docker เองในข้อ 5)
5. รีบูต แล้วล็อกอินที่หน้าจอ VM ดู IP ของ Host-only:
   ```bash
   ip -4 addr | grep 192.168.56
   ```
   จด IP ไว้ เช่น `192.168.56.101`

## 🔑 4. SSH จากเครื่องเรา

```bash
ssh <user>@192.168.56.101
```

แนะนำใช้ SSH key แทนรหัสผ่าน:
```bash
ssh-keygen -t ed25519            # ถ้ายังไม่มี key
ssh-copy-id <user>@192.168.56.101
```
Windows PowerShell ไม่มี `ssh-copy-id` — ให้ Claude ช่วย: `ช่วยเขียนคำสั่ง PowerShell คัดลอก public key ไปที่ ~/.ssh/authorized_keys บน VM`

> 💡 ใช้ VSCode Extension **Remote - SSH** เปิดไฟล์บน VM ได้เหมือนเครื่องตัวเอง

## 🐳 5. ติดตั้ง Docker บน VM

ใช้สคริปต์ [`examples/vm-setup.sh`](examples/vm-setup.sh) (ติดตั้ง Docker Engine ตามเอกสาร Docker + เปิด firewall เฉพาะ SSH):

```bash
# บนเครื่องเรา
scp day-4-testing-security/examples/vm-setup.sh <user>@192.168.56.101:~
# บน VM
bash ~/vm-setup.sh
exit   # ล็อกอินใหม่เพื่อให้ group docker มีผล
```

ทดสอบบน VM:
```bash
docker run --rm hello-world
docker compose version
```

## 📸 6. Snapshot

VirtualBox → เลือก VM → **Snapshots → Take** ตั้งชื่อ `clean-docker`
ถ้าทำอะไรพังในวันต่อๆ ไป ย้อนกลับมาจุดนี้ได้ทันที

## 🛠️ Troubleshooting

| อาการ | วิธีแก้ |
|---|---|
| สร้าง VM แบบ 64-bit ไม่ได้ | เปิด VT-x/AMD-V ใน BIOS, Windows: เปิด feature *Windows Hypervisor Platform* |
| VM ช้ามาก | ลด RAM ของ Docker Desktop (Settings → Resources / `.wslconfig`), ปิดโปรแกรมอื่น |
| ไม่เห็น IP 192.168.56.x | ตรวจว่า Adapter 2 เป็น Host-only และ interface ได้ DHCP (`sudo netplan apply`) |
| SSH `Connection refused` | บน VM: `sudo systemctl status ssh` ถ้ายังไม่ติดตั้ง `sudo apt install openssh-server` |
| Nessus (ใน Docker Desktop) มองไม่เห็น VM | ลองติดตั้ง Nessus ลง Windows โดยตรง หรือติดตั้ง Nessus ในอีก VM บน Host-only network เดียวกัน |

---

<p align="center"><a href="README.md#️-5-สร้าง-server-จำลองด้วย-virtualbox-13001415">⬅️ กลับไปบทเรียนวันที่ 4</a> · <a href="../README.md">🏠 หน้าหลัก</a></p>
