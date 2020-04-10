#  NEWS APP WITH POWERSHELL

This project is designed to show latest news in **UK** and displayed in cards.
The intention is to create a mobile friendly app and holds PowerShell as it's
backbone.

## BOILERPLATE

    NEWS
    |
    |-- Api-key.clixml
    |
    |-- app.html
    |
    |-- News-API.ps1

## DESIGN

The `NEWS APP` consists of 3 main files which works in `MVC` model. The information is
fetched from NEW API using PowerShell which is then manipulated and modified to view
in webpage. In order to get the app working

- `News-API.ps1` has to be scheduled to run for every 1 hour so that latest news can be
displayed.
- `app.html` is the static HTML file that holds the news
- `Api-key.clixml` this holds the news api key

## TODO

- Layout change
- Multipage app