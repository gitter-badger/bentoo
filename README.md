# Welcome to the Bentoo!
=================================================================================================

_Packages done right™_

[![Build Status][ci-master-badge]][ci-master]

Mirrors
------------------

The overlay is hosted on BitBucket and on Github at:

- https://bitbucket.org/redeyeteam/bentoo
- https://github.com/redeyeteam/bentoo

Quality Assurance
------------------

You should be able to use any package from my overlay without regrets, because I do and I have quite high standards.
To achieve this goal I'm using several safety guards:

- my brain of course
- _[Travis CI](https://travis-ci.org/)_, which runs:
    - _[repoman](https://wiki.gentoo.org/wiki/Repoman)_ checks
    - _[shellcheck](https://www.shellcheck.net/)_ checks
    - custom checks
- all points of _GitHub_'s feature called _[protected branches]_, which means that all merges to _master_ must pass CI tests

This all, of course, doesn't prevent build failures, missing dependencies, etc. So, should you find
some issues, please send me a PR (if you know how to fix it), or at least [file an issue][New issue].

How to install this overlay
----------------------------

### Manually (recommended)

#### 1. Add an entry to [`/etc/portage/repos.conf`](https://wiki.gentoo.org/wiki//etc/portage/repos.conf):

```ini
[bentoo]
## set this to any location you want
location = /var/cache/portage/repos/bentoo
## github-mirror
sync-uri =  https://github.com/redeyeteam/bentoo.git
## otherwise use the one and only original source
#sync-uri = https://bitbucket.org/redeyeteam/bentoo.git
sync-type = git
auto-sync = yes
## prefer my packages over the Gentoo™ ones to improve UX and stability (recommended by 9/10 IT experts)
#priority = 9999
```

#### 2. Sync

```sh
# Preferrably
eix-sync
# or if you need to
emerge --sync
```

---

[protected branches]: https://help.github.com/articles/about-protected-branches/
[ci-master-badge]: https://travis-ci.org/redeyeteam/bentoo.svg?branch=master
[ci-master]: https://travis-ci.org/redeyeteam/bentoo
