## vim_printer

[![Gem Version](https://badge.fury.io/rb/vim_printer.svg)][gem]
[![Dependency Status](https://gemnasium.com/agilecreativity/vim_printer.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/agilecreativity/vim_printer.png)][codeclimate]

[gem]: http://badge.fury.io/rb/vim_printer
[gemnasium]: https://gemnasium.com/agilecreativity/vim_printer
[codeclimate]: https://codeclimate.com/github/agilecreativity/vim_printer

Batch print/export files to htmls using the power of Vim. Output will be saved to `vim_printer_#{project_name}.tar.gz` and ready for
extract and view in your favourite browser.

- Unlimited support for [vim colorschemes][] if enabled, or `default` colorscheme that comes with Vim.
- Can print any files in any languages that you can open with Vim.
- Use the power of [Vim][] to print the code without any other tools.
- Skip any binary files automatically

### Example Outputs:

- The original input using [seoul256.vim][] colorscheme in Vim

![](https://github.com/agilecreativity/vim_printer/raw/master/01-seoul256-input.png)

The html output as rendered in the browser

![](https://github.com/agilecreativity/vim_printer/raw/master/01-seoul256-output.png)

- The original input using `Tomorrow-Night` colorscheme from [Tomorrow-theme][] in Vim

![](https://github.com/agilecreativity/vim_printer/raw/master/02-Tomorrow-Night-input.png)

The html output as renderd in the browser

![](https://github.com/agilecreativity/vim_printer/raw/master/02-Tomorrow-Night-output.png)

### Requirements

- [Vim][] - any recent version should be ok.

- Any decent `~/.vimrc` should do

  * There are so many great vim dotfiles in github repos, just search for `dotfiles` keyword:w
  * [NeoBundle][] is a very good start if you are new to Vim.
  * If you like you can use [my dotvim][] which is based on the [NeoBundle][].
  * Use any [vim colorschemes][] if not the `default` colorscheme will be used.
    My personal favourite are [seoul256.vim][] and [Tomorrow-Theme][]

- Any valid file types that are supported by Vim will produce proper color syntax in the output.
  * By default Vim supports most of major languages so you should see the proper syntax with color in the output.
  * On newer language like [Elixir][], you may have to first install [vim-elixir][] to see the proper syntax in the output.
    If this is not installed then you will get the output but will not have the beautiful color syntax.

### Sample session

- Run with the sample fixture files

```sh
vim_printer -b test/fixtures -e rb java -r
```

Will produce the file `vim_printer_fixtures.tar.gz` with the following result on the screen.

```
FYI: process file 1 of 8 : ./demo1.xxx.rb
FYI: process file 2 of 8 : ./demo1.yyy.rb
FYI: process file 3 of 8 : ./demo2.xxx.rb
FYI: process file 4 of 8 : ./demo2.yyy.rb
FYI: process file 5 of 8 : ./java/demo3.xxx.java
FYI: process file 6 of 8 : ./java/demo3.yyy.java
FYI: process file 7 of 8 : ./java/demo4.xxx.java
FYI: process file 8 of 8 : ./java/demo4.yyy.java
Your output file is ./test/fixtures/vim_printer_fixtures.tar.gz
```

### Usage

- Install the gem for your version of ruby

e.g. for rbenv your session will be something like

```sh
rbenv local 2.1.2
rbenv rehash
gem install vim_printer
```

- Print any files using the gem

```sh
vim_printer
```

- Print any files that you like using the simplest command

The following command will print out all java, and ruby files recursively
using the `solarized` colorscheme.

```sh
vim_printer --base-dir ./test/fixtures \
            --exts rb \
            --theme solarized
```

Your output will be saved to the default `vim_printer_fixtures.tar.gz` in the directory where you run this command.
To see the output in your browser just type:

```sh
mkdir -p ~/Desktop/vim_printer
mv vim_printer_fixtures.tar.gz ~/Desktop/vim_printer
cd ~/Desktop/vim_printer
tar zxvf vim_printer_fixtures.tar.gz
```

- Print only files that contain the word `xxx` in the title

```sh
vim_printer --base-dir ./test/fixtures \
            --exts java \
            --theme solarized \
            --n xxx
```

- To include files that do not have any extension you can use `--non-exts`

```shell
# To print all ruby files as well as 'Gemfile' or 'Rakefile'
vim_printer -e ruby -f Gemfile Rakefile -r
```
### Advanced Usage

The new `--command` or `-s` flag can be used to get the input from the list of file.
Any unix command that can produce the result in the list of file can be used to
generate the input for printing.

My personal use-cases:

- Print out any files that we changed in the last N git commit
(Note any binary files or deleted files will skipped automatically)

e.g. Print out any files that were changed in the last 2 commit

```shell
# Must be run from inside the project directory containging the git project
vim_printer --command 'git diff --name-only HEAD~2'
```

- Use list of file from the result of `find` with `grep` command (from inside the project directory)

```shell
vim_printer --command 'find . -type f -iname "*.rb" | grep -v _spec'
```

### Limitation/Workaround

- The `--base-dir` must be used with the `--command` if the command is not run in the context of current directory.

e.g. Assume that you want to print all of the ruby `*.rb` files from `~/Desktop/project` and you are not currently
inside the `~/Desktop/project` directory

```
# Go to home directory
cd ~

# Note we are not inside the `~/Desktop/project` directory
vim_printer --command "find ~/Desktop/project -type f -iname '*.rb'" --base-dir ~/Desktop/project
```

Will give the proper links in the generated `index.html` file

But

```
# Go to home directory
cd ~

# Run the command from the home directory
vim_printer --command "find ~/Desktop/project -type f -iname '*.rb'" --base-dir .
```
will produces the invalid links in the generated `index.html` file

### Usage/Synopsys

For help in using the gem just type `vim_printer` without any parameter

```
Usage:
  vim_printer

Options:
  -b, [--base-dir=BASE_DIR]                # Base directory
                                           # Default: . (current directory)
  -e, [--exts=one two three]               # List of extension to search for
                                           # e.g. -e rb md
  -f, [--non-exts=one two three]           # List of file without extension to be included in the result (optional)
                                           # e.g. -f Gemfile LICENSE
  -n, [--inc-words=one two three]          # List of word that must be part of the name to be included in the result (optional)
                                           # If this option is not specified then
                                           # all files having the extension specified by -e or all file specified by -f will be included
  -x, [--exc-words=one two three]          # List of words to be excluded from the result if any (optional)
                                           # Use this option to filter out files that contain some word in the name
                                           # e.g. -x '_spec' to exclude files that end with '*_spec.rb' in the name
  -i, [--ignore-case], [--no-ignore-case]  # Match case insensitively apply to both -f, n, and -x options (optional)
                                           # Default: --ignore-case
  -r, [--recursive], [--no-recursive]      # Search for files recursively (optional)
                                           # Default: --recursive
  -v, [--version]                          # Display version information
                                           #
  -t, [--theme=THEME]                      # Vim colorscheme to use (optional)
                                           # Default: 'default'
  -c, [--index], [--no-index]              # Generate the index.html file for the result (optional)
                                           # Default: --index
  -s, [--command]                          # Use the input file list from the result of the given shell command
                                           # Note: the command must return the list of file to be valid
                                           # This option ignore any of the following options -e, -f, -n, -x, -i if specified
                                           # e.g. --command 'git diff --name-only HEAD~2 | grep -v test'
                                           # e.g. --command 'find . -type f -iname "*.rb" | grep -v test | grep -v _spec'
Print files to (x)html using Vim

```

### Customization for output options

You can customize how the output is produced by using the following configuration.

Edit the file `config/initializers/vim_printer.rb` to adjust the options used by
`:TOhtml` in Vim. (see `:help :TOhtml` from inside Vim for more detail)

The default settings for the `:TOhtml` are as follow

```ruby
[
  "-c 'let g:html_expand_tabs = 1'",
  "-c 'let g:html_use_css = 1'",
  "-c 'let g:html_no_progress = 1'",
  "-c 'let g:html_number_lines = 1'"
]
```

For example, if you like to suppress the line number in the output you will
need to use `"-c 'let g:html_number_lines = 0'"` which will suppress the
setting of `:set number` in Vim.

### Development/Testing

```sh
git clone https://github.com/agilecreativity/vim_printer.git
cd vim_printer
bundle
# run default test
rake
```

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Make sure that you add the tests and ensure that all tests are passed
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

[NeoBundle]: https://github.com/Shougo/neobundle.vim
[Vim]: https://www.vim.org
[my dotvim]: https://github.com/agilecreativity/dotvim
[Elixir]: http://elixir-lang.org
[vim-elixir]: https://github.com/elixir-lang/vim-elixir
[vim colorschemes]: https://github.com/flazz/vim-colorschemes/tree/master/colors
[seoul256.vim]: https://github.com/junegunn/seoul256.vim
[Tomorrow-theme]: https://github.com/ChrisKempson/Tomorrow-Theme
