# Contributing

First of all, **thank you** for contributing, **you are awesome**!

Here are few rules to follow for a easier code review before the maintainers accept and merge your request.

##### Rules development

- Run the build.
- Update `README.md`.
- Update `Changelog.md`.
- Write [commit messages that make sense](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)

##### Rules Pull Request

- [Rebase your branch](http://git-scm.com/book/en/Git-Branching-Rebasing) before submitting your Pull Request.
- [Squash your commits] to "clean" your pull request before merging (http://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html).
- Write and good description which gives the context and/or explains why you are creating it.
- Travis CI build must pass to merge pull request

**Thank you!**

### Create a release

- Update file `VERSION`.
- Replace old X.X.X by new X.X.X in `README.md`.
- Replace `**latest**` by new version `**X.X.X**` in `Changelog.md`.

### Help to your development

- Build image : `make build`
- Start container : `make start`
- Show logs : `make logs`
- Enter in container : `make bash`
- Stop container : `make stop`
- Remove container : `make remove`
- Clean container data : `make clean`
