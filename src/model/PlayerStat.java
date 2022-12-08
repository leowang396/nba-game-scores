package model;

import java.text.DecimalFormat;

public class PlayerStat {

  private final String playerName;
  private final int minutesPlayed;
  private final int twoTotal;
  private final int twoGoal;
  private final int threeTotal;
  private final int threeGoal;
  private final int freeThrowTotal;
  private final int freeThrowGoal;
  private final int rebounds;
  private final int assists;
  private final int blocks;
  private final int steals;

  public PlayerStat(
      String playerName,
      int minutesPlayed,
      int twoTotal,
      int twoGoal,
      int threeTotal,
      int threeGoal,
      int freeThrowTotal,
      int freeThrowGoal,
      int rebounds,
      int assists,
      int blocks,
      int steals
      ) {
    this.playerName = playerName;
    this.minutesPlayed = minutesPlayed;
    this.twoTotal = twoTotal;
    this.twoGoal = twoGoal;
    this.threeTotal = threeTotal;
    this.threeGoal = threeGoal;
    this.freeThrowTotal = freeThrowTotal;
    this.freeThrowGoal = freeThrowGoal;
    this.rebounds = rebounds;
    this.assists = assists;
    this.blocks = blocks;
    this.steals = steals;
  }

  @Override
  public String toString() {
    StringBuilder output = new StringBuilder();
    final DecimalFormat df = new DecimalFormat("0.00");
    output
        .append("Player Name: ").append(playerName).append("\t")
        .append("Minutes Played: ").append(minutesPlayed).append("\n")
        .append("Two Total: ").append(twoTotal).append("\t")
        .append("Two Goal: ").append(twoGoal).append("\t")
        .append("Two Goal Percentage: ").append(df.format(((float)twoGoal/(float)twoTotal)*100)).append("%\n")
        .append("Three Total: ").append(threeTotal).append("\t")
        .append("Three Goal: ").append(threeGoal).append("\t")
        .append("Three Goal Percentage: ").append(df.format(((float)threeGoal/(float)threeTotal)*100)).append("%\n")
        .append("Free Throw Total: ").append(freeThrowTotal).append("\t")
        .append("Free Throw Goal: ").append(freeThrowGoal).append("\t")
        .append("Free Throw Percentage: ").append(df.format(((float)freeThrowGoal/(float)freeThrowTotal)*100)).append("%\n")
        .append("Rebounds: ").append(rebounds).append("\t")
        .append("Blocks: ").append(blocks).append("\n")
        .append("Assists: ").append(assists).append("\t")
        .append("Steals: ").append(steals).append("\n");
    return output.toString();
  }

}
