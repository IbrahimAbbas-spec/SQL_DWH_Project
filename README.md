<div align="center">

# 🏛️ SQL Data Warehouse & Analytics Project

### A modern Medallion-architecture DWH on SQL Server — from raw CSVs to business-ready analytics.

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-4479A1?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Draw.io](https://img.shields.io/badge/Draw.io-F08705?style=for-the-badge&logo=diagrams.net&logoColor=white)
![Notion](https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
[![Made by Ibrahim](https://img.shields.io/badge/Made_by-Ibrahim_Abbas-blueviolet?style=for-the-badge)](https://github.com/IbrahimAbbas-spec)

</div>

---

## 📌 About

Welcome to the **Data Warehouse & Analytics Project** 🚀 — an end-to-end DWH solution showcasing best practices in **Data Engineering** and **Analytics**, following the **Medallion (Bronze · Silver · Gold)** architecture on SQL Server.

> Built as a portfolio project to demonstrate the full lifecycle: from raw CSV sources to a star-schema model ready for BI and analytics.

---

## 🏗️ Data Architecture

The DWH follows a **Medallion architecture** — data flows through three layers, each with a clear purpose:

~~~mermaid
flowchart LR
    A["📁 Sources<br/>CRM + ERP CSVs"] --> B["🟫 Bronze<br/>Raw tables"]
    B --> C["⬜ Silver<br/>Cleansed & standardized"]
    C --> D["🟨 Gold<br/>Star schema views"]
    D --> E["📊 BI / Analytics<br/>Reports & ML"]

    classDef bronze fill:#cd7f32,stroke:#333,color:#fff
    classDef silver fill:#c0c0c0,stroke:#333,color:#000
    classDef gold fill:#ffd700,stroke:#333,color:#000
    class B bronze
    class C silver
    class D gold
~~~

> 💡 Editable diagram source: [`docs/data_architecture.drawio`](docs/data_architecture.drawio)

| Layer | Purpose | Storage |
|---|---|---|
| 🟫 **Bronze** | Raw data as-is from source systems | Tables (CSV → SQL Server) |
| ⬜ **Silver** | Cleansed · standardized · normalized | Tables |
| 🟨 **Gold** | Business-ready · star schema | Views |

---

## 📖 Project Overview

This project covers:

1. 🏗️ **Data Architecture** — Modern DWH using Medallion (Bronze / Silver / Gold)
2. 🔄 **ETL Pipelines** — Extract → Transform → Load from CSV sources
3. 📐 **Data Modeling** — Fact & dimension tables optimized for analytics
4. 📊 **Analytics & Reporting** — SQL reports for actionable insights

🎯 **Skills showcased:**
`SQL Development` · `Data Architecture` · `Data Engineering` · `ETL Pipelines` · `Data Modeling` · `Data Analytics`

---

## 🛠️ Tech Stack & Tools

Everything used here is **free** 🎉

| Tool | Purpose | Link |
|---|---|---|
| 📁 **Datasets** | CSV files (CRM + ERP) | [/datasets](datasets/) |
| 🗜️ **SQL Server Express** | DB engine | [Download](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) |
| 🛠️ **SSMS** | DB management GUI | [Download](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) |
| 🐙 **Git + GitHub** | Version control | [GitHub](https://github.com/IbrahimAbbas-spec) |
| 🎨 **Draw.io** | Diagrams & data models | [drawio.com](https://www.drawio.com/) |
| 📋 **Notion** | Planning & docs | [notion.com](https://www.notion.com/) |

---

## 🚀 Requirements

### Building the DWH (Data Engineering)

**Objective:** Build a modern DWH on SQL Server to consolidate sales data for analytics.

- 📂 **Sources** — ERP + CRM CSV files
- 🧹 **Quality** — cleanse before analysis
- 🔗 **Integration** — unified, analytics-friendly model
- 🎯 **Scope** — latest snapshot only (no historization)
- 📚 **Docs** — clear data model documentation

### BI & Analytics (Data Analysis)

SQL-based insights into:
- 👥 **Customer Behavior**
- 📦 **Product Performance**
- 📈 **Sales Trends**

→ More details in [docs/requirements.md](docs/requirements.md)

---

## 📂 Repository Structure

~~~
SQL_DWH_Project/
│
├── datasets/                       # Raw CSVs (ERP + CRM)
│
├── docs/                           # Project documentation
│   ├── etl.drawio                  # ETL techniques & methods
│   ├── data_architecture.drawio    # High-level architecture
│   ├── data_catalog.md             # Dataset metadata
│   ├── data_flow.drawio            # Data flow diagram
│   ├── data_models.drawio          # Star schema model
│   └── naming-conventions.md       # Naming standards
│
├── scripts/                        # SQL scripts
│   ├── bronze/                     # Raw ingestion
│   ├── silver/                     # Cleansing + transformation
│   └── gold/                       # Star schema + business logic
│
├── tests/                          # Data quality checks
│
├── README.md                       # You're here 👋
├── LICENSE                         # MIT
├── .gitignore                      # Git ignore rules
└── requirements.txt                # Project dependencies
~~~

---

## 🛡️ License

Distributed under the **MIT License**. See [LICENSE](LICENSE) for details.

---

## 🌟 About Me

<div align="center">

### Hi, I'm **Ibrahim Abbas** 👋

**Data Engineer · Data Analyst · QA**  
Passionate about turning raw data into reliable, business-ready insight.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ibrahim-abbas-de-da-qa/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/IbrahimAbbas-spec)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:eng.ibrahim.da@gmail.com)

</div>

---

<div align="center">

⭐ **If you find this project useful, give it a star!** ⭐

</div>
