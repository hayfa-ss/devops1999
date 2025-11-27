package security.demo.secure;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDaoSecure {
    private final Connection connection;

    public UserDaoSecure(Connection connection) {
        this.connection = connection;
    }

    public ResultSet findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, email);
        return ps.executeQuery();
    }
}
