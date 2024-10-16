
# CI Setup with Jenkins, Nexus, and SonarQube

This repository contains configuration files, scripts, and pipelines for setting up Jenkins, Nexus, and SonarQube using Vagrant, as well as building, testing, and deploying a Java application via a Jenkins pipeline. Different branches in this repository serve different purposes and provide specific configurations for various environments.

## Table of Contents

- [Branches Overview](#branches-overview)
- [VM Configuration](#vm-configuration)
- [CI Pipeline](#ci-pipeline)
- [Dev Branch Setup](#dev-branch-setup)

## Branches Overview

This repository contains multiple branches, each with specific functionality:

- `vm-config`: Bash scripts for setting up Jenkins, Nexus, and SonarQube using Vagrant on an Ubuntu VM.
- `ci`: Jenkins pipeline configuration for CI/CD.
- `dev`: Dev branch containing codebase setup with MySQL database configuration.

Each branch has its own detailed `README.md` explaining its purpose and usage.

## VM Configuration

If you are looking to set up Jenkins, Nexus, and SonarQube on an Ubuntu virtual machine using Vagrant, refer to the `vm-config` branch. You can find the detailed instructions for installation and setup in the README of the `vm-config` branch:

```bash
git checkout vm-config
```

[VM Configuration README](https://github.com/nulltogeek/ci-using-jenkins-nexus-sonarqube-slack/tree/vm-config)

## CI Pipeline

The `ci` branch contains the Jenkins pipeline configuration for building, testing, and deploying a Java application. It covers how to integrate with Nexus, SonarQube, and Slack for notifications.

To learn more about setting up and using the Jenkins pipeline, refer to the README in the `ci` branch:

```bash
git checkout ci
```

[CI Pipeline README](https://github.com/nulltogeek/ci-using-jenkins-nexus-sonarqube-slack/tree/ci)

## Dev Branch Setup

The `dev` branch contains the Java application codebase, including the necessary setup for MySQL and Maven. This branch also includes a MySQL database dump and configuration for setting up the development environment.

To get started with the dev branch, refer to the `README.md` file in the `dev` branch:

```bash
git checkout dev
```

[Dev Branch README](https://github.com/nulltogeek/ci-using-jenkins-nexus-sonarqube-slack/tree/dev)

## Conclusion

Each branch in this repository serves a different role, helping you set up a CI/CD environment with Jenkins, Nexus, and SonarQube, or configure a Java-based development environment with MySQL. Switch to the appropriate branch for detailed instructions.
