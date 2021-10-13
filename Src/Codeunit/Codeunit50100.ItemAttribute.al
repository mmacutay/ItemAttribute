codeunit 50100 "Item Attribute"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure OnBeforeSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; PostingSalesLine: Record "Sales Line")
    var
        ItemAttributesText: text[250];
        ItemAttributes: Record "Item Attribute";
        ItemAttributeValue: Record "Item Attribute Value";
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
    begin
        ItemAttributesText := '';
        if SalesInvLine.Type = SalesInvLine.Type::Item then begin

            ItemAttributeValueMapping.Reset();
            ItemAttributeValueMapping.SetRange("Table ID", DATABASE::Item);
            ItemAttributeValueMapping.SetRange("No.", SalesInvLine."No.");

            if ItemAttributeValueMapping.FindSet() then begin
                repeat

                    ItemAttributes.Reset();
                    ItemAttributes.SetFilter(ID, '%1', ItemAttributeValueMapping."Item Attribute ID");
                    If ItemAttributes.FindFirst() then begin
                        ItemAttributesText += ItemAttributes.Name + ':';
                    end;


                    ItemAttributeValue.Reset();
                    ItemAttributeValue.SetFilter("Attribute ID", '%1', ItemAttributeValueMapping."Item Attribute ID");
                    ItemAttributeValue.SetFilter(ID, '%1', ItemAttributeValueMapping."Item Attribute Value ID");
                    if ItemAttributeValue.FindFirst() then begin
                        ItemAttributesText += ItemAttributeValue.Value + ' ';
                    end;

                until ItemAttributeValueMapping.Next() = 0;
            end;

            SalesInvLine.Attributes := ItemAttributesText;
        end;

    end;
}
