## `dependabot-conan`

[Conan](https://conan.io/) support for [`dependabot-core`][core-repo].

### Limitations

A conanfile by itself is not sufficient to completely describe a
conan dependency graph. One or more [profiles](https://docs.conan.io/2/reference/config_files/profiles.html)
are also necessary, however there is no provision in dependabot to provide profile information
to the package manager.

Without the profile information, we can either

* Use a default profile to generate the dependency graph
* Use a [Lockfile](https://docs.conan.io/2/tutorial/versioning/lockfiles.html#)

Only repositories using [Lockfiles](https://docs.conan.io/2/tutorial/versioning/lockfiles.html#)
are currently supported. Repositories must contain a lockfile with the default name `conan.lock`,
and either a `conanfile.txt` or `conanfile.py` file.


### Running locally

1. Start a development shell

  ```
  $ bin/docker-dev-shell conan
  ```

2. Run tests
  ```
  [dependabot-core-dev] ~ $ cd conan && rspec
  ```

[core-repo]: https://github.com/dependabot/dependabot-core

### Implementation Status

This ecosystem is currently under development. See [NEW_ECOSYSTEMS.md](../NEW_ECOSYSTEMS.md) for implementation guidelines.

#### Required Classes
- [x] FileFetcher
- [ ] FileParser
- [ ] UpdateChecker
- [ ] FileUpdater

#### Optional Classes
- [ ] MetadataFinder
- [ ] Version
- [ ] Requirement

#### Supporting Infrastructure
- [ ] Comprehensive unit tests
- [ ] CI/CD integration
- [ ] Documentation
