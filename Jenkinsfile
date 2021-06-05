pipeline {
    agent any

    stages {
        stage('Install Go 1.14.2') {
            steps {
                sh 'wget -c https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local'
                sh 'export PATH=$PATH:/usr/local/go/bin'
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