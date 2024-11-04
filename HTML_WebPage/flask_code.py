#!/usr/bin/python3
from dotenv import load_dotenv
from flask import Flask, render_template, request, redirect, url_for, flash
import mysql.connector
import os

load_dotenv()

app = Flask(__name__)
app.secret_key = 'your_secret_key_here'  # Set your secret key for flash messages

# Function to connect to the database
def get_db_connection():
    return mysql.connector.connect(
        host=os.environ['SQL_HOST'],
        user=os.environ['SQL_USER'],
        password=os.environ['SQL_PWD'],
        db=os.environ['SQL_DB']
    )

# Route to display table contents
@app.route('/', methods=['GET'])
def show_table():
    connection = get_db_connection()
    mycursor = connection.cursor()

    # Fetch all rows from the Player table
    mycursor.execute("SELECT * FROM Player")
    myresult = mycursor.fetchall()
    mycursor.close()
    connection.close()

    # Render the table data in an HTML template
    return render_template('mytable.html', players=myresult)

# Route to display form and add a new player
@app.route('/add', methods=['GET', 'POST'])
def add_player():
    if request.method == 'POST':
        # Get form data safely
        rating = request.form.get('rating')
        title = request.form.get('title')
        name = request.form.get('name')
        city_id = request.form.get('city_id')

        if not (rating and title and name and city_id):
            return "Please fill in all fields."

        # Insert data into the Player table
        connection = get_db_connection()
        mycursor = connection.cursor()

        # Use parameterized query to avoid SQL injection
        sql_insert = "INSERT INTO Player (Rating, Title, Name, CityID) VALUES (%s, %s, %s, %s)"
        mycursor.execute(sql_insert, (rating, title, name, city_id))
        connection.commit()

        mycursor.close()
        connection.close()

        # Redirect to the table display page after insertion
        return redirect(url_for('show_table'))

    # Render the form to add a new player
    return render_template('add_player.html')

# Route to delete a player
@app.route('/delete/<int:player_id>', methods=['POST'])
def delete_player(player_id):
    """Delete a player from the database."""
    connection = get_db_connection()
    mycursor = connection.cursor()

    # Execute the delete command
    sql_delete = "DELETE FROM Player WHERE ID = %s"
    mycursor.execute(sql_delete, (player_id,))
    connection.commit()

    mycursor.close()
    connection.close()

    # Flash a success message and redirect
    flash(f'Player with ID {player_id} has been deleted successfully!', 'success')
    return redirect(url_for('show_table'))

if __name__ == '__main__':
    app.run(port=8000, debug=True, host="0.0.0.0")
