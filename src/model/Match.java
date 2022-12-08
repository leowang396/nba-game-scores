package model;

import java.util.ArrayList;

public class Match {

  private String Date;
  private String teamAName;
  private String teamBName;
  private int teamAScore;
  private int teamBScore;
  private ArrayList<PlayerStat> playerStatArrayList;

  public Match(
      String Date,
      String teamAName,
      String teamBName,
      int teamAScore,
      int teamBScore,
      ArrayList<PlayerStat> playerStatArrayList
  ) {
    this.Date = Date;
    this.teamAName = teamAName;
    this.teamBName = teamBName;
    this.teamAScore = teamAScore;
    this.teamBScore = teamBScore;
    this.playerStatArrayList = playerStatArrayList;
  }

  @Override
  public String toString() {
    StringBuilder output = new StringBuilder();
    output
        .append("Match record for:\n")
        .append(teamAName).append("(home) VS ").append(teamBName).append("(away) at ").append(Date).append("\n")
        .append("Score: ").append(teamAScore).append("-").append(teamBScore).append("\n");
    return output.toString();
  }

  public String playerStatToString() {
    StringBuilder output = new StringBuilder();
    this.playerStatArrayList.forEach((player) -> {
      output.append(player.toString()).append("\n");
    });
    return output.toString();
  }

}


