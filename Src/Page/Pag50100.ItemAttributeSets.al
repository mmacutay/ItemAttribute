page 50100 "Item Attribute Sets"
{
    PageType = List;
    SourceTable = "Item Attribute Value";
    SourceTableView = where(Combine = const(false));
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Selected; Selected)
                {
                    Caption = 'Enable';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin

                        MultipleValues := '';
                        ValueID := 0;
                        ColourID := 0;
                        SeasonID := 0;
                        hasColour := false;

                        ItemAttributes.Reset();
                        ItemAttributes.SetFilter(Name, 'Colour');
                        If ItemAttributes.FindFirst() then
                            ColourID := ItemAttributes.ID;

                        ItemAttributes.Reset();
                        ItemAttributes.SetFilter(Name, 'Season');
                        If ItemAttributes.FindFirst() then
                            SeasonID := ItemAttributes.ID;


                        ItemAttributeValueMapping.Reset();
                        ItemAttributeValueMapping.SetRange("Table ID", DATABASE::Item);
                        ItemAttributeValueMapping.SetRange("No.", ItemNo);
                        ItemAttributeValueMapping.SetRange("Item Attribute ID", ColourID);

                        if ItemAttributeValueMapping.FindFirst() then begin
                            hasColour := true;
                        end;

                        ItemAttributeValue.GET(Rec."Attribute ID", Rec.ID);
                        ItemAttributeValue.Mark := Selected;
                        ItemAttributeValue.MarkedOnly(true);


                        if ItemAttributeValue.Count = 0 then
                            ItemAttributeValue.ClearMarks()
                        else begin

                            if (SeasonID = Rec."Attribute ID") AND hasColour AND (ItemAttributeValue.Count > 1) then begin
                                Error('Only 1 season can select if you have "Colour" attribute.');
                                ItemAttributeValue.ClearMarks();
                                exit;
                            end;

                            ItemAttributeValue.FIND('-');

                            if ItemAttributeValue.Count = 1 then begin
                                ValueID := ItemAttributeValue.ID;
                            end
                            else begin //more than 1 selected
                                ItemAttributeValue.find('-');
                                repeat
                                    MultipleValues += ItemAttributeValue.Value + ', ';
                                until ItemAttributeValue.Next() = 0;

                                MultipleValues := DelChr(MultipleValues, '>', ', ');

                                ItemAttributeValue2.RESET;
                                ItemAttributeValue2.SetFilter("Attribute ID", '%1', Rec."Attribute ID");
                                ItemAttributeValue2.SetFilter(Value, MultipleValues);
                                ItemAttributeValue2.SetFilter(Combine, '%1', true);
                                IF ItemAttributeValue2.FindFirst() then begin
                                    ValueID := ItemAttributeValue2.ID;
                                end
                                else begin
                                    ItemAttributeValue2.Reset();
                                    ItemAttributeValue2.Init();
                                    ItemAttributeValue2."Attribute ID" := Rec."Attribute ID";
                                    ItemAttributeValue2.ID := ValueID;
                                    ItemAttributeValue2.Value := MultipleValues;
                                    ItemAttributeValue2.Combine := true;
                                    ItemAttributeValue2.Insert();
                                    ValueID := ItemAttributeValue2.ID;
                                end;
                            end;

                            ItemAttributeValueMapping.Reset();
                            ItemAttributeValueMapping.SetRange("Table ID", DATABASE::Item);
                            ItemAttributeValueMapping.SetRange("No.", ItemNo);
                            ItemAttributeValueMapping.SetRange("Item Attribute ID", Rec."Attribute ID");

                            if ItemAttributeValueMapping.FindFirst() then begin
                                ItemAttributeValueMapping."Item Attribute Value ID" := ValueID;
                                ItemAttributeValueMapping.Modify();
                            end;

                        end;
                    end;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Attribute ID"; Rec."Attribute ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field(ItemNo; ItemNo)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {

    }

    trigger OnOpenPage()
    begin
        ItemAttributeValue.ClearMarks();
    end;

    procedure SetItemNo(var No: Code[20])
    begin
        ItemNo := No;
    end;

    var
        Selected: Boolean;
        ItemNo: Code[20];

        ItemAttributes: Record "Item Attribute";
        ItemAttributeValue: Record "Item Attribute Value";
        ItemAttributeValue2: Record "Item Attribute Value";
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";

        MultipleValues: Text[250];
        ValueID: Integer;
        ColourID: Integer;
        hasColour: Boolean;

        SeasonID: Integer;


}