<div align="center">

# asdf-mimirtool [![Build](https://github.com/czchen/asdf-mimirtool/actions/workflows/build.yml/badge.svg)](https://github.com/czchen/asdf-mimirtool/actions/workflows/build.yml) [![Lint](https://github.com/czchen/asdf-mimirtool/actions/workflows/lint.yml/badge.svg)](https://github.com/czchen/asdf-mimirtool/actions/workflows/lint.yml)

[mimirtool](https://grafana.com/docs/mimir/latest/manage/tools/mimirtool/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add mimirtool
# or
asdf plugin add mimirtool https://github.com/czchen/asdf-mimirtool.git
```

mimirtool:

```shell
# Show all installable versions
asdf list-all mimirtool

# Install specific version
asdf install mimirtool latest

# Set a version globally (on your ~/.tool-versions file)
asdf global mimirtool latest

# Now mimirtool commands are available
mimirtool version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/czchen/asdf-mimirtool/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [czchen](https://github.com/czchen/)
