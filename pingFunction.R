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