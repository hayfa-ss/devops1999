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
                            sh 'npx eslint . --ext .js,.html --max-warnings=0'
                        } else {
                            bat 'npx eslint . --ext .js,.html --max-warnings=0'
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
                                trivy fs --format json --output ${TRIVY_REPORT} .
                                jq -r '.Results[].Vulnerabilities[]? 
                                    | select((.CVSS?.nvd?.V3Score // 0) >= 8)
                                    | "Package: \(.PkgName) | CVE: \(.VulnerabilityID) | CVSS: \(.CVSS.nvd.V3Score) | Severity: \(.Severity) | Title: \(.Title)"' \
                                    ${TRIVY_REPORT} > ${TRIVY_SUMMARY} || true
                                if [ ! -s ${TRIVY_SUMMARY} ]; then
                                    echo "No vulnerabilities with CVSS >= 8 found." > ${TRIVY_SUMMARY}
                                fi
                            """
                        } else {
                            bat """
                                trivy fs --format json --output ${TRIVY_REPORT} .
                                jq -r ".Results[].Vulnerabilities[]? 
                                    | select((.CVSS?.nvd?.V3Score // 0) >= 8) 
                                    | \\"Package: \(.PkgName) | CVE: \(.VulnerabilityID) | CVSS: \(.CVSS.nvd.V3Score) | Severity: \(.Severity) | Title: \(.Title)\\"" \
                                    ${TRIVY_REPORT} > ${TRIVY_SUMMARY} || echo No vulnerabilities found > ${TRIVY_SUMMARY}
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
                                gitleaks detect --source . --report-format json --report-path ${GITLEAKS_REPORT} || true
                                jq -r '.Leaks[]? 
                                    | "File: \(.FilePath) | Secret: \(.Title) | Description: \(.Description)"' \
                                    ${GITLEAKS_REPORT} > ${GITLEAKS_SUMMARY} || true
                                if [ ! -s ${GITLEAKS_SUMMARY} ]; then
                                    echo "No secrets found by Gitleaks." > ${GITLEAKS_SUMMARY}
                                fi
                            """
                        } else {
                            bat """
                                gitleaks detect --source . --report-format json --report-path ${GITLEAKS_REPORT} || echo No secrets found
                                jq -r ".Leaks[]? | \\"File: \(.FilePath) | Secret: \(.Title) | Description: \(.Description)\\"" ${GITLEAKS_REPORT} > ${GITLEAKS_SUMMARY} || echo No secrets found > ${GITLEAKS_SUMMARY}
                            """
                        }
                    }
                }
            }
        }

    }

    post {
        success {
            script {
                def trivyContent = readFile("${WORKDIR}/${TRIVY_SUMMARY}")
                def gitleaksContent = readFile("${WORKDIR}/${GITLEAKS_SUMMARY}")

                emailext(
                    subject: "✅ Jenkins Security Summary - ESLint, Trivy & Gitleaks",
                    body: """<p>Hello Hayfa,</p>
                             <p>Here are your security results:</p>
                             <h3>🔍 Trivy (CVSS >= 8)</h3>
                             <pre>${trivyContent}</pre>
                             <h3>🔐 Gitleaks (Secrets)</h3>
                             <pre>${gitleaksContent}</pre>
                             <p>Best regards,<br>Jenkins Security Bot 🤖</p>""",
                    to: "hayfasadkaoui989@gmail.com"
                )
            }
        }

        failure {
            emailext(
                subject: "❌ Jenkins Pipeline Failed",
                body: "<p>Hello Hayfa,</p><p>The Jenkins pipeline failed. Please check the console output for details.</p>",
                to: "hayfasadkaoui989@gmail.com"
            )
        }

        always {
            dir("${WORKDIR}") {
                script {
                    if (isUnix()) {
                        sh "rm -f ${TRIVY_REPORT} ${TRIVY_SUMMARY} ${GITLEAKS_REPORT} ${GITLEAKS_SUMMARY}"
                    } else {
                        bat "del /F ${TRIVY_REPORT} ${TRIVY_SUMMARY} ${GITLEAKS_REPORT} ${GITLEAKS_SUMMARY}"
                    }
                }
            }
        }
    }
}
