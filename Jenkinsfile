pipeline {
    agent any

    stages {
        stage('Checkout Source Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Jar') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Archive Jar') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Push Jar to Nexus') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'Nexus_credentials',
                    usernameVariable: 'NEXUS_USER',
                    passwordVariable: 'NEXUS_PASS'
                )]) {
                    sh '''
                        JAR_FILE=$(ls target/*.jar | grep -v original | head -n 1)

                        cat > settings.xml <<EOT
<settings>
  <servers>
    <server>
      <id>nexus</id>
      <username>${NEXUS_USER}</username>
      <password>${NEXUS_PASS}</password>
    </server>
  </servers>
</settings>
EOT

                        mvn deploy:deploy-file \
                          -DgroupId=com.githubfinal \
                          -DartifactId=github-final \
                          -Dversion=1.0.${BUILD_NUMBER} \
                          -Dpackaging=jar \
                          -Dfile=$JAR_FILE \
                          -DrepositoryId=nexus \
                          -Durl=http://nexus-service:8081/repository/maven-releases/ \
                          -DgeneratePom=true \
                          -s settings.xml
                    '''
                }
            }
        }
    }
}
