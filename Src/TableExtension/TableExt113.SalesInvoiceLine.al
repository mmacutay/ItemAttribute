tableextension 50101 SalesInvoiceLineExt extends "Sales Invoice Line"
{
    fields
    {

        field(50100; Attributes; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Combine';
        }
    }
}