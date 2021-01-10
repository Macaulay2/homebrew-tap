# Macaulay2 Tap

This is an unofficial repository for Macaulay2 and its dependencies.

## How do I install Homebrew?
See [brew.sh](https://brew.sh).

## How do I install these formulae?
To add this Homebrew tap and install Macaulay2 from a bottle, run:
```
brew tap mahrud/tap
brew install M2
```

Alternatively, to install M2 directly, run:
```
brew install mahrud/tap/M2
```

## Can I modify the options?
Yes, though the only bottled version is built with the default set of options.
To see a list of options, run:
```
brew info M2
```

## Documentation
`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## Contributing
Pull requests for improvements, bug fixes, or new formulae are welcome!
In particular, help is needed for adding better testing to the existing formulae
and moving them to the [homebrew/core](https://github.com/Homebrew/homebrew-core).

The formula from which the Macaulay2 bottle on this tap is built uses the
[CMake build system](https://github.com/Macaulay2/M2/blob/master/M2/INSTALL-CMake.md).

Before submitting a pull request, make sure that it satisfies Homebrew's syntax guidelines
with `brew syntax mahrud/tap` and that the changed formula can be bottled by running:
```
brew install --verbose --build-bottle mahrud/tap/<formula>
```

## Bug Reports
For issues concerning Macaulay2 itself, file an issue on the
[upstream repository](https://github.com/Macaulay2/M2/issues).
If the problem is specific to this build, please include the output of `brew config` in the issue.
