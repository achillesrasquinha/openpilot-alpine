.. _install:

### Installation

#### Installation via pip

The recommended way to install **openpilot-alpine** is via `pip`.

```shell
$ pip install openpilot-alpine
```

For instructions on installing python and pip see “The Hitchhiker’s Guide to Python” 
[Installation Guides](https://docs.python-guide.org/starting/installation/).

#### Building from source

`openpilot-alpine` is actively developed on [https://github.com](https://github.com/achillesrasquinha/openpilot-alpine)
and is always avaliable.

You can clone the base repository with git as follows:

```shell
$ git clone https://github.com/achillesrasquinha/openpilot-alpine
```

Optionally, you could download the tarball or zipball as follows:

##### For Linux Users

```shell
$ curl -OL https://github.com/achillesrasquinha/tarball/openpilot-alpine
```

##### For Windows Users

```shell
$ curl -OL https://github.com/achillesrasquinha/zipball/openpilot-alpine
```

Install necessary dependencies

```shell
$ cd openpilot-alpine
$ pip install -r requirements.txt
```

Then, go ahead and install openpilot-alpine in your site-packages as follows:

```shell
$ python setup.py install
```

Check to see if you’ve installed openpilot-alpine correctly.

```shell
$ openpilot-alpine --help
```