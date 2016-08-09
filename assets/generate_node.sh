#!/bin/sh
#
# Assumes /input/ has ca.pem and ca-key.pem

mkdir -p /output/kubernetes/ssl
# Checking to see if we need to do anything
if [[ -f /output/kubernetes/ssl/apiserver.pem && -f /output/kubernetes/ssl/apiserver-key.pem && -f /output/kubernetes/ssl/ca.pem ]]; then
  echo "Certificates are in order, leaving"
  exit
fi

# Variables are:
# SERVICE_DNS_NAME - defaults to localhost
# SERVICE_IP - defaults to 127.0.0.1
# HOST_IP - defaults to 127.0.0.1

if [ -z "$SERVICE_DNS_NAME" ]; then
  export SERVICE_DNS_NAME=localhost 
  echo "Did not find Service DNS Name - defaulting to ${SERVICE_DNS_NAME}";
else
  echo "Found Service DNS Name - ${SERVICE_DNS_NAME}";
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

cp /input/ca.pem /output/kubernetes/ssl/ca.pem
openssl genrsa -out /output/kubernetes/ssl/apiserver-key.pem 2048
openssl req -new -key /output/kubernetes/ssl/apiserver-key.pem -out /output/kubernetes/ssl/apiserver.csr -subj "/CN=kube-apiserver" -config /assets/apiserver.conf
openssl x509 -req -in /output/kubernetes/ssl/apiserver.csr -CA /output/kubernetes/ssl/ca.pem -CAkey /input/ca-key.pem -CAcreateserial -out /output/kubernetes/ssl/apiserver.pem -days 3650 -extensions v3_req -extfile /assets/apiserver.conf



