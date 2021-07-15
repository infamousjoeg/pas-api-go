pipeline {
    agent any

    tools {
        go 'go-1.16.4'
    }

    stages {
        stage('Lint & Vet') {
            steps {
                sh 'GO111MODULE=on golint ./...'
                sh 'GO111MODULE=on go vet'
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
                    sh 'GO111MODULE=on go test -v ./...'
                }
            }
        }
        stage('Build') {
            steps {
                sh 'GO111MODULE=on go build -o cybr .'
            }
        }
        stage('Release') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
