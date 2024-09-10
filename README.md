# rules_bison + rules_foreign_cc + `cmake()` + `BISON_PKGDATADIR` reproduction

Original repository: <https://github.com/mbland/rules-bison-pkgdatadir-repro>

Related issue: [jmillikin/rules_bison: BISON_PKGDATADIR breaks when using
cmake() from rules_foreign_cc #17][issue].

Minimal reproduction of `BISON_PKGDATADIR` breakage between `rules_bison` and
`rules_foreign_cc` as described in [Migrating to Bazel Modules (a.k.a. Bzlmod) -
Repo Names, Macros, and Variables][blog].

To recreate:

```txt
$ bazel build //...

[ ...snip... ]
[ 33%] [BISON][parser] Building parser with bison 3.3.2
bison: external/rules_bison~~bison_repository_ext~bison_v3.3.2__cfg00000B62/data/m4sugar/m4sugar.m4: cannot open: No such file or directory
make[2]: *** [CMakeFiles/repro.dir/build.make:74: rpcalc.c] Error 1
make[1]: *** [CMakeFiles/Makefile2:82: CMakeFiles/repro.dir/all] Error 2
make: *** [Makefile:91: all] Error 2
_____ END BUILD LOGS _____
[ ...snip... ]
```

To see the fix, find and uncomment the definition for `BISON_PKGDATADIR` in
[`repro/BUILD`][build].

To see the project build using `cmake` directly, run:

```txt
./cmake-build.sh
```

Per @jmillikin's comment in [the #bzlmod channel of the Bazel slack][slack]:

> This is where `BISON_PKGDATADIR` gets set:
>
> ```txt
> bison_env["BISON_PKGDATADIR"] = "{}.runfiles/{}/data".format(
>     ctx.executable.bison_tool.path,
>     ctx.executable.bison_tool.owner.workspace_name,
> )
> ```
>
> In the output you posted there's no `.runfiles`, so I'm wondering if that env
> var just isn't set at all, and bison is trying to auto-detect it based on
> `argv[0]`.
>
> Possibly the `cmake()` rule isn't reading `BisonToolchainInfo.bison_env`?

## References

- [rules_bison](https://github.com/jmillikin/rules_bison)
- [rules_m4](https://github.com/jmillikin/rules_m4)
- [rules_foreign_cc](https://github.com/bazelbuild/rules_foreign_cc)
- [rules_foreign_cc `cmake()` documentation](https://bazelbuild.github.io/rules_foreign_cc/main/cmake.html#cmake)

[issue]: https://github.com/jmillikin/rules_bison/issues/17
[blog]: https://blog.engflow.com/2024/09/06/migrating-to-bazel-modules-aka-bzlmod---repo-names-macros-and-variables/#updating-an-environment-variable-in-a-cmake-build-target
[build]: ./repro/BUILD
[slack]: https://bazelbuild.slack.com/archives/C014RARENH0/p1725925857793329?thread_ts=1725637275.962299&cid=C014RARENH0
