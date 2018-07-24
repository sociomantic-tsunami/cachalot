### Internal `cachalot` user ID changed to 2000

It used to be 1000 (default) but that causes some inconvenience if derived
images want to create own user with ID that matchees host one. It shouldn't
affect any cases where `cachalot` was used so far (non-root testing in CI) but
anyone using it locally will noticed that generated files will be owned by
non-existent (on host) user with ID 2000 when mounting host folders.
