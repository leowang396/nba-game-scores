package model.date;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

/**
 * The type Date help.
 */
public class DateHelpImpl implements DateHelp {

  @Override
  public Date stringToDate(String dateString) throws ParseException {
    DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    return formatter.parse(dateString);
  }

  @Override
  public boolean isValidDate(String dateString) {
    int length = 10;
    if ((dateString == null) || (dateString.length() != length)) {
      return false;
    }

    DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    try {
      Date date = formatter.parse(dateString);
      return dateString.equals((formatter.format(date)));
    } catch (Exception e) {
      return false;
    }
  }

  @Override
  public boolean isAfterCurrent(Date date) {
    // get current date
    Date curDate = new Date();
    return (date.after(curDate));
  }

  /**
   * get the date which before the specific date.
   *
   * @param date the input date
   * @return the date that before one date of input date e.g. the input date is 2022-10-21 then
   * return is 2022-10-22
   */
  @Override
  public Date getBeforeDay(Date date) {
    Calendar calendar = Calendar.getInstance();
    calendar.setTime(date);
    calendar.add(Calendar.DAY_OF_MONTH, -1);
    return calendar.getTime();
  }

  /**
   * get the date which after the specific date.
   *
   * @param date the input date
   * @return the date that after one date of input date e.g. the input date is 2022-10-21 then
   * return is 2022-10-22
   */
  @Override
  public Date getAfterDay(Date date, int n) {
    Calendar calendar = Calendar.getInstance();
    calendar.setTime(date);
    calendar.add(Calendar.DAY_OF_MONTH, n);
    return calendar.getTime();
  }

  /**
   * convert the date type to String.
   *
   * @param date the specific day
   * @return the String type of date
   */
  @Override
  public String dateToString(Date date) {
    DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    return format.format(date);
  }

  /**
   * get the date which is the last day of month.
   *
   * @param date the input date
   * @return the date is the last day of month
   */
  @Override
  public String getLastDayOfMonth(Date date) {
    String dateString = new DateHelpImpl().dateToString(date);
    LocalDate convertedDate = LocalDate.parse(dateString, DateTimeFormatter.ofPattern("yyyy-M-d"));
    convertedDate = convertedDate.withDayOfMonth(
            convertedDate.getMonth().length(convertedDate.isLeapYear()));
    return convertedDate.toString();
  }

  /**
   * get the date which is the last day of year.
   *
   * @param date the input date
   * @return the date is the last day of year
   */
  @Override
  public String getLastDayOfYear(Date date) {
    LocalDate localDate = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    LocalDate lastDayOfYear = localDate.with(TemporalAdjusters.lastDayOfYear());
    return lastDayOfYear.toString();
  }

  /**
   * calculate how many dates between the date1 and date2.
   *
   * @param date1 one of date that want to be calculated
   * @param date2 another date that want to be calculated
   * @return the number of days which between the date1 and date2
   */
  @Override
  public int getBetweenDays(Date date1, Date date2) {
    Calendar cal = Calendar.getInstance();
    cal.setTime(date1);
    long time1 = cal.getTimeInMillis();
    cal.setTime(date2);
    long time2 = cal.getTimeInMillis();
    long betweenDays = (time2 - time1) / (1000 * 3600 * 24);
    return Integer.parseInt(String.valueOf(betweenDays));
  }

  /**
   * calculate how many months between the date1 and date2.
   *
   * @param date1 one of date that want to be calculated
   * @param date2 another date that want to be calculated
   * @return the number of months which between the date1 and date2
   */
  @Override
  public int getBetweenMonths(Date date1, Date date2) throws ParseException {
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    Calendar startDate = Calendar.getInstance();
    Calendar endDate = Calendar.getInstance();
    startDate.setTime(format.parse(new DateHelpImpl().dateToString(date1)));
    endDate.setTime(format.parse(new DateHelpImpl().dateToString(date2)));
    int result = getBetweenYears(date1, date2) * 12 + endDate.get(Calendar.MONTH) - startDate.get(
            Calendar.MONTH);
    return result == 0 ? 1 : Math.abs(result);
  }

  /**
   * calculate how many years between the date1 and date2.
   *
   * @param date1 one of date that want to be calculated
   * @param date2 another date that want to be calculated
   * @return the number of years which between the date1 and date2
   */
  @Override
  public int getBetweenYears(Date date1, Date date2) throws ParseException {
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    Calendar startDate = Calendar.getInstance();
    Calendar endDate = Calendar.getInstance();
    startDate.setTime(format.parse(new DateHelpImpl().dateToString(date1)));
    endDate.setTime(format.parse(new DateHelpImpl().dateToString(date2)));
    return (endDate.get(Calendar.YEAR) - startDate.get(Calendar.YEAR));
  }

  /**
   * get current date by format: "yyyy-MM-dd".
   *
   * @return the current date
   */
  @Override
  public Date getCurrentDate() throws ParseException {
    Date date = new Date();
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    return new DateHelpImpl().stringToDate(formatter.format(date));
  }


}
