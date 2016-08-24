#!/bin/sh
#
# Assumes /input/ has ca.pem and ca-key.pem

mkdir -p /output/etcd/ssl

# Variables are:
# SERVICE_DNS_NAME - defaults to localhost
# HOST_DNS_NAME - defaults to localhost
# SERVICE_IP - defaults to 127.0.0.1
# HOST_IP - defaults to 127.0.0.1

if [ -z "$SERVICE_DNS_NAME" ]; then
  export SERVICE_DNS_NAME=localhost
  echo "Did not find Service DNS Name - defaulting to ${SERVICE_DNS_NAME}";
else
  echo "Found Service DNS Name - ${SERVICE_DNS_NAME}";
fi

if [ -z "$HOST_DNS_NAME" ]; then
  export HOST_DNS_NAME=localhost
  echo "Did not find Host DNS Name - defaulting to ${HOST_DNS_NAME}";
else
  echo "Found Host IP - ${HOST_DNS_NAME}";
fi

if [ -z "$SERVICE_IP" ]; then
  export SERVICE_IP=127.0.0.1
  echo "Did not find Service IP - defaulting to ${SERVICE_IP}";
else
  echo "Found Service IP - ${SERVICE_IP}";
fi

if [ -z "$HOST_IP" ]; then
  export HOST_IP=127.0.0.1
  echo "Did not find Host IP - defaulting to ${HOST_IP}";
else
  echo "Found Host IP - ${HOST_IP}";
fi

cp /input/ca.pem /output/etcd/ssl/ca.pem
openssl genrsa -out /output/etcd/ssl/server-key.pem 2048
openssl req -new -key /output/etcd/ssl/server-key.pem -out /output/etcd/ssl/server.csr -subj "/CN=kube-apiserver" -config /assets/etcd.conf
openssl x509 -req -in /output/etcd/ssl/server.csr -CA /output/etcd/ssl/ca.pem -CAkey /input/ca-key.pem -CAcreateserial -out /output/etcd/ssl/server.pem -days 3650 -extensions v3_req -extfile /assets/etcd.conf



