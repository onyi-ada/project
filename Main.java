package application;
/*
 * Software Design and Development: Complex Project Management App
 * Developers: Joy Onyerikwu(Lead), Michael Tolitson and Cullen Vaughn
 * November 2015, Clarkson Universiy
 */
	
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.channels.FileChannel;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;


public class Main extends Application {
	Stage primaryStage = new Stage();
	//directory to store gantt charts
	private String gantt_dir = "gantt-charts/";
	//directory to store excel files
	private String excell_dir = "Files/";
	private String file_path;
	private String chart_name;
	//this text file writes the data that matlab needs to read
	//it writes the filename, directory and the name that the chart needs to be saved as
	File from = new File("file_to_open.txt");
	FileWriter writer = null;
	FileChooser filechooser = new FileChooser();
	
	@Override
	public void start(Stage primaryStage) throws InterruptedException, IOException{	
			//make sure file directories exists
			checkDirectories();
		
			primaryStage.setScene(new Scene(createDesign()));
			primaryStage.setTitle("Complex Project Manager");;
			primaryStage.show();
	}
	
	public static void main(String[] args) {
		
		launch(args);
	}
	
	public Parent createDesign() throws IOException{
		GridPane grid = new GridPane();
		ImageView view = new ImageView();
		grid.getStylesheets().add(getClass().getResource("application.css").toExternalForm());
		VBox vbox = new VBox();
		vbox.setPrefSize(600, 450);
		vbox.getStylesheets().add(getClass().getResource("application.css").toExternalForm());
		vbox.getStyleClass().add("hbox");
		
		//hbox for buttons
		HBox hbox = new HBox(40);
		hbox.setPrefSize(30, 30);
		Button upload_btn = new Button("Upload Excel File");
		Button display_gantt = new Button("Display Existing Chart");
		Button import_file = new Button("Add Excel File to Path");
		Button close_app = new Button("Close Application");
		hbox.getChildren().addAll(upload_btn, display_gantt, import_file, close_app);
		//upload an excell file to calculate
		upload_btn.setOnAction(event ->{
			try {
				selectExcelFile();
				runMatlab();
			} catch (Exception e) {
				e.printStackTrace();
			}

			Image gantt = new Image(new File(gantt_dir+chart_name).toURI().toString(),600,450,false,false);
			view.setImage(gantt);

		});
		//display an existing gantt chart already in add
		display_gantt.setOnAction(event ->{
			filechooser.setInitialDirectory(new File(System.getProperty("user.home")));
			File imagename = filechooser.showOpenDialog(new Stage());
			System.out.println(imagename);
			Image image = new Image((imagename).toURI().toString(),600,450,false,false);
			view.setImage(image);
		});
		
		//import file from a different directory
		import_file.setOnAction(event ->{
			filechooser.setInitialDirectory(new File(System.getProperty("user.home")));
			File original = filechooser.showOpenDialog(new Stage());
			File copy = new File(excell_dir + original.getName());
			try {
				copy.createNewFile();
			} catch (Exception e) {
				// File could not be created
				e.printStackTrace();
			}
			
			FileChannel source = null;
			FileChannel dest = null;
			FileInputStream istream;
			FileOutputStream ostream;
			try {
				istream = new FileInputStream(original);
				ostream = new FileOutputStream(copy);
				
				source = istream.getChannel();
				dest = ostream.getChannel();
				dest.transferFrom(source, 0, source.size());
				
				source.close();
				dest.close();
				istream.close();
				ostream.close();
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
		});
		
		//close application
		close_app.setOnAction(event ->{
			Platform.exit();
		});
		
		vbox.getChildren().add(view);
		grid.add(vbox, 1, 0);
		grid.add(hbox, 1, 1);
		grid.setPrefSize(600, 480);
		
		return grid;
	}
	
	//execute matlab code
	public void runMatlab()throws IOException{
		//set up command to call matlab
		String command = "matlab -nodisplay -nosplash -nodesktop -r "
				+ "-wait run('DominantConstraints.m')";
		
		try{
			//call matlab
			Process process;
			process = Runtime.getRuntime().exec(command);
			process.waitFor();
			//clear out contents of the text file
			new PrintWriter("file_to_open.txt").close();
			
		}catch(Throwable t){
			//process could not be started
		}
	}
	
	public void selectExcelFile() throws IOException{
		filechooser.setInitialDirectory(new File(System.getProperty("user.home")));
		String file = filechooser.showOpenDialog(new Stage()).getName();
		file_path = excell_dir + file;
		chart_name = file + "_GanttChart.png";
		
		//set file name to text for matlab to retreive 
		try {
			//if file that stores excell file names does not exists, create it
			if(!from.exists()){
				PrintWriter create= new PrintWriter("file_to_open.txt","UTF-8");
				create.close();
			}
			
			//write excell file name to text file for matlab to retrieve
			writer = new FileWriter(from,true);
			BufferedWriter out = new BufferedWriter(writer);
			out.write(file_path + "|" + gantt_dir + "|" + chart_name);
			out.close();
				
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void checkDirectories(){
		//create new directories to stores needed files
		File charts = new File(gantt_dir);
		File data = new File(excell_dir);
		if(!charts.isDirectory()){
			charts.mkdir();
		}
		if(!data.isDirectory()){
			data.mkdir();
		}
	}
}
