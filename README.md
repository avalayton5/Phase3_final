Phase 3: Merch Store Application 

A web merch store application built with Python (Flask) and MySQL.

Step 1: Set up the database 

Open MySQL Workbench and run the database

Step 2: Fix password

Open app.py in any text editor

Change this line:

pythonpassword="Flavor.Savor5",

Replace Flavor.Savor5 with your own MySQL password

Save the file

Step 3: Run the Application 

Open Terminal, go to the project folder, and run: 

python3 app.py

Then open your browser and go to:
http://127.0.0.1:5000

Step 4: Log In

Use any of these sample accounts to log in:

Username: alice

Password: alice123


Username: bob

Password: bob123


Username: carol

Password: carol123


Username: david

Password: david123


Username: eva

Password: eva123


Application Features

Function 1: Place an Order

Browse available merch on the dashboard

Click add to cart to add items

Click the cart icon to view your cart

See subtotal, tax, and total

Choose a delivery method (Standard or Express)

Click place order to finish the purchase

Function 2: View Inventory Levels

The dashboard displays all products with their current stock quantities

Stock automatically decreases when an order is placed

Function 3: Check Delivery Status

Click the truck icon on the dashboard

View your most recent order's delivery ID, method, date, and status

Notes
Sample data includes 5 users, 10 products, and 7 orders that already exist
