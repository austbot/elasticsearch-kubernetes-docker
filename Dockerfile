FROM cyberluisda/elasticsearch-kubernetes:5.6.0
MAINTAINER Luis David Barrios (cyberluisda@gmail.com)

#ADDING default ES_HOME
ENV ES_HOME /elasticsearch
# Install plugins (NODE_NAME is mandatory by default use uuidgen)
RUN yes | \
  NODE_NAME="${NODE_NAME:-$(uuidgen)}" \
  bin/elasticsearch-plugin install --batch x-pack
