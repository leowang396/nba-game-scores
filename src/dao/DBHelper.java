package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import view.Console;

public class DBHelper {

  private static Connection conn;

  public static Connection getConn (String url, String username, String password) throws IllegalStateException{
    try{
      conn = DriverManager.getConnection(url, username, password);
      Console.showText("Database connect successfully.");
    } catch (SQLException e) {
      throw new IllegalStateException("Cannot connect the database!", e);
    }
    return conn;
  }

  public void closeConn() throws SQLException {
    conn.close();
  }

}
