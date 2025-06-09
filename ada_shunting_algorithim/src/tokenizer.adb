with Tokenizer.Classifiers;
use Tokenizer.Classifiers;

with FSM_Representation;

package body Tokenizer is

    procedure Traverse_Node (
        Start_Node : FSM_Representation.FSM_Node_Access_Type;
        Target_String : access constant String;
        Token_Vector : in Token_Vector_Access_Type
    ) is

        procedure Emit (
            Item : in out Token_Access_Type
        ) is
        begin

            Token_Vector.Items.Append (New_Item => Item);
            Item := null;

        end Emit;

        --    puting it in it's own function
        --    for later initialization of the token
        --    possibly add pre-initialization.
        function New_Token (
            Position : Natural
        ) return Token_Access_Type is
            Return_Token : constant Token_Access_Type :=
                Create_Token (
                    Index => Position
                );
        begin
            return Return_Token;
        end New_Token;

        Current_Node : FSM_Representation.FSM_Node_Access_Type := Start_Node;
        Postition : Natural := 1;
    begin

        Get_Next_Character :
        while Postition /= Target_String'Length + 1 loop

            declare
                Char : constant Character := Target_String (Postition);
                Classifier_Count : constant Natural :=
                    Current_Node.Mappings'Length;
            begin
                Classifier_Loop :
                for I in 1 .. Classifier_Count loop

                    declare

                        Classifier : constant Classifier_Function_Type :=
                            Current_Node.Mappings (I).Classifier;

                        Next_Node : constant
                            FSM_Representation.FSM_Node_Access_Type :=
                                Current_Node.Mappings (I).Next_Node;

                        Action : constant FSM_Representation.FSM_Action_Type :=
                            Current_Node.Mappings (I).Action;

                        Token_Type : constant Catagory_Type :=
                            Current_Node.Mappings (I).Token_Type;

                    begin

                        null;

                    end;

                end loop Classifier_Loop;

            end;

        end loop Get_Next_Character;

    end Traverse_Node;

    --    Public Functions
    procedure Tokenize (
        Token_Vector : out Token_Vector_Access_Type;
        Input_String : in String
    ) is
        Position : aliased Natural := 1;
        Target_String : aliased constant String := Input_String;
    begin
        Token_Vector := new Token_Vector_Type;

        Traverse_Node (
            Start_Node => FSM_Representation.Root_Node'Access,
            Target_String => Target_String'Access,
            Token_Vector => Token_Vector
        );

    end Tokenize;

    --    Overrides
    overriding procedure Finalize (
        Obj : in out Token_Vector_Type
    ) is
    begin
        null;
    end Finalize;

end Tokenizer;
