#  NEWS APP WITH POWERSHELL

**News app** is a collection of news updates from various news sources and shows in small chunk sections. Each news is linked to its corresponding sources, this helps to read the news in short and at the same time the detailed news can be read by a simple click on the headlines. Currently latest news in **UK** & **INDIA** and available along with **COVID-19** **UK** data.

Since the app is distributed in a url it comes as mobile friendly.

## WHAT MAKES NEWS APP DIFFERENT

**News app** holds a simple & clean layout and shows what is necessary in small chunks which makes it unique.

## APP BOILERPLATE

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

`NEWS APP` is designed with powershell which makes it more unique and consists of 3 main files which works in `MVC` model. The information is fetched from NEW API using PowerShell which is then manipulated and modified to view in webpage. In order to get the app working

- `app.ps1` has to be scheduled to run for every 1 hour so that latest news can be displayed.
- `index.html`, `india.html`, `covid-19` are the static HTML files that holds the news and covid-19 data
- `Api-key.clixml` this holds the news api key applicable if any

## NOTES

Added COVID-19 details and related url.

## TODO

- Layout change
- Multipage app
