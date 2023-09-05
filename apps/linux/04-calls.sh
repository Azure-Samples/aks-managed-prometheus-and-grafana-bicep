#!/bin/bash

# Variables
source 00-variables.sh

# Call REST API
echo "Calling REST API..."
curl https://echoserver.babosbird.com/ | jq -r 

# Simulate SQL injection
echo "Simulating SQL injection..."
curl -w 'HTTP Status: %{http_code}\n' -s -o /dev/null https://echoserver.babosbird.com/?users=ExampleSQLInjection%27%20--

# Simulate XSS
echo "Simulating XSS..."
curl -w 'HTTP Status: %{http_code}\n' -s -o /dev/null https://echoserver.babosbird.com/?users=ExampleXSS%3Cscript%3Ealert%28%27XSS%27%29%3C%2Fscript%3E

# Include forbidden word in the query string. The forbidden word "attack" is included in the query string and the security rule is defined in the config map of the NGINX ingress controller.
echo "Simulating query string manipulation with the 'attack' word in the query string..."
curl -w 'HTTP Status: %{http_code}\n' -s -o /dev/null https://echoserver.babosbird.com/?task=attack

# Simulate query string manipulation. The forbidden word "bingo" is included in the query string and the security rule is defined in the ingress object.
echo "Simulating query string manipulation with the 'bingo' word in the query string..."
curl -w 'HTTP Status: %{http_code}\n' -s -o /dev/null https://echoserver.babosbird.com/?bingo

# Simulate header manipulation. The forbidden word "bingo" is included in a custom header and the security rule is defined in the ingress object.
echo "Simulating header manipulation with the 'bingo' word in a custom header..."
curl -w 'HTTP Status: %{http_code}\n' -s -o /dev/null -H "custom: bingo" https://echoserver.babosbird.com/