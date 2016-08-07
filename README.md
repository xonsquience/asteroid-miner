# asteroid-reports
Asteroidal Resource Availability

Inspired by [Ian Webster's Asterank](https://github.com/typpo/asterank), this project plots yearly availability and market value of user-specified resources.

Databases:
http://ssd.jpl.nasa.gov/sbdb_query.cgi (all objects and attributes), and
http://neo.jpl.nasa.gov/cgi-bin/neo_ca

Due to assignment time constraints, I wrote AsteroidFinder.py to find asteroids of interest rather than use Asterank's object-oriented framework.  AsteroidFinder.py produces A_A.csv, a table containing the resources and approach dates of each asteroid that has enough information for size and composition estimation.

Until I get the RShiny app hosted, it can be viewed by downloading ui.R, server.R, A_A.csv, and executing it from within RStudio.

Features to be added:
- sliders for approach date and distance ranges
- options for if and how to weight each approach
