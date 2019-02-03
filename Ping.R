source("pingFunction.R")
# trial ----
# ping2 <- function(x) {
#     pingvec <- httping::ping(url = "http://aphen.africa")
#     
# y <- switch(x,
#             "https://google.com" = "Google home",
#             "http://172.104.147.136:8087" = "NERICC Instance",
#             "http://dhis2nigeria.org" = "NATIONAL DHIS2 Instance",
#             "http://ehealth4everyone.com" = "Ehealth4everyone website",
#             "http://healththink.org" = "HealthThink website",
#             "http://datakojo.com" = "Data kojo server",
#             "http://test.datakojo.com" = "Data kojo test server",
#             "http://aphen.africa" = "Aphen Forum")
# if(pingvec$status == 200) {
#   paste0(y, " which is accessible at " ,x ," is up with status code of ", pingvec$status)
# } else {
#   paste0(y, " which is accessible at " ,x , " is down with status code of ", pingvec$status)}
# # other code ----
# # if(pingvec == 0) {
# #   paste0(y, " which is accessible at " ,x ," is up")
# # } else {
# #   paste0(y, " which is accessible at " ,x , " is down")}
# }
# real code ----
config <- config::get()
Environment <- config$Environment
# Configure slack ----
library(slackr)
incoming_webhook_url <- config$slackIncomingWebHookUrl
api_token <- config$slackAPIToken
slackrSetup(channel = "r_notifications1", username = "martynscn",incoming_webhook_url = incoming_webhook_url,api_token = api_token)

ips <- c("http://172.104.147.136:8087","http://dhis2nigeria.org",
         "http://ehealth4everyone.com","http://healththink.org",
         "http://datakojo.com","http://test.datakojo.com","http://aphen.africa")

ips_len <- length(ips)
fac <- factor(rep_len(1:ips_len,length.out = ips_len),labels = 1:ips_len)
ping_result <- tapply(X = ips,fac, FUN = ping)
ping_result_slack <- as.character(ping_result)
slackr_bot(ping_result_slack)

