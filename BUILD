load("@polymerize//:polymerize.bzl", "polymer_library", "bower")

package(default_visibility = ["//visibility:public"])

polymer_library(
    name = "todo_ddc",
    package_name = "todo_ddc",
    base_path = "//:lib",
    dart_sources = glob(["lib/**/*.dart"]),
    export_sdk = 1,
    html_templates = glob(
        [
            "lib/**",
            "web/**",
        ],
        exclude = ["**/*.dart"],
    ),
    version = "1.0",
    deps = [
        "@polymer_element//:polymer_element",
        "@js//:js",
        "//todo_common",
        "//todo_main",
        "//todo_renderer",
        #'//todo_sample1'
    ],
)

bower(
    name = "main",
    deps = [
        "@polymer_element//:polymer_element",
    ],
)

filegroup(
    name = "default",
    srcs = [
        "main",
        "todo_ddc",
    ],
)
