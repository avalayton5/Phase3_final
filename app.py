from flask import Flask, render_template, request, redirect, url_for, session
import mysql.connector
 
app = Flask(__name__)
app.secret_key = 'random_string'
 
def get_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="Flavor.Savor5",  
        database="merch_store"
    )
 
def check_db_credentials(input_user, input_pass):
    try:
        db = get_db()
        cursor = db.cursor()
        query = "SELECT User_id, Fname FROM USERS WHERE username = %s AND password = %s"
        cursor.execute(query, (input_user, input_pass))
        user = cursor.fetchone()
        db.close()
        return user  # returns (User_id, Fname) or None
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None
 
@app.route('/')
def home():
    return render_template('login.html')
 
@app.route('/login', methods=['POST'])
def login():
    username = request.form.get('username')
    password = request.form.get('password')
    user = check_db_credentials(username, password)
    if user:
        session['user_id'] = user[0]   # store User_id in session
        session['fname'] = user[1]     # store first name in session
        session['cart'] = []
        return redirect(url_for('dashboard'))
    else:
        return render_template('login.html', error="Invalid username or password.")
 
@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('home'))
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM MERCH_STOCK")
        products = cursor.fetchall()
        db.close()
        return render_template('dashboard.html', items=products)
    except mysql.connector.Error as err:
        return f"Database Error: {err}"
 
@app.route('/add_to_cart/<int:product_id>')
def add_to_cart(product_id):
    if 'user_id' not in session:
        return redirect(url_for('home'))
    if 'cart' not in session:
        session['cart'] = []
    cart = session['cart']
    cart.append(product_id)
    session['cart'] = cart
    return redirect(url_for('dashboard'))
 
@app.route('/cart')
def cart():
    if 'user_id' not in session:
        return redirect(url_for('home'))
    cart_ids = session.get('cart', [])
    items = []
    if cart_ids:
        try:
            db = get_db()
            cursor = db.cursor(dictionary=True)
            for pid in cart_ids:
                cursor.execute("SELECT * FROM MERCH_STOCK WHERE Product_id = %s", (pid,))
                item = cursor.fetchone()
                if item:
                    items.append(item)
            db.close()
        except mysql.connector.Error as err:
            return f"Database Error: {err}"
 
    # calculate subtotal and tax
    subtotal = sum(float(item['Price']) for item in items)
    tax = round(subtotal * 0.08875, 2)
    total = round(subtotal + tax, 2)
 
    return render_template('cart.html', items=items, subtotal=subtotal, tax=tax, total=total)
 
@app.route('/place_order', methods=['POST'])
def place_order():
    if 'user_id' not in session:
        return redirect(url_for('home'))
 
    cart_ids = session.get('cart', [])
    if not cart_ids:
        return redirect(url_for('dashboard'))
 
    delivery_method = request.form.get('delivery_method', 'Standard')
    user_id = session['user_id']
 
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
 
        cursor.execute("SELECT MAX(Order_id) as max_id FROM ORDERS")
        result = cursor.fetchone()
        new_order_id = (result['max_id'] or 100) + 1
 
        cursor2 = db.cursor()
        cursor2.execute(
            "INSERT INTO ORDERS VALUES (%s, CURDATE(), %s, %s, %s)",
            (new_order_id, len(cart_ids), 'In Progress', user_id)
        )
 
        cursor.execute("SELECT MAX(Item_ID) as max_id FROM ORDER_ITEM")
        result = cursor.fetchone()
        max_item = result['max_id'] or 1000
 
        for line_num, prod_id in enumerate(cart_ids, start=1):
            max_item += 1
            cursor2.execute(
                "INSERT INTO ORDER_ITEM VALUES (%s, %s, %s, %s, %s)",
                (new_order_id, line_num, prod_id, max_item, 1)
            )
            cursor2.execute(
                "UPDATE MERCH_STOCK SET Stock_Quantity = Stock_Quantity - 1 WHERE Product_id = %s",
                (prod_id,)
            )
 
        cursor.execute("SELECT MAX(Payment_id) as max_id FROM PAYMENT")
        result = cursor.fetchone()
        new_pay_id = (result['max_id'] or 200) + 1
        cursor2.execute(
            "INSERT INTO PAYMENT VALUES (%s, CURDATE(), %s, %s, '2027-12-01', %s)",
            (new_pay_id, 4000 + new_pay_id, 999, new_order_id)
        )
 
        cursor.execute("SELECT MAX(Delivery_id) as max_id FROM DELIVERY")
        result = cursor.fetchone()
        new_del_id = (result['max_id'] or 300) + 1
        cursor2.execute(
            "INSERT INTO DELIVERY VALUES (%s, NULL, %s, %s, %s, %s)",
            (new_del_id, delivery_method, 'In Progress', new_order_id, user_id)
        )
 
        db.commit()
        db.close()
 
        session['cart'] = []  # clear cart
        session['last_order_id'] = new_order_id
        return redirect(url_for('order_confirmation'))
 
    except mysql.connector.Error as err:
        return f"Database Error: {err}"
 
@app.route('/order_confirmation')
def order_confirmation():
    if 'user_id' not in session:
        return redirect(url_for('home'))
    order_id = session.get('last_order_id', '???')
    return render_template('confirmation.html', order_id=order_id)
 
@app.route('/delivery')
def delivery():
    if 'user_id' not in session:
        return redirect(url_for('home'))
    user_id = session['user_id']
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute("""
            SELECT o.Order_id, o.Order_date, o.Order_status,
                   d.Delivery_id, d.Delivery_date, d.Method, d.Status as Delivery_status
            FROM ORDERS o
            LEFT JOIN DELIVERY d ON d.Sent_id = o.Order_id
            WHERE o.Customer_id = %s
            ORDER BY o.Order_date DESC
            LIMIT 1
        """, (user_id,))
        order = cursor.fetchone()
        db.close()
        return render_template('delivery.html', order=order)
    except mysql.connector.Error as err:
        return f"Database Error: {err}"
 
@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('home'))
 
if __name__ == '__main__':
    app.run(debug=True)
