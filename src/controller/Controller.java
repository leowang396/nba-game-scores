package controller;

import java.sql.SQLException;
import java.text.ParseException;

/**
 * Controller Interface to define methods to be used in controller.
 */
public interface Controller {

  /**
   * Initial entrance to the program.
   */
  void go() throws SQLException, ParseException;

}
