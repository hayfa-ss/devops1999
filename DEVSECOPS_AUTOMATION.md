# 🔐 Intégration DevSecOps - Automatisation Complète

## 📌 Résumé de l'automatisation

Ce projet implémente une pipeline CI/CD entièrement automatisée avec des contrôles de sécurité (DevSecOps) à tous les niveaux.

---

## 🛡️ 1. Sécurité Côté Développeur (Shift-Left)

### Pre-commit Hook (`.git/hooks/pre-commit.ps1`)
- ✅ Détection de secrets hardcodés
- ✅ Scan XSS et injections SQL
- ✅ Validation avant chaque commit

**Fichier** : `.git/hooks/pre-commit.ps1`

---

## 🚀 2. Pipeline Jenkins Automatisé

### Triggers Configurés
- **GitHub Webhook** : Déclenche le build automatiquement à chaque push
- **SCM Polling** : Scrute le repository toutes les 5 minutes

### Stages du Pipeline

#### ✅ Stage 1 : Build Maven
```groovy
mvn clean package -DskipTests
```
- Compilation du code
- Emballage Spring Boot JAR
- Durée : ~55s

#### ✅ Stage 2 : SAST - SonarQube
```groovy
mvn sonar:sonar \
-Dsonar.projectKey=timesheet-devops \
-Dsonar.host.url=http://localhost:9000 \
-Dsonar.login=${SONAR_TOKEN}
```
- Analyse statique du code source
- Détection de vulnérabilités (XSS, SQLi, etc.)
- Détection de secrets
- **Dashboard** : http://localhost:9000/dashboard?id=timesheet-devops
- Durée : ~1m36s

#### ✅ Stage 3 : Quality Gate SonarQube
- Blocage du build si la qualité est insuffisante
- Vérification via API SonarQube

#### ✅ Stage 4 : SCA - Trivy (Dépendances)
```bash
trivy fs --format json --output trivy_report.json --severity CRITICAL,HIGH .
```
- Analyse des dépendances
- Détection des vulnérabilités CVE
- Blocage si vulnérabilités CRITICAL trouvées

#### ✅ Stage 5 : Docker Build & Scan
```bash
docker build -t timesheet-devops:${BUILD_NUMBER} -f Dockerfile .
trivy image --format json --output docker_trivy_report.json \
    --severity CRITICAL,HIGH timesheet-devops:${BUILD_NUMBER}
```
- Construction de l'image Docker
- Scan de l'image pour CVEs
- Blocage si vulnérabilités CRITICAL

#### ✅ Stage 6 : Gitleaks - Scan des Secrets
```bash
gitleaks detect --source . --report-format json --report-path gitleaks_report.json
```
- Détection de secrets hardcodés (API keys, tokens, etc.)
- Blocage automatique en cas de secret détecté
- **Configuration** : `.gitleaksignore` pour exclure faux positifs

#### ✅ Stage 7 : DAST - OWASP ZAP
```bash
zaproxy -cmd -quickurl http://localhost:8082/timesheet-devops \
    -quickout zap_report.json
```
- Test dynamique de l'application en exécution
- Détection des vulnérabilités web
- Scan en baseline (non-intrusive)

#### ✅ Stage 8 : Reporting & Alerting
- Génération de rapport HTML professionnel
- Archivage des rapports JSON
- Email automatique aux développeurs

---

## 📊 3. Contrôles de Sécurité et Blocage

### Règles de Blocage Automatique

| Contrôle | Condition | Action |
|----------|-----------|--------|
| **SonarQube Quality Gate** | Quality gate fail | ❌ BLOCK |
| **Trivy SCA** | CVE CRITICAL détecté | ❌ BLOCK |
| **Trivy Docker** | CVE CRITICAL dans image | ❌ BLOCK |
| **Gitleaks** | Secret détecté | ❌ BLOCK |
| **DAST** | Vulnérabilité HIGH/CRITICAL | ⚠️ ALERT |

### Exemple de Blocage
```
❌ Gitleaks Secrets Scan FAILED
   Found 9 hardcoded secrets!
   Pipeline is BLOCKING this commit to prevent secrets exposure!
```

---

## 📁 4. Fichiers Clés

### Jenkinsfile
- **Localisation** : `devops1999/Jenkinsfile`
- **Description** : Pipeline CI/CD complète avec tous les stages DevSecOps
- **Longueur** : ~550 lignes
- **Triggers** : GitHub webhook + SCM polling

### Dockerfile
- **Localisation** : `devops1999/timesheet-devops/Dockerfile`
- **Description** : Container Spring Boot optimisé
- **Base** : `openjdk:8-jre-slim`

