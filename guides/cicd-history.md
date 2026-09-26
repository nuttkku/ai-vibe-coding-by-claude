# 📜 History of CI/CD — ที่มาที่ไปของ CI/CD

คู่มือประกอบหัวข้อ CI/CD วันที่ 4 — เล่าว่า CI/CD **เกิดจากปัญหาอะไร ใครเป็นคนเสนอ และแต่ละคนบอกว่ากระบวนการควรเป็นอย่างไร** แล้วเชื่อมกลับมาที่ pipeline ที่เราใช้ในหลักสูตร

> 📚 ทุกหัวข้อมีแหล่งอ้างอิงท้ายไฟล์ (ตัวเลข [n]) — ปีและชื่อยึดตามเอกสารต้นฉบับ

---

## 😫 1. ปัญหาเริ่มต้น: "Integration Hell"

ก่อนยุค CI ทีมพัฒนามักแยกกันเขียนโค้ดหลายสัปดาห์หรือหลายเดือน แล้วค่อย **รวมโค้ด (integrate)** ตอนใกล้ส่งงาน ผลคือ:

- 💥 โค้ดของแต่ละคนชนกันเป็นร้อยจุด ใช้เวลารวมนานพอๆ กับตอนเขียน
- 🐛 บั๊กถูกพบช้า — ยิ่งพบช้า ยิ่งแก้แพง เพราะจำไม่ได้แล้วว่าแก้อะไรไป
- 😰 การ release เป็นงานใหญ่ น่ากลัว ทำปีละไม่กี่ครั้ง และมักพังตอนขึ้นระบบจริง

ประวัติของ CI/CD คือการตอบคำถามเดียวซ้ำๆ: **"ทำอย่างไรให้การรวมโค้ดและการส่งมอบซอฟต์แวร์ เป็นเรื่องเล็ก บ่อย และไม่น่ากลัว"**

---

## 🕰️ 2. Timeline

