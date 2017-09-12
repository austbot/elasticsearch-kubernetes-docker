# elasticsearch-kubernetes-docker
Docker image based on https://github.com/pires/docker-elasticsearch-kubernetes with some plugins and customizations

# Plugins added #

`x-pack` plugin is the only one added, but Machine Learning is deactivated because
it is not compliant with alphine linux (base image). See
[discussion](https://discuss.elastic.co/t/elasticsearch-failing-to-start-due-to-x-pack/85125/7)
for more information.

# Dynamic configuration #

Dynamic configuration can be added using environment vars to `/elasticsearch/config/elasticsearch.yml`.

To add configuration (at end) you can define environment vars which name starts with
`ES_ELASTIC_CONFIG` and the value will be added at end of the configuration file
(`elasticsearch.yml`). One variable per line is desired.

For example to add `xpack.ml.enabled: false` to `elasticsearch.yml` config file you
can define `ES_ELASTIC_CONFIG_DEACTIVATE_ML` with `xpack.ml.enabled: false` value.

`_DEACTIVATE_ML` is ignored and can be used for clarification when define each
dynamic value.