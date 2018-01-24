import http.requests.*;

String category = "Food";
String weatherAPI = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22university%20of%20twente%2C%20enschede%22)&format=json";

void setup() {
	size(400, 300);
	GetRequest get = new GetRequest(weatherAPI);
	//get.send();
	println("Reponse Content: " + get.getContent());
	JSONObject json = null;
	try { // Check if able to parse JSON and get values
		json = parseJSONObject(jsonString);
		top = json.getString("joystick_left"); // Set variables
		left = json.getInt("joystick_right");
		pressed = json.getInt("pressed");
	} catch(RuntimeException e) { // Otherwise throw error
		println("Err");
	}
}

void draw() {
	background(100);
	// println("category: " + category);
}