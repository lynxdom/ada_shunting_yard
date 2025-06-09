with Tokenizer;
pragma Elaborate_All (Tokenizer);

with Token;
use Token;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;

package body ShuntingYardAlgorithm is

    Precidence_Map : constant array (Operator_Enum'Range) of Natural :=
    (
        '^' => 4,
        '*' => 3,
        '/' => 3,
        '+' => 2,
        '-' => 2,
        '(' => 1,
        ')' => 1
    );

    function Compare_Operator (Left : Character;
                               Right : Character)
        return Operator_Precedence_Enum is
    begin
        return Equal;
    end Compare_Operator;

    package body Stack_Package is

        function Empty (Stack_Object : in out Stack)
            return Boolean is
        begin
            return Stack_Object.Stack_Size = 0;
        end Empty;

        procedure Push (Stack_Object : in out Stack;
                        New_Item : Element) is

        begin
            if Stack_Object.Stack_Size = Size then
                raise Constraint_Error;
            end if;

            Stack_Object.Stack_Size :=
                Stack_Object.Stack_Size + 1;
            Stack_Object.Internal_Stack (
                Stack_Object.Stack_Size
            ) := New_Item;
        end Push;

        function Pop (Stack_Object : in out Stack) return Element is
            Return_Element : constant Element
                := Stack_Object.
                    Internal_Stack (Stack_Object.Stack_Size);
        begin
            if Stack_Object.Stack_Size = 0 then
                raise Constraint_Error;
            end if;

            Stack_Object.Stack_Size :=
                Stack_Object.Stack_Size - 1;

            return Return_Element;
        end Pop;

    end Stack_Package;

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

        declare

            package Token_Stack_Package is
                new Stack_Package (
                    Element => Token_Access_Type,
                    Size => Natural (Token_Vector.all.Items.Length)
                );

            Operator_Stack : Token_Stack_Package.Stack;
            Output_Queue : Tokenizer.Token_Vector_Type;
        begin

            for Current_Token_It in Token_Vector.all.Items.Iterate loop

                declare
                    use Tokenizer;

                    Current_Token : constant
                        Token_Access_Type :=
                            Tokenizer.Token_Vectors.Element (
                                Position => Current_Token_It
                            );

                    Current_Token_Cat : constant
                        Catagory_Type := Catagory (Item => Current_Token);
                begin

                    if Current_Token_Cat = Number then

                        Output_Queue.Items.Append (New_Item => Current_Token);

                    elsif Current_Token_Cat = Operator then

                        while not Operator_Stack.Empty loop

                            declare
                                Top_Operator : Token_Access_Type
                                    := Operator_Stack.Pop;
                            begin

                                null;

                            end;

                        end loop;

                    else
                        null;
                    end if;

                end;
            end loop;

        end;

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