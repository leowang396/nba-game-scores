package controller;

import dao.DBHelper;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Scanner;
import model.date.DateHelp;
import model.date.DateHelpImpl;
import view.Console;

public class ContributeData {

  private final ControllerImpl controllerImpl;
  private final DBHelper dbh;
  private final DateHelp dh = new DateHelpImpl();

  protected ContributeData(ControllerImpl controllerImpl, DBHelper dbh) {
    this.controllerImpl = controllerImpl;
    this.dbh = dbh;
  }

  protected void mainMenu() throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please select the function to use:\n"
        + "1.Create a new game\n"
        + "2.Update a current game\n"
        + "3.Delete a game\n"
        + "4.Create Player Game Stats\n"
        + "5.Update Player Game Stats\n"
        + "6.Delete Player Game Stats\n"
        + "0.Back to Main menu");
    int choice = sc.nextInt();
    switch (choice) {
      case 1 -> createGame(this);
      case 2 -> modifyGame(this);
      case 3 -> deleteGame(this);
      case 4 -> createPlayerGameStat(this);
      case 5 -> modifyPlayerGameStat(this) ;
      case 6 -> deletePlayerGameStat(this);
      case 0 -> controllerImpl.mainMenu(controllerImpl);
      default -> {
        Console.showText("Invalid choice, please select again.");
        mainMenu();
      }
    }
  }

  private void createGame(ContributeData cd) throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input the game date(YYYY-MM-DD):");
    String date = sc.next();
    sc.nextLine();
    if (!dh.isValidDate(date) || dh.isAfterCurrent(dh.stringToDate(date))) {
      Console.showText("Invalid date.");
      cd.mainMenu();
    }
    Console.showText("Please input the home team name:");
    String homeTeamName = sc.nextLine();
    Console.showText("Please input the score for "+homeTeamName);
    int homeTeamScore = sc.nextInt();
    sc.nextLine();
    Console.showText("Please input the away team name:");
    String awayTeamName = sc.nextLine();
    Console.showText("Please input the score for "+awayTeamName);
    int awayTeamScore = sc.nextInt();
    try {
      dbh.createGame(date,homeTeamName,awayTeamName,homeTeamScore,awayTeamScore);
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }
    cd.mainMenu();
  }

  private void modifyGame(ContributeData cd) throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input the existing game date(YYYY-MM-DD):");
    String oldDate = sc.next();
    sc.nextLine();
    if (!dh.isValidDate(oldDate) || dh.isAfterCurrent(dh.stringToDate(oldDate))) {
      Console.showText("Invalid date.");
      cd.mainMenu();
    }
    Console.showText("Please input the existing game stadium:");
    String oldStadium = sc.nextLine();
    Console.showText("Please input the new date of the game(YYYY-MM-DD)(input #same without modify this):");
    String newDate = sc.next();
    sc.nextLine();
    if ("#same".equals(newDate)) {
      newDate = oldDate;
    }
    if (!dh.isValidDate(newDate) || dh.isAfterCurrent(dh.stringToDate(newDate))) {
      Console.showText("Invalid date.");
      cd.mainMenu();
    }
    Console.showText("Please input the new stadium of the game(input #same without modify this):");
    String newStadium = sc.nextLine();
    if ("#same".equals(newStadium)) {
      newStadium = oldStadium;
    }
    Console.showText("Please input the new score for the home team:");
    int homeTeamScore = sc.nextInt();
    Console.showText("Please input the new score for the away team:");
    int awayTeamScore = sc.nextInt();
    try {
      dbh.modifyGame(oldDate,oldStadium,newDate,newStadium,homeTeamScore,awayTeamScore);
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }
    cd.mainMenu();
  }

  private void deleteGame(ContributeData cd) throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input the date of the game(YYYY-MM-DD):");
    String date = sc.next();
    sc.nextLine();
    if (!dh.isValidDate(date) || dh.isAfterCurrent(dh.stringToDate(date))) {
      Console.showText("Invalid date.");
      cd.mainMenu();
    }
    Console.showText("Please input the stadium of the game:");
    String stadium = sc.nextLine();
    try {
      dbh.deleteGame(date,stadium);
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }
    cd.mainMenu();
  }

  private void createPlayerGameStat(ContributeData cd) throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input the date of the game(YYYY-MM-DD):");
    String date = sc.next();
    sc.nextLine();
    if (!dh.isValidDate(date) || dh.isAfterCurrent(dh.stringToDate(date))) {
      Console.showText("Invalid date.");
      cd.mainMenu();
    }
    Console.showText("Please input the stadium of the game:");
    String stadium = sc.nextLine();
    Console.showText("Please input the Player name:");
    String playerName = sc.nextLine();
    int playerId = dbh.getPlayerIdByName(playerName);
    if (playerId == -1) {
      Console.showText("Invalid name.");
      cd.mainMenu();
    }
    Console.showText("Please input the minutes played of "+playerName);
    int minutePlayed = sc.nextInt();
    Console.showText("Please input the total tries of 2-score balls by "+playerName);
    int twoTotal = sc.nextInt();
    Console.showText("Please input the total goals of 2-score balls by "+playerName);
    int twoGoal = sc.nextInt();
    Console.showText("Please input the total tries of 3-score balls by "+playerName);
    int threeTotal = sc.nextInt();
    Console.showText("Please input the total goals of 3-score balls by "+playerName);
    int threeGoal = sc.nextInt();
    Console.showText("Please input the total tries of free-throw balls by "+playerName);
    int freeTotal = sc.nextInt();
    Console.showText("Please input the total goals of free-throw balls by "+playerName);
    int freeGoal = sc.nextInt();
    Console.showText("Please input the rebounds by "+playerName);
    int rebounds = sc.nextInt();
    Console.showText("Please input the assists by "+playerName);
    int assists = sc.nextInt();
    Console.showText("Please input the blocks by "+playerName);
    int blocks = sc.nextInt();
    Console.showText("Please input the steals by "+playerName);
    int steals = sc.nextInt();
    try {
      dbh.createPlayerGameStat(
          date,
          stadium,
          playerId,
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
      );
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }
    cd.mainMenu();
  }

  private void modifyPlayerGameStat(ContributeData cd) throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input the date of the existing game(YYYY-MM-DD):");
    String oldDate = sc.next();
    sc.nextLine();
    if (!dh.isValidDate(oldDate) || dh.isAfterCurrent(dh.stringToDate(oldDate))) {
      Console.showText("Invalid date.");
      cd.mainMenu();
    }
    Console.showText("Please input the stadium of the existing game:");
    String oldStadium = sc.nextLine();
    Console.showText("Please input the Player name of the existing game:");
    String playerName = sc.nextLine();
    int playerId = dbh.getPlayerIdByName(playerName);
    if (playerId == -1) {
      Console.showText("Invalid name.");
      cd.mainMenu();
    }
    Console.showText("Please input the new date(YYYY-MM-DD)(input #same without modify this)");
    String newDate = sc.next();
    sc.nextLine();
    if ("#same".equals(newDate)) {
      newDate = oldDate;
    }
    if (!dh.isValidDate(newDate) || dh.isAfterCurrent(dh.stringToDate(newDate))) {
      Console.showText("Invalid date.");
      cd.mainMenu();
    }
    Console.showText("Please input the new stadium of the game(input #same without modify this):");
    String newStadium = sc.nextLine();
    if ("#same".equals(newStadium)) {
      newStadium = oldStadium;
    }
    Console.showText("Please input the new Player name(input #same without modify this):");
    String newPlayerName = sc.nextLine();
    int newPlayerId = playerId;
    if ("#same".equals(newPlayerName)){
      newPlayerName = playerName;
    } else {
      newPlayerId = dbh.getPlayerIdByName(newPlayerName);
      if(newPlayerId == -1) {
        Console.showText("Invalid name");
        cd.mainMenu();
      }
    }
    Console.showText("Please input the minutes played for "+newPlayerName);
    int minutesPlayed = sc.nextInt();
    Console.showText("Please input the total tries of 2-score balls by "+newPlayerName);
    int twoTotal = sc.nextInt();
    Console.showText("Please input the total goals of 2-score balls by "+newPlayerName);
    int twoGoal = sc.nextInt();
    Console.showText("Please input the total tries of 3-score balls by "+newPlayerName);
    int threeTotal = sc.nextInt();
    Console.showText("Please input the total goals of 3-score balls by "+newPlayerName);
    int threeGoal = sc.nextInt();
    Console.showText("Please input the total tries of free-throw balls by "+newPlayerName);
    int freeTotal = sc.nextInt();
    Console.showText("Please input the total goals of free-throw balls by "+newPlayerName);
    int freeGoal = sc.nextInt();
    Console.showText("Please input the rebounds by "+newPlayerName);
    int rebounds = sc.nextInt();
    Console.showText("Please input the assists by "+newPlayerName);
    int assists = sc.nextInt();
    Console.showText("Please input the blocks by "+newPlayerName);
    int blocks = sc.nextInt();
    Console.showText("Please input the steals by "+newPlayerName);
    int steals = sc.nextInt();
    try {
      dbh.modifyPlayerGameStat(
          oldDate,
          oldStadium,
          playerId,
          newDate,
          newStadium,
          newPlayerId,
          minutesPlayed,
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
      );
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }
    cd.mainMenu();
  }

  private void deletePlayerGameStat(ContributeData cd) throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input the date of the game(YYYY-MM-DD):");
    String date = sc.next();
    sc.nextLine();
    if (!dh.isValidDate(date) || dh.isAfterCurrent(dh.stringToDate(date))) {
      Console.showText("Invalid date.");
      cd.mainMenu();
    }
    Console.showText("Please input the stadium of the game:");
    String stadium = sc.nextLine();
    Console.showText("Please input the player name:");
    String playerName = sc.nextLine();
    int playerId = dbh.getPlayerIdByName(playerName);
    if (playerId == -1) {
      Console.showText("Invalid name.");
      cd.mainMenu();
    }
    try {
      dbh.deletePlayerGameStat(date,stadium,playerId);
    } catch (SQLException e) {
      Console.showText(e.getMessage());
    }
    cd.mainMenu();
  }

}
