with Ada.Containers.Vectors;
with Ada.Finalization;
with Ada.Unchecked_Deallocation;

package Tokenizer is

    --    Enumerations
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

    --    Packages
    package Token_Vectors is new Ada.Containers.Vectors (
        Index_Type => Natural,
        Element_Type => Token_Access_Type
    );

    --    Vector for storing Tokens
    type Token_Vector_Type is new Ada.Finalization.Controlled with record
        Items : Token_Vectors.Vector;
    end record;

    overriding procedure Finalize (Obj : in out Token_Vector_Type);

    type Token_Vector_Access_Type is access all Token_Vector_Type;

    --    Public Functions
    procedure Tokenize (
        Token_Vector : out Token_Vector_Access_Type;
        Input_String : in String
    );

    function Value (
        Token : in     Token_Access_Type;
        Str   : access constant String
    ) return String;

    function Catagory (
        Token : in     Token_Access_Type
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

    procedure Free_Vector is
        new Ada.Unchecked_Deallocation (
            Object => Token_Vector_Type,
            Name => Token_Vector_Access_Type
        );

end Tokenizer;