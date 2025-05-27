
with Ada.Text_IO;
with Interfaces.C.Strings;

procedure Shunting_Test_Ada is
    use type Interfaces.C.Strings.chars_ptr;

    --   Call algorithim
    procedure Shunting_Yard_Algorithm (
        In_Expression  : in Interfaces.C.Strings.chars_ptr;
        Out_Expression : out Interfaces.C.Strings.chars_ptr
    )
    with Import => True, Convention => C, External_Name => "shunting_yard_algorithm";

    --   Cleanup string
    procedure Free_String (
        str_ptr : in out Interfaces.C.Strings.chars_ptr
    )
    with Import => True, Convention => C, External_Name => "free_string";

    Input    : constant String := "3 + 4 * 2 / (1 - 5) ^ 2 ^ 3";
    C_Input    : Interfaces.C.Strings.chars_ptr :=
       Interfaces.C.Strings.New_String (Input);
    C_Output    : Interfaces.C.Strings.chars_ptr;
begin

    Shunting_Yard_Algorithm (C_Input, C_Output);

    if C_Output = Interfaces.C.Strings.Null_Ptr then
        Ada.Text_IO.Put_Line ("Got null pointer back! Error in processing.");
    else
        declare
            Ada_Output : constant String := Interfaces.C.Strings.Value (C_Output);
        begin
            Ada.Text_IO.Put_Line ("Postfix: " & Ada_Output);
            Free_String (C_Output);
        end;
    end if;

    Interfaces.C.Strings.Free(C_Input);

end Shunting_Test_Ada;
