package controller;

import dao.DBHelper;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Scanner;
import model.Match;
import model.date.DateHelp;
import model.date.DateHelpImpl;
import view.Console;

public class ViewByDay {

  private final ControllerImpl controllerImpl;
  private final DBHelper dbh;
  ViewByDay(ControllerImpl controllerImpl, DBHelper dbh) {
    this.controllerImpl = controllerImpl;
    this.dbh = dbh;
    //Empty Constructor for method call
  }

  public void showByDay() throws ParseException, SQLException {
    Scanner sc = new Scanner(System.in);
    DateHelp dh = new DateHelpImpl();
    Console.showText("Please input the date(YYYY-MM-DD):");
    String date = sc.next();
    int retryTimes = 0;
    while (!dh.isValidDate(date) || dh.isAfterCurrent(dh.stringToDate(date))) {
      if (retryTimes == 3) {
        controllerImpl.mainMenu(controllerImpl);
      }
      Console.showText("Invalid date input. Please input again.");
      date = sc.next();
      retryTimes++;
    }
    ArrayList<Match> matchesByDateArrayList;
    matchesByDateArrayList = dbh.getMatchesByDay(date);
    matchesByDateArrayList.forEach((match) -> {
      Console.showText(match.toString()+"\n");
      Console.showText("Do you want to check the Player Status for this Game?(Y/N)");
      String choice = sc.next();
      if ("Y".equals(choice)) {
        Console.showText(match.playerStatToString()+"\n");
      }
    });
    controllerImpl.mainMenu(controllerImpl);
  }
}
