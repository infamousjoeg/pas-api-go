pipeline {
    agent any

    tools {
        go 'go-1.16.4'
    }

    environment {
        GO111MODULE = 'on'
    }

    stages {
        stage('Lint & Vet') {
            steps {
                sh 'golint ./...'
                sh 'go vet'
            }
        }
        stage('Test') {
            steps {
                withCredentials([
                    conjurSecretCredential(credentialsId: 'pas_hostname', variable: 'PAS_HOSTNAME'),
	                conjurSecretCredential(credentialsId: 'pas_username', variable: 'PAS_USERNAME'),
                    conjurSecretCredential(credentialsId: 'pas_password', variable: 'PAS_PASSWORD'),
                    conjurSecretCredential(credentialsId: 'ccp_client-cert', variable: 'CCP_CLIENT_CERT'),
                    conjurSecretCredential(credentialsId: 'ccp_client-priv-key', variable: 'CCP_CLIENT_PRIVATE_KEY')
	            ]) {
                    sh 'go test -v ./...'
                }

            }
        }
        stage('SonarCloud Code Analysis') {
            environment {
                SCANNER_HOME = tool 'SonarQubeScanner4.6.2.2472'
                ORGANIZATION = "infamousjoeg"
                PROJECT_NAME = "infamousjoeg_pas-api-go"
            }
            steps {
                withSonarQubeEnv("SonarCloud") {
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.organization=$ORGANIZATION \
                    -Dsonar.projectKey=$PROJECT_NAME \
                    -Dsonar.sources=.'''
                }
            }
        }
        stage('Build') {
            steps {
                sh 'go build -o cybr .'
            }
        }
        stage('Release') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}