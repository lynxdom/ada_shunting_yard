with Ada.Text_IO;
with Interfaces.C.Strings;
with ShuntingYardAlgorithm;
with Ada.Strings.Unbounded;

procedure Shunting_Test_Direct is
    use type Interfaces.C.Strings.chars_ptr;

    type Test_Case_Type is
        record
            Input : Ada.Strings.Unbounded.Unbounded_String;
            Output : Ada.Strings.Unbounded.Unbounded_String;
        end record;

    type Test_Cases_Type is array (Natural range <>) of Test_Case_Type;

    Test_Cases : constant Test_Cases_Type (1 .. 1) := (
        1 => (
            Input => Ada.Strings.Unbounded.
                To_Unbounded_String ("3 + 4 * 2 / (1 - 5) ^ 2 ^ 3"),
            Output => Ada.Strings.Unbounded.
                To_Unbounded_String ("3 4 2 * 1 5 - 2 3 ^ ^ / +")
        )
    );

begin

    for I in 1 .. Test_Cases'Last loop

        declare
            C_Input    : Interfaces.C.Strings.chars_ptr :=
                Interfaces.C.Strings.New_String (Ada.Strings.Unbounded.
                    To_String (Test_Cases (I).Input));

            C_Output    : Interfaces.C.Strings.chars_ptr;

            Expected_String : constant String :=
                Ada.Strings.Unbounded.To_String (Test_Cases (I).Output);

        begin

            ShuntingYardAlgorithm.Shunting_Yard_Algorithm (C_Input, C_Output);

            if C_Output = Interfaces.C.Strings.Null_Ptr then
                Ada.Text_IO.
                    Put_Line ("Got null pointer back! Error in processing.");
            else
                declare
                    Ada_Output : constant String :=
                        Interfaces.C.Strings.Value (C_Output);
                begin
                    Ada.Text_IO.Put_Line ("Returned Postfix: " & Ada_Output);
                    Ada.Text_IO.Put_Line ("Expected Postfix: " &
                                            Expected_String);

                    if Ada_Output /= Expected_String then
                        Ada.Text_IO.Put_Line ("Test Failed!");
                    else
                        Ada.Text_IO.Put_Line ("Test Passed!");
                    end if;

                    ShuntingYardAlgorithm.Free_String (C_Output);
                end;
            end if;

            Interfaces.C.Strings.Free (C_Input);

        end;

    end loop;

end Shunting_Test_Direct;
