fn main() {
    println!("cargo:rustc-link-search=native=../ada_shunting_algorithim/lib");
    println!("cargo:rustc-link-lib=dylib=Shuntingyardalgorithm");
}