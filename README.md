## vim_printer

Print any files to html using the power of Vim. Output will be saved to `output.tar.gz` and ready for
extract and viewing in your favourite browser.

- Unlimited support for [vim colorschemes][] if enabled, or `default` colorscheme that comes with Vim.
- Can print any files in any languages that you can open with Vim.
- Use the power of [Vim][] to print the code without any other tools.
- Tested in Linux/OSX and should also works with Windows.

[![Gem Version](https://badge.fury.io/rb/vim_printer.svg)](http://badge.fury.io/rb/vim_printer)

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

  * There are so many great vim dotfiles in github repos.

  * [NeoBundle][] is a very good start if you are new to Vim.

  * If you like you can use [my dotvim][] which is based on the [NeoBundle][].

  * Use any [vim colorschemes][] if not the `default` scheme will be used.

    My personal favourite are [seoul256.vim][] and [Tomorrow-Theme][]

- Any valid file types that are supported by Vim will be shown proper color in the output.

  * By default Vim comes with supported for major languages so you should see the proper syntax with color in the output.

  * On newer language like [Elixir][], you may have to first install [vim-elixir][] to see the proper syntax in the output.
    If this is not installed then you will get the output but will not have the beautiful color syntax.

### Sample session

- Run with the sample fixture files

```sh
vim_printer print -b test/fixtures/inputs -e rb java -r
```

Will produce the file `output.tar.gz` with the following result on the screen.

```
FYI: process file 1 of 8 : test/fixtures/inputs/demo1.xxx.rb
FYI: process file 2 of 8 : test/fixtures/inputs/demo1.yyy.rb
FYI: process file 3 of 8 : test/fixtures/inputs/demo2.xxx.rb
FYI: process file 4 of 8 : test/fixtures/inputs/demo2.yyy.rb
FYI: process file 5 of 8 : test/fixtures/inputs/java/demo3.xxx.java
FYI: process file 6 of 8 : test/fixtures/inputs/java/demo3.yyy.java
FYI: process file 7 of 8 : test/fixtures/inputs/java/demo4.xxx.java
FYI: process file 8 of 8 : test/fixtures/inputs/java/demo4.yyy.java
Your output file is output.tar.gz
```

### Usage

- Install the gem for your version of ruby

e.g. for rbenv your session will be something like

```sh
rbenv local 2.1.1 # or whatever the version of you ruby
rbenv rehash
gem install vim_printer
```
- Print any files using the gem

```sh
vim_printer
```
- Print any files that you like using the simple command

The following command will print out all java, and ruby files recursively
using the `solarized` colorscheme.

```sh
vim_printer print --base-dir ./test/fixtures \
                  --exts rb \
                  --theme solarized
```

Your output will be saved to the default `output.tar.gz` in the directory where you run this command.
To see the output in your browser just type:

```sh
mkdir -p ~/Desktop/vim_printer
mv output.tar.gz ~/Desktop/vim_printer
cd ~/Desktop/vim_printer
tar zxvf output.tar.gz
```

- Print only files that contain the word `xxx` in the title

```sh
vim_printer print --base-dir ./test/fixtures \
                  --exts java \
                  --theme solarized \
                  --n xxx
```

- For help in using the gem just type `vim_printer` without any parameter
You should see something like the following:

```
Usage:
  vim_printer print [OPTIONS]

Options:
  -b, [--base-dir=BASE_DIR]                # Base directory
                                           # Default: . (current directory)
  -e, [--exts=one two three]               # List of extensions to search for
  -f, [--non-exts=one two three]           # List of extensions to search for
  -n, [--inc-words=one two three]          # List of words to be included in the result
  -x, [--exc-words=one two three]          # List of words to be excluded from the result
  -i, [--ignore-case], [--no-ignore-case]  # Match case insensitively
                                           # Default: true
  -r, [--recursive], [--no-recursive]      # Search for files recursively
                                           # Default: true
  -t, [--theme=THEME]                      # Vim colorscheme to use
                                           # Default: default
  -v, [--version], [--no-version]          # Display version information

Print the list of files
```

### Development/Testing

```sh
git clone https://github.com/agilecreativity/vim_printer.git
cd vim_printer
bundle
# run default test
rake
```
### Known Issues

- Will be listed here if any.

### Disclaimers

- This is still early release of the gem, I may make several changes to the API.
- If you find any issues please let me know.
- Pull request is always welcome.

### Changelog

#### 0.0.6

- Move the theme option to [vim_printer][]

- Use [agile_utils][] versino 0.0.8

- Make location of the 'index.html' to the current run directory

#### 0.0.5

- Use [agile_utils][] version 0.0.5 that have the option bug fix

#### 0.0.4

- Fix the output path of 'index.html' to root directory to make links valid.

- Update [agile_utils][] to '0.0.4'

- Code cleanup using rubocop

#### 0.0.3

- Use generic functions from [agile_utils][] gem

- Update [index_html][] gem to 0.0.7

- Fix the bug in generated 'index.html' due to bug from index_html gem

#### 0.0.2

- Add the 'index_html' gem to generate the 'index.html' to the output

- Fix the error in documentation (YARD syntax error)

#### 0.0.1

- Initial release

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
[agile_utils]: https://rubygems.org/gems/agile_utils
[index_html]: https://rubygems.org/gems/index_html
