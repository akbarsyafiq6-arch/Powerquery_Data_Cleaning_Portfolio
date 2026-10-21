let
    Source = Excel.Workbook(File.Contents("C:\Users\user\Downloads\Dataset_Portofolio_2_Revisi_ECommerce.xlsx"), null, true),
    Sheet1_Sheet = Source{[Item="Sheet1",Kind="Sheet"]}[Data],
    #"Promoted Headers" = Table.PromoteHeaders(Sheet1_Sheet, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Order_ID", type text}, {"Channel", type text}, {"Payment_Method", type text}, {"Product_Name", type text}, {"Qty", Int64.Type}, {"Gross_Amount", Int64.Type}, {"Discount_IDR", Int64.Type}, {"Net_Amount_IDR", type any}, {"Order_Date", type text}, {"Status", type text}}),
    #"Trimmed Text" = Table.TransformColumns(#"Changed Type",{{"Order_ID", Text.Trim, type text}, {"Channel", Text.Trim, type text}, {"Payment_Method", Text.Trim, type text}, {"Product_Name", Text.Trim, type text}, {"Order_Date", Text.Trim, type text}, {"Status", Text.Trim, type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Trimmed Text",{{"Order_ID", Text.Clean, type text}, {"Channel", Text.Clean, type text}, {"Payment_Method", Text.Clean, type text}, {"Product_Name", Text.Clean, type text}, {"Order_Date", Text.Clean, type text}, {"Status", Text.Clean, type text}}),
    #"Uppercased Text" = Table.TransformColumns(#"Cleaned Text",{{"Order_ID", Text.Upper, type text}, {"Channel", Text.Upper, type text}, {"Payment_Method", Text.Upper, type text}, {"Product_Name", Text.Upper, type text}, {"Order_Date", Text.Upper, type text}, {"Status", Text.Upper, type text}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Uppercased Text",{{"Net_Amount_IDR", type text}}),
    #"Trimmed Text1" = Table.TransformColumns(#"Changed Type1",{{"Net_Amount_IDR", Text.Trim, type text}}),
    #"Cleaned Text1" = Table.TransformColumns(#"Trimmed Text1",{{"Net_Amount_IDR", Text.Clean, type text}}),
    #"Replaced Value" = Table.ReplaceValue(#"Cleaned Text1","Rp ","",Replacer.ReplaceText,{"Net_Amount_IDR"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value",".","",Replacer.ReplaceText,{"Net_Amount_IDR"}),
    #"Added Custom" = Table.AddColumn(#"Replaced Value1", "Net_Amount_IDR_Clear", each let
Net_Clean = try Number.From ([Net_Amount_IDR]) otherwise null

