pipeline {
    agent any
    environment {
        BLUE_SERVER = 'blue-server'
        GREEN_SERVER = 'green-server'
    }
    stages {
        stage('Deploy Blue') {
            steps {
                script {
                    echo "Deploying Blue Environment"
                    bat 'docker-compose up -d blue'
                }
            }
        }
        stage('Deploy Green') {
            steps {
                script {
                    echo "Deploying Green Environment"
                    bat 'docker-compose up -d green'
                }
            }
        }
        stage('Automated Testing') {
            steps {
                script {
                    echo "Running Tests"
                    bat 'pytest tests\\unit_tests.py'
                    bat 'pytest tests\\integration_tests.py'
                    bat 'zap-cli quick-scan http://green-server-url'
                }
            }
        }
        stage('Switch Traffic') {
            steps {
                script {
                    echo "Switching Traffic to Green"
                    bat 'switch-traffic.bat'
                }
            }
        }
        stage('Rollback') {
            when {
                expression { return currentBuild.result == 'FAILURE' }
            }
            steps {
                script {
                    echo "Rolling back to Blue"
                    bat 'rollback.bat'
                }
            }
        }
    }
}

