public class TempVuln2 {
  public void test(String email) throws Exception {
    java.sql.Connection c = null;
    java.sql.Statement stmt = null;
    try {
      stmt = c.createStatement();
      String query = "SELECT * FROM users WHERE email = '" + email + "'";
      stmt.executeQuery(query);
    } finally {
      if (stmt != null) stmt.close();
    }
  }
}
