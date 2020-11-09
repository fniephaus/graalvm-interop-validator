# Interop Validator for GraalVM [![CI](https://github.com/fniephaus/graalvm-interop-validator/workflows/CI/badge.svg)](https://github.com/fniephaus/graalvm-interop-validator/actions/)
Utility to validate the language interoperability interface of Truffle objects.


## Options

```bash
$ $GRAALVM_HOME/bin/polyglot --jvm interop_validator.rb --help
Usage: interop_validator.rb [options] <language_id> <expression>
    -v, --[no-]verbose               Run verbosely
    -d, --depth [DEPTH]              Set scan depth (default: 2)
```

## Example

```bash
$ $GRAALVM_HOME/bin/polyglot --jvm interop_validator.rb --depth 2 python "import os; os"
```

### Result

> Running on truffleruby 21.0.0-dev-eb72eb83, like ruby 2.6.6, GraalVM CE JVM [x86_64-darwin]...  
> Evaluating `import os; os` for python...

#### Potentially defective member(s) of `#<Python <module 'os' from '/languages/python/lib-python/3/os.py'>>`
- :warning: `_add` (*unreadable*)
- :warning: `_check_bytes` (*unreadable*)
- :warning: `_createenviron` (*unreadable*)
- :warning: `_fscodec` (*unreadable*)
- :warning: `_globals` (*unreadable*)
- :warning: `_have_functions` (*unreadable*)
- :warning: `_names` (*unreadable*)
- :warning: `_set` (*unreadable*)
- :warning: `posix` (*unreadable*)

#### Potentially defective member(s) of `#<Python <module 'sys' (built-in)>>`
- :warning: `make_excepthook` (*unreadable*)
- :warning: `make_flags_class` (*unreadable*)
- :warning: `make_float_info_class` (*unreadable*)
- :warning: `make_hash_info_class` (*unreadable*)
- :warning: `make_implementation_info` (*unreadable*)
- :warning: `make_int_info_class` (*unreadable*)
- :warning: `make_thread_info_class` (*unreadable*)
- :warning: `make_unraisable_hook_args_class` (*unreadable*)
- :warning: `make_unraisablehook` (*unreadable*)

---
