mod bindings;

use std::ffi::{CString, CStr};
use std::{ptr};

#[derive(Debug)]
struct TokenizerTestCase {
    input: &'static str,
    expected: &'static str,
}

const TEST_CASES : [ TokenizerTestCase; 38 ] = [

    // Basic Arithmatec
    TokenizerTestCase { input: "2 + 3", expected: "2 3 +" },
    TokenizerTestCase { input: "4 - 1", expected: "4 1 -" },
    TokenizerTestCase { input: "6 * 7", expected: "6 7 *" },
    TokenizerTestCase { input: "8 / 2", expected: "8 2 /" },

    //Operator Precidence
    TokenizerTestCase { input: "2 + 3 * 4", expected: "2 3 4 * +" },
    TokenizerTestCase { input: "2 * 3 + 4", expected: "2 3 * 4 +" },
    TokenizerTestCase { input: "2 + 3 * 4 - 5", expected: "2 3 4 * + 5 -" },

    //Parentheses
    TokenizerTestCase { input: "(2 + 3) * 4", expected: "2 3 + 4 *" },
    TokenizerTestCase { input: "2 * (3 + 4)", expected: "2 3 4 + *" },
    TokenizerTestCase { input: "(2 + 3) * (4 - 1)", expected: "2 3 + 4 1 - *" },

    // Associativity
    TokenizerTestCase { input: "5 - 3 - 2", expected: "5 3 - 2 -" }, // left associative
    TokenizerTestCase { input: "4 / 2 / 2", expected: "4 2 / 2 /" },

    // Certifiable Crazy
    TokenizerTestCase { input: "x + y", expected: "x y +" },
    TokenizerTestCase { input: "x1 + _var2", expected: "x1 _var2 +" },

    TokenizerTestCase { input: "sin(x)", expected: "x sin" },
    TokenizerTestCase { input: "cos(x + y)", expected: "x y + cos" },
    TokenizerTestCase { input: "log(10)", expected: "10 log" },
    TokenizerTestCase { input: "sqrt(4 + 5)", expected: "4 5 + sqrt" },

    TokenizerTestCase { input: "2 ^ 3", expected: "2 3 ^" },
    TokenizerTestCase { input: "2 ^ 3 ^ 2", expected: "2 3 2 ^ ^" }, // assumes right-associative

    TokenizerTestCase { input: "3.14 * r ^ 2", expected: "3.14 r 2 ^ *" },
    TokenizerTestCase { input: "0.5 + .5", expected: "0.5 0.5 +" },
    TokenizerTestCase { input: "1.0e3 + 2.5E-2", expected: "1.0e3 2.5E-2 +" },

    TokenizerTestCase { input: "max(a, b + c)", expected: "a b c + max" },
    TokenizerTestCase { input: "pow(2, 10)", expected: "2 10 pow" },

    TokenizerTestCase { input: "2 * x + y / 3 ^ z", expected: "2 x * y 3 z ^ / +" },
    TokenizerTestCase { input: "((x))", expected: "x" },
    TokenizerTestCase { input: "(x + (y)) * z", expected: "x y + z *" },

    // Failure Cases
    TokenizerTestCase { input: "", expected: "ERR" },
    TokenizerTestCase { input: "sin()", expected: "ERR" },
    TokenizerTestCase { input: "x + ", expected: "ERR" },
    TokenizerTestCase { input: "()", expected: "ERR" },
    TokenizerTestCase { input: "log(1, 2)", expected: "ERR" }, // if single-arg log only
    TokenizerTestCase { input: "2 + * 3", expected: "ERR" },
    TokenizerTestCase { input: "sqrt(4 + 5", expected: "ERR" },
    TokenizerTestCase { input: "2 +", expected: "ERR" },
    TokenizerTestCase { input: "(2 + 3", expected: "ERR" },
    TokenizerTestCase { input: "2 + * 3", expected: "ERR" },
];

// FFI call wrapper
fn call_tokenizer_ffi(input: &str) -> String {
    let c_input = CString::new(input).expect("CString Failed");
    let mut output_ptr: *mut i8 = ptr::null_mut();

    unsafe {
        bindings::shunting_yard_algorithm(c_input.as_ptr(), &mut output_ptr);

        if output_ptr.is_null() {
            return String::from("ERR");
        }

        let output_cstr = CStr::from_ptr(output_ptr);
        let output_str = output_cstr.to_string_lossy().to_string();

        bindings::free_string(&mut output_ptr);
        output_str
    }
}

fn main() {
    for test_case in &TEST_CASES {
        let actual = call_tokenizer_ffi(test_case.input);

        if actual.trim() == test_case.expected {
            println!("✅ PASS: `{}` → `{}`", test_case.input, actual);
        } else {
            println!("❌ FAIL: `{}`\n   Expected: `{}`\n   Got:      `{}`",
                     test_case.input, test_case.expected, actual);
        }
    }
}

