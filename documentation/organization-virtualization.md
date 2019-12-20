# HyperLedger Organization virtualization strategies
This document describes different virtualization strategies which can be applied to HyperLedger organizations.

## Single organization, single network, single Kube
This strategy was designed for enterprise startups willing to speed-up their BlockChain development.
Key concepts are:

- The project has only one HyperLedger organization for simplicity of software development.
- One organization has only one HyperLedger network which is similar to the HyperLedger Simple Network Example. 
This greatly reduces the entry level for project developers.
- This single HyperLedger Network is virtualized either using Docker Compose or using the Minikube or using a simple Kubernetes cluster. 
This is a purely DevOps task, the software developer can use a Docker Compose approach on a local machine to simplify everything.

There are the following outcomes of this approach:
- Each organization has one administrator. Everything is managed using his login/password or certificates acquired after enrollment.
- Each organization can have child users attached to the administrator. This provides more granulated roles with reduced privileges if necessary.
- For projects handling multiple organizations - we need to process a collection of Kubes (and networks within each Kube) at each level of software.
