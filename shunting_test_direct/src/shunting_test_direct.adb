with Ada.Text_IO;
with Interfaces.C.Strings;
with ShuntingYardAlgorithm;

procedure Shunting_Test_Direct is
    use type Interfaces.C.Strings.chars_ptr;

    Input    : constant String := "3 + 4 * 2 / (1 - 5) ^ 2 ^ 3";
    C_Input    : Interfaces.C.Strings.chars_ptr :=
       Interfaces.C.Strings.New_String (Input);
    C_Output    : Interfaces.C.Strings.chars_ptr;
begin

    ShuntingYardAlgorithm.Shunting_Yard_Algorithm (C_Input, C_Output);

    if C_Output = Interfaces.C.Strings.Null_Ptr then
        Ada.Text_IO.Put_Line ("Got null pointer back! Error in processing.");
    else
        declare
            Ada_Output : constant String := Interfaces.C.Strings.Value (C_Output);
        begin
            Ada.Text_IO.Put_Line ("Postfix: " & Ada_Output);
            ShuntingYardAlgorithm.Free_String (C_Output);
        end;
    end if;

    Interfaces.C.Strings.Free(C_Input);

end Shunting_Test_Direct;
