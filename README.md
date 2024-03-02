# save-check.el

The `save-check` package provides a simple means of checking for errors, by automatically running a linter when files are saved.

The idea is that this is a _globally_ enabled package that does the right thing depending upon the mode of the file(s) you're working upon.



## Implementation

Once enabled a global hook is added to `after-save-hook`, which will trigger the package and ensure future file-saves trigger the behaviour:

* The syntax check will be executed by executing an external process.
  * The command can be configured based upon the major-mode of the buffer.
* If the process exits with successful (zero) status-code, then nothing happens.
* If the process exits with a failure (non-zero) status-code
  * The STDOUT/STDERR of that process will be shown in a popup-buffer.
  * Pressing `q` will kill that notification.



## Installation

Save this file to a directory which is included upon your load-path, and then add:

```
(require 'save-check)
```



## Configuration

The configuration of this package is mostly related to updating the `save-check-config` list.

There are several possible keys that can be set within the list-items:

* Mandatory arguments:
  * `:mode` - The name of the major-mode to operate within.
  * `:exec` - The process to execute to run the syntax-check.
    * `%f` will be replaced with the filename which was just saved.
    * `%d` will be replaced with the directory within which the file was just saved.
    * Note that `:exec` can be replaced with `:lisp`.
* Optional arguments:
  * `:cond` - An optional config that may be used to disable a check.
  * `:eval` - If this is present then the expression will be evaluated.

There are some other variables which can be set though:

* `save-check-buffer-name`
  * Configures the buffer-name of any failing results which are shown.
* `save-check-show-eval`
  * If `:eval` is used to execute a lisp expression on a particular mode then the output is discarded by default.  Set this value to a non-nil value to see it.
