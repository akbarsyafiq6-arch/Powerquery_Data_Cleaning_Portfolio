# 📊 Power Query (M Code) Automated Data Cleaning & Quality Audit Pipeline

![Power Query](https://img.shields.io/badge/Tool-Power_Query_%2F_M_Code-green)
![Excel](https://img.shields.io/badge/Format-Microsoft_Excel-blue)
![Audit Status](https://img.shields.io/badge/Data_Quality_Audit-100%25_Verified-success)

## 📌 Executive Summary

This repository contains **4 End-to-End Data Cleaning, Normalization, and Automated Quality Audit Case Studies** built with **Power Query (M Code)** across multiple industries (Logistics, E-Commerce, HRIS Payroll, and B2B CRM).

The system implements a **3-Layer Data Governance Architecture** (*Raw Data → Audit Defect Log → Ready-to-Use Master Data*) to process **4,000 raw transactional records** without premature data loss.

---

## 📈 Consolidated Data Quality Matrix

| No | Case Study Domain | Raw Rows | Valid Data (Ready-Use) | Defect Data (Audit Log) | Defect Rate (%) | Key M Code Transformation Focus |
| :-: | :--- | :-: | :-: | :-: | :-: | :--- |
| **1** | **Logistics & Inventory** | 1,000 | 736 | 264 | 26.4% | Dual-culture date parsing, OCR typo repair (`O`→`0`), absolute `Qty` & `Price` recovery. |
| **2** | **E-Commerce Sales** | 1,000 | 867 | 133 | 13.3% | Currency symbol stripping (`Rp`), `Net_Amount` parsing, multi-column `Info_Audit` string concatenation. |
| **3** | **HRIS & Payroll** | 1,000 | 821 | 179 | 17.9% | Strict 16-digit national ID validation, double duplicate grouping (ID & NIK), overtime parsing. |
| **4** | **CRM B2B Leads** | 1,000 | 841 | 159 | 15.9% | Corrupted email syntax repair (`AT`→`@`, `.co.iddd`), phone prefix preservation (`08...`). |
| **TTL**| **4-Domain Pipeline** | **4,000** | **3,265** | **735** | **18.4%** | **Automated 1-Click Refresh ETL Pipeline** |

---

## 🏗️ Repository Architecture

```text
Powerquery_Data_Cleaning_Portfolio/
│
├── README.md                          # Primary Documentation (Indonesian)
├── README_EN.md                       # Primary Documentation (English)
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
