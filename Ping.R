ping <- function(x, stderr = FALSE, stdout = FALSE,...){
  pingvec <- system2(command = "ping", args = x,
                     stdout = FALSE,
                     stderr = FALSE,...)
  y <- switch(x,
              "www.google.com" = "Google home",
              "172.104.147.136:8087" = "NERICC Instance",
              "www.dhis2nigeria.org" = "NATIONAL DHIS2 Instance",
              "www.ehealth4everyone.com" = "Ehealth4everyone website",
              "www.healththink.org" = "HealthThink website",
              "www.datakojo.com" = "Data kojo server",
              "www.test.datakojo.com" = "Data kojo test server",
              "aphen.africa" = "Aphen Forum")
  if(pingvec == 0) {
    paste0(y, " which is accessible at " ,x ," is up")
  } else {
    paste0(y, " which is accessible at " ,x , " is down")}
}
config <- config::get()
Environment <- config$Environment
# Configure slack ----
library(slackr)
incoming_webhook_url <- config$slackIncomingWebHookUrl
api_token <- config$slackAPIToken
slackrSetup(channel = "r_notifications1", username = "martynscn",incoming_webhook_url = incoming_webhook_url,api_token = api_token)

ips <- c("172.104.147.136:8087","www.dhis2nigeria.org",
         "www.ehealth4everyone.com","www.healththink.org",
         "www.datakojo.com","www.test.datakojo.com","aphen.africa")

ips_len <- length(ips)
fac <- factor(rep_len(1:ips_len,length.out = ips_len),labels = 1:ips_len)
ping_result <- tapply(X = ips,fac, FUN = ping)
ping_result_slack <- as.character(result)
slackr_bot(ping_result_slack)
