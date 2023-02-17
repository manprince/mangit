node {
    
    stage('Deploy to staging'){
        env.releaseId = getReleaseId(env.releaseName)
        env.releaseUrl = "https://grouplease.atlassian.net/projects/FP/versions/${env.releaseId}"
        env.releaseVersion = env.releaseBuild_NAME
        currentBuild.displayName=env.releaseVersion
        deployTo("${env.STAGING_HOST}", "staging", "${env.DOCKER_STAGING_REGISTRY}")
    }
    
    stage('Transition issues')
    {
        transitionIssuesToStaging()   
    }
    
    stage('Announce staging deployment'){
         announceDeployment("Staging")
    }
}


def deployTo(host, composeRelativePath, registry){
    sshagent(['deploy-key']) {
            withCredentials([usernamePassword(credentialsId: 'jerome_nexus', passwordVariable: 'PASSWORD', usernameVariable: 'USER')]) {
                sh """
                    ssh -o StrictHostKeyChecking=no -l jerome $host <<EOF
                    cd /var/share/Miscellaneous/Docker/compose/$composeRelativePath/;
                    docker login -u $USER -p $PASSWORD $registry;
                    VERSION=${env.releaseVersion} docker-compose pull ${env.SERVICE_DOCKER_SERVICE_NAME};
                    VERSION=${env.releaseVersion} docker-compose up -d --force-recreate ${env.SERVICE_DOCKER_SERVICE_NAME};
                    VERSION=${env.releaseVersion} docker-compose pull ${env.WEBAPP_DOCKER_SERVICE_NAME};
                    VERSION=${env.releaseVersion} docker-compose up -d --force-recreate ${env.WEBAPP_DOCKER_SERVICE_NAME};
                    EOF""".stripIndent()
            }   
        }
}

def announceDeployment(environment){
    slackSend botUser: true, channel: '#general', color: 'good', message: "[$environment] ${env.releaseName} has been deployed :  ${env.releaseUrl}", tokenCredentialId: 'slack-finwiz'
    rocketSend avatar: 'https://jenkins.grouplease.co.th/static/ff676c77/images/headshot.png',  channel: 'finwiz-deployment', message: "[$environment] ${env.releaseName} has been deployed :  ${env.releaseUrl}", rawMessage: true
}

String getReleaseId(releaseName){
    def versions = jiraGetProjectVersions(idOrKey: 'FP').data
    def release = null
    for(version in versions){
        if(version.name.equals(releaseName)){
            release = version
            break;
        }
    }
    return release.id
}

def transitionIssuesToStaging(){
    def release = jiraGetVersion(env.releaseId).data
    def searchResults = jiraJqlSearch jql: "project = FP AND fixVersion = '${env.releaseName}' and status = RESOLVED"
    def issues = searchResults.data.issues
    for (i = 0; i <issues.size(); i++) {
        def issueResult = jiraGetIssue idOrKey: issues[i].key
        def fixVersions = issueResult.data.fields.fixVersions << release
        def testIssue = [fields: [fixVersions: fixVersions]]
        response = jiraEditIssue idOrKey: issues[i].key, issue: testIssue
        def transitionInput = [
                "transition": [
                "id": "31"
                ]
                ]
          jiraTransitionIssue idOrKey: issues[i].key, input: transitionInput
        }
}
 