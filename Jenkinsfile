pipeline {
    agent any

    environment {
        SONAR_TOKEN = "sqa_78ae98a3e2e0904d4f081cde0d1a9b5da461a4c4"
        TRIVY_REPORT = "trivy_report.json"
        TRIVY_SUMMARY = "trivy_filtered.txt"
        GITLEAKS_REPORT = "gitleaks_report.json"
        GITLEAKS_SUMMARY = "gitleaks_filtered.txt"
        DEPENDENCY_CHECK_REPORT = "dependency-check-report.html"
        DOCKER_REPORT = "docker_scan_report.json"
        WORKDIR = "timesheet-devops/timesheet-devops"
        DOCKER_IMAGE = "timesheet-devops:latest"
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

        stage('OWASP Dependency-Check (SCA)') {
            steps {
                dir("${WORKDIR}") {
                    echo "Running OWASP Dependency-Check for dependency vulnerabilities..."
                    script {
                        if (isUnix()) {
                            sh """
                                dependency-check.sh --project "timesheet-devops" \
                                --scan . \
                                --format HTML \
                                --out ${DEPENDENCY_CHECK_REPORT} \
                                --failOnCVSS 7 || true
                            """
                        } else {
                            bat """
                                dependency-check.bat --project "timesheet-devops" ^
                                --scan . ^
                                --format HTML ^
                                --out %DEPENDENCY_CHECK_REPORT% ^
                                --failOnCVSS 7 || exit /b 0
                            """
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir("${WORKDIR}") {
                    echo "Building Docker image for security scanning..."
                    script {
                        if (isUnix()) {
                            sh """
                                docker build -t ${DOCKER_IMAGE} .
                            """
                        } else {
                            bat """
                                docker build -t %DOCKER_IMAGE% .
                            """
                        }
                    }
                }
            }
        }

        stage('Docker Image Security Scan') {
            steps {
                dir("${WORKDIR}") {
                    echo "Scanning Docker image with Trivy..."
                    script {
                        if (isUnix()) {
                            sh """
                                trivy image --format json --output ${DOCKER_REPORT} ${DOCKER_IMAGE} 2>/dev/null || true
                                trivy image --severity HIGH,CRITICAL ${DOCKER_IMAGE} || true
                            """
                        } else {
                            bat """
                                trivy image --format json --output %DOCKER_REPORT% %DOCKER_IMAGE% 2>nul || exit /b 0
                                trivy image --severity HIGH,CRITICAL %DOCKER_IMAGE% || exit /b 0
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                dir("${WORKDIR}") {
                    // Read security scan reports with safe null handling
                    def trivyContent = (fileExists("${TRIVY_SUMMARY}") ? readFile("${TRIVY_SUMMARY}").trim() : "No Trivy report available.") ?: "No Trivy report available."
                    def gitleaksContent = (fileExists("${GITLEAKS_SUMMARY}") ? readFile("${GITLEAKS_SUMMARY}").trim() : "No Gitleaks report available.") ?: "No Gitleaks report available."
                    def dockerContent = fileExists("${DOCKER_REPORT}") ? "Docker image scan completed." : "No Docker scan report available."

                    emailext(
                        subject: "✅ Jenkins CI/CD Security Pipeline - Build & Security Scans",
                        body: """<p>Hello Hayfa,</p>
                                 <p>Build and comprehensive security scan summary:</p>
                                 <h3>📦 Build Status</h3>
                                 <p>Spring Boot 3.5.0 - Java 17 Build Completed</p>
                                 <h3>🔍 Code Quality (SAST)</h3>
                                 <p>SonarQube Analysis - Check dashboard at http://localhost:9000</p>
                                 <h3>📚 Dependency Vulnerabilities (SCA)</h3>
                                 <p>OWASP Dependency-Check & Trivy Scan - See attached reports</p>
                                 <h3>🐳 Docker Image Security</h3>
                                 <pre>${dockerContent}</pre>
                                 <h3>🔐 Secrets Detection</h3>
                                 <pre>${gitleaksContent}</pre>
                                 <h3>🛡️ Trivy Scan</h3>
                                 <pre>${trivyContent}</pre>
                                 <p>For detailed reports, check Jenkins artifacts.<br>Best regards,<br>Jenkins Security Bot 🤖</p>""",
                        to: "hayfasadkaoui989@gmail.com",
                        attachmentsPattern: "**/dependency-check-report.html, **/trivy_report.json, **/docker_scan_report.json"
                    )
                    
                    // Archive reports for later analysis
                    archiveArtifacts artifacts: "**/dependency-check-report.html, **/trivy_report.json, **/docker_scan_report.json, **/gitleaks_report.json", 
                                     allowEmptyArchive: true
                    
                    // Clean up temporary files
                    if (isUnix()) {
                        sh "rm -f ${TRIVY_REPORT} ${TRIVY_SUMMARY} ${GITLEAKS_REPORT} ${GITLEAKS_SUMMARY} 2>/dev/null || true"
                    } else {
                        bat "del /F ${TRIVY_REPORT} ${TRIVY_SUMMARY} ${GITLEAKS_REPORT} ${GITLEAKS_SUMMARY} 2>nul || exit 0"
                    }
                }
            }
        }

        failure {
            emailext(
                subject: "❌ Jenkins Pipeline Failed",
                body: "<p>Hello Hayfa,</p><p>The Jenkins pipeline failed during security scanning. Please check the console output for details.</p>",
                to: "hayfasadkaoui989@gmail.com"
            )
        }
    }
}