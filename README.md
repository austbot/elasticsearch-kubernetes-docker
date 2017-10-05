# elasticsearch-kubernetes-docker
Docker image based `cyberluisda/elasticsearch-kubernetes` (`master` branch of
this project). `master` if based on https://github.com/pires/docker-elasticsearch-kubernetes with some customizations

# Plugins added #

`x-pack` plugin is the only one added, (**FIXME**) but Machine Learning is
deactivated because it is not compliant with alphine linux (base image). See
[discussion](https://discuss.elastic.co/t/elasticsearch-failing-to-start-due-to-x-pack/85125/7)
for more information.

# Dynamic configuration #

Dynamic configuration can be added using environment vars, see `README.md` on
master branch.
