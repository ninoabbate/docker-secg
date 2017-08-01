#   SNMP exporter config generator
The config generator uses NetSNMP to parse MIBs, and generates configs for the Prometheus snmp_exporter using them.
This is a docker container built to facilitate the config generation, it is built from scratch starting from Alpine Linux and SNMP exporter config generator source code [SNMP exporter config generator](https://github.com/prometheus/snmp_exporter/tree/master/generator). 

## Requirements
- docker
- your device MIBs

## How to run it
For demo purposes I've added the Palo Alto firewall mibs to this repo.
- Clone this repo
- Run the [aabbate/secg](https://hub.docker.com/r/aabbate/secg/) container mounting the MIBs directory, the generator.yml file and the empty `snmp.yml` file 
```
$  docker run --rm -v "$PWD/mibs:/root/.snmp/mibs" \
	-v "$PWD/generator.yml:/root/go/src/github.com/prometheus/snmp_exporter/generator/generator.yml" \
	-v "$PWD/snmp.yml:/root/go/src/github.com/prometheus/snmp_exporter/generator/snmp.yml" aabbate/secg
```
- Once completed, you will find the generated configuration on the `snmp.yml` file, which can be used on your SNMP-exporter installation.

## Volumes mounts
In order to generate the configuration you need to set the following mounts:
- the MIBS volume: where you will put your mibs
    * bind your directory with `/root/.snmp/mibs`
- the generator.yml file: where the generator will get the OIDs to walk
    * bind your file with `/root/go/src/github.com/prometheus/snmp_exporter/generator/generator.yml`
- the snmp.yml file: where you will find the generated configuration for SNMP-exporter
    * bind your file with `/root/go/src/github.com/prometheus/snmp_exporter/generator/snmp.yml`

## Container tags
The [aabbate/secg](https://hub.docker.com/r/aabbate/secg/) container follows the snmp_exporter tag/release naming convention.
The tag `latest` is the latest tag version released on snmp_exporter repository.

## To generate your custom configuration:
- Execute a snmpwalk on your device in order to get the right OIDs
- Clone this repo
- Edit the `generator.yml` adding your OIDs
- Copy your MIBs files on mibs directory
- Run the aabbate/secg container mounting:
    * the mibs directory to `/root/.snmp/mibs`
    * the empty `snmp.yml` to `/root/go/src/github.com/prometheus/snmp_exporter/generator/snmp.yml`
    * your custom `generator.yml` file to `/root/go/src/github.com/prometheus/snmp_exporter/generator/generator.yml`
- Get the configuration from the updated `snmp.yml` file.
