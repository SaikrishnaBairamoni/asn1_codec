#!/bin/bash
#  Copyright (C) 2018-2020 LEIDOS.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); you may not
#  use this file except in compliance with the License. You may obtain a copy of
#  the License at
# 
#  http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#  License for the specific language governing permissions and limitations under
#  the License.

# script executes all kafka_clients and scheduling service build and coverage steps so that they can be singularly
# wrapped by the sonarcloud build-wrapper
set -e

ls -la && pwd
# Build acm.
mkdir -p /build && cd /build && cmake /__w/asn1_codec/asn1_codec/ && make

# Add test data. This changes frequently so keep it low in the file.
mv ./docker-test /__w/asn1_codec/asn1_codec/docker-test
# run ACM
chmod 7777 /asn1_codec/run_acm.sh
./asn1_codec/run_acm.sh
test --output-on-failure