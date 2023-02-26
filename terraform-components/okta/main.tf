resource "okta_app_oauth" "oidc" {
  label          = "My OIDC"
  type           = "web"
  grant_types    = ["authorization_code"]
  response_types = ["code"]
  omit_secret    = false
  redirect_uris  = ["pablo put his nginx url here. figure this out later."]
}

