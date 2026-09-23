# Prompt Patterns สำหรับ Claude Code

## 1. บริบท → งาน → ข้อจำกัด → เกณฑ์เสร็จ

```
[บริบท]     อ่าน CLAUDE.md และ backend/src/routes/bookings.js
[งาน]       เพิ่ม endpoint PATCH /api/bookings/:id สำหรับแก้เวลาจอง
[ข้อจำกัด]   ห้ามจองซ้อนเวลาห้องเดียวกัน, ใช้ transaction, ไม่แก้ไฟล์อื่นนอกจาก routes และ tests
[เสร็จเมื่อ]  มี integration test ครอบคลุมกรณีสำเร็จ/ซ้อนเวลา/ไม่พบ และรันผ่าน
```

## 2. วางแผนก่อนลงมือ
```
ยังไม่ต้องแก้โค้ด — เสนอแผนก่อนว่าจะแก้ไฟล์ไหนบ้างและทำไม
```
ใช้ร่วมกับ **Plan mode** ของ Claude Code ได้

## 3. ถามกลับเมื่อไม่ชัด
```
ถ้ามีข้อมูลไม่พอให้ถามฉันก่อน ไม่เกิน 3 คำถาม อย่าเดา
```

## 4. ส่ง Error แบบเต็ม
```
ทำ <ขั้นตอน> แล้วเจอ error นี้:
<วาง error ทั้งหมด รวม stack trace>
คาดหวังว่า: <ผลที่ควรเป็น>
```

## 5. ป้องกันการ "โกง" Test
```
ถ้า test fail เพราะโค้ดผิด ให้แก้โค้ด ห้ามแก้ test ให้ผ่านโดยไม่บอก
ห้าม skip test หรือลด threshold ของ security scan
```

## 6. จำกัดขอบเขต
```
แก้เฉพาะ frontend/src/lib/BookingForm.svelte อย่าแตะไฟล์อื่น
```

## 7. อธิบายให้เรียนรู้
```
อธิบายสิ่งที่เพิ่งแก้ให้คนที่เพิ่งเริ่มเขียน Node.js เข้าใจ ไม่เกิน 10 บรรทัด
```

## 8. Review ตัวเอง
```
review diff ที่ยังไม่ commit ในมุม security และ edge case ก่อนที่ฉันจะ commit
```

## Anti-patterns ที่ควรเลี่ยง
- ❌ "ทำให้แอปดีขึ้น" — กว้างเกินไป
- ❌ "แก้ bug" โดยไม่มี error หรือขั้นตอน reproduce
- ❌ สั่งหลายฟีเจอร์ในครั้งเดียวโดยไม่ commit ระหว่างทาง
- ❌ วาง password/API key ลงใน Prompt

อ้างอิง: Anthropic Prompt Engineering Guide และ Claude Code Best Practices — ดู [CREDITS.md](../CREDITS.md)
