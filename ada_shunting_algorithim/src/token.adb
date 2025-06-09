package body Token is

    function Create_Token (
        Index : Natural;
        Length : Natural := 0;
        Catagory : Catagory_Type := Unknown
    ) return Token_Access_Type is
    begin
        return new Token_Type'(
            Ada.Finalization.Controlled with
                Index    => Index,
                Length   => Length,
                Catagory => Catagory
        );
    end Create_Token;

    function Catagory (
        Item : in Token_Access_Type
    ) return Catagory_Type is
    begin
        return Item.Catagory;
    end Catagory;

    --    Token Access Functions
    function Value (
        Item : in Token_Access_Type;
        Str   : access constant String
    ) return String is
    begin
        return Str (
            Item.all.Index ..
            Item.all.Index + Item.all.Length - 1
        );
    end Value;

    overriding procedure Finalize (
        Obj : in out Token_Type
    ) is
    begin
        null;
    end Finalize;

end Token;