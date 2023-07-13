# AlmaLinux 8 Docker Container for Ansible Testing

This is a Docker test container for Ansible testing on AlmaLinux 8. Based on [docker-almalinux8-ansible](https://github.com/glillico/docker-almalinux8-ansible) from gillico. 

## Tags

  - `latest` - Latest stable release of AlmaLinux 8.8, Ansible 2.15.1, Ansible 6.17.2, Python 3.9.16

## Build

To build this docker container you can do the following.

  - Install Docker Engine, see [here](https://docs.docker.com/engine/install/) for details.
  - Clone this repository.
    - `$ git clone https://github.com/nodespacehosting/docker-almalinux8-ansible.git`
  - Change to the repositories directory.
    - `$ cd docker-almalinux8-ansible`
  - Run the command
    - `$ docker build -t almalinux8-ansible .`

## Usage

This container is intended to be used for automated Ansible linting and syntax checking using CI/CD pipelines. It is not intended to be used as a general purpose container, although it can be used for that purpose if you so desire.

An example of how to use this container using GitLab CI/CD is shown below.

```yaml
---
image: nodespace/docker-almalinux8-ansible

before_script:
  - dnf update -y
  - git submodule update --init
  - pip3 install --upgrade pip
  - pip3 install --upgrade ansible-lint
  - ansible --version
  - ansible-lint --version

stages:
  - ansible-lint
  - ansible-syntax-check

ansible-lint:
  stage: ansible-lint
  script:
    - ansible-lint *.yml

ansible-syntax-check:
  stage: ansible-syntax-check
  script:
    - ansible-playbook --inventory inventory --syntax-check *.yml
```

Keep in mind that this is just an example and you will need to modify it to suit your needs.

## License

Licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

Copyright © 2023 [NodeSpace Technologies, LLC](https://www.nodespace.com)