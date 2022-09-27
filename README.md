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

## Build tips
Docker caches every step in the Dockerfile, sometimes is
useful to reset the cache at one particualar step. Adding
the following in the previous line does the trick:
```
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
```


# TODO

* User right management. Seems to have problems with root and the gitpod user

* ssh management.
    We need a way to manage ssh keys (used for example for github validation
    for example)
    We cannot burn them into the image, so we need a way to
    pass them from the host system. Having a fromt end with
    an account system would allow to just log in and share
    between devices.

     I think this could be useful:
    - https://stackoverflow.com/questions/22907231/how-to-copy-files-from-host-to-docker-container

    ** This can be solved using the following command to
    mound the local ssh keys in the repo:
    ```
    docker run -it --rm -v C:\Users\blasc\.ssh\:/home/dev/.ssh -v C:\Users\blasc\Projects\:/workspace -h "dev-env" --privileged -p 8083:8083 -p 6080:6080 blascoburguillos/dev-env:arch-base-22.9.17
    ```
    For it to work, git repos need to use the ssh version.
    We need to look into the credential manager (I think
    this is what gitpod is using) for https repos to work

* port forwarding system.
    We need a way to open ports while the dev env is
    working. We could use something in the line of
    localtunnel or pagekite. I think gitpod uses something
    like this to open and close ports.

* gitpod uses tigerVNC. We should consider using this, seems
to offer better performance
https://tigervnc.org/

# Resources

* Nice setup, they use tigerVNC and noVNC:
https://github.com/DCsunset/docker-i3-arch-vnc

* Gitpod images:
https://github.com/gitpod-io/workspace-images/blob/main/base/Dockerfile

* VNC are by concept inneficient. We should explore other
desktop sharing solutions:
 - nomachine
 - Remmina
