### Changelog

#### 0.1.11

- Use lastest version of `code_lister` (0.1.4)

#### 0.1.10

- Rename `--shell-command` to `--command` [Improvement]
- Move the logic to `code_lister` gem

#### 0.1.9

- Add advance `--shell_command` option to get the input file list from the the shell command [New]

#### 0.1.8

- Add `configuration.rb` for easy customization of options to `:TOhtml` [New]
- Update default usage in `cli.rb` and `README.md` [Improvement]
- Suppress line number in the result by default [Improvement]

#### 0.1.7

- Handle the edge case for File.binary?

#### 0.1.6

- Update rubocop to 0.23.x
- Minor code cleanup

#### 0.1.5

- Add option '--index' to make it possible to skip the cration of 'index.html'
- Make the final output filename 'vim_printer_<base_dir>.tar.gz'

#### 0.1.4

- Skip binary input files when applicable

#### 0.1.3

- Simplify the CLI interface
- Cleanup style with rubocop

#### 0.1.2

- Minor code cleanup

#### 0.1.1

- First [Semantic Versioning][] release

#### 0.1.0

- Make the output work properly when `--base-dir` options is relative path
- Update code cleanup

#### 0.0.9

- Update to latest gems

#### 0.0.8

- Update gemspec
- Update dependency to the latest version
- Make the `--base-dir .` the default behavior (make output better)
- Add rubocop gem

#### 0.0.7

- Update dependency gems to the latest version
- Add Changelogs.md
- Add links to gemnasium and codeclimate

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

[agile_utils]: https://rubygems.org/gems/agile_utils
[index_html]: https://rubygems.org/gems/index_html
[vim_printer]: https://rubygems.org/gems/vim_printer
[Semantic Versioning]: http://semver.org
