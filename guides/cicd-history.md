# 📜 History of CI/CD — ที่มาที่ไปของ CI และ CD

คู่มือประกอบหัวข้อ CI/CD วันที่ 4 — เล่าว่า **CI** และ **CD** เกิดจากปัญหาอะไร ใครเป็นคนเสนอ และแต่ละคนบอกว่ากระบวนการควรเป็นอย่างไร

> 📚 **กดตัวเลข `[n]` เพื่อเปิดอ่านต้นฉบับได้ทันที** — ปี ชื่อ และคำพูดในไฟล์นี้ตรวจกับแหล่งต้นฉบับแล้ว ข้อมูลที่ยืนยันจากต้นฉบับไม่ได้ถูกตัดออก
> ข้อความในเครื่องหมาย *"..."* เป็นข้อความต้นฉบับภาษาอังกฤษ (verbatim) ส่วนคำอธิบายภาษาไทยเป็นการสรุปความ

---

## 🧭 0. CI กับ CD ไม่ได้เกิดมาพร้อมกัน

ทุกวันนี้เราพูดติดกันว่า "CI/CD" แต่จริงๆ เป็น **สองกระแสที่เกิดห่างกันราว 10 ปี** และแก้ปัญหาคนละช่วงของงาน

```
 ทศวรรษ 1990 ── 2000 ─────────── 2009–2010 ─────────────── 2013 → ปัจจุบัน
 🔵 CI: ปัญหา "รวมโค้ด"          🟢 CD: ปัญหา "ส่งโค้ดถึงผู้ใช้"   🟣 รวมเป็น "CI/CD"
 McConnell · Beck · Fowler       Fitz · Flickr · Humble & Farley   Docker · DORA · GitHub Actions
```

| | 🔵 CI — Continuous Integration | 🟢 CD — Continuous Delivery / Deployment |
|---|---|---|
| ยุค | ทศวรรษ 1990 – ต้นทศวรรษ 2000 | ปลายทศวรรษ 2000 – 2010 |
| ปัญหาที่แก้ | หลายคนแยกกันเขียนนานๆ แล้ว **รวมโค้ด** ตอนท้าย → ชนกัน พบบั๊กช้า | รวมโค้ดได้แล้ว แต่ **การนำขึ้นระบบจริง** ยังช้า เสี่ยง และทำด้วยมือ |
| ใครเกี่ยว | ทีมพัฒนา (Dev) | ทีมพัฒนา + ทีมดูแลระบบ (Dev + Ops) |
| คำถามหลัก | "โค้ดของทุกคนรวมกันแล้วยังทำงานไหม?" | "โค้ดที่ผ่านแล้ว ถึงมือผู้ใช้ได้เร็วและปลอดภัยไหม?" |

---

# 🔵 ส่วน A: Continuous Integration (CI)

## 🕰️ A1. Timeline ของ CI

