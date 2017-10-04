# elasticsearch-kubernetes-docker
Docker image based on https://github.com/pires/docker-elasticsearch-kubernetes with some plugins and customizations

# Plugins added #

`x-pack` plugin is the only one added, but Machine Learning is deactivated because
it is not compliant with alphine linux (base image). See
[discussion](https://discuss.elastic.co/t/elasticsearch-failing-to-start-due-to-x-pack/85125/7)
for more information.

# Dynamic configuration #

Dynamic configuration can be added using environment vars to `/elasticsearch/config/elasticsearch.yml`.

To remove configuration (remove lines based on sed regesp) you can define
environment vars which name starts with `ES_ELASTIC_DELETE_CONFIG` and the
value is the regexp to be applied with `sed -re "/_VALUE_/d"`, where `_VALUE_` is
the value of environment var.

For example to delete `data` from next configuration:

```yaml
path:
  data: /data/data
  logs: /data/log
```

you can define `ES_ELASTIC_DELETE_CONFIG_ORIGINAL_DATA="data: \/data\/data$"`

`_ORIGINAL_DATA` is ignored and can be used for clarification when define each
dynamic value.

To add configuration (at end) you can define environment vars which name starts with
`ES_ELASTIC_CONFIG` and the value will be added at end of the configuration file
(`elasticsearch.yml`). One variable per line is desired.

For example to add `xpack.ml.enabled: false` to `elasticsearch.yml` config file you
can define `ES_ELASTIC_CONFIG_DEACTIVATE_ML` with `xpack.ml.enabled: false` value.

`_DEACTIVATE_ML` is ignored and can be used for clarification when define each
dynamic value.

In same way when environment var contains `$(...)` substrings, some values of
data will be resolved in-place (using `bash -c echo"...`).

For example if you define
`ES_ELASTIC_CONFIG_SET_NODENAME="node: $(echo ${HOSTNAME}-)$(echo $RANDOM)"`, then
`node: HOSTNAME-RANDOM_NUBMER` property will be added to `elasticsearch.yml`
( `HOSTNAME` will be replaced with host name on container and `RANDOM_NUMBER` will
be replaced by numeric random value, i.e `node: 4720009b01ba-21683`).
