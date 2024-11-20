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

#Route to update a plyer
@app.route('/update/<int:player_id>', methods=['GET', 'POST'])
def update_player(player_id):
    connection = get_db_connection()
    mycursor = connection.cursor()

    if request.method == 'POST':
        # Get the updated form data
        rating = request.form.get('rating')
        title = request.form.get('title')
        name = request.form.get('name')
        city_id = request.form.get('city_id')

        # Update the player in the database
        sql_update = "UPDATE Player SET Rating = %s, Title = %s, Name = %s, CityID = %s WHERE ID = %s"
        mycursor.execute(sql_update, (rating, title, name, city_id, player_id))
        connection.commit()

        mycursor.close()
        connection.close()

        # Redirect to the table display page after update
        return redirect(url_for('show_table'))

    # Fetch the player's current data to pre-fill the update form
    sql_select = "SELECT * FROM Player WHERE ID = %s"
    mycursor.execute(sql_select, (player_id,))
    player = mycursor.fetchone()

    mycursor.close()
    connection.close()

    # Render the update form with the current player data
    return render_template('update_player.html', player=player)

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

# Route to display tournaments and their associated players
@app.route('/tournaments', methods=['GET'])
def show_tournaments():
    connection = get_db_connection()
    mycursor = connection.cursor()

    # Fetch all tournaments
    mycursor.execute("SELECT * FROM Tournament")
    tournaments = mycursor.fetchall()
    mycursor.close()
    connection.close()

    return render_template('tournaments.html', tournaments=tournaments)

# Route to view players associated with a tournament
@app.route('/tournament/<int:tournament_id>', methods=['GET'])
def view_tournament_players(tournament_id):
    connection = get_db_connection()
    mycursor = connection.cursor()

    # Fetch the tournament details
    mycursor.execute("SELECT * FROM Tournament WHERE TournamentID = %s", (tournament_id,))
    tournament = mycursor.fetchone()

    # Fetch players associated with the tournament
    mycursor.execute("""
        SELECT Player.ID, Player.Name, Player.Rating, Player.Title, Player.CityID
        FROM PlayerTournament
        JOIN Player ON PlayerTournament.PlayerID = Player.ID
        WHERE PlayerTournament.TournamentID = %s
    """, (tournament_id,))
    players = mycursor.fetchall()
    mycursor.close()
    connection.close()

    return render_template('tournament_players.html', tournament=tournament, players=players)

# Route to assign a player to a tournament
@app.route('/assign', methods=['GET', 'POST'])
def assign_player_to_tournament():
    connection = get_db_connection()
    mycursor = connection.cursor()

    if request.method == 'POST':
        player_id = request.form.get('player_id')
        tournament_id = request.form.get('tournament_id')

        if not (player_id and tournament_id):
            return "Please select both a player and a tournament."

        # Insert into PlayerTournament
        sql_insert = "INSERT INTO PlayerTournament (PlayerID, TournamentID) VALUES (%s, %s)"
        try:
            mycursor.execute(sql_insert, (player_id, tournament_id))
            connection.commit()
        except mysql.connector.Error as err:
            return f"Player is already in the tournament!"
        finally:
            mycursor.close()
            connection.close()

        flash('Player assigned to tournament successfully!', 'success')
        return redirect(url_for('show_tournaments'))

    # Fetch players and tournaments for dropdown options
    mycursor.execute("SELECT ID, Name FROM Player")
    players = mycursor.fetchall()

    mycursor.execute("SELECT TournamentID, Type FROM Tournament")
    tournaments = mycursor.fetchall()

    mycursor.close()
    connection.close()

    return render_template('assign_player.html', players=players, tournaments=tournaments)





if __name__ == '__main__':
    app.run(port=8000, debug=True, host="0.0.0.0")