
Geocoder.configure(
  ip_lookup: :geoip2,
  geoip2: {
    file: Rails.root.join("lib", "GeoLite2-City.mmdb")
  }
)

if Rails.env.production?
  AuthTrail.job_queue = :low_priority
else
  AuthTrail.geocode = false
end
