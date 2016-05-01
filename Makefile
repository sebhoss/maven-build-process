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
	@mvn versions:display-dependency-updates -U

.PHONY: display-plugin-updates
display-plugin-updates:
	@mvn versions:display-plugin-updates -U

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

.PHONY: release
release:
	# TODO: gpg-agent
	# TODO: ssh-agent
	# TODO: mvn batch mode
	@mvn deploy scm:tag -Drevision=`(date +%Y.%m.%d)`
