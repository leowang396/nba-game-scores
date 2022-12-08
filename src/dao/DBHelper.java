package dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import model.Match;
import model.PlayerStat;
import model.PlayerStatBuilder;
import view.Console;

public class DBHelper {

  private static Connection conn;

  /**
   * Constructor of DBHelper Object, to call the methods inside the class.
   * @param url MySQL url
   * @param username MySQL username
   * @param password MySQL password
   */
  public DBHelper(String url, String username, String password) {
    conn = getConn(url, username, password);
  }

  public static Connection getConn(String url, String username, String password)
      throws IllegalStateException {
    try {
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

  /**
   * Return the login status.
   *
   * @param username userName
   * @param password passWord
   * @return the login status. 1=success 0=fail.
   */
  public int login(String username, String password) {
    int result = 0;
    try (
        Statement stmt = conn.createStatement();
        ResultSet rs1 = stmt.executeQuery("SELECT * FROM user")) {
      Map<String,String> userPassMap = new HashMap<>();
      while (rs1.next()) {
        userPassMap.put(rs1.getString("account_name"),rs1.getString("password"));
      }
      if (!userPassMap.containsKey(username)) {
        Console.showText("No such a user.");
      } else if (!userPassMap.get(username).equals(password)) {
        Console.showText("Wrong password.");
      } else {
        result = 1;
      }
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }
    return result;
  }

  /**
   * Get Matches(Games) as an ArrayList by the date.
   * @param date specific date in format "YYYY-MM-DD"
   * @return the matches ArrayList
   */
  public ArrayList<Match> getMatchesByDay(String date) {
    ArrayList<Match> matchesByDayArrayList = new ArrayList<>();
    try {
      Statement stmt = conn.createStatement();
      ResultSet rs1 = stmt.executeQuery("SELECT * FROM game WHERE date = '" + date +"'");
      while (rs1.next()) {
        String tempStadium = rs1.getString("stadium");
        Statement stmt2 = conn.createStatement();
        ResultSet homeTeamResultSet = stmt2.executeQuery(
            "SELECT team_name FROM team WHERE home_stadium = '" + tempStadium +"'");
        homeTeamResultSet.next();
        String teamAName = homeTeamResultSet.getString("team_name");
        int teamAScore = rs1.getInt("home_team_score");
        int teamBScore = rs1.getInt("away_team_score");
        Statement stmt3 = conn.createStatement();
        ResultSet rs2 = stmt3.executeQuery(
            "SELECT team_name FROM plays_in WHERE date = '" + date + "' AND stadium = '"
                + tempStadium + "'");
        String teamBName = null;
        while (rs2.next()) {
          if (!Objects.equals(rs2.getString("team_name"), teamAName)) {
            teamBName = rs2.getString("team_name");
          }
        }

        PlayerStatBuilder psb = new PlayerStatBuilder();
        Statement stmt4 = conn.createStatement();
        ResultSet rs3 = stmt4.executeQuery(
            "SELECT * FROM player_game_stat WHERE date = '" + date + "' AND stadium = '"
                + tempStadium + "'");
        while (rs3.next()) {
          int playerId = rs3.getInt("player_id");
          Statement stmt5 = conn.createStatement();
          ResultSet rs4 = stmt5.executeQuery(
              "SELECT name FROM player WHERE player_id = " + playerId);
          rs4.next();
          String playerName = rs4.getString("name");
          int minutePlayed = rs3.getInt("minutes_played");
          int twoTotal = rs3.getInt("two_total");
          int twoGoal = rs3.getInt("two_goal");
          int threeTotal = rs3.getInt("three_total");
          int threeGoal = rs3.getInt("three_goal");
          int freeTotal = rs3.getInt("free_throw_total");
          int freeGoal = rs3.getInt("free_throw_goal");
          int rebounds = rs3.getInt("rebounds");
          int assists = rs3.getInt("assists");
          int blocks = rs3.getInt("blocks");
          int steals = rs3.getInt("steals");
          psb.add(
              new PlayerStat(
                  playerName,
                  minutePlayed,
                  twoTotal,
                  twoGoal,
                  threeTotal,
                  threeGoal,
                  freeTotal,
                  freeGoal,
                  rebounds,
                  assists,
                  blocks,
                  steals
              )
          );
        }
        ArrayList<PlayerStat> tempPlayerStatArrayList = psb.build();
        psb = new PlayerStatBuilder();
        matchesByDayArrayList.add(
            new Match(
                date,
                teamAName,
                teamBName,
                teamAScore,
                teamBScore,
                tempPlayerStatArrayList
            )
        );
      }
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }

    return matchesByDayArrayList;
  }

//  public ArrayList<Match> getMatchByTeam(String teamName) {
//
//  }

  /**
   * Method to call procedures inside the database to create a new user.
   *
   * @param username username
   * @param password password
   * @throws SQLException when SQL fails
   */
  public void createUser(String username, String password) throws SQLException {
    String createUserQuery = "{CALL create_user(?,?)}";
    try (CallableStatement stmt = conn.prepareCall(createUserQuery)) {
      stmt.setObject("new_account_name",username);
      stmt.setObject("new_password",password);
      ResultSet rs = stmt.executeQuery();
      Console.showText("User created.");
    } catch (SQLException e) {
    Console.showText(e.getMessage());
    }
  }

  public void modifyUser(String oldUsername, String newUsername, String password) {
    String modifyUserQuery = "{CALL update_user(?,?,?)}";
    try (CallableStatement stmt = conn.prepareCall(modifyUserQuery)) {
      stmt.setObject("existing_account_name",oldUsername);
      stmt.setObject("new_account_name",newUsername);
      stmt.setObject("new_password",password);
      ResultSet rs = stmt.executeQuery();
      Console.showText("User modified.");
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }
  }


  /**
   * Method to call procedures inside the database to delete a user.
   *
   * @param username username
   * @throws SQLException when SQL fails
   */
  public void deleteUser(String username) throws SQLException {
    String deleteUserQuery = "{CALL delete_user(?)}";
    try (CallableStatement stmt = conn.prepareCall(deleteUserQuery)) {
      stmt.setObject("existing_account_name",username);
      ResultSet rs = stmt.executeQuery();
      Console.showText("User deleted.");
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }
  }



}
