with Interfaces.C;
with Interfaces.C.Strings;

package ShuntingYardAlgorithm is

    --   Call algorithim
    procedure Shunting_Yard_Algorithm (
        In_Expression  : in Interfaces.C.Strings.chars_ptr;
        Out_Expression : out Interfaces.C.Strings.chars_ptr
    )
    with Export => True,
         Convention => C,
         External_Name => "shunting_yard_algorithm";

    --   Cleanup string
    procedure Free_String (
        str_ptr : in out Interfaces.C.Strings.chars_ptr
    )
    with Export => True,
         Convention => C,
         External_Name => "free_string";

end ShuntingYardAlgorithm;