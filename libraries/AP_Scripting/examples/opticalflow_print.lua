local PARAM_FOCAL_LENGTH_MM = 16

// Pin 13 has an LED connected on most Arduino boards.
// Pin 11 has the LED on Teensy 2.0
// Pin 6  has the LED on Teensy++ 2.0
// Pin 13 has the LED on Teensy 3.0
// give it a name:
#define LED 13

long last_check = 0;
int px = 0;
int py = 0;
float focal_length_px = (PARAM_FOCAL_LENGTH_MM) / (4.0f * 6.0f) * 1000.0f;
  
// Initialize PX4Flow library
PX4Flow sensor = PX4Flow(); 


function update
  if (loop_start - last_check > 100) {
    local x_rate = sensor.gyro_x_rate_integral() / 10.0f;       // mrad
    local y_rate = sensor.gyro_y_rate_integral() / 10.0f;       // mrad
    local flow_x = sensor.pixel_flow_x_integral() / 10.0f;      // mrad
    local flow_y = sensor.pixel_flow_y_integral() / 10.0f;      // mrad  
    local timespan = sensor.integration_timespan();               // microseconds
    local distance_cm = rangefinder:distance_cm_orient(rotation)    // cm
    local quality = sensor.quality_integral();
    
    if (quality > 100)
    {
      // Update flow rate with gyro rate
      local pixel_x = flow_x + x_rate; // mrad
      local pixel_y = flow_y + y_rate; // mrad
      
      local velocity_x = pixel_x * ground_distance  / (timespan/10)     // m/s
      local velocity_y = pixel_y * ground_distance  / (timespan/10)     // m/s 
      
      // Integrate velocity to get pose estimate
      px = px + velocity_x * 100;
      py = py + velocity_y * 100;
    }
    else {
      Serial.println("");
    }
    
    last_check = loop_start;
  }
}