| ปี | เหตุการณ์ | สิ่งที่เปลี่ยน |
|---|---|---|
| **1991** | Grady Booch ใช้คำว่า *continuous integration* ในหนังสือ Object-Oriented Design [1] | เป็นแค่การเอ่ยถึงสั้นๆ ประโยคเดียว ยังไม่ใช่แนวปฏิบัติ [2] |
| **1996** | Steve McConnell เขียนบทความ **"Daily Build and Smoke Test"** (IEEE Software, ก.ค. 1996) เล่าวิธีของ Microsoft [3] | build ทั้งโปรเจกต์ **ทุกวัน** + ทดสอบเบื้องต้น (smoke test) |
| **ปลายทศวรรษ 1990** | Kent Beck พัฒนา CI เป็นแนวปฏิบัติหนึ่งของ **Extreme Programming (XP)** [2] และเขียนหนังสือ *Extreme Programming Explained* (1999) [4] | integrate **หลายครั้งต่อวัน** ไม่ใช่วันละครั้ง |
| **2000** | Martin Fowler เผยแพร่บทความ **"Continuous Integration"** (10 ก.ย. 2000; ปรับปรุง 2006; เขียนใหม่ 18 ม.ค. 2024) [2] | รวบรวมแนวปฏิบัติ CI เป็นข้อๆ ที่คนทั้งวงการอ้างถึง |
| **~2001** | **CruiseControl** จาก ThoughtWorks — Fowler เรียกว่า "CI service ตัวแรก" [2] | มีเครื่องมือที่ build + test อัตโนมัติทุกครั้งที่มี commit |
| **2004–2005** | Kohsuke Kawaguchi สร้าง **Hudson** ที่ Sun (เริ่ม 2004, ออก ก.พ. 2005) [5] | CI server แบบ open source ที่ติดตั้งง่าย แพร่หลายมาก |
| **2007** | Paul Duvall และคณะ เขียน *Continuous Integration: Improving Software Quality and Reducing Risk* [6] | CI กลายเป็นความรู้มาตรฐานในวงการ |
| **ก.พ. 2009** | Timothy Fitz เขียน **"Continuous Deployment at IMVU: Doing the impossible fifty times a day"** [7] | **Continuous Deployment** — ผ่าน test แล้วขึ้นระบบจริงอัตโนมัติ วันละหลายสิบครั้ง |
| **มิ.ย. 2009** | John Allspaw & Paul Hammond บรรยาย **"10+ Deploys Per Day: Dev and Ops Cooperation at Flickr"** ที่ Velocity [8] | จุดประกาย **DevOps** — ทีม Dev กับ Ops ต้องทำงานด้วยกัน |
| **ต.ค. 2009** | Patrick Debois จัด **DevOpsDays** ครั้งแรกที่ Ghent ประเทศเบลเยียม [9] | เกิดคำว่า "DevOps" และชุมชน DevOps |
| **2010** | Jez Humble & David Farley ออกหนังสือ **Continuous Delivery** [10] | แนวคิด **Deployment Pipeline** และ "ซอฟต์แวร์ต้องพร้อม release ได้ตลอดเวลา" |
| **ม.ค. 2011** | ชุมชน Hudson ลงมติ fork โปรเจกต์ใหม่ชื่อ **Jenkins** หลังปัญหากับ Oracle (release แรก 11 ก.พ. 2011) [5] | Jenkins กลายเป็น CI server ที่ใช้มากที่สุดในยุคนั้น |
| **2013** | **Docker** เปิดตัว [11] | build ครั้งเดียวเป็น **image** แล้วรันเหมือนกันทุกที่ — CI/CD ส่งมอบ image แทนไฟล์ |
| **2014–2018** | รายงาน **State of DevOps** และหนังสือ **Accelerate** (Forsgren, Humble, Kim, 2018) [12] | พิสูจน์ด้วยข้อมูลว่าทีมที่ deploy บ่อยกลับ **เสถียรกว่า** — เกิด **DORA metrics** [13] |
| **2018–2019** | **GitHub Actions** เปิดตัว (2018) แล้วรองรับ CI/CD เต็มรูปแบบ 8 ส.ค. 2019 (GA 13 พ.ย. 2019) [14] | CI/CD อยู่ใน repo เดียวกับโค้ด เขียนเป็นไฟล์ YAML — ในหลักสูตรใช้เป็น **ส่วนเสริม** |
| **2020s** | **DevSecOps / Shift-left security** — ใส่ security scan (SCA, SAST, DAST, image scan) ใน pipeline · กรอบความปลอดภัยของ supply chain เช่น SLSA [15] | ตรวจความปลอดภัย **ทุก commit** ไม่ใช่ปีละครั้ง — เหมือน Snyk/ZAP ใน `ci.yml` ของเรา |

---

## 🗣️ 3. แต่ละคนบอกว่ากระบวนการควรเป็นอย่างไร

### 🧪 Microsoft / McConnell (1996) — Daily Build and Smoke Test [3]

1. **build ทั้งระบบทุกวัน** — compile, link ทุกไฟล์เป็นโปรแกรมที่รันได้
2. **smoke test** — ทดสอบง่ายๆ ว่าโปรแกรม "ไม่ควันขึ้น" (ทำงานพื้นฐานได้)
3. ถ้า build พัง = **งานด่วนอันดับแรก** ของทีม ต้องแก้ทันที

> 💡 ข้อจำกัด: วันละครั้งยังช้าเกินไป และมักไม่มีชุด test อัตโนมัติที่ครบ — Fowler ชี้ว่านี่คือสิ่งที่ต่างจาก CI จริง [2]

### ⚡ Kent Beck / Extreme Programming (ปลาย 1990s) [2][4]

- integrate และ test **หลายครั้งต่อวัน** แทนที่จะรอ
- ทุกการเปลี่ยนแปลงต้องผ่าน **test อัตโนมัติ** ทั้งหมด
- หลักคิด: **"ถ้าอะไรเจ็บปวด ให้ทำบ่อยขึ้น"** — การ integrate ที่ทำบ่อยจะเล็กและง่าย

