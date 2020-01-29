load("@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
     "feature",
     "flag_group",
     "flag_set",
     "tool_path",
     "with_feature_set")

load(
    "@bazel_tools//tools/build_defs/cc:action_names.bzl",
    _ASSEMBLE_ACTION_NAME = "ASSEMBLE_ACTION_NAME",
    _CLIF_MATCH_ACTION_NAME = "CLIF_MATCH_ACTION_NAME",
    _CPP_COMPILE_ACTION_NAME = "CPP_COMPILE_ACTION_NAME",
    _CPP_HEADER_PARSING_ACTION_NAME = "CPP_HEADER_PARSING_ACTION_NAME",
    _CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME = "CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME",
    _CPP_LINK_EXECUTABLE_ACTION_NAME = "CPP_LINK_EXECUTABLE_ACTION_NAME",
    _CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME = "CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME",
    _CPP_MODULE_CODEGEN_ACTION_NAME = "CPP_MODULE_CODEGEN_ACTION_NAME",
    _CPP_MODULE_COMPILE_ACTION_NAME = "CPP_MODULE_COMPILE_ACTION_NAME",
    _C_COMPILE_ACTION_NAME = "C_COMPILE_ACTION_NAME",
    _LINKSTAMP_COMPILE_ACTION_NAME = "LINKSTAMP_COMPILE_ACTION_NAME",
    _LTO_BACKEND_ACTION_NAME = "LTO_BACKEND_ACTION_NAME",
    _PREPROCESS_ASSEMBLE_ACTION_NAME = "PREPROCESS_ASSEMBLE_ACTION_NAME",
)


all_link_actions = [
    _CPP_LINK_EXECUTABLE_ACTION_NAME,
    _CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME,
    _CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME,    
]

def _impl(ctx):
    tool_paths = [
        tool_path(
            name = "gcc",
            path = "/usr/bin/gcc",
        ),
        tool_path(
            name = "ld",
            path = "/usr/bin/ld",
        ),
        tool_path(
            name = "ar",
            path = "/usr/bin/ar",
        ),
        tool_path(
            name = "cpp",
            path = "/usr/bin/c++",
        ),
        tool_path(
            name = "gcov",
            path = "/usr/bin/gcov",
        ),
        tool_path(
            name = "nm",
            path = "/usr/bin/nm",
        ),
        tool_path(
            name = "objdump",
            path = "/usr/bin/objdump",
        ),
        tool_path(
            name = "strip",
            path = "/usr/bin/strip",
        ),
    ]
    default_link_flags_feature = feature(
       name = "default_link_flags",
       enabled = True,
       flag_sets = [
           flag_set(
               actions = all_link_actions,
               flag_groups = [
                   flag_group(
                       flags = [
			   "-static-libgcc",
                           "-Wl,-Bstatic",
			   "-lstdc++",
			   "-Wl,-Bdynamic",			   
                           "-lm",
			   "-ldl",
                           "-no-canonical-prefixes",
                           "-pass-exit-codes",
                       ],
                   ),
               ],
           ),
           flag_set(
               actions = all_link_actions,
               flag_groups = [flag_group(flags = ["-Wl,--gc-sections"])],
               with_features = [with_feature_set(features = ["opt"])],
                ),
            ],
        )
   


    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,

        toolchain_identifier = "clangstatic-toolchain",
        host_system_name = "unknown-linux-gnu",
        target_system_name = "unknown-linux-gnu",
        target_cpu = "k8",
	cxx_builtin_include_directories = ["/usr/include", "/usr/lib/gcc/x86_64-linux-gnu/8/include", "/usr/lib/gcc/x86_64-linux-gnu/8/include-fixed"],
        target_libc = "unknown",
        compiler = "clang-static",
        abi_version = "unknown",
        abi_libc_version = "unknown",
	tool_paths = tool_paths,
#        features = [default_link_flags_feature, "static_link_cpp_runtimes", "static_linking_mode"],
        features = [default_link_flags_feature, ],

    )

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)
