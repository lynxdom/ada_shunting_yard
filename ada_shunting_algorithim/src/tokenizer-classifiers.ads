package Tokenizer.Classifiers is

    type Classifier_Function_Type is
        access function (
            Char : Character
    ) return Boolean;

    function Is_Digit (
        Char : Character
    ) return Boolean;

    function Is_Point (
        Char : Character
    ) return Boolean;

    function Is_Comma (
        Char : Character
    ) return Boolean;

    function Is_Unary_Minus (
        Char : Character
    ) return Boolean;

    function Is_Operator (
        Char : Character
    ) return Boolean;

    function Is_White_Space (
        Char : Character
    ) return Boolean;

    function Is_Open_Param (
        Char : Character
    ) return Boolean;

    function Is_Close_Param (
        Char : Character
    ) return Boolean;

    function Out_Of_Set (
        Char : Character
    ) return Boolean;

end Tokenizer.Classifiers;