use std::os::raw::{c_char};

extern "C" {
    pub fn shunting_yard_algorithm(input: *const c_char, output: *mut *mut c_char);
    pub fn free_string(ptr: *mut *mut c_char);
}