in
if Net_Clean = null then null else Number.Abs(Net_Clean)),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Custom",{"Order_ID", "Channel", "Payment_Method", "Product_Name", "Qty", "Gross_Amount", "Discount_IDR", "Net_Amount_IDR", "Net_Amount_IDR_Clear", "Order_Date", "Status"}),
    #"Added Custom1" = Table.AddColumn(#"Reordered Columns", "Order_Date_Clean", each try Date.FromText ([Order_Date], [Culture = "en-US"]) otherwise (try Date.FromText ([Order_Date], [Culture = "id-ID"])otherwise null)),
    #"Reordered Columns1" = Table.ReorderColumns(#"Added Custom1",{"Order_ID", "Channel", "Payment_Method", "Product_Name", "Qty", "Gross_Amount", "Discount_IDR", "Net_Amount_IDR", "Net_Amount_IDR_Clear", "Order_Date", "Order_Date_Clean", "Status"}),
    #"Grouped Rows" = Table.Group(#"Reordered Columns1", {"Order_ID"}, {{"Count_ID", each Table.RowCount(_), Int64.Type}, {"Table", each _, type table [Order_ID=text, Channel=text, Payment_Method=text, Product_Name=text, Qty=nullable number, Gross_Amount=nullable number, Discount_IDR=nullable number, Net_Amount_IDR=nullable text, Net_Amount_IDR_Clear=nullable number, Order_Date=text, Order_Date_Clean=nullable date, Status=text]}}),
    #"Filtered Rows" = Table.SelectRows(#"Grouped Rows", each true),
    #"Expanded Table" = Table.ExpandTableColumn(#"Filtered Rows", "Table", {"Channel", "Payment_Method", "Product_Name", "Qty", "Gross_Amount", "Discount_IDR", "Net_Amount_IDR", "Net_Amount_IDR_Clear", "Order_Date", "Order_Date_Clean", "Status"}, {"Channel", "Payment_Method", "Product_Name", "Qty", "Gross_Amount", "Discount_IDR", "Net_Amount_IDR", "Net_Amount_IDR_Clear", "Order_Date", "Order_Date_Clean", "Status"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded Table", "Net_Amount_IDR", "Net_Amount_IDR - Copy"),
    #"Changed Type2" = Table.TransformColumnTypes(#"Duplicated Column",{{"Net_Amount_IDR - Copy", Int64.Type}}),
    #"Added Custom2" = Table.AddColumn(#"Changed Type2", "Status_Audit", each if [Order_ID] = null or [Order_ID] <> null and [Count_ID] > 1 or [Channel] = null or [Payment_Method] = null or [Product_Name] = null or [Qty] = null or[Qty] < 0 or [Gross_Amount] = null or [Gross_Amount] < 0 or [Discount_IDR] = null or [Discount_IDR] < 0 or [Net_Amount_IDR_Clear] = null or [#"Net_Amount_IDR - Copy"] < 0 or [Order_Date_Clean] = null then "Defect Data" else "Valid Data"),
    #"Added Custom3" = Table.AddColumn(#"Added Custom2", "Info_Audit", each let
Order_Defect = if [Order_ID] = null or [Order_ID] <> null and [Count_ID] > 1 then "Defect ID/Duplicates ID;" else "",

Channel_Defect = if [Channel] = null then "Defect Channel;" else "",

Payment_Defect = if [Payment_Method] = null then "Defect Payment Method;" else "",

Product_Defect = if [Product_Name] = null then "Defect Product Name;" else "",

Qty_Defect = if [Qty] = null or [Qty] < 0 then "Defect Qty;" else "",

Gross_Defect = if [Gross_Amount] = null or [Gross_Amount] < 0 then "Defect Gross Amount;" else "",

Discount_Defect = if [Discount_IDR] = null or [Discount_IDR] < 0 then "Defect Discount;" else "",

Net_Defect = if [Net_Amount_IDR_Clear] = null or [#"Net_Amount_IDR - Copy"] < 0 then "Defect Net Amount;" else "",

Date_Defect = if [Order_Date_Clean] = null then "Defect Date Order;" else ""

in
Order_Defect & Channel_Defect & Payment_Defect & Product_Defect & Qty_Defect & Gross_Defect & Discount_Defect & Net_Defect & Date_Defect),
    #"Filtered Rows1" = Table.SelectRows(#"Added Custom3", each ([Status_Audit] = "Defect Data")),
    #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows1",{"Net_Amount_IDR - Copy"}),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Removed Columns", "Net_Amount_IDR", "Net_Amount_IDR_Parsed"),
    #"Changed Type3" = Table.TransformColumnTypes(#"Duplicated Column1",{{"Net_Amount_IDR_Parsed", Int64.Type}}),
    #"Reordered Columns2" = Table.ReorderColumns(#"Changed Type3",{"Order_ID", "Count_ID", "Channel", "Payment_Method", "Product_Name", "Qty", "Gross_Amount", "Discount_IDR", "Net_Amount_IDR", "Net_Amount_IDR_Parsed", "Net_Amount_IDR_Clear", "Order_Date", "Order_Date_Clean", "Status", "Status_Audit", "Info_Audit"})
in
    #"Reordered Columns2"