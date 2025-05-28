with Tokenizer.Classifiers;
use Tokenizer.Classifiers;

with Ada.Text_IO;

package body Tokenizer is

    --    FSM
    type FSM_Node_Type;
    type FSM_Node_Access_Type is access all FSM_Node_Type;
    type FSM_Action_Type is (Skip, Start, Stay, Finalize, Transition, Error);

    package Tokenizer_Exceptions is

        Tokenizer_Error : exception;

    end Tokenizer_Exceptions;

    type Classifier_Mapping_Type is
        record
            Classifier : Classifier_Function_Type;
            Next_Node : FSM_Node_Access_Type;
            Action : FSM_Action_Type;
            Token_Type : Catagory_Type;
        end record;

    type Classifier_Array_Maps_Type is
        array (
            Natural range <>
        ) of Classifier_Mapping_Type;

    type FSM_Node_Type (Length : Natural) is
        record
            Mappings : Classifier_Array_Maps_Type (1 .. Length);
        end record;

    Single_Char_Node : aliased FSM_Node_Type := (
        Length => 1,
        Mappings => (
            1 => (
                Classifier => Out_Of_Set'Access,
                Next_Node => null,
                Action => Finalize,
                Token_Type => Unknown
            )
        )
    );

    Digit_One_Node : aliased FSM_Node_Type := (
        Length => 3,
        Mappings => (
            1 => (
                Classifier => Classifiers.Is_Digit'Access,
                Next_Node => null,
                Action => Stay,
                Token_Type => Unknown
            ),
            2 => (
                Classifier => Is_White_Space'Access,
                Next_Node => null,
                Action => Finalize,
                Token_Type => Unknown
            ),
            3 => (
                Classifier => Classifiers.Out_Of_Set'Access,
                Next_Node => null,
                Action => Error,
                Token_Type => Unknown
            )
        )
    );

    Root_Node : aliased FSM_Node_Type := (
        Length => 8,
        Mappings => (
            1 => (
                Classifier => Is_White_Space'Access,
                Next_Node => null,
                Action => Skip,
                Token_Type => Unknown
            ),
            2 => (
                Classifier => Is_Digit'Access,
                Next_Node => Digit_One_Node'Access,
                Action => Start,
                Token_Type => Number
            ),
            3 => (
                Classifier => Is_Unary_Minus'Access,
                Next_Node => Digit_One_Node'Access,
                Action => Start,
                Token_Type => Number
                ),
            4 => (
                Classifier => Is_Point'Access,
                Next_Node => Digit_One_Node'Access,
                Action => Start,
                Token_Type => Number
            ),
            5 => (
                Classifier => Is_Operator'Access,
                Next_Node => Single_Char_Node'Access,
                Action => Start,
                Token_Type => Operator
            ),
            6 => (
                Classifier => Is_Close_Param'Access,
                Next_Node => Single_Char_Node'Access,
                Action => Start,
                Token_Type => Close_Paren
            ),
            7 => (
                Classifier => Is_Open_Param'Access,
                Next_Node => Single_Char_Node'Access,
                Action => Start,
                Token_Type => Open_Paren
            ),
            8 => (
                Classifier => Out_Of_Set'Access,
                Next_Node => null,
                Action => Error,
                Token_Type => Unknown
            )
        )
    );

    function Catagory (
        Token : in Token_Access_Type
    ) return Catagory_Type is
    begin
        return Token.Catagory;
    end Catagory;

    procedure Traverse_Node (
        Postition : access Natural;
        Token : Token_Access_Type;
        Current_Node : FSM_Node_Access_Type;
        Target_String : access constant String
    ) is
        Classifier_Count : constant Natural := Current_Node.Mappings'Length;

    begin

        Get_Next_Character :
        while Postition.all /= Target_String'Length + 1 loop

            declare
                Char : constant Character := Target_String (Postition.all);
            begin

                Classifier_Loop :
                for I in 1 .. Classifier_Count loop

                    declare

                        Classifier : constant Classifier_Function_Type :=
                            Current_Node.Mappings (I).Classifier;

                        Next_Node : constant FSM_Node_Access_Type :=
                            Current_Node.Mappings (I).Next_Node;

                        Action : constant FSM_Action_Type :=
                            Current_Node.Mappings (I).Action;

                        Token_Type : constant Catagory_Type :=
                            Current_Node.Mappings (I).Token_Type;

                    begin

                        if Classifier (Char => Char) then

                            case Action is

                                when Start =>

                                    Token.Index := Postition.all;
                                    Token.Catagory := Token_Type;
                                    Token.Length := 1;

                                    Postition.all := Postition.all + 1;

                                    Traverse_Node (
                                        Postition,
                                        Token,
                                        Next_Node,
                                        Target_String
                                    );

                                    return;

                                when Transition =>

                                    Traverse_Node (
                                        Postition,
                                        Token,
                                        Next_Node,
                                        Target_String
                                    );

                                    return;

                                when Stay =>

                                    Token.Length := Token.Length + 1;
                                    Postition.all := Postition.all + 1;

                                when Finalize =>

                                    return;

                                when Skip =>

                                    Postition.all := Postition.all + 1;
                                    exit Classifier_Loop;

                                when Error =>
                                    raise Tokenizer_Exceptions.Tokenizer_Error
                                    with "Token exception at " &
                                            Natural'Image (Postition.all) &
                                         " Character " &
                                            Character'Image (Char);

                            end case;

                        end if;

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

        Ada.Text_IO.Put_Line ("Target String :" & Target_String);

        while Position /= Input_String'Last + 1 loop

            declare
                Token : constant Token_Access_Type := new Token_Type'(
                    Ada.Finalization.Controlled with
                            Index         => Position,
                            Length        => 0,
                            Catagory      => Unknown
                );
            begin

                Traverse_Node (
                    Position'Access,
                    Token,
                    Root_Node'Access,
                    Target_String'Access
                );

                Token_Vectors.Append (
                    Container => Token_Vector.all.Items,
                    New_Item => Token
                );

                declare
                    Token_Str : constant String := Value (
                                                    Token => Token,
                                                    Str => Target_String'Access
                                                );
                    Cat_Str : constant String :=
                        Catagory_Type'Image (Token.Catagory);

                    Index_Str : constant String := Natural'Image (Token.Index);
                    Len_Str : constant String := Natural'Image (Token.Length);
                begin

                    Ada.Text_IO.Put_Line (" Token :[" & Token_Str & "]" &
                                          " Catalog :" & Cat_Str &
                                          " Index :" & Index_Str &
                                          " Length :" & Len_Str);

                end;

            end;

        end loop;

    end Tokenize;

    --    Overrides
    overriding procedure Finalize (
        Obj : in out Token_Vector_Type
    ) is
    begin
        null;
    end Finalize;

    overriding procedure Finalize (
        Obj : in out Token_Type
    ) is
    begin
        null;
    end Finalize;

    --    Token Access Functions
    function Value (
        Token : in Token_Access_Type;
        Str   : access constant String
    ) return String is
    begin
        return Str (
            Token.all.Index ..
            Token.all.Index + Token.all.Length - 1
        );
    end Value;

end Tokenizer;
