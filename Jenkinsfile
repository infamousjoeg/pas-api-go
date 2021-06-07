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
                    conjurSecretCredential(credentialsId: 'ccp_client-priv-key', variable: 'CCP_CLIENT_PRIV_KEY')
	            ]) {
                    sh 'echo $CCP_CLIENT_CERT > /tmp/client.crt'
                    sh 'echo $CCP_CLIENT_PRIV_KEY > /tmp/client.key' 
                    sh 'go test -v ./...'
                }

            }
        }
        stage('Code Analysis') {
            steps {
                echo 'Analyzing code...'
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