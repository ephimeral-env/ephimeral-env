# ephimeral-env

The goal of this project is to develop an easy way to manage
what we call ephimeral development environments. The idea
behind is that these environments require no setup, they are
easy to create and dispose. 

The host system can be kept vanilla, so that all the
customization and personalization efforts are expressed
through the ephimeral dev env, so they become
persistent across systems and resistent to system failures.

# Goals

* Graphic applications.
* Fast loading and response.
* Interoperability between host and dev-env. The code stays
local in the host system.
* No configuration.
* Off-line availability.

# TODO

* ssh management. I think this could be useful:
    - https://stackoverflow.com/questions/22907231/how-to-copy-files-from-host-to-docker-container
