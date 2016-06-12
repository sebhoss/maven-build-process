# http://www.gnu.org/software/make/manual/make.html
# https://www.gnu.org/prep/standards/html_node/Makefile-Basics.html#Makefile-Basics
# http://clarkgrubb.com/makefile-style-guide

############
# PROLOGUE #
############
MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/sh
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

######################
# INTERNAL VARIABLES #
######################
timestamp := $(shell /bin/date "+%Y.%m.%d-%H%M%S")

###############
# GOALS/RULES #
###############

.PHONY: all
all: help

#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'targets'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }

help: ##@other Show this help
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

.PHONY: display-dependency-updates
display-dependency-updates: ##@maintenance Display dependency updates in 'maven-boms'
	@mvn versions:display-dependency-updates -U -pl maven-boms -amd

.PHONY: display-plugin-updates
display-plugin-updates: ##@maintenance Display plugin updates in 'maven-parents'
	@mvn versions:display-plugin-updates -U -pl maven-parents -amd

.PHONY: display-property-updates
display-property-updates: ##@maintenance Display property updates in all modules
	@mvn versions:display-property-updates -U

.PHONY: sonar-analysis
sonar-analysis: ##@maintenance Performs Sonarqube analysis
	# http://docs.sonarqube.org/display/SONAR/Analyzing+with+SonarQube+Scanner+for+Maven
	@mvn clean install
	@mvn sonar:sonar -Dsonar.host.url=http://localhost:59000

.PHONY: sign-waiver
sign-waiver: ##@one-time Signs the WAIVER
	@gpg2 --no-version --armor --sign AUTHORS/WAIVER

.PHONY: release-into-local-nexus
release-into-local-nexus: ##@release Releases all artifacts into a local nexus
	mvn versions:set -DnewVersion=$(timestamp) -DgenerateBackupPoms=false
	mvn clean deploy scm:tag -Dtag=maven-build-process-$(timestamp) -DpushChanges=false -DskipLocalStaging=true -Drelease=local
	-mvn versions:set -DnewVersion=0.0.0-SNAPSHOT -DgenerateBackupPoms=false

.PHONY: release-into-sonatype-nexus
release-into-sonatype-nexus: ##@release Releases all artifacts into Maven Central (through Sonatype OSSRH)
	mvn versions:set -DnewVersion=$(timestamp) -DgenerateBackupPoms=false
	mvn clean gpg:sign deploy scm:tag -Dtag=maven-build-process-$(timestamp) -DpushChanges=false -Drelease=sonatype
	git push --tags
	-mvn versions:set -DnewVersion=0.0.0-SNAPSHOT -DgenerateBackupPoms=false
