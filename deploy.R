## deploy.R ##

library(rsconnect)
deployApp("../crisis_network", account = "tbdsolutions")

# for MDHHS Time and Distance Standards
deployApp("CRU_app", account = "tbdsolutions")

# Get info about ShinyApps accounts
accounts()
accountInfo("tbdsolutions")

applications("tbdsolutions")
#terminateApp("crisis_network", account = "tbdsolutions", quiet = FALSE)
