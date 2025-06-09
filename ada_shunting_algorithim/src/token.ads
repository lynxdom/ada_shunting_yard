with Ada.Finalization;
with Ada.Unchecked_Deallocation;

package Token is
    type Catagory_Type is (
        Number,
        Operator,
        Open_Paren,
        Close_Paren,
        Func,
        Identifier,
        Unknown
    );

    --    private types
    type Token_Type is private;
    type Token_Access_Type is access Token_Type;

    function Create_Token (
        Index : Natural;
        Length : Natural := 0;
        Catagory : Catagory_Type := Unknown
    ) return Token_Access_Type;

    function Value (
        Item : in     Token_Access_Type;
        Str   : access constant String
    ) return String;

    function Catagory (
        Item : in     Token_Access_Type
    ) return Catagory_Type;

private

    type Token_Type is new Ada.Finalization.Controlled with record
        Index : Natural;
        Length : Natural;
        Catagory : Catagory_Type;
    end record;

    overriding procedure Finalize (Obj : in out Token_Type);

    --    Unchecked deallocation machinery
    procedure Free_Token is
        new Ada.Unchecked_Deallocation (
            Object => Token_Type,
            Name => Token_Access_Type
        );

end Token;