pageextension 50102 PostedSalesInvSubform extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field(Attributes; Rec.Attributes)
            {
                Caption = 'Attributes';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}