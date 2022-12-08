package controller;

import dao.DBHelper;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Scanner;
import view.Console;

public class UserAdmin {

  private final ControllerImpl controllerImpl;
  private final DBHelper dbh;

  public UserAdmin(ControllerImpl controllerImpl, DBHelper dbh) {
    this.controllerImpl = controllerImpl;
    this.dbh = dbh;
  }

  public void mainMenu() throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please select the function for user:\n"
        + "1.Create a new user\n"
        + "2.Modify a current user\n"
        + "3.Delete a user\n"
        + "0.Back to Main menu");
    int choice = sc.nextInt();
    switch (choice) {
      case 1 -> createUser(this);
      case 2 -> modifyUser(this);
      case 3 -> deleteUser(this);
      case 0 -> controllerImpl.mainMenu(controllerImpl);
      default -> {
        Console.showText("Invalid choice, please select again.");
        mainMenu();
      }
    }
  }

  private void createUser(UserAdmin userAdmin) throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input the username:");
    String username = sc.next();
    Console.showText("Please set the password for user "+username);
    String password = sc.next();
    try {
      dbh.createUser(username,password);
    } catch (SQLException e) {
      Console.showText("Something wrong happened in UserAdmin/createUser:" + e.getMessage());
    }
    userAdmin.mainMenu();
  }

  private void modifyUser(UserAdmin userAdmin) throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input the username that you want to modify:");
    String oldUsername = sc.next();
    Console.showText("Please set the new username for user "+ oldUsername);
    String newUsername = sc.next();
    Console.showText("Please set the password for user "+ newUsername);
    String password = sc.next();
    dbh.modifyUser(oldUsername,newUsername,password);
    userAdmin.mainMenu();
  }

  private void deleteUser(UserAdmin userAdmin) throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input the username:");
    String username = sc.next();
    try {
      dbh.deleteUser(username);
    } catch (SQLException e) {
      Console.showText("Something wrong happened in UserAdmin/deleteUser:" + e.getMessage());
    }
    userAdmin.mainMenu();
  }

}
