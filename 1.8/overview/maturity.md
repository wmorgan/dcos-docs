---
post_title: Feature Maturity Phases
nav_title: Feature Maturity
menu_order: 10
---

The purpose of the Feature Maturity Phases is for Mesosphere Product and Engineering organizations to jointly educate customers, partners, and Mesosphere field and support organizations about the maturity and quality of features.

- [Criteria](#criteria)
- [Phases](#phases)
- [Establishing Maturity](#establishing-maturity)
- [Communication](#communication)
- [Current DC/OS feature maturity](#current-maturity)

# <a name="criteria"></a>Criteria

## Completeness

**Functionality:** Completeness of the feature implementation.

**Interfaces:** Feature has an API with deprecation cycle, CLI, and UI.

**Documentation:** Feature has appropriate documentation. e.g., Admin Guide, Developer Guide, Release Notes.

## Quality

**Functional Test:** Feature is validated for correctness.

**System Test:** Feature is validated to meet scalability, reliability, and performance requirements through a combination of load, soak, stress, spike, fault, and configuration tests.

**Mesosphere Dogfooding:** Feature in-use in Mesosphere production environment.

## Support

Mesosphere Support offered for the feature. i.e., 8x5 or 24x7.

# <a name="phases"></a>Phases

## Experimental

### Completeness

* Feature may be incomplete
* API may be incomplete and is subject to change without warning or deprecation cycle
* User interfaces may be missing or incomplete
* Documentation may be missing or incomplete

### Quality

* Limited or no functional test
* Limited or no system test
* Limited or no Mesosphere dogfooding

### Support

* No technical support from Mesosphere

## Preview

### Completeness

* Feature is complete
* API may be incomplete and changes may not be subject to deprecation cycle
* User interfaces may be missing or incomplete
* Documentation may be incomplete

### Quality

* Robust functional test
* Limited or no system test
* Limited or no Mesosphere dogfooding

### Support

* No SLA governed support available

## Stable

### Completeness

* Feature is complete
* API is complete and changes are subject to deprecation cycle
* User Interfaces are complete
* Documentation is complete

### Quality

* Robust functional test
* Robust performance testing
* Robust fault testing
* Robust Mesosphere dogfooding

### Support

* SLA governed support available

# <a name="establishing-maturity"></a>Establishing Maturity

Product Management and Engineering Manager work together to determine feature maturity for a release.

# <a name="communication"></a>Communication

It is essential to clearly communicate Feature Maturity Phase for all features with customers, partners, and Mesosphere field and support organizations.

The feature maturity phases will be available on the Mesosphere and DC/OS web sites.

Feature maturity communication channels:

* Release Notes
* Universe
* Support Enablement
* Field Enablement

# <a name="current-maturity"></a>Current feature maturity

| Capabilities      	| Status 	|
|-------------------	|--------	|
| Built-in Marathon 	| Stable 	|
| Jobs                  | Preview   |
| ip/container via. VxLAN | Preview |
| Named VIPs | Preview |
| Network Isolation | Experimental |
| Binary CLI | Stable |
| Download CLI | Stable |
| Local Universe | Preview |
| Secrets | Preview |
| SSO with SAML/oAuth2 | Experimental |
| Cluster-wide encryption with PKI | Preview |
| Service Accounts  | Preview |
| Cluster-wide authn/authz  | Preview |
| Fine-grained authn/authz  | Preview |
| Search/Bind and Client Certificate based authentication for LDAP/AD  | Preview |
| Identity and Access Management Service (users and groups)  | Stable |
| HDFS | Experimental |
| Kafka  | Preview |
| Confluent Kafka  | Preview |
| Cassandra  | Preview |
| Datastax Enterprise (DSE)  | Preview |
| Spark	| Stable 	|
| Artifactory  | Preview |
| GitLab  | Preview |
| Jenkins	| Stable 	|
| AWS: Custom AMI Support  | Preview |
| AWS: Centos7 support	| Stable 	|
| Universal Containerizer support | Experimental |