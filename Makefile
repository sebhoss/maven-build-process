all: help

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

display-dependency-updates:
	@mvn versions:display-dependency-updates -U

display-plugin-updates:
	@mvn versions:display-plugin-updates -U

display-property-updates:
	@mvn versions:display-property-updates -U

sonar-analysis:
	# http://docs.sonarqube.org/display/SONAR/Analyzing+with+SonarQube+Scanner+for+Maven
	@mvn clean install
	@mvn sonar:sonar -Dsonar.host.url=http://localhost:59000

sign-waiver:
	@gpg2 --no-version --armor --sign AUTHORS/WAIVER

release:
    # TODO: gpg-agent
    # TODO: ssh-agent
    # TODO: mvn batch mode
	@mvn versions:set -DnewVersion=`(date +%Y.%m.%d)`-SNAPSHOT
	@mvn versions:commit
	@mvn -B release:prepare release:perform -DdevelopmentVersion=0.0.0-SNAPSHOT
