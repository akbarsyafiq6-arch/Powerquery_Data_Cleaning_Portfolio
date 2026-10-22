# 📊 Power Query (M Code) Automated Data Cleaning & Quality Audit Pipeline

![Power Query](https://img.shields.io/badge/Tool-Power_Query_%2F_M_Code-green)
![Excel](https://img.shields.io/badge/Format-Microsoft_Excel-blue)
![Audit Status](https://img.shields.io/badge/Data_Quality_Audit-100%25_Verified-success)

## 📌 Ringkasan Eksekutif

Repositori ini berisi **4 Studi Kasus End-to-End Data Cleaning, Normalisasi, dan Audit Otomatis** menggunakan **Power Query (M Code)** lintas industri (Logistik, E-Commerce, HRIS Payroll, dan B2B CRM). 

Sistem ini dibangun dengan arsitektur **3-Layer Data Governance** (*Raw Data → Audit Defect Log → Ready-to-Use Master Data*) untuk mengolah **4.000 total baris data mentah** tanpa kehilangan informasi akibat penghapusan data secara prematur.

---

## 📈 Matriks Konsolidasi Kualitas Data

| No | Domain Studi Kasus | Total Baris | Data Valid (Ready-Use) | Data Cacat (Defect Log) | Tingkat Cacat (%) | Fokus Transformasi M Code Utama |
| :-: | :--- | :-: | :-: | :-: | :-: | :--- |
| **1** | **Logistics & Inventory** | 1.000 | 736 | 264 | 26,4% | Parsing tanggal dual-culture, perbaikan OCR (`O`→`0`), pemulihan nilai absolut `Qty` & `Price`. |
| **2** | **E-Commerce Sales** | 1.000 | 867 | 133 | 13,3% | Stripping simbol `Rp`, konversi `Net_Amount`, penggabungan indikator `Info_Audit` multi-kolom. |
| **3** | **HRIS & Payroll** | 1.000 | 821 | 179 | 17,9% | Validasi ketat NIK KTP 16-digit, isolasi duplikasi ganda (ID & NIK), parsing jam lembur. |
| **4** | **CRM B2B Leads** | 1.000 | 841 | 159 | 15,9% | Repair sintaks email terkorupsi (`AT`→`@`, `.co.iddd`), preservasi nomor HP prefiks `08...`. |
| **TTL**| **Kompilasi 4 Pipeline** | **4.000** | **3.265** | **735** | **18,4%** | **Automated 1-Click Refresh ETL Pipeline** |

---

## 🏗️ Arsitektur Repositori

```text
Powerquery_Data_Cleaning_Portfolio/
│
├── README.md                          # Dokumentasi utama (Bahasa Indonesia)
├── README_EN.md                       # Dokumentasi utama (English Version)
│
├── Docs/
│   ├── Portofolio_Data_Cleaning_PDF_ID_Version.pdf
│   └── Data_Cleaning_Portfolio_PDF_EN_Version.pdf
│
├── Datasets/
│   ├── 01_Logistics_&_Inventory_Control_Pipeline.xlsx
│   ├── 02_End-to-End_E-Commerce_Sales_Reconciliation_Pipeline_in_Power_Query_M_Code.xlsx
│   ├── 03_Automated_HRIS_Master_Data_Audit_&_Payroll_Compliance_Cleaner.xlsx
│   └── 04_CRM_B2B_Lead_Database_Normalization_&_Anomaly_Detection_System.xlsx
│
└── M_Scripts/
    ├── 01_Logistics_&_Inventory_Control_Pipeline.m
    ├── 02_End-to-End_E-Commerce_Sales_Reconciliation_Pipeline_in_Power_Query_M_Code.m
    ├── 03_Automated_HRIS_Master_Data_Audit_&_Payroll_Compliance_Cleaner.m
    └── 04_CRM_B2B_Lead_Database_Normalization_&_Anomaly_Detection_System.m
