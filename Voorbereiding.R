

## ---- voorbereiding

# Opzetten ----------------------------------------------------------------

library("RODBC")
library("tidyverse")
library('openssl')
library('rjson')
library('lubridate')
library('ggplot2')

rm(list = ls())


# Connectie ---------------------------------------------------------------

dbhandle <- odbcDriverConnect('driver={SQL Server};server=HSKWCPMI01;database=ecdReplication;trusted_connection=true')

t <- sqlQuery(dbhandle, read_file('SQL/setup.sql'))



# Constanten --------------------------------------------------------------

vanafdatum <- '2019-07-01'



# Query uitvoeren op database ---------------------------------------------

# Eerst string ophalen
querystring <- read_file('SQL/tijdelijke_tabellen.sql')

# Dan afvuren op de database
t2 <- sqlQuery(dbhandle, querystring)



# Eerst string ophalen
querystring <- read_file('SQL/resultaat.sql')

querystring <- str_replace_all(querystring, "@param_begindatum", vanafdatum)


test_trend <- sqlQuery(dbhandle, querystring)




# Databse opschonen  ------------------------------------------------------


t <- sqlQuery(dbhandle, read_file("SQL/tear_down.sql"))



# verbreken verbinding ----------------------------------------------------

RODBC::odbcCloseAll()




# Verdere bewerkingen -----------------------------------------------------

test_trend$datum <- make_date(year = test_trend$jaar, month = test_trend$maand, day = 1)


ggplot(data = test_trend, aes(x=datum, y = gemiddeld_aantal_tests, group = dossier_type)) + 
    geom_line(aes(color = dossier_type)) +
    expand_limits(y = 0) + 
    scale_x_date(date_breaks = "months", date_labels = "%m-%y")










