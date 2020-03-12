require "http/client"
require "json"

# You want just the domain and a list of subdomains that will
# point to the computer you will run this script on. Example:
# domains = { 
#   "homedomain.com" => ["vpn", "firefly"],
#   "startup.io" => ["app", "auth"],
# }
domains = {
  # FILL_ME_IN
}

# Get the external IP address
external_ip = `curl -s ifconfig.me`

# Gandi LiveDNS API KEY
api_key = "FILL_ME_IN"

domains.each do |domain, subdomains|
  api_url = "https://dns.api.gandi.net/api/v5/domains/#{domain}"

  #Get the current Zone for the provided domain
  headers = HTTP::Headers{"X-Api-Key" => api_key}
  response = HTTP::Client.get(api_url, headers: headers)
  current_zone_href = JSON.parse(response.body)["zone_records_href"]

  # Update the A Record of the subdomain using PUT
  update_headers = HTTP::Headers{
    "X-Api-Key" => api_key, 
    "Content-Type" => "application/json"
  }

  subdomains.each do |subdomain|
    response = HTTP::Client.put(
      "#{current_zone_href}/#{subdomain}/A", 
      headers: update_headers,
      body: { 
        rrset_name: subdomain,
        rrset_type: "A",
        rrset_ttl: 1800,
        rrset_values: [external_ip]
      }.to_json
    )

    puts "Update for #{subdomain}.#{domain} returned #{response.status}: #{response.status_message}"
  end
end
