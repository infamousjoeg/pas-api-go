pipeline {
    agent any

    tools {
        go 'go-1.16.4'
    }

	environment {
		GO111MODULE = 'on'
        CGO_ENABLED = 0 
        GOPATH = "${JENKINS_HOME}/jobs/${JOB_NAME}/builds/${BUILD_ID}"
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
				withEnv(["PATH+GO=${GOPATH}/bin"]) {
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
