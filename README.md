# MVVM, Combine, UIKit, Programmatic UI, Pagination, Login, Persist Login, Products Listing


### 👋 Hi! This repo conatains an App fulfulling following criterea

# App Features
### 1. Login Flow
• Create a Login Screen with fields for email and password.
• Implement basic validation (e.g., email format, password length).
• On successful login, navigate to the Home Screen.
• Persist login state so that if the user is already logged in, they are automatically
navigated to the Home Screen on the next app launch.
### 2. Home Screen
• The Home Screen should display multiple dynamic rows.
• Each row should have a title and a horizontally scrollable list of products.
• The number of rows and products in each row should be fetched from an API.
• The UI should update dynamically based on the received data.
### 3. API Integration
• Implement a Login API to handle authentication.
• Implement a Home Screen Data API that returns dynamic rows and products.
• Use token-based authentication for secure API requests.
### 4. Technical Expectations
• Use MVVM architecture.
• Implement network calls using URLSession (or Alamofire if preferred).
• Store authentication tokens securely (e.g., Keychain or UserDefaults).
• Ensure smooth scrolling and efficient data handling.
• Use Combine or async/await for reactive programming (if applicable).
### Bonus 
• Implement pagination on the Home Screen.
• Show a loading indicator during API calls.
• Deign UI programmatically.
• Handle authentication on Home Screen Api.

# Limitations
1- I cannot find any public API for email/password login, that also supports accessToken authentication support as I have implemented in this repo, it will login and also will check on relaunch if user is logged in or. Although I have integrated email field with validations.
2- Same for Pagination, I didn't get any oublic API with same features having pagination. So I have implemented pagination demo for your referance.
3- To test Pagination click on any product collection item, it will land on a new page, where you can test pagination.

# How to login ?
For login username and password you can hit this API on google "https://dummyjson.com/users"
It will give you plenty of user entries, you can try any username and password.
Email could be anyone, this is just for showing validations. 
If we have any API supporting same authentication features, we can easily replace email/password authentication API.

<p align="center">
 <img src="https://github.com/user-attachments/assets/13c582f0-447c-4566-b508-ab56b7b0cea3" width="200"/>
 <img src="https://github.com/user-attachments/assets/8143745a-a327-446c-bf50-ba05dfd45aeb" width="200"/>
 <img src="https://github.com/user-attachments/assets/80f827cb-e660-418a-b833-d5a01fe8452e" width="200"/>
 <img src="https://github.com/user-attachments/assets/2ebb8058-f651-41ac-bd79-518ec33865e1" width="200"/>
 <img src="https://github.com/user-attachments/assets/8efc0452-5bc1-487a-bb54-bb57d3312127" width="200"/>
</p>

**Tech Used**
-  Cocoapods
-  Alamofire
-  UIKit
-  Combine
-  MVVM Architecture
-  Programmatic UI
-  Swift
