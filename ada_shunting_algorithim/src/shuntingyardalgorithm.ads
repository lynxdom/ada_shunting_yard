with Interfaces.C;
with Interfaces.C.Strings;

package ShuntingYardAlgorithm is

    generic
        type Element is private;
        Size : Natural;
    package Stack_Package is

        procedure Push (New_Item : Element);
        function Pop return Element;

    private
        type Stack is array (Natural range 1 .. Size) of Element;

        Internal_Stack : Stack;
        Stack_Size : Natural := 0;

    end Stack_Package;

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