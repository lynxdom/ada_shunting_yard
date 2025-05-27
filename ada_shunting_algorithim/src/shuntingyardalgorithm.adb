with Tokenizer;
pragma Elaborate_All (Tokenizer);

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;

package body ShuntingYardAlgorithm is

    --    Call algorithim
    procedure Shunting_Yard_Algorithm (
        In_Expression  : in Interfaces.C.Strings.chars_ptr;
        Out_Expression : out Interfaces.C.Strings.chars_ptr
    ) is
        Msg : constant String := "Hello World!";
        Token_Vector : Tokenizer.Token_Vector_Access_Type := null;

        In_String : constant String :=
            Interfaces.C.Strings.Value (Item => In_Expression);

    begin

        Tokenizer.Tokenize (
            Token_Vector => Token_Vector,
            Input_String => In_String
        );

        Out_Expression := Interfaces.C.Strings.New_String (
            Str => Msg
        );
    exception

        when E : others =>
            declare
                Full_Message : constant String := Exception_Information (E);
            begin
                Put_Line (Full_Message);
            end;

    end Shunting_Yard_Algorithm;

    --    Cleanup string
    procedure Free_String (
        str_ptr : in out Interfaces.C.Strings.chars_ptr
    ) is

    begin
        Interfaces.C.Strings.Free (
            Item => str_ptr
        );
    end Free_String;

end ShuntingYardAlgorithm;