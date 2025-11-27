# 🛡️ Shift-Left Security Guide - Développement Sécurisé Local

## 📌 Objectif
Détecter les failles de sécurité **AVANT de commiter**, directement dans l'IDE et via Git hooks.

---

## 1️⃣ **IDE Sécurisé - VS Code Setup**

### A. Extensions recommandées
```
Extensions à installer (Ctrl + Shift + X):
✅ SonarLint (SonarSource) - Détection statique
✅ GitLens - Visualiser l'historique de sécurité
✅ Code Runner - Exécuter et tester le code
```

### B. Settings pour la sécurité
Ajouter à `.vscode/settings.json`:
```json
{
  "sonarlint.ls.enabled": true,
  "sonarlint.connectedMode.project": {
    "projectKey": "timesheet-devops"
  },
  "[java]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "redhat.java"
  }
}
```

---

## 2️⃣ **Shift-Left avec Git Pre-Commit Hooks**

### A. Comment ça marche?

```
Vous tapez: git commit -m "..."
         ↓
    Git hook s'exécute AVANT
         ↓
    Scanner SAST local
         ↓
    ✅ Pas d'erreurs → Commit accepté
    ❌ Erreurs trouvées → Commit bloqué
```

### B. Qu'est-ce que le hook vérifie?

Le fichier `.git/hooks/pre-commit` scanne automatiquement:

| Check | Détecte | Severité |
|-------|---------|----------|
| **Check 1** | Hardcoded secrets (passwords, API keys, tokens) | 🔴 BLOCKER |
| **Check 2** | SQL string concatenation (SQL Injection risk) | 🟠 CRITICAL |
| **Check 3** | HTML concatenation (XSS vulnerability) | 🟠 CRITICAL |
| **Check 4** | Sensitive data in logs | 🟡 MAJOR |
| **Check 5** | Generic exception handlers | 🟡 MAJOR |

---

## 3️⃣ **Exemple Pratique: Code Vulnérable vs Sécurisé**

### ❌ **CODE VULNÉRABLE** (Le hook le BLOQUERA)

```java
// ❌ Check 1: BLOCKER - Hardcoded Secret
private String apiKey = "sk_live_12345678"; // Detected!

// ❌ Check 2: CRITICAL - SQL Injection
public void getUser(String id) {
    String query = "SELECT * FROM users WHERE id = " + id; // Detected!
}

// ❌ Check 3: CRITICAL - XSS Risk
public String renderUser(String name) {
    return "<div>" + name + "</div>"; // Detected!
}

// ❌ Check 4: MAJOR - Log sensitive data
public void login(String password) {
    System.out.println("Login password: " + password); // Detected!
}

// ❌ Check 5: MAJOR - Generic exception
try {
    doSomething();
} catch (Exception e) { // Detected!
    e.printStackTrace();
}
```

### ✅ **CODE SÉCURISÉ** (Le hook l'ACCEPTERA)

```java
// ✅ Check 1: Secret en variable d'environnement
private String apiKey = System.getenv("API_KEY");

// ✅ Check 2: Prepared Statement (SQL Injection safe)
public void getUser(String id) {
    String query = "SELECT * FROM users WHERE id = ?";
    preparedStatement.setString(1, id);
}

// ✅ Check 3: HTML Escaped (XSS safe)
public String renderUser(String name) {
    String safe = HtmlUtils.htmlEscape(name);
    return "<div>" + safe + "</div>";
}

// ✅ Check 4: Ne pas logger les données sensibles
public void login(String password) {
    System.out.println("Login attempted"); // Safe - no password logged
}

// ✅ Check 5: Exceptions spécifiques
try {
    doSomething();
} catch (SQLException e) { // Specific exception
    log.error("Database error", e);
} catch (IOException e) {
    log.error("IO error", e);
}
```

---

## 4️⃣ **Comment Tester le Hook**

### Étape 1: Créer un fichier vulnérable
```bash
cd c:\Users\hayfa\Downloads\timesheet-devops\devops1999

# Créer un fichier avec une faille intentionnelle
cat > test_vulnerable.java << 'EOF'
public class Test {
    private String password = "admin123"; // Hardcoded secret
}
EOF
```

### Étape 2: Essayer de commiter
```bash
git add test_vulnerable.java
git commit -m "Test vulnerable code"
```

### Résultat attendu:
```
🔍 Running Shift-Left Security Scans...
📋 Files to scan:
test_vulnerable.java

🔐 [Check 1] Scanning for hardcoded secrets...
  ❌ BLOCKER in test_vulnerable.java: Hardcoded secret detected!
  1: private String password = "admin123";

❌ SECURITY SCAN FAILED: 1 issue(s) found!

⚙️  HOW TO FIX:
1. Fix the security issues in your code
2. Stage the fixed files: git add <file>
3. Try committing again
```

### Étape 3: Corriger et recommiter
```bash
# Corriger le fichier
cat > test_vulnerable.java << 'EOF'
public class Test {
    private String password = System.getenv("DB_PASSWORD");
}
EOF

git add test_vulnerable.java
git commit -m "Fix security issues"
```

### Résultat:
```
✅ SECURITY SCAN PASSED: No obvious issues found!
[main xxxxx] Fix security issues
```

---

## 5️⃣ **Contourner le Hook (Pas recommandé)**

Si tu DOIS commiter du code vulnérable (dev/test):
```bash
git commit --no-verify -m "Temp: Skip security checks"
```

