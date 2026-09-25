# 📆 Prompt หลักรายวัน

รายละเอียดและบริบทของแต่ละ Prompt อยู่ในบทเรียนของวันนั้นๆ

## 🧰 วันที่ 1
- 🎬 สาธิตสด: `สร้างเว็บหน้าเดียวสำหรับสุ่มชื่อผู้อบรมในห้องนี้ มีปุ่ม "สุ่ม" และรายชื่อแก้ไขได้ ใช้ HTML ไฟล์เดียว`
- 🔍 ลองครั้งแรก: `สร้างไฟล์ hello.html ที่แสดงคำว่า "สวัสดี Vibe Coding" ตัวใหญ่กลางจอ พื้นหลังไล่สี แล้วบอกวิธีเปิดดู` → [day-1 §5](../day-1-intro/README.md#-5-ติดตั้ง-vscode--claude-code-13451445)

## 🎮 วันที่ 2
- 🎮 Claude Code Bootcamp: โหมด, โมเดล, คำสั่ง `/` ทีละตัว + custom command → [day-2 §1](../day-2-bootcamp/README.md#-1-claude-code-bootcamp)
- 🌱 Git Bootcamp: `เพิ่มฟังก์ชัน addVat(price) บวก VAT 7% พร้อม test แล้ว commit ให้ด้วย` (อ่านคำสั่ง git ก่อนกด Yes) → [day-2 §2](../day-2-bootcamp/README.md#-2-git-bootcamp)
- 🐳 อธิบาย Compose: `อธิบาย @docker-compose.yml นี้แบบคนเพิ่งเริ่ม ไม่เกิน 10 บรรทัด ยังไม่ต้องแก้อะไร`
- 💡 ขัดเกลา App Idea → [day-2 §4](../day-2-bootcamp/README.md#-4-workshop-เขียน-prompt-app-idea)
- 📝 สร้าง CLAUDE.md ร่างแรก: `/init` หรือ `อ่าน docs/app-idea.md แล้วช่วยกรอก CLAUDE.md ส่วน Project ให้กระชับ`
- 🗄️ อธิบาย SQL: `อธิบาย SQL นี้ทีละบรรทัดแบบคนเพิ่งเริ่ม และบอกว่ามีความเสี่ยงอะไรไหม: <SQL>` → [day-2 §7](../day-2-bootcamp/README.md#️-7-ฐานข้อมูล-dbms--datagrip--dbeaver)
- 🧪 Scaffold จาก Prompt เดียว → [day-2 §8](../day-2-bootcamp/README.md#-8-lab-scaffold-จาก-prompt-เดียว)
- 🎨 UI เชื่อม API → [day-2 §9](../day-2-bootcamp/README.md#-9-lab-svelte-ui-เชื่อม-api)

## 🏗️ วันที่ 3
- ☁️ แก้ปัญหา Tunnel: `ฉันรัน cloudflared quick tunnel บน Ubuntu VM ด้วย docker แล้ว URL เปิดไม่ได้ ... ช่วยไล่หาสาเหตุทีละขั้น` → [day-3 §2](../day-3-server-auth/README.md#️-2-cloudflare-tunnel--เปิดเว็บใน-vm-ให้คนภายนอกเข้าได้)
- 📧 วางแผน Login ผ่าน Email (Plan mode) → [day-3 §3](../day-3-server-auth/README.md#-3-login-ผ่าน-email-13001415)
- 🔑 เรียนจาก repo ตัวอย่างแล้ววางแผน 2FA: `อ่านโปรเจกต์ตัวอย่างใน ~/2fa-example เฉพาะส่วน 2FA ... แล้ววางแผนนำ TOTP 2FA + backup codes มาใส่ในแอปของฉัน` → [day-3 §4](../day-3-server-auth/README.md#-4-2fa--mfa--ให้-claude-เรียนจาก-repo-ตัวอย่าง-14151515)
- 👮 เรียนจาก repo ตัวอย่างแล้ววางแผน RBAC: `อ่านโปรเจกต์ตัวอย่างใน ~/2fa-example เฉพาะส่วน RBAC ... แล้ววางแผนเพิ่ม RBAC ให้แอปของฉัน` → [day-3 §5](../day-3-server-auth/README.md#-5-rbac--กำหนดสิทธิ์ตามบทบาท-15151600)
- 🔍 ตรวจงาน auth: `/security-review`

## 🚀 วันที่ 4
- 🧪 วางแผน test → [day-4 §3](../day-4-build-deploy/README.md#-3-unit-test--integration-test)
- 📦 แก้ตามผล Snyk: `นี่คือผล snyk test: <ผล> จัดลำดับตามความรุนแรง ... แก้เฉพาะ High/Critical ก่อน`
- 🕷️ แก้ตาม ZAP: `นี่คือ alert จาก ZAP: <รายการ> แก้ใน backend ... อธิบายแต่ละ alert สั้นๆ`
- 🛰️ ตีความ Nessus: `สรุป finding เป็นภาษาไทย: ความเสี่ยง, เกี่ยวกับแอปหรือ OS, วิธีแก้`
- 🌍 Deploy → [day-4 §8](../day-4-build-deploy/README.md#-8-deploy-ขึ้น-server-จริง)
- 🏃 วางแผน Sprint: `วางแผน Sprint (1 ชั่วโมง) เป็น task ย่อยที่แต่ละ task commit ได้เอง เรียงตามลำดับความสำคัญ` → [day-4 §9](../day-4-build-deploy/README.md#-9-sprint--ปิดฟีเจอร์--polish--แก้บั๊ก)
- 🎤 ร่างสไลด์ Demo: `อ่าน docs/app-idea.md, README.md และ git log --oneline แล้วช่วยกรอก templates/demo-presentation.md` → [day-4 §10](../day-4-build-deploy/README.md#-10-อัปเดต-server--เตรียมนำเสนอ-การบ้าน)
- ⚙️ สร้าง CI/CD → [day-4 §11](../day-4-build-deploy/README.md#️-11-cicd-ด้วย-github-actions-15001600)

## 🎤 วันที่ 5 — Demo Day (ไม่มีการสอน)
- แชร์ Prompt ที่ได้ผลที่สุดของตัวเองใน [community.md](community.md)
