#!/bin/bash
set -euo pipefail

WORKDIR="/shared/scion-certs"
AS_NUMBER=$1

echo "Waiting for certificate files for AS${AS_NUMBER} in ${WORKDIR}..."
# Wait until both cp-as certificate files and the TRC exist
while [ ! -f "${WORKDIR}/AS${AS_NUMBER}/cp-as.pem" ] || \
      [ ! -f "${WORKDIR}/AS${AS_NUMBER}/cp-as.key" ] || \
      [ ! -f "${WORKDIR}/ISD42-B1-S1.trc" ]; do
    sleep 1
done

echo "Certificate files found. Installing to local system..."

mkdir -p /etc/scion/crypto/as
mkdir -p /etc/scion/certs
mkdir -p /etc/scion/keys

cp "${WORKDIR}/AS${AS_NUMBER}/cp-as.pem" /etc/scion/crypto/as/
cp "${WORKDIR}/AS${AS_NUMBER}/cp-as.key" /etc/scion/crypto/as/
cp "${WORKDIR}/ISD42-B1-S1.trc" /etc/scion/certs/

head -c 16 /dev/urandom | base64 - > /etc/scion/keys/master0.key
head -c 16 /dev/urandom | base64 - > /etc/scion/keys/master1.key

chown -R scion:scion /etc/scion

echo "SCION certificates installed successfully"
