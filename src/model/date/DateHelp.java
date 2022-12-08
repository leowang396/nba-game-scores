package model.date;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;

/**
 * The interface of DateHelp, provides date format related functions.
 */
public interface DateHelp {

  /**
   * convert the string type of date to date type.
   *
   * @param dateString the date as in string as in format of "yyyy-MM-dd"
   * @return the date type object as in format of "yyyy-MM-dd"
   */
  Date stringToDate(String dateString) throws ParseException;

  /**
   * check the format of date. the format should be "yyyy-mm-dd" 2022-2-30 is Invalid 2003-2-29 is
   * Invalid.
   *
   * @param dateString the date that input
   * @return if valid return true,
   */
  boolean isValidDate(String dateString);

  /**
   * If is the date is after today.
   * @param date the input date
   * @return if input date is after current date, return true otherwise, return false
   */
  boolean isAfterCurrent(Date date);

  /**
   * get the date which before the specific date.
   *
   * @param date the input date
   * @return the date that before one date of input date e.g. the input date is 2022-10-21 then
   *     return is 2022-10-22
   */
  Date getBeforeDay(Date date);

  /**
   * get the date which after the specific date.
   *
   * @param date the input date
   * @return the date that after one date of input date e.g. the input date is 2022-10-21 then
   *     return is 2022-10-20
   */
  Date getAfterDay(Date date, int n);

  /**
   * convert the date type to String.
   *
   * @param date the specific day
   * @return the String type of date
   */
  String dateToString(Date date);

  /**
   * get the date which is the last day of month.
   *
   * @param date the input date
   * @return the date is the last day of month
   */
  String getLastDayOfMonth(Date date);

  /**
   * get the date which is the last day of year.
   *
   * @param date the input date
   * @return the date is the last day of year
   */
  String getLastDayOfYear(Date date);


  /**
   * calculate how many dates between the date1 and date2.
   *
   * @param date1 one of date that want to be calculated
   * @param date2 another date that want to be calculated
   * @return the number of days which between the date1 and date2
   */
  int getBetweenDays(Date date1, Date date2);

  /**
   * calculate how many months between the date1 and date2.
   *
   * @param date1 one of date that want to be calculated
   * @param date2 another date that want to be calculated
   * @return the number of months which between the date1 and date2
   */
  int getBetweenMonths(Date date1, Date date2) throws ParseException;

  /**
   * calculate how many years between the date1 and date2.
   *
   * @param date1 one of date that want to be calculated
   * @param date2 another date that want to be calculated
   * @return the number of years which between the date1 and date2
   */
  int getBetweenYears(Date date1, Date date2) throws ParseException;

  /**
   * get current date by format: "yyyy-MM-dd".
   *
   * @return the current date
   */
  Date getCurrentDate() throws ParseException;


}
