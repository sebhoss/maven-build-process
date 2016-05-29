# https://www.gnu.org/prep/standards/html_node/Makefile-Basics.html#Makefile-Basics
# http://clarkgrubb.com/makefile-style-guide
SHELL = /bin/sh

.PHONY: all
all: help

.PHONY: help
help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make display-dependency-updates - display dependency updates"
	@echo "   2. make display-plugin-updates     - display plugin updates"
	@echo "   3. make display-property-updates   - display property updates"
	@echo "   4. make sonar-analysis             - perform sonar analysis"
	@echo "   5. make sign-waiver                - GPG sign the WAIVER"
	@echo "   6. make release                    - perform the next release"

.PHONY: display-dependency-updates
display-dependency-updates:
	@mvn versions:display-dependency-updates -U -pl maven-boms -amd

.PHONY: display-plugin-updates
display-plugin-updates:
	@mvn versions:display-plugin-updates -U -pl maven-parents -amd

.PHONY: display-property-updates
display-property-updates:
	@mvn versions:display-property-updates -U

.PHONY: sonar-analysis
sonar-analysis:
	# http://docs.sonarqube.org/display/SONAR/Analyzing+with+SonarQube+Scanner+for+Maven
	@mvn clean install
	@mvn sonar:sonar -Dsonar.host.url=http://localhost:59000

.PHONY: sign-waiver
sign-waiver:
	@gpg2 --no-version --armor --sign AUTHORS/WAIVER

timestamp := $(shell /bin/date "+%Y.%m.%d-%H%M%S")

.PHONY: release-into-local-nexus
release-into-local-nexus:
	mvn versions:set -DnewVersion=$(timestamp) versions:commit
	mvn clean deploy scm:tag -Dtag=maven-build-process-$(timestamp) -DpushChanges=false -DskipLocalStaging=true -Drelease=local
	-mvn versions:set -DnewVersion=0.0.0-SNAPSHOT versions:commit

.PHONY: release-into-sonatype-nexus
release-into-sonatype-nexus:
	mvn versions:set -DnewVersion=$(timestamp) versions:commit
	mvn clean gpg:sign deploy scm:tag -Dtag=maven-build-process-$(timestamp) -DpushChanges=false -Drelease=sonatype
	-mvn versions:set -DnewVersion=0.0.0-SNAPSHOT versions:commit
