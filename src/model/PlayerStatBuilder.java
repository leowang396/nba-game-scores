package model;

import java.util.ArrayList;

public class PlayerStatBuilder {

  private ArrayList<PlayerStat> playerStatArrayList;

  public PlayerStatBuilder() {
    playerStatArrayList = new ArrayList<>();
  }

  public PlayerStatBuilder add(PlayerStat playerStat) {
    this.playerStatArrayList.add(playerStat);
    return this;
  }

  public ArrayList<PlayerStat> build() {
    return this.playerStatArrayList;
  }

}