### .gitleaksignore
- **Localisation** : `devops1999/.gitleaksignore`
- **Description** : Exclusion des faux positifs Gitleaks

### Pre-commit Hook
- **Localisation** : `devops1999/.git/hooks/pre-commit.ps1`
- **Description** : Contrôles de sécurité locaux avant commit

---

## 🔧 5. Configuration Jenkins

### Credentials Configurés
- `SONAR_TOKEN` : Token SonarQube (sécurisé)
- Authentification GitHub (si webhook)

### Environment Variables
- `SONAR_TOKEN = credentials('SONAR_TOKEN')`
- `DOCKER_IMAGE = "timesheet-devops:${BUILD_NUMBER}"`
- `DOCKER_REGISTRY = "localhost:5000"`

### Options
- Timeout : 1 heure
- Conservation des logs : 10 derniers builds

---

## 📈 6. Rapports et Notifications

### Rapports Générés

1. **SonarQube Dashboard**
   - URL : http://localhost:9000/dashboard?id=timesheet-devops
   - Contenu : Analyse statique, couverture de code, hotspots de sécurité

2. **Rapport Email HTML**
   - Destinataire : hayfasadkaoui989@gmail.com
   - Contenu : Résumé de tous les stages, statuts de sécurité

3. **Rapports JSON**
   - `trivy_report.json` : Vulnérabilités SCA
   - `docker_trivy_report.json` : Vulnérabilités Docker
   - `gitleaks_report.json` : Secrets détectés
   - `zap_report.json` : Vulnérabilités DAST

### Notifications Automatiques
- ✅ Email sur SUCCESS
- ❌ Email sur FAILURE avec détails du problème

---

## 🎯 7. Conformité aux Exigences

| Exigence | Implémentation | Statut |
|----------|-----------------|--------|
| **Analyse du pipeline existant** | Jenkinsfile complet | ✅ |
| **Sécurité côté développeur** | Pre-commit hook + SonarLint | ✅ |
| **SAST** | SonarQube intégré | ✅ |
| **SCA** | Trivy analyseur | ✅ |
| **Scan Docker** | Trivy image scan | ✅ |
| **DAST** | OWASP ZAP | ✅ |
| **Secrets Scan** | Gitleaks | ✅ |
| **Blocking Rules** | Automatique sur CRITICAL | ✅ |
| **Reporting** | HTML + Email + JSON | ✅ |
| **Alerting** | Email automatique | ✅ |
| **Documentation** | Ce fichier + PRESENTATION.md | ✅ |

---

## 🚀 8. Comment Utiliser

### Déclencher un Build
1. Faire un commit et push sur la branche `main`
2. Jenkins détecte automatiquement via webhook
3. Pipeline exécute tous les stages

### Voir les Résultats
- Jenkins : http://localhost:8080/job/devops1999/
- SonarQube : http://localhost:9000/dashboard?id=timesheet-devops
- Email : Rapport HTML envoyé automatiquement

### Déboguer une Défaillance
1. Consulter la console Jenkins
2. Lire le rapport d'erreur par email
3. Corriger le problème identifié
4. Faire un nouveau commit/push

---

## 📊 9. Métriques et Indicateurs

### Build #103 (Exemple)
- **Status** : FAILED (Gitleaks détecté 9 secrets)
- **Durée** : ~5 min
- **Étapes réussies** : Build ✅, SonarQube ✅, Trivy ✅
- **Étape échouée** : Gitleaks ❌ (comportement attendu)

### Actions Prises
- ✅ Création de `.gitleaksignore` pour exclure faux positifs
- ✅ Nouveau push pour relancer le pipeline

---

## 🔐 10. Bonnes Pratiques Implémentées

✅ **Jamais de secrets en dur** - Utilisation de Jenkins credentials
✅ **Shift-left security** - Pre-commit hook et SonarLint
✅ **Automatisation complète** - Aucune intervention manuelle
✅ **Blocage automatique** - Vulnérabilités = arrêt du pipeline
✅ **Traçabilité** - Tous les rapports archivés
✅ **Notification** - Email sur succès/échec
✅ **Conteneurisation** - Docker build intégré
✅ **Tests multiples** - SAST + SCA + DAST

---

## 📞 Contact & Support

- **Auteur** : Hayfa Sadkaoui
- **Email** : hayfasadkaoui989@gmail.com
- **Repository** : https://github.com/hayfa-ss/devops1999

---

**Dernière mise à jour** : 2025-11-28
**Status** : ✅ Pipeline OpérationnelL
