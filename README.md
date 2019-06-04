# HyperLedger Fabric workspace
This project is a starting point for creating an empty HyperLedger network for further experiments or software development.

Note that this basic network is built from a network template which may not be exact as what you need.

## HyperLedger pre-requisites installation
TODO:

## Basic HyperLedger network configuration

To build cryptography keys and network definitions, run ``build.sh``.
To remove cryptography keys and network definitions, run ``clean.sh``.
To start the network, run ``start.sh``.
To stop it, run ``stop.sh``.
TO restart the network, run ``restart.sh``.

## Amazon EC2 instance requirements
The HyperLedger network requires quite a lot of memory and disk size.
We recommend having:
- at least 8GB of memory;
- at least 60GB of free disk space.

## License agreement

This project is based on https://github.com/hyperledger/fabric-samples.
The difference is a cleaned-up and reduced amount of code necessary to create a basic HyperLedger network.

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
