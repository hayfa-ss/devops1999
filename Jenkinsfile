pipeline {
    agent any

    environment {
        SONAR_TOKEN = "sqa_78ae98a3e2e0904d4f081cde0d1a9b5da461a4c4"
        TRIVY_REPORT = "timesheet-devops/timesheet-devops/trivy_report.json"
        TRIVY_SUMMARY = "timesheet-devops/timesheet-devops/trivy_filtered.txt"
        GITLEAKS_REPORT = "timesheet-devops/timesheet-devops/gitleaks_report.json"
        GITLEAKS_SUMMARY = "timesheet-devops/timesheet-devops/gitleaks_filtered.txt"
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
                dir('timesheet-devops/timesheet-devops') {
                    echo "Building project with Maven..."
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Lint JavaScript') {
            steps {
                dir('timesheet-devops/timesheet-devops') {
                    echo "Running ESLint checks..."
                    sh 'npx eslint . --ext .js,.html --max-warnings=0'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('timesheet-devops/timesheet-devops') {
                    echo "Running SonarQube Analysis..."
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=timesheet-devops \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }

        stage('Trivy Security Scan (Filtered)') {
            steps {
                dir('timesheet-devops/timesheet-devops') {
                    echo "Running Trivy JSON scan and filtering vulnerabilities CVSS >= 8..."
                    sh '''
                        # Ensure output directory exists
                        mkdir -p timesheet-devops/timesheet-devops

                        # Run Trivy scan
                        trivy fs --format json --output timesheet-devops/timesheet-devops/trivy_report.json .

                        # Filter vulnerabilities with CVSS >= 8
                        jq -r '.Results[].Vulnerabilities[]? 
                            | select((.CVSS?.nvd?.V3Score // 0) >= 8) 
                            | "Package: \(.PkgName) | CVE: \(.VulnerabilityID) | CVSS: \(.CVSS.nvd.V3Score) | Severity: \(.Severity) | Title: \(.Title)"' \
                            timesheet-devops/timesheet-devops/trivy_report.json > timesheet-devops/timesheet-devops/trivy_filtered.txt || true

                        # If no vulnerabilities found
                        if [ ! -s timesheet-devops/timesheet-devops/trivy_filtered.txt ]; then
                            echo "No vulnerabilities with CVSS >= 8 found." > timesheet-devops/timesheet-devops/trivy_filtered.txt
                        fi
                    '''
                }
            }
        }

        stage('Gitleaks Scan') {
            steps {
                dir('timesheet-devops/timesheet-devops') {
                    echo "Running Gitleaks scan for secrets..."
                    sh '''
                        mkdir -p timesheet-devops/timesheet-devops

                        # Run Gitleaks scan
                        gitleaks detect --source . --report-format json --report-path timesheet-devops/timesheet-devops/gitleaks_report.json || true

                        # Format output
                        jq -r '.Leaks[]? 
                            | "File: \(.FilePath) | Secret: \(.Title) | Description: \(.Description)"' \
                            timesheet-devops/timesheet-devops/gitleaks_report.json > timesheet-devops/timesheet-devops/gitleaks_filtered.txt || true

                        if [ ! -s timesheet-devops/timesheet-devops/gitleaks_filtered.txt ]; then
                            echo "No secrets found by Gitleaks." > timesheet-devops/timesheet-devops/gitleaks_filtered.txt
                        fi
                    '''
                }
            }
        }
    }

    post {
        success {
            script {
                def trivyContent = readFile(TRIVY_SUMMARY)
                def gitleaksContent = readFile(GITLEAKS_SUMMARY)

                emailext(
                    subject: "✅ Jenkins Security Summary - ESLint, Trivy & Gitleaks",
                    body: """<p>Hello Hayfa,</p>
                             <p>ESLint checked your JS/HTML files.</p>
                             <p>Here are vulnerabilities with CVSS >= 8:</p>
                             <pre>${trivyContent}</pre>
                             <p>Secrets detected by Gitleaks:</p>
                             <pre>${gitleaksContent}</pre>
                             <p>Best,<br>Jenkins Security Bot 🤖</p>""",
                    to: "hayfasadkaoui989@gmail.com"
                )
            }
        }

        failure {
            emailext(
                subject: "❌ Jenkins Pipeline Failed",
                body: """<p>Hello Hayfa,</p>
                         <p>The Jenkins pipeline failed. Please check the console output for details.</p>""",
                to: "hayfasadkaoui989@gmail.com"
            )
        }

        always {
            sh '''
                echo "Cleaning up temporary reports..."
                rm -f timesheet-devops/timesheet-devops/trivy_report.json timesheet-devops/timesheet-devops/trivy_filtered.txt timesheet-devops/timesheet-devops/gitleaks_report.json timesheet-devops/timesheet-devops/gitleaks_filtered.txt
            '''
        }
    }
}
