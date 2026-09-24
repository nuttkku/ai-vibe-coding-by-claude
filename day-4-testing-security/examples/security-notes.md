# Security Notes — <ชื่อแอป>

บันทึกผลสแกนและการแก้ไข (ตัวอย่างแม่แบบ — คัดลอกไปไว้ที่ `docs/security-notes.md` ในโปรเจกต์ของคุณ)

| วันที่ | เครื่องมือ | Finding | Severity | การแก้ไข | Commit |
|---|---|---|---|---|---|
| YYYY-MM-DD | Snyk | `<package>@<version>` Prototype Pollution | High | อัปเกรดเป็น `<version>` | `abc1234` |
| YYYY-MM-DD | ZAP | CSP Header Not Set | Medium | เพิ่ม `helmet()` ใน Express | `def5678` |
| YYYY-MM-DD | Nessus | SSH อนุญาต password login | Medium | ปิด `PasswordAuthentication` | — (server config) |

## ความเสี่ยงที่ยอมรับ (Accepted risks)
- <finding> — เหตุผลที่ยังไม่แก้ และแผนจะแก้เมื่อไหร่
