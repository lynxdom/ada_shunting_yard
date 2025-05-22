# Shunting Yard Algorithm: Ada + Rust FFI Integration

This project is a hybrid implementation of the **Shunting Yard Algorithm**, written in **Ada** and tested via **Rust** using FFI bindings.

It serves as a practical exploration in:
- Systems-level multi-language interoperability
- Compiler correctness
- Clean, explicit token parsing in strongly typed environments

## 📦 Project Structure

.
├── ada_shunting_algorithim
│   ├── alire
│   │   ├── alire.lock
│   │   ├── build_hash_inputs
│   │   └── settings.toml
│   ├── alire.toml
│   ├── config
│   │   ├── shuntingyardalgorithm_config.ads
│   │   ├── shuntingyardalgorithm_config.gpr
│   │   └── shuntingyardalgorithm_config.h
│   ├── lib
│   │   ├── libShuntingyardalgorithm.so -> Shuntingyardalgorithm.so.0.1.0-dev
│   │   ├── shuntingyardalgorithm.ali
│   │   ├── shuntingyardalgorithm_config.ali
│   │   ├── Shuntingyardalgorithm.so.0.1.0-dev
│   │   └── tokenizer.ali
│   ├── obj
│   │   └── development
│   ├── share
│   │   └── shuntingyardalgorithm
│   ├── shuntingyardalgorithm.gpr
│   └── src
│       ├── shuntingyardalgorithm.adb
│       ├── shuntingyardalgorithm.ads
│       ├── tokenizer.adb
│       └── tokenizer.ads
└── shunting_test_rs
    ├── Cargo.lock
    ├── Cargo.toml
    ├── src
    │   └── main.rs
    └── target
        ├── CACHEDIR.TAG
        └── debug

14 directories, 21 files


## 🛠️ Build Instructions

### Requirements
- **GCC Ada** (`gnat`) — the Ada compiler in GNU Compiler Collection
- [Alire](https://alire.ada.dev/) for project and dependency management
- [Rust](https://www.rust-lang.org/tools/install)
- `cargo`, `gprbuild`, and optionally `tree` for file visualization

### Building the Project

From the root of the repository:

```bash
# Step 1: Build the Ada shared object
alr build -P ada_shunting_algorithim/shuntingyardalgorithm.gpr

# Step 2: Build the Rust FFI test suite
cd shunting_test_rs
cargo build
