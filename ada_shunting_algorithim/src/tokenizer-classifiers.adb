
package body Tokenizer.Classifiers is

    function Is_Digit (
        Char : Character
    ) return Boolean is
        Char_Value : constant Natural := Character'Pos (Char);
    begin
        return Char_Value >= 48 and then Char_Value <= 57;
    end Is_Digit;

    function Is_Point (
        Char : Character
    ) return Boolean is
    begin
        return Char = '.';
    end Is_Point;

    function Is_Comma (
        Char : Character
    ) return Boolean is
    begin
        return Char = ',';
    end Is_Comma;

    function Is_Unary_Minus (
        Char : Character
    ) return Boolean is
    begin
        return Char = '-';
    end Is_Unary_Minus;

    function Is_Operator (
        Char : Character
    ) return Boolean is
    begin

        if Char = '+' or else
           Char = '-' or else
           Char = '/' or else
           Char = '*' or else
           Char = '^'
        then
            return True;
        else
            return False;
        end if;

    end Is_Operator;

    function Is_White_Space (
        Char : Character
    ) return Boolean is
        Char_Value : constant Natural := Character'Pos (Char);
    begin
        if Char_Value = 32 or else
           Char_Value = 9
        then
            return True;
        else
            return False;
        end if;
    end Is_White_Space;

    function Is_Open_Param (
        Char : Character
    ) return Boolean is
    begin
        return Char = '(';
    end Is_Open_Param;

    function Is_Close_Param (
        Char : Character
    ) return Boolean is
    begin
        return Char = ')';
    end Is_Close_Param;

    function Out_Of_Set (
        Char : Character
    ) return Boolean is
    begin
        pragma Unreferenced (Char);

        return True;
    end Out_Of_Set;

end Tokenizer.Classifiers;