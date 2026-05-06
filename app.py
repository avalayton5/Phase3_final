from flask import Flask, render_template, request, redirect, url_for,session
import mysql.connector

app = Flask(__name__)
app.secret_key = 'random_string'

# Function to check database credentials
def check_db_credentials(input_user, input_pass):
    try:
        # Connect to your MySQL server
        db = mysql.connector.connect(
            host="localhost",
            user="root",           
            password="Lulu1991!", 
            database="phase3_kay_db"
        )
        cursor = db.cursor()

        # Query to find a user with the matching username and password
        # WARNING: In a real app, use password hashing! 
        query = "SELECT * FROM USERS WHERE username = %s AND password = %s"
        cursor.execute(query, (input_user, input_pass))
        
        user = cursor.fetchone()
        db.close()

        if user:
            return True
        return False
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return False

@app.route('/')
def home():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login():
    # Grab data from the HTML form
    username = request.form.get('username')
    password = request.form.get('password')

    if check_db_credentials(username, password):
        return redirect(url_for('dashboard'))
    else:
        return "<h1>Login Failed. Invalid credentials.</h1>"

@app.route('/dashboard')
def dashboard():
    try:
        # 1. Connect to the database
        db = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Lulu1991!",
            database="phase3_kay_db"
        )
        cursor = db.cursor(dictionary=True) # dictionary=True makes data easier to use in HTML

        # 2. Fetch all products from your MERCH_STOCK table
        cursor.execute("SELECT * FROM MERCH_STOCK")
        products = cursor.fetchall()
        
        db.close()

        # 3. Pass the 'products' list to the HTML template
        return render_template('dashboard.html', items=products)

    except mysql.connector.Error as err:
        return f"Database Error: {err}"

@app.route('/add_to_cart/<int:product_id>')
def add_to_cart(product_id):
    # 1. Initialize the cart if it doesn't exist yet
    if 'cart' not in session:
        session['cart'] = []

    # 2. Add the product ID to the list
    # We use a temp list because modifying sessions directly can be finicky
    cart = session['cart']
    cart.append(product_id)
    session['cart'] = cart

    # 3. Go back to the merch page
    return redirect(url_for('dashboard'))

if __name__ == '__main__':
    app.run(debug=True)