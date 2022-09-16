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

# Requirments

Docker and a web browser are the only requirements for our
host system.

# Usage

```
docker run -it --rm -v C:\Users\blasc\projects\you-art\:/workspace -h "dev-env-youart" --privileged -p 8083:8083 -p 6080:6080 blascoburguillos/dev-env:arch-22.9.14
```

# Instruction for building Docker images and publish them
We just need to navigate to the folder containing the
Dockerfile and run the following command:
```
docker build -t blascoburguillos/dev-env:os-name-base-yy.mm.dd
```

After the image has been built, we can push it with:
```
docker push blascoburguillos/dev-env:os-name-base-yy.mm.dd
```




# TODO

* ssh management.
    We need a way to manage ssh keys (used for example for github validation
    for example)
    We cannot burn them into the image, so we need a way to
    pass them from the host system. Having a fromt end with
    an account system would allow to just log in and share
    between devices.

     I think this could be useful:
    - https://stackoverflow.com/questions/22907231/how-to-copy-files-from-host-to-docker-container
