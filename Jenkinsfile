def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

pipeline {
    agent any
    tools {
        maven 'MAVEN3'
        jdk 'OracleJDK17'
    }
    environment {
        NEXUS_URL = 'http://<NEXUS_IP>:<NEXUS_PORT>'
        NEXUS_REPOSITORY_SNAPSHOT = '<SNAPSHOT_REPOSITORY>'
        NEXUS_REPOSITORY_RELEASE = '<RELEASE_REPOSITORY>'
        NEXUS_REPOSITORY_GROUP = '<GROUP_REPOSITORY>'
        NEXUS_REPOSITORY_CENTRAL = '<CENTRAL_REPOSITORY>'

        NEXUS_USERNAME = '<NEXUS_USERNAME>'
        NEXUS_PASSWORD = '<NEXUS_PASSWORD>'

        SONARQUBE_SERVER = '<SONARQUBE_SERVER>'
        SONARQUBE_SCANNER = '<SONARQUBE_SCANNER>'
    }
    stages {
        stage('Build') {
            steps {
                // install dependencies from nexus
                sh 'mvn -s settings.xml -DskipTests install'
            }
            post {
                success {
                    echo 'Now Archiving.'
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }
        stage('TEST') {
            steps {
                sh 'mvn -s settings.xml test'
            }
        }
        stage('Checkstyle Analysis') {
            steps {
                sh 'mvn -s settings.xml checkstyle:checkstyle'
            }
        }
        stage('Sonar Analysis') {
            environment {
                scannerHome = tool "${SONARSCANNER}"
            }
            steps {
                withSonarQubeEnv("${SONARSERVER}") {
                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=<PROJECT_NAME> \
                       -Dsonar.projectName=<PROJECT_NAME>-repo \
                       -Dsonar.projectVersion=1.0 \
                       -Dsonar.sources=src/ \
                       -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                       -Dsonar.junit.reportsPath=target/surefire-reports/ \
                       -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                       -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('UploadArtifact') {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                    groupId: 'QA',
                    version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                    repository: "${RELEASE_REPO}",
                    credentialsId: "${NEXUS_LOGIN}",
                    artifacts: [
                        [
                            artifactId: '<ARTIFACT_ID>',
                            classifier: '',
                            file: 'target/vprofile-v2.war',
                            type: 'war'
                        ]
                    ]
                )
            }
        }
    }
    post {
        always {
            echo 'Slack Notification'
            slackSend(
                channel: '#<CHANNEL_NAME>',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More Info at: ${env.BUILD_URL}"
            )
        }
    }
}