⚠️ **NE LE FAIS QUE EN CAS D'URGENCE!**

---

## 6️⃣ **Flux DevSecOps Complet (Shift-Left)**

```
┌─────────────────────────────────────────┐
│  1. Developer writes code in VS Code    │
│     (SonarLint shows issues in real-time)
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  2. Developer stages files              │
│     git add file.java                   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  3. Pre-Commit Hook runs LOCALLY        │ ← SHIFT-LEFT
│     ✅ Checks: secrets, SQL, XSS, logs │
│     ❌ If issues → Commit BLOCKED       │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  4. Developer fixes issues locally      │
│     Code is secure BEFORE pushing       │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  5. Developer pushes to GitHub          │
│     git push origin main                │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  6. GitHub Webhook triggers Jenkins     │
│     Build #N+1 starts                   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  7. Jenkins runs FULL PIPELINE          │
│     ✅ Build (Maven)                   │
│     ✅ SAST (SonarQube)                │
│     ✅ SCA (Trivy)                     │
│     ✅ Secrets (Gitleaks)              │
│     ✅ DAST (OWASP ZAP)                │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  8. Email report sent to developers     │
│     Results visible on dashboards       │
└─────────────────────────────────────────┘
```

---

## 7️⃣ **Best Practices - Développement Sécurisé**

### ✅ DO:
```java
// ✅ Use environment variables for secrets
String dbPassword = System.getenv("DB_PASSWORD");

// ✅ Use PreparedStatement for queries
PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
ps.setInt(1, userId);

// ✅ Escape HTML output
String safe = HtmlUtils.htmlEscape(userInput);
model.addAttribute("name", safe);

// ✅ Use specific exceptions
try {
    connectToDatabase();
} catch (SQLException e) {
    log.error("Database connection failed", e);
}

// ✅ Validate user input
if (userId == null || userId.isEmpty()) {
    throw new IllegalArgumentException("User ID required");
}

// ✅ Log security events (without sensitive data)
log.info("User login attempt from IP: " + ipAddress);
```

### ❌ DON'T:
```java
// ❌ Hardcoded secrets
String password = "admin123";

// ❌ String concatenation in SQL
String query = "SELECT * FROM users WHERE id = " + id;

// ❌ Unescaped user input in HTML
String html = "<div>" + userInput + "</div>";

// ❌ Generic exception handling
try { ... } catch (Exception e) { }

// ❌ No input validation
user.setId(userId); // Could be null!

// ❌ Logging sensitive data
log.info("User password: " + password);
```

---

## 8️⃣ **Sensibilisation Développeurs**

### Points clés à retenir:

1. **Secrets**: JAMAIS en dur → Toujours en env variables
2. **SQL**: JAMAIS de concaténation → PreparedStatement
3. **XSS**: JAMAIS de HTML brut → Toujours escape
4. **Logs**: JAMAIS de données sensibles
5. **Exceptions**: Toujours SPÉCIFIQUES
6. **Input**: TOUJOURS valider

### Audit de sécurité personnel:
Avant chaque commit, demandez-vous:
```
☐ Ai-je des secrets en dur?
☐ Ai-je des requêtes SQL concaténées?
☐ Ai-je du contenu utilisateur en HTML?
☐ Ai-je loggé des données sensibles?
☐ Ai-je gérées les exceptions correctement?
☐ Ai-je validé l'input utilisateur?
```

Si OUI à une question → **Corriger AVANT de commiter!**

---

## 9️⃣ **Commandes Utiles**

```bash
# Voir le hook pré-commit
cat .git/hooks/pre-commit

# Modifier le hook
nano .git/hooks/pre-commit

# Rendre le hook exécutable (Linux/Mac)
chmod +x .git/hooks/pre-commit

# Tester directement (Windows - bash)
bash .git/hooks/pre-commit

# Vérifier les fichiers qui seront commitées
git diff --cached

# Faire un commit sans passer par le hook (D'URGENCE!)
git commit --no-verify -m "Message"
```

---

## 🔟 **Intégration Continue (CI/CD)**

Après avoir fixé les problèmes localement:

```bash
# Push vers GitHub
git push origin main

# Jenkins s'auto-déclenche
# → Build #N+1 commence
# → Tous les scans s'exécutent (SAST, SCA, Secrets, DAST)
# → Email avec résultats reçu

# Voir les résultats:
# 1. SonarQube: http://localhost:9000/dashboard?id=timesheet-devops
# 2. Jenkins: http://localhost:8080/job/devops1999/
# 3. Email: hayfasadkaoui989@gmail.com
```

---

## ✅ **Checklist Shift-Left Complète**

```
✅ VS Code installé
✅ SonarLint extension installée
✅ .vscode/settings.json configuré
✅ Git pre-commit hook en place
✅ Hook bloque les codes vulnérables
✅ Développeurs sensibilisés aux bonnes pratiques
✅ Secrets gérés via env variables
✅ SQL queries utilisant PreparedStatement
✅ HTML output échappé
✅ Exceptions gérées spécifiquement
✅ Input utilisateur validé

= SHIFT-LEFT COMPLET ET OPÉRATIONNEL ✅
```

---

**Status: SHIFT-LEFT SECURITY IMPLÉMENTÉE! 🛡️**

Tous les problèmes sont détectés LOCALEMENT avant même d'atteindre Jenkins/SonarQube!
