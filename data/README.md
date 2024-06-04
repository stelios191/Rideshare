Here you'll store your raw data files. If they are encoded in a supported file format, they'll automatically be loaded when you call `load.project()`.

Data Schema:

id: unique identifier for each ride
timestamp: the Unix timestamp for each ride
hour: the hour of day the ride took place
day: the day of month the ride took place
month: the month the ride took place
datetime: date and time of the ride
source: the starting point for each ride
destination: the ending point for each ride
cab_type: the type of ride (Lyft or Uber)
name: the display name of the ride type
price: the price of the ride
distance: the distance of the ride in miles
surge_multiplier: the surge multiplier for the ride
temperature: the temperature in degrees Fahrenheit at the time of the ride
apparentTemperature: the "feels like" temperature in degrees Fahrenheit at the time of the ride
short_summary: a short description of the weather at the time of the ride
precipIntensity: the intensity of precipitation (inches of water per hour) at the time of the ride
precipProbability: the probability of precipitation at the time of the ride
humidity: the relative humidity at the time of the ride
windSpeed: the wind speed in miles per hour at the time of the ride
windGust: the wind gust speed in miles per hour at the time of the ride
visibility: the average visibility in miles at the time of the ride
temperatureHigh: the high temperature in degrees Fahrenheit for the day of the ride
temperatureLow: the low temperature in degrees Fahrenheit for the day of the ride
dewPoint: the dew point in degrees Fahrenheit at the time of the ride
pressure: the barometric pressure in millibars at the time of the ride
windBearing: the direction that the wind is coming from in degrees, with true north at 0 degrees
cloudCover: the percentage of sky obscured by clouds at the time of the ride
uvIndex: the UV index at the time of the ride
visibility.1: the visibility in miles at the time of the ride (identical to the visibility variable)