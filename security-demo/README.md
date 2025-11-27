# Security Demo

This folder contains secure examples and instructions to demonstrate how the pre-commit hook defends against SQL injection and XSS.

## Files
- `secure/UserDaoSecure.java`: Java example using `PreparedStatement` to prevent SQL injection.
- `secure/xss_safe.html`: Example using `textContent` instead of `innerHTML` to avoid XSS.

## How to demonstrate to your professor
1. Show the secure examples in `security-demo/secure/`.
2. Locally, you can create a vulnerable file (not committed) to show the hook blocks it:

```powershell
# Create a vulnerable Java file that concatenates user input into SQL
New-Item test_vuln.java -Value 'public class Test { private String password = "admin123"; }'
# Stage and try to commit
git add test_vuln.java
git commit -m "Test vulnerable code"
# The pre-commit hook will detect the vulnerable pattern and block the commit
```

3. Then show the secure example and explain how `PreparedStatement` or `textContent` mitigate the risks.

> Note: The hook is configured to block obvious hardcoded secrets, API keys, SQL concatenations with `createStatement`, and risky DOM insertion patterns like `innerHTML` or `document.write`.
