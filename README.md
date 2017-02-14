#   SNMP exporter config generator
The config generator uses NetSNMP to parse MIBs, and generates configs for the Prometheus snmp_exporter using them.
This is a docker container built to facilitate the config generation, it is built from scratch starting from Alpine Linux and SNMP exporter config generator source code [SNMP exporter config generator](https://github.com/prometheus/snmp_exporter/tree/master/generator). 

## Requirements
- docker
- your device MIBs

## How to run it
For demo purposes I've added the A10 AX load balancer mibs to this repo.
- Clone this repo
- Run the aabbate/secg container mounting the MIBs directory and the empty `snmp.yml` file 
```
$  docker run -it -v "$PWD/a10mibs:/root/.snmp/mibs" -v "$PWD/snmp.yml:/snmp_exporter/generator/snmp.yml" aabbate/secg
```
- Once completed, you will find the generated configuration on the `snmp.yml` file 

## To generate your custom configuration:
- Execute a snmpwalk on your device in order to get the right OIDs
- Clone this repo
- Edit the `generator.yml` adding your OIDs
- Run the aabbate/secg container mounting:
    * your MIBs directory to `/root/.snmp/mibs`
    * the empty `snmp.yml` to `/snmp_exporter/generator/snmp.yml`
    * your custom `generator.yml` file to `/snmp_exporter/generator/generator.yml`
- Get the configuration from the updated `snmp.yml` file
