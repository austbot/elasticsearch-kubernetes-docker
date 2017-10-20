FROM cyberluisda/elasticsearch:5.6.2
###
##-- from upstream ()
###
# Override config, otherwise plug-in install will fail
ADD config /elasticsearch/config

# Set environment
ENV DISCOVERY_SERVICE elasticsearch-discovery

# Kubernetes requires swap is turned off, so memory lock is redundant
ENV MEMORY_LOCK false
###
##-- end from upstream
###

#ADDING default ES_HOME
ENV ES_HOME /elasticsearch
ENV ES_ELASTIC_CONFIG_DEACTIVATE_ML xpack.ml.enabled: false

# Upload files
RUN mkdir -p ${ES_HOME}/thirdparty
ADD files/* ${ES_HOME}/thirdparty/
RUN chmod a+x ${ES_HOME}/thirdparty/pre-configure.sh

# Add software base
RUN apt-get update && apt-get install patch && rm -fr /var/lib/apt/lists/*

# Active pre-configure.sh patching file
RUN patch -i ${ES_HOME}/thirdparty/active-pre-configure.patch /run.sh
