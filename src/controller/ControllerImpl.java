package controller;

import dao.DBHelper;
import java.sql.Connection;
import java.util.Scanner;
import view.Console;

public class ControllerImpl implements Controller{

  private final String url = "jdbc:mysql://localhost:3306/" + "";
  private Connection conn;

  public ControllerImpl() {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input your username:");
    String username = sc.next();
    Console.showText("Please input your password:");
    String password = sc.next();
    try {
      this.conn = DBHelper
          .getConn(url, username, password);
    } catch (IllegalStateException e) {
      System.out.println(e);
    }
    sc.close();
  }

  private void mainMenu(ControllerImpl controllerImpl) {
    Scanner sc = new Scanner(System.in);

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
  public void go() {
    Controller controllerImpl = new ControllerImpl();
    controllerImpl.Main
  }
}

