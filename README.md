![cartly_logo](https://github.com/rai-rajeev/Cartly/assets/106883666/ba68add7-7c40-4e9b-bf71-a9420b0d4457)
# CARTLY
"**Cartly** is a mobile application that enables users to place prepaid food orders at outlets within their locality. Shops can accept or reject these orders, and the order is completed when the shop scans the unique QR code presented by the user. If a shop rejects an order, a refund is automatically initiated and completed within 4-5 working days from the day of initiation. Its integration with Google Maps provides the exact location of the shop, making it easy for users to pick up their orders."
# Features
+ Mobile number verification for shopkeepers
+ Pre-payment and refunds (using the RazorPay Payment Gateway)
+ Precise and accurate locations of shops (using Google Maps)
+ Dark/light theme toggle
+ Search functionality
+ Real-time updates about the shop
+ Check whether items are in stock
+ Unique QR code generation and scanning for order verification
+ Accessibility to contact shops
+ Ability for shopkeepers to open or close their shop at their discretion
+ Order history for both shopkeepers and users
# Tech Stack
**Client:** Flutter

**Server:** Firebase

**Database:** Firebase Realtime Database

**External API used:** RazorPay, Google Maps, Google OAuth
# Screenshots
![bcc26030-f07d-4bcd-8f9b-5b7a86a9f952](https://github.com/user-attachments/assets/d2b5bc69-8900-4fab-aac2-0eaab82407f3)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![7278833b-fee5-4146-b260-58ae00a62520](https://github.com/user-attachments/assets/9e50e91e-7671-4c1f-bc7f-74b54f00a48b)
# Download APK File
https://drive.google.com/file/d/19fji_V1VhO0PcMEPVr28fMucK9b0ag62/view?usp=sharing
# Environment Variable
 Razorpay Key ID
 ```bash
 key_id
```
Razorpay Secret Key
```bash
 sec_key
```
# Demo
# Working of User-side of app
When initiating the "Sign In as Customer" process, users who are not yet registered will be redirected to Google authentication for registration. During this process, users can select their email ID to complete the registration. For registration, we are using the Google OAuth API. Once registered successfully, users will be directed to the app's main home page.
## The Home Screen:
A convenient sidebar located at the top left corner features options for user details, a Light/Dark mode toggle switch, order history, pending orders, and logout.

**Theme Toggle:** The theme toggle switch allows users to toggle between light and dark themes.

**Order History:** Users can see their previous order status (i.e., whether the order has been successfully completed or the shopkeeper rejected their order).

**Pending Orders:** Users can see orders that have been accepted by the shopkeeper but are not yet successfully completed. It allows users to generate a unique QR code for verification at the time of order completion.

**Logout:** Allows users to log out from the app.

The top right corner includes quick access to the user's cart, followed by a search bar which allows users to search for restaurants by name and an open now filter option to help users find currently open restaurants. All restaurants will appear in a vertically scrollable list containing information about the restaurant (i.e., name, location, and contact information). Tapping on restaurant cards will direct users to the restaurant page.
 ## Restaurant Sreen
 It provides comprehensive details such as the name, operating hours, precise location, and contact information of the shopkeeper. This is followed by a vertically scrollable and attractive menu of the restaurant. The menu showcases all available dishes, allowing users to customize their orders by adjusting quantities directly from this page to their cart.
 ## Cart SCreen 
Orders are conveniently organized by restaurant, each with its own dedicated checkout page for seamless payment processing. Users can effortlessly manage the quantity of items in their cart as needed.
## Checkout Screen
The app seamlessly integrates the Razorpay Payment Interface from this screen. Shop owners are required to input their Razorpay Merchant Credentials during the registration process. Users can securely complete transactions by entering their bank details on the checkout screen. Upon successful payment, the order is automatically deducted from the cart. Once accepted by the shop owner, the order transitions into the user's pending orders and the shop's accepted orders.

**Order Collection Process** When an order is pending for pickup, a unique QR code containing the order ID is generated. Upon visiting the shop, the shopkeeper scans this QR code to verify and confirm the order, ensuring a seamless transaction.
# Working of the Shopkeeper-Side of the App
After selecting "Sign in as shopkeeper," users who aren't registered are redirected to a mobile number verification screen. Here, they request an OTP on their mobile number and then proceed to the OTP verification page after completing a "not a robot" verification. After entering the OTP sent to their mobile number and clicking "Verify," they will be redirected to the Google sign-in page for authentication. Once signed in via Google Auth, a registration form appears for shopkeepers to fill out their details. Upon form submission, the shop owner's home screen appears. Please allow some time after clicking "Submit," as image uploads may take a moment.
## Home Screen:
The owner's home screen features a side drawer, similar to the user interface, providing access to profile details, a light/dark theme toggle, a shop open/closed toggle, scan QR, add items, order history, and logout options.

**Shop Open/Closed Switch:** This additional feature allows the shopkeeper to change the shop's status.

**Add Item:** This feature allows shopkeepers to add new items to their menu by providing a few pieces of information about the dish.

**Scan QR Code:** This feature allows shopkeepers to scan the unique QR code generated by customers at the time of order completion.

The top right corner displays the restaurant's image.

A bottom navigation bar allows shopkeepers to navigate among the menu screen, current orders screen, and accepted order screen.
## Menu screen:
Display all the items that have been added to the menu by the owner in a vertical manner, containing information about the dish (i.e., name, price, suggested time, image), and a button that allows the owner to change the status of the dish (i.e., whether it is in stock or not).
## Current Orders Screen:
This page displays all current orders awaiting responses from the shop owner. The owner can accept or reject orders. If the owner rejects an order, then a refund is initiated and completed within 4-5 working days from the day of initiation. If the owner accepts an order, then it moves to the accepted order screen.
## Accepted Orders Screen:
Here, the shop owner can view all accepted orders awaiting further action.
# Authors
+ [@rai-rajeev](https://github.com/rai-rajeev)
# Important Note 
Please provide the required permissions for the smooth functioning of the app.<br/>
Always refresh to get updated data.<br/> 
 Use the app with patience.<br/>
 Shopkeepers, please ensure to add Razorpay credentials correctly to receive payments. Otherwise, no one else will be responsible for any mistransaction of money. 




  
