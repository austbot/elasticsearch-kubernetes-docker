# elasticsearch-kubernetes-docker
Docker image based `cyberluisda/elasticsearch-kubernetes` (`master` branch of
this project). `master` if based on https://github.com/pires/docker-elasticsearch-kubernetes with some customizations

# Plugins added #

`x-pack` plugin is the only one added, (**FIXME**) but Machine Learning is
deactivated because it is not compliant with alphine linux (base image). See
[discussion](https://discuss.elastic.co/t/elasticsearch-failing-to-start-due-to-x-pack/85125/7)
for more information.

## x-pack extensions ##

In addition new functionality to create certs based on CA key and certifciate
is implemented.

To run this certificates creation you need to define next environment variables:

* `CREATECERTS_SELF_SIGNED_CAKEY_FILE`. Path on docker of CA PEM File (i.e `ca.key`).
  Usually paths with certificate is mounted on docker.

* `CREATECERTS_SELF_SIGNED_CACERT_FILE`. Path on docker of CA CERT File (i.e `ca.crt`).
  Usually paths with certificate is mounted on docker.

* `CREATECERTS_SELF_SIGNED_DNS_CSV`. String in CSV format (separator = `,`) with
  DNSs to add to certificates resultings.

Certificates created will be saved in `$ES_HOME/config/certificates-created` path.
And names will be `${HOSTNAME}.key` and `${HOSTNAME}.crt`, for PEM and certificate
files respectively.

# Dynamic configuration #

Dynamic configuration can be added using environment vars, see `README.md` on
master branch.
