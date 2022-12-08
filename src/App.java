import controller.Controller;
import controller.ControllerImpl;
import java.sql.SQLException;
import java.text.ParseException;

public class App {

  public static void main(String[] args) throws SQLException, ParseException {
    Controller controller = new ControllerImpl();
    controller.go();
  }

}
