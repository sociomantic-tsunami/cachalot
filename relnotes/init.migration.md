### Use init system as runtimebase ENTRYPOINT

Now `runtimebase` image overrides `ENTRYPOINT` to use [dumb-init](https://github.com/Yelp/dumb-init)
as an init system. In practice that means that all images that use `runtimebase`
as a base in their `Dockefile` must specify command to start their application
using `CMD` directive and must not change `ENTRYPOINT`.

Benefit is that dumb-init will manage signal handling and zombie processes in
a similar way to regular Linux init system, allowing most applications to work
as-is inside the container.
