# 🔍 Guide: Vérifier SonarLint dans VS Code

## 1️⃣ VÉRIFIER QUE SONARLINT EST INSTALLÉ

### A. Ouvrir l'onglet Extensions
```
Raccourci: Ctrl + Shift + X
ou
Clic sur icône Extensions (gauche)
```

### B. Chercher "SonarLint"
```
Tapez: SonarLint
Vous devez voir:
✅ SonarLint (par SonarSource)
✅ Status: Installed (bleu)
```

### C. Si SonarLint n'est pas installé
```
1. Clic sur "Install" 
2. Attendez 5-10 secondes
3. Recharger VS Code (Ctrl + Shift + P > "Developer: Reload Window")
```

---

## 2️⃣ ACTIVER SONARLINT

### A. Ouvrir Paramètres SonarLint
```
Méthode 1:
1. Ctrl + Shift + X (Extensions)
2. SonarLint > Gear icon (⚙️) > Extension Settings

Méthode 2:
1. Ctrl + , (Settings)
2. Taper: "sonarlint"
3. Clic sur "Edit in settings.json"
```

### B. Configuration de base
```json
{
  "sonarlint.rules": {
    // Activer toutes les règles par défaut
  },
  "sonarlint.ls.enabled": true,
  "sonarlint.connectedMode.enable": false
}
```

### C. Sauvegarder
```
Ctrl + S pour sauvegarder
SonarLint redémarre automatiquement
```

---

## 3️⃣ VÉRIFIER QUE SONARLINT FONCTIONNE

### A. Ouvrir un fichier Java
```
Fichier à analyser:
c:\Users\hayfa\Downloads\timesheet-devops\devops1999\src\main\java\tn\esprit\spring\entity\User.java
```

### B. Regarder le bas à gauche
```
VS Code Status Bar (bas):
Vous devez voir:
✅ "SonarLint: Ready"
ou
✅ "SonarLint: Analyzing..."
```

### C. Onglet "Problems" (Problèmes)
```
Raccourci: Ctrl + Shift + M
ou
Clic sur l'onglet "Problems"

Vous verrez:
- Type: Error / Warning
- Description: Faille détectée
- Ligne: Numéro de la ligne
- Fichier: Chemin du fichier
```

---

## 4️⃣ VOIR LES RÉSULTATS DE SONARLINT

### Exemple: Créer une faille intentionnelle

#### Test 1: SQL Injection Risk
```java
// ❌ CODE VULNERABLE
String query = "SELECT * FROM users WHERE id = " + userId; // ⚠️ SQL Injection
// Soulignage rouge + message SonarLint

// ✅ CODE SÉCURISÉ
String query = "SELECT * FROM users WHERE id = ?";
preparedStatement.setInt(1, userId);
```

**SonarLint affichera**:
```
⚠️ Make sure this SQL query is built safely
   Line: 10, Column: 15
   Rule: java:S2077
```

#### Test 2: XSS Risk (Cross-Site Scripting)
```java
// ❌ CODE VULNERABLE
String html = "<div>" + userInput + "</div>"; // ⚠️ XSS Risk

// ✅ CODE SÉCURISÉ
String html = "<div>" + escape(userInput) + "</div>";
```

**SonarLint affichera**:
```
⚠️ Make sure user input is sanitized before use
   Line: 12, Column: 20
   Rule: java:S2631
```

#### Test 3: Hardcoded Credentials
```java
// ❌ CODE VULNERABLE
String password = "admin123"; // ⚠️ Hardcoded Secret
String apiKey = "sk_live_abcd1234"; // ⚠️ Exposed API Key

// ✅ CODE SÉCURISÉ
String password = System.getenv("DB_PASSWORD");
String apiKey = configuration.getProperty("api.key");
```

**SonarLint affichera**:
```
🔴 BLOCKER: Password hardcoded in source code
   Line: 15, Column: 22
   Rule: java:S2068

🔴 BLOCKER: Remove this hardcoded secret
   Line: 16, Column: 21
   Rule: java:S6418
```

---

## 5️⃣ PANNEAUX DE SONARLINT

### A. Onglet "SonarLint" (Gauche)
```
Clic sur l'icône SonarLint (gauche) → "SonarLint" tab
```

**Affiche**:
```
📊 SONARLINT STATUS
├─ Ready
├─ Files analyzed
├─ Last analysis: 2 minutes ago
└─ Problems found: X issues
   ├─ 🔴 Blocker: X
   ├─ 🟠 Critical: X
   ├─ 🟡 Major: X
   └─ 💙 Minor: X
```

### B. Onglet "Problems" (Bas)
```
Ctrl + Shift + M
```

**Affiche**:
```
PROBLEMS  (Filtrer par fichier/règle)

File: User.java
├─ Line 45: ⚠️ Make sure SQL is built safely (S2077)
├─ Line 67: 🟡 Code smell detected (S1192)
└─ Line 89: 💙 Minor issue (S1150)

File: UserService.java
├─ Line 23: 🔴 Security hotspot (S2068)
└─ Line 45: 🟠 Critical bug (S1163)
```

### C. Issues au-dessus du code
```
❌ Erreur (rouge): Blocker/Critical
⚠️  Warning (orange): Major
💡 Info (bleu): Minor
```

---

## 6️⃣ COMPRENDRE LES CODES D'ERREUR

### Sécurité
```
S2068  - Hardcoded password
S2077  - SQL Injection
S2631  - XSS (Cross-Site Scripting)
S6418  - API Key exposure
S3330  - CSRF vulnerability
S6291  - Sensitive data exposure
```

### Code Quality
```
S1192  - Duplicate strings
S1150  - Unreachable code
S1163  - Throw exception in finally
S1149  - Catch generic exception
```

