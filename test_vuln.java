// Fichier de test vulnérable pour démonstration
public class test_vuln {
    public static void main(String[] args) {
        String secret = "password123"; // Ceci est une vulnérabilité volontaire
        System.out.println("Vulnerable file committed: " + secret);
    }
}
