WanderSync 
WanderSync is a modern travel wishlist and digital journal application built with Flutter. It helps travelers plan their adventures, document their memories, and stay organized through a modular and scalable architecture.

 Features
Secure Authentication Hub: Robust user login and registration powered by Firebase.

Discovery Feed: Explore trending destinations and find inspiration for your next trip.

Personal Bucket List: Track the places you dream of visiting with a streamlined wishlist.

Digital Travel Journal: Capture and preserve your travel experiences with detailed logs.

Preparation Checklist: Stay organized with customizable tasks for trip planning.

Real-time Sync: All data is managed and synced across devices using Google Cloud Firestore.

 Architecture
The project follows a Modular Bloc Architecture to ensure clean code, high maintainability, and scalability. Each core feature is treated as an independent module:

Auth Module: Manages session states and user identity.

Feed Module: Handles the fetching and display of social/discovery content.

Wishlist Module: Manages CRUD operations for travel destinations.

Journal Module: Handles data persistence for travel memories.

Checklist Module: Organizes task-based data for trip prep.

 Tech Stack
Frontend: Flutter (Dart)

State Management: Flutter Bloc

Backend: Firebase (Authentication & Cloud Firestore)

Testing: Mockito for unit testing and Firebase component mocking.

Version Control: Atomic commit strategy for a clean and professional history.

 Getting Started
Prerequisites
Flutter SDK (Stable channel)

A Firebase project set up on the Firebase Console

Installation
Clone the repository:

Bash
git clone https://github.com/muhammadhassan191/WanderSync.git
cd WanderSync
Install dependencies:

Bash
flutter pub get
Firebase Setup:

Add your google-services.json (Android) and GoogleService-Info.plist (iOS) to the respective directories.

Enable Email/Password Auth and Firestore in your Firebase project.

Run the app:

Bash
flutter run
 Testing
The project uses Mockito to ensure components are reliable and bug-free. To run the tests:

Bash
flutter test

 Contributing
Contributions are welcome! If you have suggestions for improvements or new features, feel free to open an issue or submit a pull request.
