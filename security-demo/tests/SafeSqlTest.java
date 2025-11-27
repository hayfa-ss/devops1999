public class SafeSqlTest {
    public void findByEmail(String email, java.sql.Connection connection) throws java.sql.SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (java.sql.PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // safe: process result set without embedding input into SQL
                }
            }
        }
    }
}