### 📋 Martin Fowler (2000 → 2024) — แนวปฏิบัติ CI 11 ข้อ [2]

| # | แนวปฏิบัติ (ตามชื่อในบทความ) | ความหมาย |
|---|---|---|
| 1 | Put everything in a version controlled mainline | ทุกอย่างที่ต้องใช้ build อยู่ใน git สาขาหลัก |
| 2 | Automate the Build | build ได้ด้วยคำสั่งเดียว |
| 3 | Make the Build Self-Testing | build ต้องรัน test เองและบอกผ่าน/ไม่ผ่าน |
| 4 | Everyone Pushes Commits To the Mainline Every Day | ทุกคน push เข้าสาขาหลักอย่างน้อยวันละครั้ง |
| 5 | Every Push to Mainline Should Trigger a Build | ทุก push ต้องมีเครื่องกลาง build ให้ |
| 6 | Fix Broken Builds Immediately | build แดง = ทุกคนหยุดแก้ก่อน |
| 7 | Keep the Build Fast | build ต้องเร็ว (Beck แนะนำราว 10 นาที) |
| 8 | Hide Work-in-Progress | ฟีเจอร์ที่ยังไม่เสร็จซ่อนไว้ (เช่น feature flag) แต่ยัง merge ได้ |
| 9 | Test in a Clone of the Production Environment | ทดสอบในสภาพแวดล้อมเหมือนของจริง |
| 10 | Everyone can see what's happening | ทุกคนเห็นสถานะ build |
| 11 | Automate Deployment | deploy ด้วยสคริปต์ ไม่ใช่มือ |

### 🚀 Timothy Fitz / IMVU (2009) — Continuous Deployment [7]

1. commit บ่อยๆ (continuous integration)
2. **รัน test ทั้งหมดอัตโนมัติทุก commit**
3. ถ้า **ผ่านทั้งหมด → deploy ขึ้น cluster จริงทันที** ไม่มีคนกดปุ่ม
4. เฝ้าดูระบบหลัง deploy — ถ้าผิดปกติให้ย้อนกลับ

> 💡 คนในวงการตอนนั้นคิดว่า "เป็นไปไม่ได้" — จึงเป็นที่มาของชื่อบทความ "Doing the impossible fifty times a day"

### 🤝 Allspaw & Hammond / Flickr (2009) — Dev + Ops ร่วมมือกัน [8]

**เครื่องมือ:** infrastructure อัตโนมัติ · version control ที่ใช้ร่วมกัน · build และ deploy ด้วยขั้นตอนเดียว · feature flags · metrics ที่ทุกคนเห็นร่วมกัน
**วัฒนธรรม:** เคารพกัน · ไว้ใจกัน · มองความล้มเหลวอย่างสร้างสรรค์ · **ไม่โทษกัน (no blame)**

### 🏗️ Humble & Farley (2010) — Continuous Delivery และ Deployment Pipeline [10][16]

**Deployment Pipeline** = การทำให้เส้นทางจาก commit ถึงระบบจริงเป็นอัตโนมัติ แบ่งเป็นด่าน:

```
 commit ──► Commit stage ──► Automated acceptance tests ──► (performance / manual testing) ──► Release
            compile, unit test,     ทดสอบระบบทั้งก้อน              ด่านเพิ่มตามความจำเป็น          กดปุ่มเดียว
            วิเคราะห์โค้ด, สร้าง artifact
```

**หลักการ 8 ข้อของการส่งมอบซอฟต์แวร์** [10]:
1. สร้างกระบวนการ release ที่ **ทำซ้ำได้และเชื่อถือได้**
2. **Automate almost everything**
3. **Keep everything in version control**
4. **If it hurts, do it more frequently, and bring the pain forward**
5. **Build quality in** — ใส่คุณภาพตั้งแต่ต้น ไม่ใช่ตรวจตอนท้าย
6. **Done means released** — เสร็จ = อยู่ในมือผู้ใช้แล้ว
7. **Everybody is responsible for the delivery process**
8. **Continuous improvement**

