# save-check.el

The `save-check` package provides a simple means of checking for syntax errors of files after they have been saved.

Once enabled a global hook is added to `after-save-hook` which will run a syntax check:

* The syntax check will be executed by executing an external process.
  * The command will have the name of the saved-file as an argument.
* If the process exits with successful (zero) status-code, then nothing happens.
* If the process exits with a failure (non-zero) status-code
  * The STDOUT/STDERR of that process will be shown.
  * But importantly this will happen _after_ the file has been saved, and no changes will be made to it on-disk.



## Installation

Save this file to a directory which is included upon your load-path, and then add:

```
(require 'save-check)
```

The configuration is contained within the `save-check-config` list, and contains pairs:

* The name of the major-mode to operate within.
* The process to execute to run the syntax-check.
  * `%s` will be replaced with the path to the filename to check.

New entries may be added as you would expect.
