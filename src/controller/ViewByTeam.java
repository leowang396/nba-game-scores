package controller;

import dao.DBHelper;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Scanner;
import model.Match;
import view.Console;

public class ViewByTeam {

  private final ControllerImpl controllerImpl;
  private final DBHelper dbh;

  protected ViewByTeam(ControllerImpl controllerImpl, DBHelper dbh) {
    this.controllerImpl = controllerImpl;
    this.dbh = dbh;
  }

  public void showByTeam() throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input the team name:");
    String teamName = sc.nextLine();
    ArrayList<Match> matchesByTeamArrayList = dbh.getMatchByTeam(teamName);
    matchesByTeamArrayList.forEach((match) -> {
      Console.showText(match.toString());
      Console.showText("Do you want to check the Player Status for this Game?(Y/N)");
      String choice = sc.next();
      if ("Y".equals(choice)) {
        Console.showText(match.playerStatToString()+"\n");
      }
    });
    controllerImpl.mainMenu(controllerImpl);
  }
}
