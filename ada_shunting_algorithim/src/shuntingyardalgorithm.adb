package body ShuntingYardAlgorithm is

    -- Call algorithim
    procedure Shunting_Yard_Algorithm (
        In_Expression  : in Interfaces.C.Strings.chars_ptr;
        Out_Expression : out Interfaces.C.Strings.chars_ptr
    ) is

         Msg : constant String := "Hello World!";

    begin
        Out_Expression := Interfaces.C.Strings.New_String( Str => Msg );
    end;

    -- Cleanup string
    procedure Free_String (
        str_ptr : in out Interfaces.C.Strings.chars_ptr
    ) is

    begin
        Interfaces.C.Strings.Free( Item => str_ptr );
    end;

end ShuntingYardAlgorithm;