| ปี | เหตุการณ์ | แหล่ง |
|---|---|---|
| **1991** | Grady Booch ใช้วลี *continuous integration* ในหนังสือ *Object Oriented Design with Applications* — Fowler ระบุว่าเป็นแค่การเอ่ยถึงในประโยคเดียว | [[1]](https://archive.org/details/objectorientedde00grad) [[2]](https://martinfowler.com/articles/continuousIntegration.html) |
| **ก.ค. 1996** | Steve McConnell เขียน **"Daily Build and Smoke Test"** ใน *IEEE Software* เล่าแนวปฏิบัติที่ Microsoft ใช้ | [[3]](https://stevemcconnell.com/articles/daily-build-and-smoke-test/) |
| **ทศวรรษ 1990** | Kent Beck พัฒนา CI เป็นแนวปฏิบัติหนึ่งของ **Extreme Programming (XP)** | [[2]](https://martinfowler.com/articles/continuousIntegration.html) |
| **ต.ค. 1999** | Kent Beck ออกหนังสือ *Extreme Programming Explained: Embrace Change* | [[4]](https://www.oreilly.com/library/view/extreme-programming-explained/0201616416/) |
| **10 ก.ย. 2000** | Martin Fowler เผยแพร่บทความ **"Continuous Integration"** (ปรับปรุง 1 พ.ค. 2006, เขียนใหม่ 18 ม.ค. 2024) | [[2]](https://martinfowler.com/articles/continuousIntegration.html) |
| **ต้นทศวรรษ 2000** | **CruiseControl** และ CI service อื่นๆ ทำให้ CI แพร่หลาย | [[2]](https://martinfowler.com/articles/continuousIntegration.html) |
| **2004** | Kohsuke Kawaguchi เริ่มเขียน **Hudson** ขณะทำงานที่ Sun Microsystems | [[5]](https://www.theregister.com/2018/11/09/jenkins_interview/) |
| **2007** | Duvall, Matyas, Glover ออกหนังสือ *Continuous Integration: Improving Software Quality and Reducing Risk* (Jolt Award 2008) | [[6]](https://www.informit.com/store/continuous-integration-improving-software-quality-and-9780132651165) |
| **ม.ค. 2011** | Hudson เปลี่ยนชื่อเป็น **Jenkins** เพราะ Oracle อ้างสิทธิ์เครื่องหมายการค้าชื่อ "Hudson" | [[7]](https://kohsuke.org/2011/01/11/bye-bye-hudson-hello-jenkins/) [[8]](https://www.jenkins.io/blog/2011/01/11/hudsons-future/) |

## 🗣️ A2. กระบวนการตามต้นฉบับ

### 🧪 McConnell (1996) — Daily Build and Smoke Test [[3]](https://stevemcconnell.com/articles/daily-build-and-smoke-test/)

> *"A common practice at Microsoft and some other shrink-wrap software companies is the 'daily build and smoke test' process."*

> *"Every file is compiled, linked, and combined into an executable program every day, and the program is then put through a 'smoke test.'"*

สรุป: **build ทั้งระบบเป็นโปรแกรมที่รันได้ทุกวัน** แล้วทดสอบเบื้องต้น (smoke test) ว่าโปรแกรมทำงานพื้นฐานได้

### ⚡ จาก daily build สู่ CI — Fowler ชี้ความต่าง [[2]](https://martinfowler.com/articles/continuousIntegration.html)

> *"Continuous Integration was developed as a practice by Kent Beck as part of Extreme Programming in the 1990s."*

> *"Microsoft had been known for doing daily builds (usually overnight), but without the testing regimen or the focus on fixing defects that are such crucial elements of Continuous Integration."*

> *"Some people credit Grady Booch for coining the term, but he only used the phrase as an offhand description in a single sentence in his object-oriented design book."*

สรุป: daily build คือ "build ทุกวัน" แต่ CI เพิ่ม **ชุด test อัตโนมัติ** และ **การแก้ข้อผิดพลาดทันที** เข้าไป

### 📋 Fowler — แนวปฏิบัติ CI 11 ข้อ [[2]](https://martinfowler.com/articles/continuousIntegration.html)

| # | แนวปฏิบัติ (ชื่อตามบทความ) | ความหมาย |
|---|---|---|
| 1 | Put everything in a version controlled mainline | ทุกอย่างที่ต้องใช้ build อยู่ใน version control สาขาหลัก |
| 2 | Automate the Build | build ได้ด้วยคำสั่งเดียว |
| 3 | Make the Build Self-Testing | build ต้องรัน test เองและบอกผ่าน/ไม่ผ่าน |
| 4 | Everyone Pushes Commits To the Mainline Every Day | ทุกคน push เข้าสาขาหลักอย่างน้อยวันละครั้ง |
| 5 | Every Push to Mainline Should Trigger a Build | ทุก push ต้องมีการ build อัตโนมัติ |
| 6 | Fix Broken Builds Immediately | build พัง = แก้ก่อนทำอย่างอื่น |
| 7 | Keep the Build Fast | build ต้องเร็ว ได้ผลเร็ว |
| 8 | Hide Work-in-Progress | ซ่อนงานที่ยังไม่เสร็จ แต่ยังรวมเข้าสาขาหลักได้ |
| 9 | Test in a Clone of the Production Environment | ทดสอบในสภาพแวดล้อมที่เหมือนของจริง |
| 10 | Everyone can see what's happening | ทุกคนเห็นสถานะ build |
| 11 | Automate Deployment | deploy ด้วยสคริปต์ |

> 💡 ข้อ 11 คือสะพานไปสู่ยุค CD — Fowler เขียนเรื่องนี้ไว้ แต่การทำให้ "ส่งถึงผู้ใช้" เป็นเรื่องปกติ เพิ่งเป็นกระแสหลักในส่วน B

### 🛠️ เครื่องมือ: Hudson → Jenkins

Kawaguchi เล่าว่าเริ่มเขียน Hudson เพราะเบื่อที่ build พังบ่อย จนรู้สึกว่า *"I felt like I had to write a program."* [[5]](https://www.theregister.com/2018/11/09/jenkins_interview/)

ปี 2011 ชุมชนย้ายไปใช้ชื่อ Jenkins: *"Oracle was asserting a trademark right to the project name 'Hudson', and that caused some considerable concerns to the community."* [[7]](https://kohsuke.org/2011/01/11/bye-bye-hudson-hello-jenkins/)

---

# 🟢 ส่วน B: Continuous Delivery & Continuous Deployment (CD)

## 😫 B0. ปัญหาใหม่หลัง CI

พอ CI ทำให้ "รวมโค้ด" เป็นเรื่องปกติ ปัญหาย้ายไปอยู่ **ช่วงสุดท้าย** คือการนำขึ้นระบบจริง CD ตั้งเป้าให้ส่งการเปลี่ยนแปลงถึงผู้ใช้ได้ *"safely and quickly in a sustainable way"* [[12]](https://continuousdelivery.com/)

## 🕰️ B1. Timeline ของ CD

| ปี | เหตุการณ์ | แหล่ง |
|---|---|---|
| **10 ก.พ. 2009** | Timothy Fitz เขียน **"Continuous Deployment at IMVU: Doing the impossible fifty times a day"** | [[9]](https://timothyfitz.com/2009/02/10/continuous-deployment-at-imvu-doing-the-impossible-fifty-times-a-day/) |
| **2009** | John Allspaw & Paul Hammond บรรยาย **"10+ Deploys Per Day: Dev and Ops Cooperation at Flickr"** ที่งาน Velocity | [[10]](https://www.youtube.com/watch?v=LdOe18KhtT4) |
| **2009** | **devopsdays** ครั้งแรกที่ Ghent ประเทศเบลเยียม ผู้ก่อตั้งคือ Patrick Debois | [[11]](https://devopsdays.org/about) |
| **2010** | Jez Humble & David Farley ออกหนังสือ **Continuous Delivery** | [[12]](https://continuousdelivery.com/) |
| **2011** | Fowler: *"if it hurts, do it more often"* | [[14]](https://martinfowler.com/bliki/FrequencyReducesDifficulty.html) |
| **2013** | รายงาน **State of DevOps** ฉบับแรก — ต่อมาทีม DORA (Nicole Forsgren, Jez Humble, Gene Kim) ทำวิจัยต่อ และ Google ซื้อ DORA ในปี 2019 | [[18]](https://newsletter.getdx.com/p/history-of-dora) |
| **15 มี.ค. 2013** | Solomon Hykes สาธิต **Docker** ต่อสาธารณะครั้งแรกที่ PyCon | [[17]](https://www.docker.com/blog/docker-nine-years-young/) |
| **30 พ.ค. 2013** | Fowler เขียน bliki **ContinuousDelivery** และ **DeploymentPipeline** | [[15]](https://martinfowler.com/bliki/ContinuousDelivery.html) [[16]](https://martinfowler.com/bliki/DeploymentPipeline.html) |
| **2018** | หนังสือ **Accelerate** (Forsgren, Humble, Kim) | [[19]](https://itrevolution.com/product/accelerate/) |

## 🗣️ B2. กระบวนการตามต้นฉบับ

### 🚀 Timothy Fitz (2009) — Continuous Deployment [[9]](https://timothyfitz.com/2009/02/10/continuous-deployment-at-imvu-doing-the-impossible-fifty-times-a-day/)

> *"Continuously integrate (commit early and often). On commit automatically run all tests. If the tests pass deploy to the cluster. If the deploy succeeds, repeat."*

> *"Our tests suite takes nine minutes to run (distributed across 30-40 machines). Our code pushes take another six minutes."*

สรุป: CI → test ทั้งหมดอัตโนมัติ → ผ่านแล้ว **ขึ้นระบบจริงทันทีโดยไม่มีคนกด** → หลัง deploy ระบบเฝ้าดูตัวเลข ถ้าแย่ลงอย่างมีนัยสำคัญทางสถิติจะ **ย้อนกลับ (rollback) อัตโนมัติ**

> 💡 สังเกตว่าข้อแรกของ Fitz คือ *"Continuously integrate"* — CD **ต่อยอดจาก CI** ไม่ได้มาแทน

### 🤝 Allspaw & Hammond (2009) — Dev + Ops [[10]](https://www.youtube.com/watch?v=LdOe18KhtT4)

ชื่อการบรรยายบอกสาระหลักไว้เอง: Flickr deploy ได้ **มากกว่าวันละ 10 ครั้ง** ด้วย **ความร่วมมือระหว่างทีม Dev กับ Ops** — ดูรายละเอียดจากคลิปต้นฉบับ ปีเดียวกันนั้นเกิดงาน devopsdays ครั้งแรก [[11]](https://devopsdays.org/about)

### 🏗️ Humble & Farley — Continuous Delivery [[12]](https://continuousdelivery.com/)

> *"Continuous Delivery is the ability to get changes of all types—including new features, configuration changes, bug fixes and experiments—into production, or into the hands of users, safely and quickly in a sustainable way."*

**หลักการ 5 ข้อ** ตามเว็บไซต์ continuousdelivery.com [[13]](https://continuousdelivery.com/principles/):

1. Build Quality In — ใส่คุณภาพตั้งแต่ต้น ไม่ใช่ตรวจตอนท้าย
2. Work in Small Batches — ทำทีละชิ้นเล็กๆ
3. Computers Perform Repetitive Tasks, People Solve Problems — งานซ้ำให้เครื่อง คนแก้ปัญหา
4. Relentlessly Pursue Continuous Improvement — ปรับปรุงอย่างต่อเนื่อง
5. Everyone is Responsible — ทุกคนรับผิดชอบร่วมกัน

### 🔁 หลักคิดเบื้องหลัง — Fowler (2011) [[14]](https://martinfowler.com/bliki/FrequencyReducesDifficulty.html)

> *"if it hurts, do it more often"*

งานที่เจ็บปวด (เช่น integrate หรือ deploy) ยิ่งทำบ่อย แต่ละครั้งยิ่งเล็ก ได้ feedback เร็ว และมีแรงจูงใจให้ทำเป็นอัตโนมัติ

### 🚦 Deployment Pipeline — Fowler (2013) [[16]](https://martinfowler.com/bliki/DeploymentPipeline.html)

> *"A deployment pipeline is a way to deal with this by breaking up your build into stages. Each stage provides increasing confidence, usually at the cost of extra time."*

สรุป: แบ่งเส้นทางจาก commit ถึงระบบจริงเป็น **ด่าน** — ด่านแรกเร็ว ด่านหลังช้ากว่าแต่มั่นใจขึ้น

### ⚖️ Continuous Delivery ≠ Continuous Deployment — Fowler (2013) [[15]](https://martinfowler.com/bliki/ContinuousDelivery.html)

> *"Continuous Delivery is a software development discipline where you build software in such a way that the software can be released to production at any time."*

ส่วน Continuous Deployment คือ *"every change goes through the pipeline and automatically gets put into production, resulting in many production deployments every day."*

- **Delivery** = พร้อม release ได้ตลอดเวลา — **คนเลือกว่าจะกดเมื่อไหร่**
- **Deployment** = ทุกการเปลี่ยนแปลงที่ผ่าน pipeline **ขึ้นระบบจริงอัตโนมัติ**

### 🐳 Docker (2013) [[17]](https://www.docker.com/blog/docker-nine-years-young/)

ในการสาธิตครั้งแรกที่ PyCon Solomon Hykes พูดถึงปัญหาว่า *"shipping to the server is hard"* ([🎥 คลิป](https://www.youtube.com/watch?v=wW9CAH9nSLs)) — Docker จึงเป็นเครื่องมือสำคัญของยุค CD: build เป็น image แล้วนำไปรันบน server

### 📊 DORA — วัดผลการส่งมอบ [[18]](https://newsletter.getdx.com/p/history-of-dora) [[20]](https://dora.dev/guides/dora-metrics-four-keys/)

DORA เริ่มจากรายงาน State of DevOps (2013) และสรุปงานวิจัยในหนังสือ Accelerate (2018) [[19]](https://itrevolution.com/product/accelerate/) ปัจจุบันวัดด้วย 5 metrics [[20]](https://dora.dev/guides/dora-metrics-four-keys/):

| กลุ่ม | Metric | ความหมาย |
|---|---|---|
| ⚡ Throughput | Change lead time | จาก commit ถึงขึ้นระบบจริงใช้เวลาเท่าไหร่ |
| ⚡ Throughput | Deployment frequency | deploy บ่อยแค่ไหน |
| ⚡ Throughput | Failed deployment recovery time | deploy พังแล้วกู้คืนได้เร็วแค่ไหน |
| 🛡️ Instability | Change fail rate | สัดส่วน deploy ที่ต้องแก้ไขทันทีหลัง deploy |
| 🛡️ Instability | Deployment rework rate | สัดส่วน deploy ที่ไม่ได้วางแผน เพราะต้องแก้ปัญหาในระบบจริง |

---

# 🟣 ส่วน C: รวมเป็น "CI/CD"

เมื่อเครื่องมือทำได้ครบตั้งแต่ build → test → deploy ในที่เดียว คนจึงเรียกรวมกันว่า **CI/CD**

| ปี | เหตุการณ์ | แหล่ง |
|---|---|---|
| **2018** | GitHub เปิดตัว **GitHub Actions** | [[21]](https://github.blog/news-insights/product-news/github-actions-now-supports-ci-cd/) |
| **8 ส.ค. 2019** | GitHub Actions รองรับ CI/CD (GA 13 พ.ย. 2019) | [[21]](https://github.blog/news-insights/product-news/github-actions-now-supports-ci-cd/) |
| **มิ.ย. 2021** | Google เปิดตัว **SLSA** — กรอบความปลอดภัยของ software supply chain | [[22]](https://security.googleblog.com/2021/06/introducing-slsa-end-to-end-framework.html) |

> *"But we've also heard clear feedback from almost everyone: you want CI/CD!"*
> — Nat Friedman (CEO GitHub ในขณะนั้น), 8 ส.ค. 2019 [[21]](https://github.blog/news-insights/product-news/github-actions-now-supports-ci-cd/)

**ภาพรวมความต่าง:**

```
 เขียนโค้ด ─► push ─► build + test อัตโนมัติ ─► พร้อม release ─► ขึ้นระบบจริง
 └────────── 🔵 CI ───────────┘
 └────────────── 🟢 Continuous Delivery ──────────┘ + คนกดปุ่ม release
 └────────────────────── 🟢 Continuous Deployment ───────────────────┘ อัตโนมัติทั้งหมด
```

| | 🔵 CI | 🟢 Continuous Delivery | 🟢 Continuous Deployment |
|---|---|---|---|
| ทำอะไร | รวมโค้ดบ่อย + build/test อัตโนมัติทุก push | ทุกการเปลี่ยนแปลงที่ผ่าน pipeline **พร้อม release ได้เสมอ** | ทุกการเปลี่ยนแปลงที่ผ่าน pipeline **ขึ้นระบบจริงอัตโนมัติ** |
| คนต้องทำอะไร | แก้ build ที่พังทันที | **ตัดสินใจกด** release | ไม่ต้องกด — ดูแล test และ monitoring |
| ต้นทาง | Beck / Fowler [[2]](https://martinfowler.com/articles/continuousIntegration.html) | Humble & Farley [[12]](https://continuousdelivery.com/), Fowler [[15]](https://martinfowler.com/bliki/ContinuousDelivery.html) | Fitz [[9]](https://timothyfitz.com/2009/02/10/continuous-deployment-at-imvu-doing-the-impossible-fifty-times-a-day/), Fowler [[15]](https://martinfowler.com/bliki/ContinuousDelivery.html) |

> 💡 **"CD"** จึงหมายถึงได้ทั้ง Delivery และ Deployment — ต้องดูบริบท

---

## 🔗 เชื่อมกับ pipeline ในหลักสูตร

ในหลักสูตรเรา **ไม่ยึดติดเครื่องมือ** — ผู้เรียนเขียนสเปก pipeline เอง (`docs/pipeline.md`) แล้วให้ Claude สร้าง `scripts/pipeline.sh` ที่ทำตามสเปก ส่วน GitHub Actions เป็นส่วนเสริม

| แนวคิด (ต้นทาง) | อยู่ตรงไหนในหลักสูตร |
|---|---|
| 🔵 Put everything in a version controlled mainline [[2]](https://martinfowler.com/articles/continuousIntegration.html) | สเปก `docs/pipeline.md` และ `scripts/pipeline.sh` อยู่ใน git |
| 🔵 Make the Build Self-Testing [[2]](https://martinfowler.com/articles/continuousIntegration.html) | ด่าน 🧪 Test |
| 🔵 Fix Broken Builds Immediately [[2]](https://martinfowler.com/articles/continuousIntegration.html) | กติกา **fail fast** — ด่านไหนแดง หยุดทั้งเส้น |
| 🟢 Build Quality In [[13]](https://continuousdelivery.com/principles/) · supply chain security [[22]](https://security.googleblog.com/2021/06/introducing-slsa-end-to-end-framework.html) | ด่าน 🛡️ Security ก่อน Build |
| 🟢 "shipping to the server is hard" → Docker [[17]](https://www.docker.com/blog/docker-nine-years-young/) | ด่าน 🐳 Build เป็น docker image |
| 🔵 Test in a Clone of the Production Environment [[2]](https://martinfowler.com/articles/continuousIntegration.html) | ด่าน 💨 Smoke รันด้วย Docker Compose เหมือนบน VM |
| 🟢 Deployment pipeline แบ่งเป็นด่าน [[16]](https://martinfowler.com/bliki/DeploymentPipeline.html) | Test → Security → Build → Smoke → Deploy |
| 🟢 Continuous Delivery [[15]](https://martinfowler.com/bliki/ContinuousDelivery.html) | ด่าน 🌍 Deploy ขึ้น VM — **เรากดรันเอง = Continuous Delivery** |
| 🟢 Continuous Deployment [[9]](https://timothyfitz.com/2009/02/10/continuous-deployment-at-imvu-doing-the-impossible-fifty-times-a-day/) | (ต่อยอด) ให้ pipeline รันอัตโนมัติทุก push เช่น ผ่าน GitHub Actions |
| 🔵 Everyone can see what's happening [[2]](https://martinfowler.com/articles/continuousIntegration.html) | สคริปต์พิมพ์ ✅/❌ ทุกด่าน · (เสริม) แท็บ Actions บน GitHub |

---

## 🗣️ คำถามชวนคิดในห้อง

- ทำไม CD เกิดหลัง CI เกือบ 10 ปี? ถ้ายังรวมโค้ดกันไม่ได้ จะส่งมอบบ่อยได้ไหม?
- *"if it hurts, do it more often"* ใช้กับการ deploy แอปของเราได้อย่างไร?
- แอปของเราควรเป็น Continuous **Delivery** หรือ Continuous **Deployment**? เพราะอะไร?
- ถ้า AI ช่วยเขียนโค้ดเร็วขึ้นมาก CI/CD สำคัญขึ้นหรือน้อยลง?

---

## 📚 แหล่งอ้างอิง

**🔵 CI**

1. <a id="ref-1"></a>Grady Booch. *Object Oriented Design with Applications*. Benjamin/Cummings, 1991. ISBN 0-8053-0091-0. <https://archive.org/details/objectorientedde00grad>
2. <a id="ref-2"></a>Martin Fowler. "Continuous Integration" (10 Sep 2000; revised 1 May 2006; rewritten 18 Jan 2024). <https://martinfowler.com/articles/continuousIntegration.html>
3. <a id="ref-3"></a>Steve McConnell. "Daily Build and Smoke Test". *IEEE Software* 13(4), July 1996. <https://stevemcconnell.com/articles/daily-build-and-smoke-test/>
4. <a id="ref-4"></a>Kent Beck. *Extreme Programming Explained: Embrace Change*. Addison-Wesley, 1999. ISBN 0-201-61641-6. <https://www.oreilly.com/library/view/extreme-programming-explained/0201616416/>
5. <a id="ref-5"></a>The Register. Interview with Kohsuke Kawaguchi on the origins of Hudson/Jenkins (9 Nov 2018). <https://www.theregister.com/2018/11/09/jenkins_interview/>
6. <a id="ref-6"></a>Paul M. Duvall, Steve Matyas, Andrew Glover. *Continuous Integration: Improving Software Quality and Reducing Risk*. Addison-Wesley, 2007. ISBN 978-0-321-33638-5. <https://www.informit.com/store/continuous-integration-improving-software-quality-and-9780132651165>
7. <a id="ref-7"></a>Kohsuke Kawaguchi. "Bye bye Hudson, Hello Jenkins" (11 Jan 2011). <https://kohsuke.org/2011/01/11/bye-bye-hudson-hello-jenkins/>
8. <a id="ref-8"></a>Jenkins Blog. "Hudson's future" (11 Jan 2011). <https://www.jenkins.io/blog/2011/01/11/hudsons-future/>

**🟢 CD**

9. <a id="ref-9"></a>Timothy Fitz. "Continuous Deployment at IMVU: Doing the impossible fifty times a day" (10 Feb 2009). <https://timothyfitz.com/2009/02/10/continuous-deployment-at-imvu-doing-the-impossible-fifty-times-a-day/>
10. <a id="ref-10"></a>John Allspaw & Paul Hammond. "10+ Deploys Per Day: Dev and Ops Cooperation at Flickr". Velocity 2009 (video). <https://www.youtube.com/watch?v=LdOe18KhtT4>
11. <a id="ref-11"></a>devopsdays — About. <https://devopsdays.org/about>
12. <a id="ref-12"></a>Jez Humble & David Farley. *Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation*. Addison-Wesley, 2010. ISBN 978-0-321-60191-9. · continuousdelivery.com <https://continuousdelivery.com/>
13. <a id="ref-13"></a>Jez Humble. continuousdelivery.com — "Principles". <https://continuousdelivery.com/principles/>
14. <a id="ref-14"></a>Martin Fowler. "Frequency Reduces Difficulty" (bliki, 28 Jul 2011). <https://martinfowler.com/bliki/FrequencyReducesDifficulty.html>
15. <a id="ref-15"></a>Martin Fowler. "Continuous Delivery" (bliki, 30 May 2013; updated 12 Aug 2014). <https://martinfowler.com/bliki/ContinuousDelivery.html>
16. <a id="ref-16"></a>Martin Fowler. "Deployment Pipeline" (bliki, 30 May 2013). <https://martinfowler.com/bliki/DeploymentPipeline.html>
17. <a id="ref-17"></a>Docker Blog. "Docker: Nine Years YOUNG" — first public demo at PyCon, 15 Mar 2013. <https://www.docker.com/blog/docker-nine-years-young/> · video: <https://www.youtube.com/watch?v=wW9CAH9nSLs>
18. <a id="ref-18"></a>DX Newsletter. "History of DORA". <https://newsletter.getdx.com/p/history-of-dora>
19. <a id="ref-19"></a>Nicole Forsgren, Jez Humble, Gene Kim. *Accelerate: The Science of Lean Software and DevOps*. IT Revolution, 2018. ISBN 978-1-942788-33-1. <https://itrevolution.com/product/accelerate/>
20. <a id="ref-20"></a>DORA. "DORA's software delivery performance metrics". <https://dora.dev/guides/dora-metrics-four-keys/>

**🟣 CI/CD**

21. <a id="ref-21"></a>Nat Friedman. "GitHub Actions now supports CI/CD, free for public repositories". GitHub Blog, 8 Aug 2019. <https://github.blog/news-insights/product-news/github-actions-now-supports-ci-cd/>
22. <a id="ref-22"></a>Google Online Security Blog. "Introducing SLSA, an End-to-End Framework for Supply Chain Integrity" (June 2021). <https://security.googleblog.com/2021/06/introducing-slsa-end-to-end-framework.html>