แนวปฏิบัติสำคัญ: **build artifact ครั้งเดียว** แล้วใช้ตัวเดียวกันทุกสภาพแวดล้อม · deploy ด้วยวิธีเดียวกันทุกที่ · ถ้าด่านไหนพัง **หยุดทั้ง line**

### 📊 DORA / Accelerate (2014–ปัจจุบัน) — วัดผลด้วยข้อมูล [12][13]

งานวิจัยหลายปีพบว่าทีมที่ **ส่งมอบบ่อย** กลับ **เสถียรกว่า** — ความเร็วกับความเสถียรไปด้วยกันได้ · DORA วัดด้วย metrics (เดิม "four keys" ปัจจุบันขยายเป็น 5 ตัว) [13]:

| กลุ่ม | Metric | ความหมาย |
|---|---|---|
| ⚡ ความเร็ว | Change lead time | จาก commit ถึงขึ้นระบบจริงใช้เวลาเท่าไหร่ |
| ⚡ ความเร็ว | Deployment frequency | deploy บ่อยแค่ไหน |
| ⚡ ความเร็ว | Failed deployment recovery time | deploy พังแล้วกู้คืนได้เร็วแค่ไหน |
| 🛡️ ความเสถียร | Change fail rate | สัดส่วน deploy ที่ต้องแก้ด่วน/rollback |
| 🛡️ ความเสถียร | Deployment rework rate | สัดส่วน deploy ที่ไม่ได้วางแผน เพราะต้องแก้ปัญหาในระบบจริง |

---

## 🔤 4. CI · Continuous Delivery · Continuous Deployment ต่างกันอย่างไร

```
 เขียนโค้ด ─► push ─► build + test อัตโนมัติ ─► artifact พร้อม release ─► ขึ้นระบบจริง
 └────────── CI ──────────────┘
 └────────────── Continuous Delivery ──────────────┘ + คนกดปุ่ม release
 └────────────────────── Continuous Deployment ───────────────────────────┘ อัตโนมัติทั้งหมด
```

| | CI | Continuous Delivery | Continuous Deployment |
|---|---|---|---|
| ทำอะไร | รวมโค้ดบ่อย + build/test อัตโนมัติทุก push | ทุกการเปลี่ยนแปลงที่ผ่าน pipeline **พร้อม release ได้เสมอ** | ทุกการเปลี่ยนแปลงที่ผ่าน pipeline **ขึ้นระบบจริงอัตโนมัติ** |
| คนต้องทำอะไร | แก้ build ที่แดงทันที | **ตัดสินใจกดปุ่ม** release | ไม่ต้องกด — ดูแล test และ monitoring ให้ดี |
| ใครเสนอ | Beck / Fowler [2] | Humble & Farley [10][16] | Fitz [7] |

> 💡 **"CD"** จึงหมายถึงได้ทั้ง Delivery และ Deployment — ต้องดูบริบท [16]

---

## 🔗 5. เชื่อมกับ pipeline ในหลักสูตร

ในหลักสูตรเรา **ไม่ยึดติดเครื่องมือ** — ผู้เรียนเขียนสเปก pipeline เอง (`docs/pipeline.md`) แล้วให้ Claude สร้าง `scripts/pipeline.sh` ที่ทำตามสเปก ส่วน GitHub Actions เป็นส่วนเสริม

