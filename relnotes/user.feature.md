## Internal `cachalot` user

As part of base image generation, a user named `cachalot` is now created. It is
intended to be used to run tests without accidental `root` access which may
affect the result.

This user is added to `sudoers` with a permission to run any `sudo` command
without a password.

Previously the host user ID was always used to run tests, which had the benefit
of generated file artifacts having meaningful ownership if they are written into
mounted folder from the host system. However, such user can't possibly have
`sudo` access.
