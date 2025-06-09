with Tokenizer.Classifiers;

with Token;
use Token;

package FSM_Representation is

    --    FSM
    type FSM_Node_Type;
    type FSM_Node_Access_Type is access all FSM_Node_Type;
    type FSM_Action_Type is (
        Skip,
        Start,
        Stay,
        Move,
        Error,
        Emit_Move,
        Emit);

    package Tokenizer_Exceptions is

        Tokenizer_Error : exception;

    end Tokenizer_Exceptions;

    type Classifier_Mapping_Type is
        record
            Classifier : Tokenizer.Classifiers.Classifier_Function_Type;
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
                Classifier => Tokenizer.Classifiers.Out_Of_Set'Access,
                Next_Node => null,
                Action => Emit,
                Token_Type => Unknown
            )
        )
    );

    Digit_One_Node : aliased FSM_Node_Type := (
        Length => 5,
        Mappings => (
            1 => (
                Classifier => Tokenizer.Classifiers.Is_Digit'Access,
                Next_Node => null,
                Action => Stay,
                Token_Type => Unknown
            ),
            2 => (
                Classifier => Tokenizer.Classifiers.Is_White_Space'Access,
                Next_Node => null,
                Action => Emit,
                Token_Type => Unknown
            ),
            3 => (
                Classifier => Tokenizer.Classifiers.Is_Close_Param'Access,
                Next_Node => null,
                Action => Emit,
                Token_Type => Unknown
            ),
            4 => (
                Classifier => Tokenizer.Classifiers.Is_Operator'Access,
                Next_Node => null,
                Action => Emit,
                Token_Type => Unknown
            ),
            5 => (
                Classifier => Tokenizer.Classifiers.Out_Of_Set'Access,
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
                Classifier => Tokenizer.Classifiers.Is_White_Space'Access,
                Next_Node => null,
                Action => Skip,
                Token_Type => Unknown
            ),
            2 => (
                Classifier => Tokenizer.Classifiers.Is_Digit'Access,
                Next_Node => Digit_One_Node'Access,
                Action => Start,
                Token_Type => Number
            ),
            3 => (
                Classifier => Tokenizer.Classifiers.Is_Unary_Minus'Access,
                Next_Node => Digit_One_Node'Access,
                Action => Start,
                Token_Type => Number
                ),
            4 => (
                Classifier => Tokenizer.Classifiers.Is_Point'Access,
                Next_Node => Digit_One_Node'Access,
                Action => Start,
                Token_Type => Number
            ),
            5 => (
                Classifier => Tokenizer.Classifiers.Is_Operator'Access,
                Next_Node => Single_Char_Node'Access,
                Action => Start,
                Token_Type => Operator
            ),
            6 => (
                Classifier => Tokenizer.Classifiers.Is_Close_Param'Access,
                Next_Node => Single_Char_Node'Access,
                Action => Start,
                Token_Type => Close_Paren
            ),
            7 => (
                Classifier => Tokenizer.Classifiers.Is_Open_Param'Access,
                Next_Node => Single_Char_Node'Access,
                Action => Start,
                Token_Type => Open_Paren
            ),
            8 => (
                Classifier => Tokenizer.Classifiers.Out_Of_Set'Access,
                Next_Node => null,
                Action => Error,
                Token_Type => Unknown
            )
        )
    );


end FSM_Representation;