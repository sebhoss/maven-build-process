node {
    stage "Checkout"
    checkout scm

    stage "Tooling"
    def mvnHome = tool "latest-maven"

    stage "Timestamp"
    sh 'date "+%Y.%m.%d-%H%M%S" > TIMESTAMP'
    def timestamp = readFile("TIMESTAMP")

    stage "Versioning"
    sh "${mvnHome}/bin/mvn  -s build/jenkins/local-nexus.xml versions:set -DgenerateBackupPoms=false -DnewVersion=${timestamp}"

    stage "Build & Deploy"
    sh "${mvnHome}/bin/mvn -s build/jenkins/local-nexus.xml clean deploy -DskipLocalStaging=true"

    stage "Cleanup"
    sh "rm -f TIMESTAMP"

}
