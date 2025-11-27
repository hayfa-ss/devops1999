public class TempVuln {
  public void test(String email) {
    String query = "SELECT * FROM users WHERE email = '" + email + "'";
  }
}
