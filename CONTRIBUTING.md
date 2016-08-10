# Contributing

First of all, **thank you** for contributing, **you are awesome**!

Here are few rules to follow for a easier code review before the maintainers accept and merge your request.

----

### Development

- Make your changes
- Test build docker image
- Update `README.md`
- Update `Changelog.md` (Write changes under section `**latest**`)
- Write [commit messages that make sense](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)

### Pull Request

- [Rebase your branch](http://git-scm.com/book/en/Git-Branching-Rebasing) before submitting your Pull Request.
- [Squash your commits] to "clean" your pull request before merging (http://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html).
- Write and good description which gives the context and/or explains why you are creating it.
- Travis CI build must pass to merge pull request

### Create a release

- Update file `VERSION`.
- Replace old version `O.O.O` by new version `N.N.N` in `README.md`.
- Replace `**latest**` by new version `**N.N.N**` in `Changelog.md`.
- Create a empty section `**latest**` at the top of `Changelog.md`.
- Commit message must be **Release N.N.N**

### Help to your development

- Build image : `make build`
- Start container : `make start`
- Show logs : `make logs`
- Enter in container : `make bash`
- Stop container : `make stop`
- Remove container : `make remove`
- Clean container data : `make clean`
