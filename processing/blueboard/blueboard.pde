import http.requests.*;
import processing.serial.*;

String weatherAPI = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22university%20of%20twente%2C%20enschede%22)&format=json";
JSONObject weatherData;
// String jsonString = "{ \"gender\": \"male\", \"technology\": 2, \"fashion\": 4, \"food\": 4 }";
// String jsonString = "iphone\n";
String previousPreference = null;
Serial IO;
String[] adCategories = {};
String[] adBiases = {};
// PImage[] adImages;
PImage ADIMAGE;
float weatherSize = 14;
int loopNumber = 0;
String previous = "generic";

void updateWeather() {
	GetRequest get = new GetRequest(weatherAPI);
	get.send();
	try {
		weatherData = parseJSONObject(get.getContent()).getJSONObject("query").getJSONObject("results").getJSONObject("channel").getJSONObject("item").getJSONObject("condition");
	} catch(RuntimeException e) {
		println("Error parsing Yahoo! Weather JSON");
	}
}

void setup() {
	fullScreen();
	weatherSize = float(height > width ? width : height) / 35;
	IO = new Serial(this, Serial.list()[2], 9600);
	updateWeather();
	// Find available categories from ads folder
	File file = new File(sketchPath() + "/data/ads");
	for (int i = 0; i < file.list().length; i++) {
		File subFile = new File(sketchPath() + "/data/ads/" + file.list()[i]);
		// Make sure it's a directory containing samples
		// if (subFile.isDirectory()) {
			adCategories = append(adCategories, subFile.getName());
		// }
	}
	ADIMAGE = loadImage("ads/" + "technology" + "/" + int(random(0, 5)) + ".jpg");
	// adImages = new PImage[adCategories.length];
	// for (int i = 0; i < adCategories.length; i++) {
	// 	adImages[i] = loadImage("ads/" + adCategories[i]);
	// }
}

String nowImage = "generic";
int done = 0;
void draw() {
	background(100);
	if (IO.available() > 0) {
		String jsonString = IO.readString();
		if (jsonString != null) {
			JSONObject json = null;
			try {
				json = parseJSONObject(jsonString);
				String gender = json.getString("gender");
				int technologyPoints = json.getInt("technology");
				technologyPoints = technologyPoints > 10 ? 10 : technologyPoints;
				int fashionPoints = json.getInt("fashion");
				fashionPoints = fashionPoints > 10 ? 10 : fashionPoints;
				int foodPoints = json.getInt("food");
				foodPoints = foodPoints > 10 ? 10 : foodPoints;
				for (int i = 0; i < technologyPoints; i++) {
					adBiases = append(adBiases, "technology");
				}
				for (int i = 0; i < fashionPoints; i++) {
					adBiases = append(adBiases, "fashion-" + gender);
				}
				for (int i = 0; i < foodPoints; i++) {
					adBiases = append(adBiases, "food");
				}
				if (done == 0) {
					nowImage = adBiases[int(random(0, technologyPoints + fashionPoints + foodPoints))];
					println("CHANGED IMAGE: " + nowImage);
					done = 1;
				}
			} catch(RuntimeException e) {
				
			}
		}
	}
	if (nowImage.equals("generic")) {
		String jsonString = "{ \"gender\": \"male\", \"technology\": " + int(random(0, 11)) + ", \"fashion\": " + int(random(0, 11)) + ", \"food\": " + int(random(0, 11)) + " }";
		JSONObject json = parseJSONObject(jsonString);
		String gender = json.getString("gender");
		int technologyPoints = json.getInt("technology");
		technologyPoints = technologyPoints > 10 ? 10 : technologyPoints;
		int fashionPoints = json.getInt("fashion");
		fashionPoints = fashionPoints > 10 ? 10 : fashionPoints;
		int foodPoints = json.getInt("food");
		foodPoints = foodPoints > 10 ? 10 : foodPoints;
		for (int i = 0; i < technologyPoints; i++) {
			adBiases = append(adBiases, "technology");
		}
		for (int i = 0; i < fashionPoints; i++) {
			adBiases = append(adBiases, "fashion-" + gender);
		}
		for (int i = 0; i < foodPoints; i++) {
			adBiases = append(adBiases, "food");
		}
		if (done == 0) {
			nowImage = adBiases[int(random(0, technologyPoints + fashionPoints + foodPoints))];
			ADIMAGE = loadImage("ads/" + nowImage + "/" + int(random(0, 5)) + ".jpg");
			println("CHANGED IMAGE: " + nowImage);
			done = 1;
		}
	}
	// if (previous.equals(nowImage)) {
		image(ADIMAGE, 0, 0);	
		// previous = nowImage;
	// } else {
		// image(getImageFromString(previous), 0, 0);
	// }
	fill(50);
	textSize(weatherSize);
	text(str((Integer.parseInt(weatherData.getString("temp")) - 32) * 5 / 9) + "°C " + weatherData.getString("text"), 20, 40);
	text((day() > 9 ? day() : "0" + day()) + "-" + (month() > 9 ? month() : "0" + month()) + "-" + year() + " " + (hour() > 9 ? hour() : "0" + hour()) + ":" + (minute() > 9 ? minute() : "0" + minute()), 20, weatherSize + 50);
	if (millis() > loopNumber * 30000) {
		adBiases = new String[0];
		done = 0;
		// updateWeather();
		loopNumber++;
	}
	delay(1000);
}