| แนวคิด (ใคร) | อยู่ตรงไหนในหลักสูตร |
|---|---|
| Keep everything in version control (Humble & Farley [10]) | สเปก `docs/pipeline.md` และ `scripts/pipeline.sh` อยู่ใน git |
| Make the build self-testing (Fowler [2]) | ด่าน 🧪 Test |
| Fix broken builds immediately (Fowler [2]) | กติกา **fail fast** — ด่านไหนแดง หยุดทั้งเส้น |
| Build quality in / Shift-left security (Humble & Farley [10], DevSecOps [15]) | ด่าน 🛡️ Security ก่อน Build |
| Build artifact ครั้งเดียว (Humble & Farley [10]) + Docker [11] | ด่าน 🐳 Build (docker image) |
| Test in a clone of production (Fowler [2]) | ด่าน 💨 Smoke รันด้วย Docker Compose เหมือนบน VM |
| Automate deployment (Fowler [2]) / Continuous Delivery (Humble & Farley [10]) | ด่าน 🌍 Deploy ขึ้น VM — **เรากดรันเอง = Continuous Delivery** |
| Continuous Deployment (Fitz [7]) | (ต่อยอด) ให้ pipeline รันอัตโนมัติทุก push เช่น ผ่าน GitHub Actions |
| Everyone can see what's happening (Fowler [2]) | สคริปต์พิมพ์ ✅/❌ ทุกด่าน · (เสริม) แท็บ Actions บน GitHub |

## 🗣️ 6. คำถามชวนคิดในห้อง

- ทำไมการ deploy **บ่อยขึ้น** ถึงทำให้ระบบ **พังน้อยลง** ตามงานวิจัยของ DORA?
- แอปของเราควรเป็น Continuous **Delivery** หรือ Continuous **Deployment**? เพราะอะไร?
- ถ้า AI ช่วยเขียนโค้ดเร็วขึ้น 10 เท่า CI/CD สำคัญขึ้นหรือน้อยลง?

---

## 📚 แหล่งอ้างอิง

1. Grady Booch. *Object Oriented Design with Applications*. Benjamin/Cummings, 1991.
2. Martin Fowler. "Continuous Integration" (2000, ปรับปรุง 2006, เขียนใหม่ 2024). <https://martinfowler.com/articles/continuousIntegration.html>
3. Steve McConnell. "Daily Build and Smoke Test". *IEEE Software* 13(4), July 1996. <https://stevemcconnell.com/articles/daily-build-and-smoke-test/>
4. Kent Beck. *Extreme Programming Explained: Embrace Change*. Addison-Wesley, 1999.
5. Hudson / Jenkins history: <https://en.wikipedia.org/wiki/Hudson_(software)> · <https://en.wikipedia.org/wiki/Jenkins_(software)>
6. Paul M. Duvall, Steve Matyas, Andrew Glover. *Continuous Integration: Improving Software Quality and Reducing Risk*. Addison-Wesley, 2007.
7. Timothy Fitz. "Continuous Deployment at IMVU: Doing the impossible fifty times a day" (10 Feb 2009). <https://timothyfitz.com/2009/02/10/continuous-deployment-at-imvu-doing-the-impossible-fifty-times-a-day/>
8. John Allspaw & Paul Hammond. "10+ Deploys Per Day: Dev and Ops Cooperation at Flickr". Velocity 2009. <https://www.youtube.com/watch?v=LdOe18KhtT4>
9. DevOpsDays — About / history. <https://devopsdays.org/about>
10. Jez Humble & David Farley. *Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation*. Addison-Wesley, 2010. <https://continuousdelivery.com/>
11. Docker (software) — history. <https://en.wikipedia.org/wiki/Docker_(software)>
12. Nicole Forsgren, Jez Humble, Gene Kim. *Accelerate: The Science of Lean Software and DevOps*. IT Revolution, 2018. <https://itrevolution.com/product/accelerate/>
13. DORA — Software delivery performance metrics. <https://dora.dev/guides/dora-metrics-four-keys/>
14. GitHub Blog. "GitHub Actions now supports CI/CD, free for public repositories" (8 Aug 2019). <https://github.blog/news-insights/product-news/github-actions-now-supports-ci-cd/>
15. SLSA — Supply-chain Levels for Software Artifacts. <https://slsa.dev/>
16. Martin Fowler. "Continuous Delivery" (bliki) · "Deployment Pipeline" (bliki). <https://martinfowler.com/bliki/ContinuousDelivery.html> · <https://martinfowler.com/bliki/DeploymentPipeline.html>
