let
    Source = Excel.Workbook(File.Contents("C:\Users\user\Downloads\Dataset_Portofolio_4_CRM_Lead.xlsx"), null, true),
    Sheet1_Sheet = Source{[Item="Sheet1",Kind="Sheet"]}[Data],
    #"Promoted Headers" = Table.PromoteHeaders(Sheet1_Sheet, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Lead_ID", type text}, {"Contact_Name", type text}, {"Company_Name", type text}, {"Email_Address", type text}, {"Phone_Number", type text}, {"Lead_Source", type text}, {"Lead_Score", type any}, {"Lead_Status", type text}}),
    #"Trimmed Text" = Table.TransformColumns(#"Changed Type",{{"Lead_ID", Text.Trim, type text}, {"Contact_Name", Text.Trim, type text}, {"Company_Name", Text.Trim, type text}, {"Email_Address", Text.Trim, type text}, {"Phone_Number", Text.Trim, type text}, {"Lead_Source", Text.Trim, type text}, {"Lead_Status", Text.Trim, type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Trimmed Text",{{"Lead_ID", Text.Clean, type text}, {"Contact_Name", Text.Clean, type text}, {"Company_Name", Text.Clean, type text}, {"Email_Address", Text.Clean, type text}, {"Phone_Number", Text.Clean, type text}, {"Lead_Source", Text.Clean, type text}, {"Lead_Status", Text.Clean, type text}}),
    #"Uppercased Text" = Table.TransformColumns(#"Cleaned Text",{{"Lead_ID", Text.Upper, type text}, {"Contact_Name", Text.Upper, type text}, {"Company_Name", Text.Upper, type text}, {"Email_Address", Text.Upper, type text}, {"Phone_Number", Text.Upper, type text}, {"Lead_Source", Text.Upper, type text}, {"Lead_Status", Text.Upper, type text}}),
    #"Replaced Value" = Table.ReplaceValue(#"Uppercased Text","_"," ",Replacer.ReplaceText,{"Lead_Status"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","+62 ","0",Replacer.ReplaceText,{"Phone_Number"}),
    #"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","-","",Replacer.ReplaceText,{"Phone_Number"}),
    #"Added Custom" = Table.AddColumn(#"Replaced Value2", "Phone_Number_Clean", each if Text.StartsWith (Text.From ([Phone_Number]), "08") then Text.From ([Phone_Number]) else null),
    #"Changed Type1" = Table.TransformColumnTypes(#"Added Custom",{{"Phone_Number_Clean", type text}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Changed Type1",{"Lead_ID", "Contact_Name", "Company_Name", "Email_Address", "Phone_Number", "Phone_Number_Clean", "Lead_Source", "Lead_Score", "Lead_Status"}),
    #"Replaced Value3" = Table.ReplaceValue(#"Reordered Columns","CO.IDDD","CO.ID",Replacer.ReplaceText,{"Email_Address"}),
    #"Replaced Value4" = Table.ReplaceValue(#"Replaced Value3","ATSOLUSI","@SOLUSI",Replacer.ReplaceText,{"Email_Address"}),
    #"Replaced Value5" = Table.ReplaceValue(#"Replaced Value4","ATINOVASI","@INOVASI",Replacer.ReplaceText,{"Email_Address"}),
    #"Replaced Value6" = Table.ReplaceValue(#"Replaced Value5","ATNUSANTARA","@NUSANTARA",Replacer.ReplaceText,{"Email_Address"}),
    #"Replaced Value7" = Table.ReplaceValue(#"Replaced Value6","ATLOGISTIK","@LOGISTIK",Replacer.ReplaceText,{"Email_Address"}),
    #"Replaced Value8" = Table.ReplaceValue(#"Replaced Value7","ATTEKNOLOGI","@TEKNOLOGI",Replacer.ReplaceText,{"Email_Address"}),
    #"Grouped Rows" = Table.Group(#"Replaced Value8", {"Lead_ID"}, {{"Count_Lead", each Table.RowCount(_), Int64.Type}, {"Table", each _, type table [Lead_ID=text, Contact_Name=text, Company_Name=text, Email_Address=nullable text, Phone_Number=nullable text, Phone_Number_Clean=nullable text, Lead_Source=text, Lead_Score=any, Lead_Status=nullable text]}}),
    #"Expanded Table" = Table.ExpandTableColumn(#"Grouped Rows", "Table", {"Contact_Name", "Company_Name", "Email_Address", "Phone_Number", "Phone_Number_Clean", "Lead_Source", "Lead_Score", "Lead_Status"}, {"Table.Contact_Name", "Table.Company_Name", "Table.Email_Address", "Table.Phone_Number", "Table.Phone_Number_Clean", "Table.Lead_Source", "Table.Lead_Score", "Table.Lead_Status"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Table",{{"Table.Lead_Status", "Lead_Status"}, {"Table.Lead_Score", "Lead_Score"}, {"Table.Lead_Source", "Lead_Source"}, {"Table.Phone_Number_Clean", "Phone_Number_Clean"}, {"Table.Phone_Number", "Phone_Number"}, {"Table.Email_Address", "Email_Address"}, {"Table.Company_Name", "Company_Name"}, {"Table.Contact_Name", "Contact_Name"}}),
    #"Added Custom1" = Table.AddColumn(#"Renamed Columns", "Lead_Score_Clean", each let
Score = try Number.From ([Lead_Score]) otherwise null

in
if Score <> null then Number.Abs (Score) else null),
    #"Reordered Columns1" = Table.ReorderColumns(#"Added Custom1",{"Lead_ID", "Count_Lead", "Contact_Name", "Company_Name", "Email_Address", "Phone_Number", "Phone_Number_Clean", "Lead_Source", "Lead_Score", "Lead_Score_Clean", "Lead_Status"}),
    #"Added Custom2" = Table.AddColumn(#"Reordered Columns1", "Audit_Status", each if [Lead_ID] = null or Text.From(Text.Trim([Lead_ID])) = "" or [Lead_ID] <> null and [Count_Lead] > 1 or [Phone_Number_Clean] = null or [Lead_Score_Clean] = null or [Lead_Score] < 1 then "Defect" else "Valid"),
    #"Added Custom3" = Table.AddColumn(#"Added Custom2", "Audit_Info", each let
LeadId = if [Lead_ID] = null or [Lead_ID] <> null and [Count_Lead] > 1 or Text.From(Text.Trim([Lead_ID])) = "" then "Defect/Duplicates ID;" else "", 

PhoneNumber = if [Phone_Number_Clean] = null then "Non/Wrong Phone Number;" else "",

LeadScore = if [Lead_Score_Clean] = null or [Lead_Score] < 0 then "Blank/Min Score;" else ""

in
LeadId & PhoneNumber & LeadScore),
    #"Filtered Rows" = Table.SelectRows(#"Added Custom3", each ([Audit_Status] = "Defect"))
in
    #"Filtered Rows"