#  NEWS APP WITH POWERSHELL

This project is designed to show latest news in **UK** & **INDIA** and displayed in cards.
The intention is to create a mobile friendly app and holds PowerShell as it's
backbone.

Each news title is a link to the source news content from different sources.

## BOILERPLATE

    NEWS
    |
    |-- Logs # folder to track the logs information
    |
    |-- Module # main module
    |
    |-- Reports # contains covid-19 reports
    |
    |-- Api-Key.clixml # Api key (if applicable)
    |
    |-- app.ps1 # script which runs the app
    |
    |-- uk.html
    |
    |-- india.html
    |
    |-- covid-19.html

## DESIGN

The `NEWS APP` consists of 3 main files which works in `MVC` model. The information is
fetched from NEW API using PowerShell which is then manipulated and modified to view
in webpage. In order to get the app working

- `app.ps1` has to be scheduled to run for every 1 hour so that latest news can be
displayed.
- `uk.html`, `india.html`, `covid-19` are the static HTML files that holds the news and covid-19 data
- `Api-key.clixml` this holds the news api key applicable if any

## NOTES

Added COVID-19 details and related url.

## TODO

- Layout change
- Multipage app
