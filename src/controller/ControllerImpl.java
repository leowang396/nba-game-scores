package controller;

import dao.DBHelper;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Scanner;
import view.Console;

public class ControllerImpl implements Controller{

  private final String url = "jdbc:mysql://localhost:3306/" + "nba_game_scores";
  private final DBHelper dbh = new DBHelper(url,"java","password");

  public ControllerImpl() {
  }

  protected void mainMenu(ControllerImpl controllerImpl) throws ParseException, SQLException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please select the function that you want to use:\n"
        + "1.View data by Day\n"
        + "2.View data by Team\n"
        + "3.View data by Player\n"
        + "4.Contribute on data\n"
        + "9.User Administration\n"
        + "0.Exit the program");
    int choice = sc.nextInt();
    switch (choice) {
      case 1 -> new ViewByDay(this,dbh).showByDay();
      case 2 -> new ViewByTeam(this,dbh).showByTeam();
      case 3 -> new ViewByPlayer(this,dbh).showByPlayer();
      case 4 -> new ContributeData(this,dbh).mainMenu();
      case 9-> new UserAdmin(this,dbh).mainMenu();
      case 0 -> exit();
      default -> {
        Console.showText("Invalid choice, please select again.");
        mainMenu(this);
      }
    }
  }

  /**
   * Function to show the status viewed by day.
   */
  private void viewByDay(Connection conn) {

  }

  /**
   * Function to show the status viewed by a specific team.
   */
  private void viewByTeam(Connection conn) {

  }

  /**
   * Function to show the status viewed by a specific player.
   */
  private void viewByPlayer(Connection conn) {

  }

  @Override
  public void go() throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input your username:");
    String username = sc.next();
    Console.showText("Please input your password:");
    String password = sc.next();
    int retryTimes = 0;
    while (dbh.login(username,password) == 0) {
      if (retryTimes == 5) {
        Console.showText("Retry failed too many times.");
        this.exit();
      }
      Console.showText("Please input your username:");
      username = sc.next();
      Console.showText("Please input your password:");
      password = sc.next();
      retryTimes++;
    }
    Console.showText("Login success!");
    mainMenu(this);
    //controllerImpl.Main
  }

  public void exit() throws SQLException {
    dbh.closeConn();
    System.exit(0);
  }
}

