package controller;

import dao.DBHelper;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Scanner;
import model.PlayerStat;
import view.Console;

public class ViewByPlayer {

  private final ControllerImpl controllerImpl;
  private final DBHelper dbh;

  public ViewByPlayer(ControllerImpl controllerImpl, DBHelper dbh) {
    this.controllerImpl = controllerImpl;
    this.dbh = dbh;
  }

  public void showByPlayer() throws SQLException, ParseException {
    Scanner sc = new Scanner(System.in);
    Console.showText("Please input the player name that you want to view:");
    String playerName = sc.nextLine();
    PlayerStat ps;
    try {
      if (dbh.getPlayerIdByName(playerName) == -1) {
        Console.showText("Invalid Player Name.");
        controllerImpl.mainMenu(controllerImpl);
      } else {
        ps = dbh.getPlayerStat(dbh.getPlayerIdByName(playerName));
        Console.showText(ps.toString());
      }
    } catch (SQLException | ParseException e) {
      throw new RuntimeException(e);
    }
    controllerImpl.mainMenu(controllerImpl);
  }
}
