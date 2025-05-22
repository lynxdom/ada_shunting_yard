with Ada.Containers.Vectors;

package Tokenizer is

    -- Enumerations
    type Catagory_Type is ( Number, Operator, Open_Paren, Close_Paren, Func, Identifier );

    -- private types
    type Token_Type is private;
    type Token_Access_Type is access Token_Type;
    type Token_Iterator_Type is private;
    type Token_Iterator_Access_Type is access Token_Iterator_Type;



    -- Public Functions
    procedure Tokenize(
        Token_Iterator: in out Token_Iterator_Access_Type;
        Input_String : in String
    );
    
    procedure Next( 
        Token_Iterator : in out Token_Iterator_Access_Type 
    );
    
    function Value( 
        Token_Iterator : in     Token_Iterator_Access_Type 
    ) return String;
    
    function Catagory( 
        Token_Iterator : in     Token_Iterator_Access_Type 
    ) return Catagory_Type;


private

    type Token_Type is record
        index : Natural;
        length : Natural;
        catagory : Catagory_Type;
    end record;

    -- Packages
    package Token_Iterator_Vector_Type is new Ada.Containers.Vectors( 
        Index_Type => Natural,
        Element_Type => Token_Type 
    );

    type Token_Iterator_Type is tagged record
        currect_index : Natural;
        token_vector : Token_Iterator_Vector_Type.Vector;
    end record;

end Tokenizer;