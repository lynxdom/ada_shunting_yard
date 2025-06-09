with Ada.Containers.Vectors;
with Ada.Finalization;
with Ada.Unchecked_Deallocation;

with Token;
use Token;

package Tokenizer is

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

private

    procedure Free_Vector is
        new Ada.Unchecked_Deallocation (
            Object => Token_Vector_Type,
            Name => Token_Vector_Access_Type
        );

end Tokenizer;