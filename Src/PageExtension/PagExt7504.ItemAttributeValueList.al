pageextension 50101 ItemAttributeValueListExt extends "Item Attribute Value List"
{
    layout
    {
        modify(Value)
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                ItemAttributeSet: Page "Item Attribute Sets";
                ItemAttributeValue: Record "Item Attribute Value";
                ActionType: Action;
                Item: Record Item;
            begin
                If Rec."Attribute Type" = Rec."Attribute Type"::Option then begin
                    ItemAttributeValue.ClearMarks();
                    ItemAttributeValue.Reset();
                    ItemAttributeValue.SetFilter("Attribute ID", '%1', Rec."Attribute ID");
                    ItemAttributeValue.SetFilter(Value, '<>%1', '');
                    ItemAttributeValue.SetFilter(Combine, '%1', false);
                    If ItemAttributeValue.FindSet() then begin
                        Clear(ItemAttributeSet);
                        ItemAttributeSet.SetTableView(ItemAttributeValue);
                        ItemAttributeSet.SetItemNo(RelatedRecordCode);
                        ActionType := ItemAttributeSet.RunModal();

                        IF (ActionType = ACTION::OK) OR (ActionType = ACTION::Cancel) then begin
                            CurrPage.Close();
                            Item.Get(RelatedRecordCode);
                            PAGE.RunModal(PAGE::"Item Attribute Value Editor", Item);
                        end;

                    end;
                end;
            end;
        }
    }
}