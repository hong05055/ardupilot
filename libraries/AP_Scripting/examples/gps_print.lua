function update()
  gcs:send_text(0, "Hello World")
  local gps_location = gps:location(gps:primary_sensor())
  gcs:send_text(0, "Location is" .. string.format("%d", gps_location.lat))
  gcs:send_text(0, "Location is" .. string.format("%d", gps_location.lng))
  return update,100
end

return update()
