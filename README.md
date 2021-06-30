Fluttter Sample Asignment

Hello,

I have developed an application about different restaurants as described in the task. The main goal was to access the information through an API call and manage it using BLoC, to be able to show it later through out the view. The application only consists of two views, and these are classified into folders with their respective files. I had to create an 'images' folder to store a default image for those restaurants that didn't had a thumbnail.

From the 'main.dart' file, I directly call the Home Page View, using it's BLoC. Once we access the view, I use the funcion .map as a loop so that all the restaurants show up with the structure that de class 'RestaurantCard' has already defined. I have aldo declared a model for the Home Page that contains all the attributes that the task asks for. To do that, you need to install the 'http' package, and use the function .get, giving as a parameter de URL of the task statement.

The Home Page Bloc has one event (homePageInitialize) and three states (Initial, Loading, Success and Error). This is how I managed to notify the view which widget should be shown.

All the restaurant cards have a Gesture Detector parent so that if we tap on them, we automatically navigate to the Restaurant Page View. I have divided the page in four sections: Thumbnail, Identity, Information and Delivery. All these four clases receive as a parameter the Restaurant Page Model we declare at the beginning of the view. This model has more specific attributes such as description, address, phone number and email. The Restaurant Page Bloc has the same states as the Home Page but it has also two more events other than the Initialize. This two event (showDescriptionPressed and showInfoPressed) are in charge of showing more information in the view.

I have enjoyed developing this app and hope that everything is clear.

-Adrián Boix Necochea