### Performance
```
S1196  - Inefficient loop
S1197  - Useless assignment
S1065  - Incorrect regex
```

---

## 7️⃣ CORRIGER LES PROBLÈMES

### A. Clic sur l'ampoule (💡) Quick Fix
```
1. Survolez l'erreur
2. Clic sur l'ampoule bleue (💡)
3. Sélectionnez la correction proposée
4. SonarLint applique la fix
```

**Exemple**:
```java
// ❌ Avant
String password = "admin123";

// ✅ Après (Quick Fix)
String password = System.getenv("DB_PASSWORD");
```

### B. Manual Fix
```
1. Lisez le message SonarLint
2. Consultez la documentation (lien dans message)
3. Modifiez le code manuellement
4. Sauvegardez (Ctrl + S)
5. SonarLint ré-analyse automatiquement
```

---

## 8️⃣ DÉMARRAGE RAPIDE - TEST SONARLINT

### Étape 1: Créer un fichier test
```bash
Créer: c:\Users\hayfa\Downloads\timesheet-devops\devops1999\src\main\java\tn\esprit\spring\test\SecurityTest.java
```

### Étape 2: Ajouter du code vulnérable
```java
package tn.esprit.spring.test;

public class SecurityTest {
    
    // ❌ Test 1: Hardcoded Secret
    private String apiKey = "sk_live_12345678"; // SonarLint alerte ici
    
    // ❌ Test 2: SQL Injection
    public void getUserData(String userId) {
        String query = "SELECT * FROM users WHERE id = " + userId; // Alerte ici
    }
    
    // ❌ Test 3: XSS Risk
    public String getUserInput(String input) {
        return "<div>" + input + "</div>"; // Alerte ici
    }
}
```

### Étape 3: Sauvegarder et regarder
```
1. Ctrl + S (Sauvegarder)
2. SonarLint analyse automatiquement
3. Ouvrez Problems (Ctrl + Shift + M)
4. Vous verrez 3 erreurs détectées ✅
```

### Étape 4: Corriger le code
```java
package tn.esprit.spring.test;

public class SecurityTest {
    
    // ✅ Test 1: Secret en env
    private String apiKey = System.getenv("API_KEY");
    
    // ✅ Test 2: Prepared Statement
    public void getUserData(String userId) {
        String query = "SELECT * FROM users WHERE id = ?";
        // Utiliser PreparedStatement
    }
    
    // ✅ Test 3: Sanitized input
    public String getUserInput(String input) {
        String safe = input.replace("<", "&lt;").replace(">", "&gt;");
        return "<div>" + safe + "</div>";
    }
}
```

### Étape 5: Vérifier que les erreurs disparaissent
```
1. Ctrl + S (Sauvegarder)
2. Ouvrez Problems (Ctrl + Shift + M)
3. Les 3 erreurs doivent disparaître ✅
4. Statut SonarLint: "Ready - No issues"
```

---

## 9️⃣ CONFIGURATION AVANCÉE

### A. Connecter à SonarQube Cloud (optionnel)
```
1. Aller dans "SonarLint" settings
2. Activer "Connected Mode"
3. Sélectionner: "SonarQube Cloud"
4. Entrer token SonarQube
5. Lier à votre projet timesheet-devops
6. SonarLint utilisera les mêmes règles que Jenkins
```

### B. Activer/Désactiver des règles
```json
{
  "sonarlint.rules": {
    "java:S2068": "off",    // Désactiver hardcoded password
    "java:S1150": "on",     // Activer unreachable code
    "java:S1192": "off"     // Désactiver duplicate strings
  }
}
```

### C. Ignorer les fichiers
```json
{
  "sonarlint.ls.javaHome": "C:\\Program Files\\Java\\jdk-17",
  "sonarlint.connectedMode.project": "timesheet-devops"
}
```

---

## 🔟 TROUBLESHOOTING

| Problème | Solution |
|----------|----------|
| SonarLint n'apparaît pas | Installer via Ctrl + Shift + X |
| Status: "Idle" | Ouvrir un fichier Java |
| Pas d'erreurs détectées | Vérifier settings.json (enabled: true) |
| Extension plantée | Recharger VS Code |
| Java errors | Vérifier JAVA_HOME configuration |
| Trop d'erreurs | Réduire la sévérité dans settings.json |

---

## 📊 CHECKLIST SONARLINT

```
✅ SonarLint installé (Ctrl + Shift + X)
✅ Extension "Ready" en bas à gauche
✅ Onglet "Problems" visible (Ctrl + Shift + M)
✅ Fichier Java ouvert
✅ Erreurs affichées en temps réel (rouge/orange)
✅ Quick Fix (💡) disponible
✅ Corrections automatiques appliquées
✅ Erreurs disparaissent après correction

= SONARLINT FONCTIONNE PARFAITEMENT ✅
```

---

## 🎯 RÉSULTAT ATTENDU

### Avant correction
```
File: SecurityTest.java
├─ Line 6: 🔴 Remove this hardcoded secret (S6418)
├─ Line 10: 🔴 SQL injection risk (S2077)
└─ Line 14: 🟠 XSS vulnerability (S2631)

Total: 3 Issues (1 Blocker, 1 Critical, 1 Major)
```

### Après correction
```
File: SecurityTest.java
✅ No Issues Found

Total: 0 Issues
SonarLint Status: Ready
```

---

## 💡 ASTUCE

Pour voir tous les problèmes du workspace:
```
1. Ouvrez Problems (Ctrl + Shift + M)
2. Clic sur "Filter" (entonnoir)
3. Sélectionnez "SonarLint"
4. Clic sur "Group by Rule"
5. Vous verrez tous les problèmes groupés par type
```

---

**Status: SonarLint est votre FIRST LINE OF DEFENSE pour la sécurité! 🛡️**
