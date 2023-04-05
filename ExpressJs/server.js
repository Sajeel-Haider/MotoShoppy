const express = require("express");

const app = express();

app.get("/", function (request, response) {
  //first parameter is the route for the request
  //console.log(request);
  response.send("Hello"); //sends the response rendered on our browser
});
app.get("/contact", function (request, response) {
  response.send("Contact me at: some@gmail.com");
});
app.get("/about", function (request, response) {
  response.send("We are in about section");
});
app.listen(3000, function () {
  console.log("Server started on port 3000");
}); //port 3000 (listen to that port for any http request)

//use nodemon.io -> it will compile your code for server so you dont have to start your server again and again
