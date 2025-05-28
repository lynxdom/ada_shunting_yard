with Interfaces.C;
with Interfaces.C.Strings;

package ShuntingYardAlgorithm is

    generic
        type Element is private;
        Size : Natural;
    package Stack_Package is

        type Stack is tagged private;

        procedure Push (Stack_Object : in out Stack;
                        New_Item : Element);
        function Pop (Stack_Object : in out Stack) return Element;
        function Empty (Stack_Object : in out Stack) return Boolean;

    private
        type Stack_Array is array (Natural range 1 .. Size) of Element;

        type Stack is tagged
        record
            Internal_Stack : Stack_Array;
            Stack_Size : Natural := 0;
        end record;
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

private
    type Operator_Enum is ('^', '*', '/', '+', '-', '(', ')');
    type Operator_Precedence_Enum is (Greater, Lesser, Equal);

end ShuntingYardAlgorithm;