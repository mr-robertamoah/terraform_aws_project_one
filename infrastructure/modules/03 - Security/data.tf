data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
  request_headers = {
    Accept = "text/plain"
  }
}