#include <iostream>
#include <string>
#include <vector>
#include <cstring>
#include <cstdlib>  // for getenv / setenv on POSIX
#include <thread>

extern "C" {
    // Match the Ada interface
    void shunting_yard_algorithm(const char* in_expression, char** out_expression);
    void free_string(char** str_ptr);
}

struct TokenizerTestCase {
    const char* input;
    const char* expected;
};

const TokenizerTestCase TEST_CASES[] = {
    { "-3 + -4", "-3 -4 +" },
    { "-3.5 + -4.25", "-3.5 -4.25 +" },
    { "6.0 - -2.5", "6.0 -2.5 -" },
    { "-1.2e3 + -3.4e-2", "-1.2e3 -3.4e-2 +" },
    { "-7 + -0.5", "-7 -0.5 +" },
    { "-2.5 * -1e-2", "-2.5 -1e-2 *" },
    { "(-3.5 + -4.5) * -2.0", "-3.5 -4.5 + -2.0 *" },
    { "", "ERR" },
    { "sin()", "ERR" },
    { "2 + 3", "2 3 +" },
    { "(2 + 3) * (4 - 1)", "2 3 + 4 1 - *" }
    // Add more test cases from your original array as needed
};

std::string call_tokenizer_ffi(const std::string& input) {
    char* output_ptr = nullptr;

#ifdef __unix__
    setenv("GNAT_SECONDARY_STACK_SIZE", "10M", 1);
#endif

    shunting_yard_algorithm(input.c_str(), &output_ptr);

    if (!output_ptr) {
        return "ERR";
    }

    std::string result(output_ptr);
    free_string(&output_ptr);
    return result;
}

int main() {
    for (const auto& test_case : TEST_CASES) {
        std::string actual;

        std::thread t([&]() {
            actual = call_tokenizer_ffi(test_case.input);
        });

        t.join();

        if (actual == test_case.expected) {
            std::cout << "✅ PASS: `" << test_case.input << "` → `" << actual << "`\n";
        } else {
            std::cout << "❌ FAIL: `" << test_case.input << "`\n"
                      << "   Expected: `" << test_case.expected << "`\n"
                      << "   Got:      `" << actual << "`\n";
        }
    }

    return 0;
}
