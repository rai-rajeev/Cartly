![cartly_logo](https://github.com/rai-rajeev/Cartly/assets/106883666/ba68add7-7c40-4e9b-bf71-a9420b0d4457)
# CARTLY
**Cartly** is a mobile application that enables users to place prepaid food orders at outlets within their locality. Shops can accept or reject these orders, and the order is completed when the shop scans the unique QR code presented by the user. If a shop rejects an order, a refund is automatically initiated and completed within 4-5 working days from the day of initiation. Its integration with Google Maps provides the exact location of the shop, making it easy for users to pick up their orders.
# Features
- Mobile number verification for shopkeepers
- Pre-payment and refunds (using RazorPay Payment Gateway)
- Precise and accurate locations of the shops (using Google Maps)
- Dark/light theme toggle
- Search functionality
- Real-time updates about the shop
- Check whether items are in stock or not
- Unique QR code generation and scanning for order verification
- Accessibility to contact shops
- Ability for shopkeepers to open or close their shop at their discretion 
- order history for both shopkeepers and users
# Tech Stack
**Client:** Flutter

**Server:** Firebase

**Database:** Firebase RealTime Database

**External API used:** RazorPay, Google Maps, Google OAuth
# Screenshots
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
When initiating the "Customer Sign In" process, users who are not yet registered will be redirected to Google authentication for registration. During this process, users can select their email ID to complete the registration.for registration, we are using Google Oauth Api Once registered successfully, you will be directed to the app's main home page.

## The Home Screen:
 A convenient sidebar located at the top left corner featuring options for user details,Light/Dark mode toggle switch, order history, pending orders and logout.<br/>
 **Theme Toggle:** Theme toggle switch allows users to toggle between light and dark theme.<br/>
 **Order History:** users can see their previous order status (i.e either order has been succesfully completed or shopkeeper rejected their order).<br/>
 **Pending orders:** users can see orders which are accepted by the shopkeeper but yet not succesfully completed and allow users to generated unique QR code for verification at the time of order completion. <br/>
 **Logout:** allow users to logout from the app.<br/>
 The top right corner includes quick access to the user's cart.Followed a **search bar**  which allow users to search restaurant by names and an **open now** filter option to help users find currently open restaurants. All restaurant will appear in vertically scrollable list containing information about the restaurant (i.e name, location and contact information). on tapping restaurant cards it will direct users to restaurant page.
 ## Restaurant Sreen
 It provides comprehensive details such as name, operating hours, precise location, and contact information of the shopkeeper.this is followed by a vertically scrollable and attractive menu of the restaurant.The menu showcases all available dishes, allowing users to customize their orders by adjusting quantities directly from this page to their cart.
 ## Cart SCreen 
orders are conveniently organized by restaurant, each with its dedicated checkout page for seamless payment processing. Users can effortlessly manage the quantity of items in their cart as needed.
## Checkout Screen
The app seamlessly integrates the Razorpay Payment Interface from this screen. Shop owners are required to input their Razorpay Merchant Credentials during the registration process. Users can securely complete transactions by entering their bank details on the checkout screen. Upon successful payment, the order is automatically deducted from the cart.Once accepted by the shop owner, the order transitions into the user's pending orders and the shop's accepted orders.

**Order Collection Process** When an order is pending for pickup, a unique QR code containing the order ID is generated. Upon visiting the shop, the shopkeeper scans this QR code to verify and confirm the order, ensuring a seamless transaction.
# Working of Shopkeeper-side of app
After selecting "Sign in as shopkeeper," users who aren't registered are redirected to mobile number verification Screen on which they have to request for an otp on their mobile number then it direct user to verify otp page after a not robot verification and entering otp sent to their mobile number and clicking verify then will be redirected to google sign in page for  Google authentication. Once signed in via Google Auth, a registration form appears for shopkeepers to fill out their details. Upon form submission, the owner's home screen appears. Please allow some time after clicking Submit, as image uploads may take a moment.

## Home Screen:
The owner's home screen features:
A side drawer, similar to the user interface, providing access to profile details, light/dark theme toggle, shop open/closed toggle, scan Qr, add items, order history, and logout options.<br/>

**shop open/closed switch:** additonal feature allow shopkeeper to change shop status.<br/> 
**add item:** allows shopkeepers to add new items to their menu by provide few information about the dish.<br/>
**Scan Qr code:** allow shopkeepers to scan unique Qr generated at customer end on the time of completion of order.<br/>
The top right corner displays the restaurant's image. 
A bottom navigation bar allow shopkeepers to navigate among menu screen, current orders screen and accepted order screen.
## Menu screen:
display all the items that have added to the menu by the owner in vertical manner containing information about the dish (i.e. name, price, suggested time, image) and a button which allows owner to change the status of the dish (i.e. whether it is in stock or not).
## Current Orders Screen:
This page displays all current orders awaiting responses from the shop owner. owner can accept or reject orders. if owner rejects an order then a refund initate and complete within 4-5 working days from the day of initiation. if owner accepts order then it moves to accepted order screen.
## Accepted Orders Screen:
Here, the shop owner can view all accepted orders awaiting further action.
# Authors
+ [@rai-rajeev](https://github.com/rai-rajeev)
# Important Note 
Please provide the required permissions for the smooth functioning of the app.<br/>
Always refresh to get updated data.<br/> 
 Use the app with patience.<br/>
 Shopkeepers, please ensure to add Razorpay credentials correctly to receive payments. Otherwise, no one else will be responsible for any mistransaction of money. 




  
