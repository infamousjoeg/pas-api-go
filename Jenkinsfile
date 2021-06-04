pipeline {
    agent any

    tools {
        go 'go-1.16.4'
    }

    stages {
        stage('Test') {
            withCredentials([
                conjurSecretCredential(credentialsId: 'pas_hostname', variable: 'PAS_HOSTNAME'),
	            conjurSecretCredential(credentialsId: 'pas_username', variable: 'PAS_USERNAME'),
                conjurSecretCredential(credentialsId: 'pas_password', variable: 'PAS_PASSWORD'),
                conjurSecretCredential(credentialsId: 'ccp_client-cert', variable: 'CCP_CLIENT_CERT'),
                conjurSecretCredential(credentialsId: 'ccp_client-priv-key', variable: 'CCP_CLIENT_PRIV_KEY')
	        ])

            steps {
                sh 'go test -v ./...'
            }
        }
        stage('Code Analysis') {
            steps {
                echo 'Analyzing code...'
            }
        }
        stage('Build') {
            steps {
                sh './make'
            }
        }
        stage('Release') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}