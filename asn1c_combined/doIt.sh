#!/bin/bash

# asn1c -Wdebug-compiler -fcompound-names -gen-PER -pdu=all 1609dot2-base-types.asn 1609dot2-schema.asn J2735_201603DA.ASN 2>&1 | tee compile.out
#asn1c -fcompound-names -gen-PER -gen-OER -pdu=all *.asn 2>&1 | tee compile.out
asn1c -fcompound-names -gen-PER -gen-OER -pdu=all \
../scms-asn/1609dot2-asn/1609dot2-schema.asn \
../scms-asn/1609dot2-asn/1609dot2-base-types.asn \
J2735_201603DA.ASN SEMI_v2.3.0_070616.asn 2>&1 | tee compile.out

sed -i 's/\(-DASN_PDU_COLLECTION\)/-DPDU=MessageFrame \1/' Makefile.am.example

make -f Makefile.am.example
