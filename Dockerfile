FROM cyberluisda/elasticsearch-kubernetes-base:5.6.0
MAINTAINER Luis David Barrios (cyberluisda@gmail.com)

#ADDING default ES_HOME
ENV ES_HOME /elasticsearch
# Install plugins (NODE_NAME is mandatory by default use uuidgen)
RUN yes | \
  NODE_NAME="${NODE_NAME:-$(uuidgen)}" \
  bin/elasticsearch-plugin install --batch x-pack

# Upload files
RUN mkdir -p ${ES_HOME}/thirdparty
ADD files/* ${ES_HOME}/thirdparty/
RUN chmod a+x ${ES_HOME}/thirdparty/pre-configure.sh

# Active pre-configure.sh patching file
RUN patch -i ${ES_HOME}/thirdparty/active-pre-configure.patch /run.sh

# ES Machine learning (X-pack) can not run in alphine linux (base image)
# Removing ML based on https://discuss.elastic.co/t/elasticsearch-failing-to-start-due-to-x-pack/85125/7
RUN rm -fr ${ES_HOME}/plugins/x-pack/platform/linux-x86_64
# Deactivaing ML from elasticsearch config (using pre-configure functionality)
ENV ES_ELASTIC_CONFIG_DEACTIVATE_ML "xpack.ml.enabled: false"
