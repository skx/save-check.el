# save-check.el

The `save-check` package provides a simple means of checking for syntax errors automatically when files are saved.

Once enabled a global hook is added to `after-save-hook` which will run a syntax check:

* The syntax check will be executed by executing an external process.
  * The command can be configured based upon the major-mode of the buffer.
* If the process exits with successful (zero) status-code, then nothing happens.
* If the process exits with a failure (non-zero) status-code
  * The STDOUT/STDERR of that process will be shown.
  * But importantly this will happen _after_ the file has been saved, and no changes will be made to it on-disk.



## Installation

Save this file to a directory which is included upon your load-path, and then add:

```
(require 'save-check)
```



## Configuration

The configuration is contained within the `save-check-config` list.

There are several possible keys that can be set within the list-items:

* Mandatory arguments:
  * `:mode` - The name of the major-mode to operate within.
  * `:exec` - The process to execute to run the syntax-check.
    * `%f` will be replaced with the filename which was just saved.
    * `%d` will be replaced with the directory within which the file was just saved.
* Optional arguments:
  * `:cond` - An optional config that may be used to disable a check.
