<div align="center">
  <img src=".github/assets/logo.png" height="128">
  <h1>
      openpilot-alpine
  </h1>
  <h4>OpenPilot for Alpine Docker</h4>
</div>

<p align="center">
    <a href='https://github.com/achillesrasquinha/openpilot-alpine//actions?query=workflow:"Continuous Integration"'>
      <img src="https://img.shields.io/github/workflow/status/achillesrasquinha/openpilot-alpine/Continuous Integration?style=flat-square">
    </a>
    <a href="https://coveralls.io/github/achillesrasquinha/openpilot-alpine">
      <img src="https://img.shields.io/coveralls/github/achillesrasquinha/openpilot-alpine.svg?style=flat-square">
    </a>
    <a href="https://pypi.org/project/openpilot-alpine/">
      <img src="https://img.shields.io/pypi/v/openpilot-alpine.svg?style=flat-square">
    </a>
    <a href="https://pypi.org/project/openpilot-alpine/">
      <img src="https://img.shields.io/pypi/l/openpilot-alpine.svg?style=flat-square">
    </a>
    <a href="https://pypi.org/project/openpilot-alpine/">
		  <img src="https://img.shields.io/pypi/pyversions/openpilot-alpine.svg?style=flat-square">
	  </a>
    <a href="https://git.io/boilpy">
      <img src="https://img.shields.io/badge/made%20with-boilpy-red.svg?style=flat-square">
    </a>
</p>

### Table of Contents
* [Features](#features)
* [Quick Start](#quick-start)
* [Usage](#usage)
* [License](#license)

### Features
* Python 2.7+ and Python 3.4+ compatible.

### Quick Start

```shell
$ pip install openpilot-alpine
```

Check out [installation](docs/source/installation.md) for more details.

### Usage

#### Application Interface

```python
>>> import openpilot_alpine
```


#### Command-Line Interface

```console
$ openpilot-alpine
Usage: openpilot-alpine [OPTIONS] COMMAND [ARGS]...

  OpenPilot for Alpine Docker

Options:
  --version   Show the version and exit.
  -h, --help  Show this message and exit.

Commands:
  help     Show this message and exit.
  version  Show version and exit.
```


### License

This repository has been released under the [MIT License](LICENSE).

---

<div align="center">
  Made with ❤️ using <a href="https://git.io/boilpy">boilpy</a>.
</div>