let
    Source = Csv.Document(File.Contents("C:\Users\user\Downloads\Dataset_Portofolio_3_HR_Payroll.csv"),[Delimiter=",", Columns=8, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Employee_ID", type text}, {"Employee_Name", type text}, {"NIK_KTP", type text}, {"Department", type text}, {"Job_Title", type text}, {"Base_Salary_IDR", type number}, {"Overtime_Hours", type text}, {"Join_Date", type date}}),
    #"Trimmed Text" = Table.TransformColumns(#"Changed Type",{{"Employee_ID", Text.Trim, type text}, {"Employee_Name", Text.Trim, type text}, {"NIK_KTP", Text.Trim, type text}, {"Department", Text.Trim, type text}, {"Job_Title", Text.Trim, type text}, {"Overtime_Hours", Text.Trim, type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Trimmed Text",{{"Employee_ID", Text.Clean, type text}, {"Employee_Name", Text.Clean, type text}, {"NIK_KTP", Text.Clean, type text}, {"Department", Text.Clean, type text}, {"Job_Title", Text.Clean, type text}, {"Overtime_Hours", Text.Clean, type text}}),
    #"Uppercased Text" = Table.TransformColumns(#"Cleaned Text",{{"Employee_ID", Text.Upper, type text}, {"Employee_Name", Text.Upper, type text}, {"NIK_KTP", Text.Upper, type text}, {"Department", Text.Upper, type text}, {"Job_Title", Text.Upper, type text}, {"Overtime_Hours", Text.Upper, type text}}),
    #"Replaced Value" = Table.ReplaceValue(#"Uppercased Text"," HOURS","",Replacer.ReplaceText,{"Overtime_Hours"}),
    #"Added Custom" = Table.AddColumn(#"Replaced Value", "Overtime_Hours_Clean", each let
Overtime = try Number.From ([Overtime_Hours]) otherwise null

in
if Overtime = null then null else Number.Abs(Overtime)),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Custom",{"Employee_ID", "Employee_Name", "NIK_KTP", "Department", "Job_Title", "Base_Salary_IDR", "Overtime_Hours", "Overtime_Hours_Clean", "Join_Date"}),
    #"Grouped Rows" = Table.Group(#"Reordered Columns", {"Employee_ID"}, {{"Count_ID", each Table.RowCount(_), Int64.Type}, {"Table", each _, type table [Employee_ID=text, Employee_Name=text, NIK_KTP=text, Department=text, Job_Title=text, Base_Salary_IDR=nullable number, Overtime_Hours=nullable text, Overtime_Hours_Clean=number, Join_Date=nullable date]}}),
    #"Expanded Table" = Table.ExpandTableColumn(#"Grouped Rows", "Table", {"Employee_Name", "NIK_KTP", "Department", "Job_Title", "Base_Salary_IDR", "Overtime_Hours", "Overtime_Hours_Clean", "Join_Date"}, {"Table.Employee_Name", "Table.NIK_KTP", "Table.Department", "Table.Job_Title", "Table.Base_Salary_IDR", "Table.Overtime_Hours", "Table.Overtime_Hours_Clean", "Table.Join_Date"}),
    #"Grouped Rows1" = Table.Group(#"Expanded Table", {"Table.NIK_KTP"}, {{"Count_NIK", each Table.RowCount(_), Int64.Type}, {"Table", each _, type table [Employee_ID=text, Count_ID=number, Table.Employee_Name=nullable text, Table.NIK_KTP=nullable text, Table.Department=nullable text, Table.Job_Title=nullable text, Table.Base_Salary_IDR=nullable number, Table.Overtime_Hours=nullable text, Table.Overtime_Hours_Clean=nullable number, Table.Join_Date=nullable date]}}),
    #"Expanded Table1" = Table.ExpandTableColumn(#"Grouped Rows1", "Table", {"Employee_ID", "Count_ID", "Table.Employee_Name", "Table.Department", "Table.Job_Title", "Table.Base_Salary_IDR", "Table.Overtime_Hours", "Table.Overtime_Hours_Clean", "Table.Join_Date"}, {"Table.Employee_ID", "Table.Count_ID", "Table.Table.Employee_Name", "Table.Table.Department", "Table.Table.Job_Title", "Table.Table.Base_Salary_IDR", "Table.Table.Overtime_Hours", "Table.Table.Overtime_Hours_Clean", "Table.Table.Join_Date"}),
    #"Reordered Columns1" = Table.ReorderColumns(#"Expanded Table1",{"Table.Employee_ID", "Table.Count_ID", "Table.Table.Employee_Name", "Table.NIK_KTP", "Count_NIK", "Table.Table.Department", "Table.Table.Job_Title", "Table.Table.Base_Salary_IDR", "Table.Table.Overtime_Hours", "Table.Table.Overtime_Hours_Clean", "Table.Table.Join_Date"}),
    #"Renamed Columns" = Table.RenameColumns(#"Reordered Columns1",{{"Table.Employee_ID", "Employee_ID"}, {"Table.Count_ID", "Count_ID"}, {"Table.Table.Employee_Name", "Employee_Name"}, {"Table.NIK_KTP", "NIK_KTP"}, {"Table.Table.Job_Title", "Job_Title"}, {"Table.Table.Department", "Department"}, {"Table.Table.Base_Salary_IDR", "Base_Salary_IDR"}, {"Table.Table.Overtime_Hours", "Overtime_Hours"}, {"Table.Table.Overtime_Hours_Clean", "Overtime_Hours_Clean"}, {"Table.Table.Join_Date", "Join_Date"}}),
    #"Added Custom1" = Table.AddColumn(#"Renamed Columns", "NIK_KTP_Clean", each try Number.From ([NIK_KTP]) otherwise null),
    #"Trimmed Text1" = Table.TransformColumns(Table.TransformColumnTypes(#"Added Custom1", {{"NIK_KTP_Clean", type text}}, "id-ID"),{{"NIK_KTP_Clean", Text.Trim, type text}}),
    #"Reordered Columns2" = Table.ReorderColumns(#"Trimmed Text1",{"Employee_ID", "Count_ID", "Employee_Name", "NIK_KTP", "NIK_KTP_Clean", "Count_NIK", "Department", "Job_Title", "Base_Salary_IDR", "Overtime_Hours", "Overtime_Hours_Clean", "Join_Date"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Reordered Columns2",{{"Overtime_Hours", Int64.Type}}),
    #"Added Custom2" = Table.AddColumn(#"Changed Type1", "Status_Audit", each if [Employee_ID] = null or Text.From(Text.Trim([Employee_ID])) = "" or [Employee_ID] <> null and [Count_ID] > 1 or [NIK_KTP_Clean] = null or [NIK_KTP_Clean] <> null and [Count_NIK] > 1 or Text.Length (Text.From([NIK_KTP_Clean])) <> 16 or [Overtime_Hours_Clean] = null or [Overtime_Hours] < 0 then "Defect" else "Valid"),
    #"Added Custom3" = Table.AddColumn(#"Added Custom2", "Info_Audit", each let
ID_Defect = if [Employee_ID] = null or Text.From(Text.Trim([Employee_ID])) = "" or [Employee_ID] <> null and [Count_ID] > 1 then "Defect/Dupicates ID;" else "",

NIK_Defect = if [NIK_KTP_Clean] = null or Text.From(Text.Trim([NIK_KTP_Clean])) = "" or [NIK_KTP_Clean] <> null and [Count_NIK] > 1 or Text.Length (Text.From([NIK_KTP_Clean])) <> 16 then "Defect/Dupicates NIK;" else "",

Base_Salary_Defect = if [Base_Salary_IDR] = null then "Defect Base Salery;" else "",

Overtime_Defect = if [Overtime_Hours_Clean] = null or [Overtime_Hours] < 0 then "Defect Overtime" else "",

Join_Date_Defect = if [Join_Date] = null then "Defect Join Date" else ""

in
ID_Defect & NIK_Defect & Base_Salary_Defect & Overtime_Defect & Join_Date_Defect),
    #"Filtered Rows" = Table.SelectRows(#"Added Custom3", each ([Status_Audit] = "Defect"))
in
    #"Filtered Rows"