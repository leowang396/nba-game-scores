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

  public ArrayList<Match> getMatchByTeam(String teamName) {
    ArrayList<Match> matchesByTeamArrayList = new ArrayList<>();
    String getMatchesByTeamQuery = "{CALL all_games(?)}";
    try (CallableStatement stmt = conn.prepareCall(getMatchesByTeamQuery)) {
      stmt.setObject("input_team_name",teamName);
      ResultSet rs = stmt.executeQuery();
      while (rs.next()) {
        String tempStadium = rs.getString("stadium");
        Statement stmt2 = conn.createStatement();
        ResultSet homeTeamResultSet = stmt2.executeQuery(
            "SELECT team_name FROM team WHERE home_stadium = '" + tempStadium +"'");
        homeTeamResultSet.next();
        String teamAName = homeTeamResultSet.getString("team_name");
        int teamAScore = rs.getInt("home_team_score");
        int teamBScore = rs.getInt("away_team_score");
        String date = rs.getString("date");
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
        matchesByTeamArrayList.add(
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


    return matchesByTeamArrayList;
  }

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
    Console.showText("Create User Error: "+e.getMessage());
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
      Console.showText("Modify User Error: "+ e.getMessage());
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
      Console.showText("Delete User Error: "+e.getMessage());
    }
  }


  public void createGame(
      String date,
      String homeTeamName,
      String awayTeamName,
      int homeTeamScore,
      int awayTeamScore
  ) throws SQLException {
    String createGameQuery = "{CALL create_game(?,?,?,?,?)}";
    try (CallableStatement stmt = conn.prepareCall(createGameQuery)) {
      stmt.setObject("date",date);
      stmt.setObject("home_team_name",homeTeamName);
      stmt.setObject("away_team_name",awayTeamName);
      stmt.setObject("home_team_score",homeTeamScore);
      stmt.setObject("away_team_score",awayTeamScore);
      ResultSet rs = stmt.executeQuery();
      Console.showText("Game created.");
    } catch (SQLException e) {
      Console.showText("Create Game Error: "+e.getMessage());
    }
  }

  public void modifyGame(
      String oldDate,
      String oldStadium,
      String newDate,
      String newStadium,
      int homeTeamScore,
      int awayTeamScore
  ) throws SQLException {
    String modifyGameQuery = "{CALL update_game(?,?,?,?,?,?)}";
    try (CallableStatement stmt = conn.prepareCall(modifyGameQuery)) {
      stmt.setObject("existing_date",oldDate);
      stmt.setObject("existing_stadium",oldStadium);
      stmt.setObject("new_date",newDate);
      stmt.setObject("new_stadium",newStadium);
      stmt.setObject("new_home_team_score",homeTeamScore);
      stmt.setObject("new_away_team_score",awayTeamScore);
      ResultSet rs = stmt.executeQuery();
      Console.showText("Game modified.");
    } catch (SQLException e) {
      Console.showText("Modify Game Error: "+e.getMessage());
    }
  }

  public void deleteGame(
      String date,
      String stadium
  ) throws SQLException {
    String deleteGameQuery = "{CALL delete_game(?,?)}";
    try (CallableStatement stmt = conn.prepareCall(deleteGameQuery)) {
      stmt.setObject("existing_date",date);
      stmt.setObject("existing_stadium",stadium);
      ResultSet rs = stmt.executeQuery();
      Console.showText("Game deleted.");
    } catch (SQLException e) {
      Console.showText("Delete Game Error: "+e.getMessage());
    }
  }


  public void createPlayerGameStat(
      String date,
      String stadium,
      int playerId,
      int minutesPlayed,
      int twoTotal,
      int twoGoal,
      int threeTotal,
      int threeGoal,
      int freeTotal,
      int freeGoal,
      int rebounds,
      int assists ,
      int blocks ,
      int steals
  ) throws SQLException {
    String createPGSQuery = "{CALL create_player_game_stat(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
    try (CallableStatement stmt = conn.prepareCall(createPGSQuery)) {
      stmt.setObject("date", date);
      stmt.setObject("stadium", stadium);
      stmt.setObject("player_id", playerId);
      stmt.setObject("minutes_played", minutesPlayed);
      stmt.setObject("two_total", twoTotal);
      stmt.setObject("two_goal", twoGoal);
      stmt.setObject("three_total", threeTotal);
      stmt.setObject("three_goal", threeGoal);
      stmt.setObject("free_throw_total", freeTotal);
      stmt.setObject("free_throw_goal", freeGoal);
      stmt.setObject("rebounds", rebounds);
      stmt.setObject("assists", assists);
      stmt.setObject("blocks", blocks);
      stmt.setObject("steals", steals);
      ResultSet rs = stmt.executeQuery();
      Console.showText("Player Game Stat created.");

    } catch (SQLException e) {
      Console.showText("Create Play Game Stat Error: " + e.getMessage());
    }
  }

  public void modifyPlayerGameStat(
      String oldDate,
      String oldStadium,
      int oldPlayerId,
      String newDate,
      String newStadium,
      int newPlayerId,
      int minutesPlayed,
      int twoTotal,
      int twoGoal,
      int threeTotal,
      int threeGoal,
      int freeTotal,
      int freeGoal,
      int rebounds,
      int assists ,
      int blocks ,
      int steals
  ) throws SQLException {
    String modifyPGSQuery = "{CALL update_player_game_stat(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
    try (CallableStatement stmt = conn.prepareCall(modifyPGSQuery)) {
      stmt.setObject("existing_date", oldDate);
      stmt.setObject("existing_stadium", oldStadium);
      stmt.setObject("existing_player_id", oldPlayerId);
      stmt.setObject("new_date", newDate);
      stmt.setObject("new_stadium", newStadium);
      stmt.setObject("new_player_id", newPlayerId);
      stmt.setObject("new_minutes_played", minutesPlayed);
      stmt.setObject("new_two_total", twoTotal);
      stmt.setObject("new_two_goal", twoGoal);
      stmt.setObject("new_three_total", threeTotal);
      stmt.setObject("new_three_goal", threeGoal);
      stmt.setObject("new_free_throw_total", freeTotal);
      stmt.setObject("new_free_throw_goal", freeGoal);
      stmt.setObject("new_rebounds", rebounds);
      stmt.setObject("new_assists", assists);
      stmt.setObject("new_blocks", blocks);
      stmt.setObject("new_steals", steals);
      ResultSet rs = stmt.executeQuery();
      Console.showText("Player Game Stat modified.");
    } catch (SQLException e) {
      Console.showText("Modify Play Game Stat Error: " + e.getMessage());
    }
  }

  public void deletePlayerGameStat(
      String date,
      String stadium,
      int playerId
  ) throws SQLException {
    String deletePGSQuery = "{CALL delete_player_game_stat(?,?,?)}";
    try (CallableStatement stmt = conn.prepareCall(deletePGSQuery)) {
      stmt.setObject("existing_date", date);
      stmt.setObject("existing_stadium",stadium);
      stmt.setObject("existing_player_id",playerId);
      ResultSet rs = stmt.executeQuery();
      Console.showText("Player Game Stat deleted.");
    } catch (SQLException e) {
      Console.showText("Delete Play Game Stat Error: " + e.getMessage());
    }
  }

  public String getPlayerNameById(int playerId) {
    String playerName = "";
    try (Statement stmt = conn.createStatement();
        ResultSet rs1 = stmt.executeQuery("SELECT name FROM player WHERE player_id = " +playerId)) {
      rs1.next();
      playerName = rs1.getString("name");
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }
    return playerName;
  }


  public int getPlayerIdByName(String playerName) {
    int playerId = -1;
    try (
        Statement stmt = conn.createStatement();
        ResultSet rs1 = stmt.executeQuery("SELECT player_id FROM player WHERE name = '" +playerName +"'")) {
      rs1.next();
      playerId = rs1.getInt("player_id");
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }
    return playerId;
  }

  public PlayerStat getPlayerStat(int playerId) {
    String getPlayerStatQuery = "{CALL player_game_avg(?)}";
    PlayerStat ps = null;
    try (CallableStatement stmt = conn.prepareCall(getPlayerStatQuery)) {
      stmt.setObject("input_player_id", playerId);
      ResultSet rs = stmt.executeQuery();
      rs.next();
      ps = new PlayerStat(
          getPlayerNameById(playerId),
          rs.getInt(1),
          rs.getInt(2),
          rs.getInt(3),
          rs.getInt(4),
          rs.getInt(5),
          rs.getInt(6),
          rs.getInt(7),
          rs.getInt(8),
          rs.getInt(9),
          rs.getInt(10),
          rs.getInt(11)
      );
    } catch (SQLException e) {
      Console.showText("Get Player Stat Error: "+e.getMessage());
    }
    return ps;
  }


}
