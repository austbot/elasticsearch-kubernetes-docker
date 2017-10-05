FROM cyberluisda/elasticsearch-kubernetes:5.6.0
MAINTAINER Luis David Barrios (cyberluisda@gmail.com)

#ADDING default ES_HOME
ENV ES_HOME /elasticsearch
# Install plugins (NODE_NAME is mandatory by default use uuidgen)
RUN yes | \
  NODE_NAME="${NODE_NAME:-$(uuidgen)}" \
  bin/elasticsearch-plugin install --batch x-pack

# FIXME
# ES Machine learning (X-pack) can not run in alphine linux (base image)
# Removing ML based on https://discuss.elastic.co/t/elasticsearch-failing-to-start-due-to-x-pack/85125/7
RUN rm -fr ${ES_HOME}/plugins/x-pack/platform/linux-x86_64
# Deactivaing ML from elasticsearch config (using pre-configure functionality)
ENV ES_ELASTIC_CONFIG_DEACTIVATE_ML "xpack.ml.enabled: false"
