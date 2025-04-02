# Macaulay2 Tap

This is the Homebrew repository for Macaulay2 and its dependencies.

## How do I install Homebrew?
See [brew.sh](https://brew.sh).

## How do I install these formulae?
To add this Homebrew tap and install Macaulay2 from a bottle, run:
```
brew tap Macaulay2/tap
brew install M2
```

Alternatively, to install M2 directly, run:
```
brew install Macaulay2/tap/M2
```

## Can I modify the options?
Yes, though the only bottled version is built with the default set of options.
To see a list of options, run:
```
brew info M2
```

## Documentation
`brew help`, `man brew` or the [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook).

## Contributing
Pull requests for improvements, bug fixes, or new formulae are welcome!
In particular, help is needed for adding better testing to the existing formulae
and moving them to [homebrew/core](https://github.com/Homebrew/homebrew-core).

Before submitting a [pull request](https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request),
make sure that it satisfies Homebrew's style guidelines with
```
brew style Macaulay2/tap
```
and that the changed formula can be bottled by running:
```
brew install --verbose --build-bottle Macaulay2/tap/<formula>
```
You can use this [Docker environment](https://github.com/Macaulay2/M2/tree/master/M2/BUILD/docker/brew)
for testing the formulae in a controlled environment. Afterwards, you can audit the formula with:
```
brew audit Macaulay2/tap
```

When a pull request becomes green (all checks passed), then you can publish the built bottles.
To do so, label your PR as `pr-pull` and the workflow will be triggered. Do NOT merge the PR.

## Bottling
Pre-built Homebrew "bottles", which may be used instead of building from source,
are built using GitHub Actions for Linux and recent macOS systems.
See the [wiki](https://github.com/Macaulay2/homebrew-tap/wiki) for information
about bottling Macaulay2 and its dependencies for different architectures.

The formula from which the Macaulay2 bottle on this tap is built uses the
[CMake build system](https://github.com/Macaulay2/M2/wiki/Building-M2-from-source-using-CMake).

## Bug Reports
For issues concerning Macaulay2 itself, file an issue on the
[upstream repository](https://github.com/Macaulay2/M2/issues).
If the problem is specific to this build, please open an issue here and include the output of `brew config` and `brew doctor`. You can also try visiting the [wiki](https://github.com/Macaulay2/homebrew-tap/wiki) for debugging information and workarounds for common problems.
