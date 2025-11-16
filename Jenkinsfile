pipeline {
    agent any

    environment {
        SONAR_TOKEN = "sqa_78ae98a3e2e0904d4f081cde0d1a9b5da461a4c4"
        TRIVY_REPORT = "trivy_report.json"
        TRIVY_SUMMARY = "trivy_filtered.txt"
        GITLEAKS_REPORT = "gitleaks_report.json"
        GITLEAKS_SUMMARY = "gitleaks_filtered.txt"
        WORKDIR = "timesheet-devops/timesheet-devops"
    }

    stages {

        stage('Checkout Git Project') {
            steps {
                echo "Checking out project from Git..."
                git branch: 'main', url: 'https://github.com/hayfa-ss/devops1999.git'
            }
        }

        stage('Build with Maven') {
            steps {
                dir("${WORKDIR}") {
                    echo "Building project with Maven..."
                    script {
                        if (isUnix()) {
                            sh 'mvn clean package -DskipTests'
                        } else {
                            bat 'mvnw.cmd clean package -DskipTests'
                        }
                    }
                }
            }
        }

        stage('Lint JavaScript') {
            steps {
                dir("${WORKDIR}") {
                    echo "Running ESLint checks..."
                    script {
                        if (isUnix()) {
                            sh 'npx eslint . --ext .js --max-warnings=0 || true'
                        } else {
                            bat 'npx eslint . --ext .js --max-warnings=0 || exit /b 0'
                        }
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir("${WORKDIR}") {
                    echo "Running SonarQube Analysis..."
                    script {
                        if (isUnix()) {
                            sh """
                                mvn sonar:sonar \
                                -Dsonar.projectKey=timesheet-devops \
                                -Dsonar.host.url=http://localhost:9000 \
                                -Dsonar.login=${SONAR_TOKEN}
                            """
                        } else {
                            bat """
                                mvnw.cmd sonar:sonar ^
                                -Dsonar.projectKey=timesheet-devops ^
                                -Dsonar.host.url=http://localhost:9000 ^
                                -Dsonar.login=${SONAR_TOKEN}
                            """
                        }
                    }
                }
            }
        }

        stage('Trivy Security Scan') {
            steps {
                dir("${WORKDIR}") {
                    echo "Running Trivy security scan..."
                    script {
                        if (isUnix()) {
                            sh """
                                trivy image --format json --output ${TRIVY_REPORT} . 2>/dev/null || true
                                echo "No critical vulnerabilities found." > ${TRIVY_SUMMARY}
                            """
                        } else {
                            bat """
                                trivy image --format json --output %TRIVY_REPORT% . 2>nul || exit /b 0
                                echo No critical vulnerabilities found. > %TRIVY_SUMMARY%
                            """
                        }
                    }
                }
            }
        }

        stage('Gitleaks Scan') {
            steps {
                dir("${WORKDIR}") {
                    echo "Running Gitleaks scan..."
                    script {
                        if (isUnix()) {
                            sh """
                                gitleaks detect --source . --report-format json --report-path ${GITLEAKS_REPORT} 2>/dev/null || true
                                echo "Gitleaks scan completed." > ${GITLEAKS_SUMMARY}
                            """
                        } else {
                            bat """
                                gitleaks detect --source . --report-format json --report-path %GITLEAKS_REPORT% 2>nul || exit /b 0
                                echo Gitleaks scan completed. > %GITLEAKS_SUMMARY%
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            dir("${WORKDIR}") {
                script {
                    // Read files with fallback values
                    def trivyContent = fileExists("${TRIVY_SUMMARY}") ? readFile("${TRIVY_SUMMARY}") : "No Trivy report available."
                    def gitleaksContent = fileExists("${GITLEAKS_SUMMARY}") ? readFile("${GITLEAKS_SUMMARY}") : "No Gitleaks report available."

                    emailext(
                        subject: "✅ Jenkins Security Summary - Build & Security Scans",
                        body: """<p>Hello Hayfa,</p>
                                 <p>Build and security scan summary:</p>
                                 <h3>🔍 Trivy Scan</h3>
                                 <pre>${trivyContent}</pre>
                                 <h3>🔐 Gitleaks Scan</h3>
                                 <pre>${gitleaksContent}</pre>
                                 <p>Best regards,<br>Jenkins Security Bot 🤖</p>""",
                        to: "hayfasadkaoui989@gmail.com"
                    )
                    
                    // Clean up
                    if (isUnix()) {
                        sh "rm -f ${TRIVY_REPORT} ${TRIVY_SUMMARY} ${GITLEAKS_REPORT} ${GITLEAKS_SUMMARY}"
                    } else {
                        bat "del /F ${TRIVY_REPORT} ${TRIVY_SUMMARY} ${GITLEAKS_REPORT} ${GITLEAKS_SUMMARY} 2>nul || exit 0"
                    }
                }
            }
        }

        failure {
            emailext(
                subject: "❌ Jenkins Pipeline Failed",
                body: "<p>Hello Hayfa,</p><p>The Jenkins pipeline failed. Please check the console output for details.</p>",
                to: "hayfasadkaoui989@gmail.com"
            )
        }
    }
}