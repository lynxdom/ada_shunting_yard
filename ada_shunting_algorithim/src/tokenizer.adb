package body Tokenizer is

    -- Public Functions
    procedure Tokenize(
        Token_Iterator: in out Token_Iterator_Access_Type ;
        Input_String : in String
    ) is
    begin
        Token_Iterator := null;
    end;

    procedure Next( 
        Token_Iterator : in out Token_Iterator_Access_Type 
    ) is
    begin
        null;
    end;
    
    function Value( 
        Token_Iterator : in     Token_Iterator_Access_Type 
    ) return String is
    begin
        return "";
    end;
    
    function Catagory( 
        Token_Iterator : in     Token_Iterator_Access_Type 
    ) return Catagory_Type is
    begin
        return Number;
    end;


end Tokenizer;