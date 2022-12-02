# Final report pointers:
1. Redesigned ERD, make sure operations that involve create, update, delete are added. e.g., by adding operations for the administrators.
2. Reframe app as an info-crowdsourcing app, so that users can CREATE/UPDATE/DELETE in addition to RETRIEVE.

# If given more time:
1. Authentication system for users.
2. Add administrators to valid information accuracy before adding into the system.
3. Automate the computation of conference standings.

# User transaction examples:
## Create
- Create a User
- Create a Game
- Create a PlayerGameStat

## Update/Delete
- Update/Delete a User
- Update/Delete a Game
- Update/Delete a PlayerGameStat

## Retrieve
- List all games played by a particular team
- List the game-average stats of a player
- Identify the current team of a player
- Identify the number of games played by a team
- Identify the current head coach of a team
- Identify the current conference standing of a team