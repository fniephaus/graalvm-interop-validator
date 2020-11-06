# Interop Validator for GraalVM
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
$ $GRAALVM_HOME/bin/polyglot --jvm interop_validator.rb python "import os; os"
```

### Result

> Running on truffleruby 21.0.0-dev-eb72eb83, like ruby 2.6.6, GraalVM CE JVM [x86_64-darwin]...

#### Unreadable member(s) of `#<Python <module 'os' from '/languages/python/lib-python/3/os.py'>>`
- `_add` (*Unknown identifier: _add*)
- `_check_bytes` (*Unknown identifier: _check_bytes*)
- `_createenviron` (*Unknown identifier: _createenviron*)
- `_fscodec` (*Unknown identifier: _fscodec*)
- `_globals` (*Unknown identifier: _globals*)
- `_have_functions` (*Unknown identifier: _have_functions*)
- `_names` (*Unknown identifier: _names*)
- `_set` (*Unknown identifier: _set*)
- `posix` (*Unknown identifier: posix*)

#### Unreadable member(s) of `#<Python <module 'sys' (built-in)>>`
- `make_excepthook` (*Unknown identifier: make_excepthook*)
- `make_flags_class` (*Unknown identifier: make_flags_class*)
- `make_float_info_class` (*Unknown identifier: make_float_info_class*)
- `make_hash_info_class` (*Unknown identifier: make_hash_info_class*)
- `make_implementation_info` (*Unknown identifier: make_implementation_info*)
- `make_int_info_class` (*Unknown identifier: make_int_info_class*)
- `make_thread_info_class` (*Unknown identifier: make_thread_info_class*)
- `make_unraisable_hook_args_class` (*Unknown identifier: make_unraisable_hook_args_class*)
- `make_unraisablehook` (*Unknown identifier: make_unraisablehook*)

---
