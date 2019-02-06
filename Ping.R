source("pingFunction.R")
httping <- function(x) {
  y <- switch(x,
              "http://172.104.147.136:8087" = "NERICC Instance",
              "http://dhis2nigeria.org" = "NATIONAL DHIS2 Instance",
              "http://ehealth4everyone.com" = "Ehealth4everyone website",
              "http://healththink.org" = "HealthThink website",
              "http://datakojo.com" = "Data kojo server",
              "http://test.datakojo.com" = "Data kojo test server",
              "http://aphen.africa" = "Aphen Forum"
  )
  tryCatch(expr = {kk <- httping::ping(x)},
           error = paste0("Trying to access ",y," accessible at ",x," gave an ERROR"),
           warning = paste0("Trying to access ",y," accessible at ",x," gave a WARNING"),
           message = paste0("Trying to access ",y," accessible at ",x," gave a MESSAGE"))
  
  if(kk$status == 200) {
    paste0(y, " which is accessible at " ,x ," is UP with status code of ", kk$status, " and header status of ", kk$request$all_headers[[1]]$status)
  } else if(kk$status != 200) {
    paste0(y, " which is accessible at " ,x ," is DOWN with status code of ", kk$status, " and header status of ", kk$request$all_headers[[1]]$status)
  }
}

# real code ----
config <- config::get()
Environment <- config$Environment
# Configure slack ----
library(slackr)
incoming_webhook_url <- config$slackIncomingWebHookUrl
api_token <- config$slackAPIToken
slackrSetup(channel = "r_notifications1", username = "martynscn",incoming_webhook_url = incoming_webhook_url,api_token = api_token)
# Test IPs ----
ips2 <- c("http://172.104.147.136:8087","http://dhis2nigeria.org","http://ehealth4everyone.com",
         "http://healththink.org","http://datakojo.com","http://test.datakojo.com","http://aphen.africa")

ips <- c("172.104.147.136:8087","www.dhis2nigeria.org","www.ehealth4everyone.com","www.healththink.org",
         "www.datakojo.com","www.test.datakojo.com","www.aphen.africa")

ips_len <- length(ips)
ips_len2 <- length(ips2)
fac <- factor(rep_len(1:ips_len,length.out = ips_len),labels = 1:ips_len)
fac2 <- factor(rep_len(1:ips_len2,length.out = ips_len2),labels = 1:ips_len2)

ping_result <- tapply(X = ips,fac, FUN = ping)
ping_result2 <- tapply(X = ips2,fac2, FUN = httping)


ping_result_slack <- as.character(ping_result)
ping_result_slack2 <- as.character(ping_result2)



slackr_bot(ping_result_slack)
slackr_bot(ping_result_slack2)

