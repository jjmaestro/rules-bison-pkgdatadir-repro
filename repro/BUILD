load(":rules.bzl", "repo_name_variable")
load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(
    name = "repro_srcs",
    srcs = [
      "CMakeLists.txt",
      "rpcalc.y",
    ],
)

exports_files(["CMakeLists.txt"])

cmake(
    name = "repro",
    cache_entries = {
        # https://github.com/bazelbuild/rules_foreign_cc/pull/1219
        # makes it impossible to set `-DBISON_EXECUTABLE` with `execpath` in
        # `generate_args` using recent versions of rules_foreign_cc. Fortunately
        # we can work around this with with `env` variables, and `cache_entries`
        # is a better home, anyway.
        #
        # Also, once https://github.com/bazelbuild/rules_foreign_cc/pull/1272
        # makes it into a release, `cache_entries` will support location and
        # Make variable expansion. Then we can get move the `BISON_EXECUTABLE`
        # entry from `env` to replace the following.
        "BISON_EXECUTABLE": "$$BISON_EXECUTABLE$$",
    },

    # Note that rules_foreign_cc implicitly prefixes every `$(execpath `
    # value with `$$EXT_BUILD_ROOT$$/` unless it already contains
    # `EXT_BUILD_ROOT`:
    #
    # - https://github.com/bazelbuild/rules_foreign_cc/blob/0.12.0/foreign_cc/private/framework.bzl#L379-L380
    # - https://github.com/bazelbuild/rules_foreign_cc/blob/0.12.0/foreign_cc/private/framework.bzl#L1076-L1081
    env = {
        "BISON_EXECUTABLE": "$(execpath @bison//bin:bison)",

        # Without the `BISON_PKGDATADIR` definition below, we get the following
        # error, where `BISON_REPO_NAME` is the canonical name of the repository
        # for `@bison//bin:bison`:
        #
        #   bison: external/BISON_REPO_NAME/data/m4sugar/m4sugar.m4:
        #     cannot open: No such file or directory
        #
        # Uncomment the `BISON_PKGDATADIR` definition to make the error go away.

        #"BISON_PKGDATADIR": "$(execpath @bison//bin:bison).runfiles/" +
        #    "$(bison-repo)/data",

        # Defining this as "$(M4)" doesn't work:
        #
        #   bison: m4 subprocess failed: No such file or directory

        "M4": "$(execpath @m4//bin:m4)",
    },
    toolchains = [
        ":bison-repo",
        "@rules_bison//bison:current_bison_toolchain",
        "@rules_m4//m4:current_m4_toolchain",
    ],
    build_data = [
        "@bison//bin:bison",
        "@m4//bin:m4",
    ],
    install = False,
    lib_source = ":repro_srcs",
    out_lib_dir = "../repro.build_tmpdir",
    out_static_libs = ["librepro.a"],
)

repo_name_variable(
    name = "bison-repo",
    dep = "@bison//bin:bison",
)
