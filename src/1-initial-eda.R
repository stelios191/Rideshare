library('ProjectTemplate')
load.project()

####### Temporal Features #######

# Box plot of Temporal features
RideShare_train %>% select(hour, day, month) %>% boxplot()

## price by the month
RideShare_train %>%
  drop_na(price) %>%
  group_by(month) %>%
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(month, avg_price))  + geom_point() + geom_smooth(method = "lm")  +
  labs(x = "Month", y = "Average Price")

## price by the day
RideShare_train %>%
  drop_na(price) %>%
  group_by(day) %>% 
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(day, avg_price))  + geom_point() + geom_smooth()  +
  labs(x = "Day of the month", y = "Average Price")

## price by the hour
RideShare_train %>%
  drop_na(price) %>%
  group_by(hour) %>%
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(hour, avg_price))  + geom_point() + geom_smooth()  +
  labs(x = "Hour", y = "Average Price")

####### Location & Distance Features #######

## price by the source area
RideShare_train %>%
  drop_na(price) %>%
  group_by(source) %>%
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(source, avg_price))  + geom_bar(stat = "identity")+
  scale_x_discrete(guide = guide_axis(angle = 90)) +
  labs(x = "Destination", y = "Average Price")

## price by the destination area
RideShare_train %>%
  drop_na(price) %>% 
  group_by(destination) %>% 
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(destination, avg_price))  + geom_bar(stat = "identity")+
  scale_x_discrete(guide = guide_axis(angle = 90)) +
  labs(x = "Source", y = "Average Price")

## price by the distance
RideShare_train %>%
  drop_na(price) %>%
  group_by(distance) %>% 
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(distance, avg_price))  + geom_point() + geom_smooth() +
  labs(x = "Distance", y = "Average Price")

####### Ride Characteristics Features #######

## price by the type of ride sharing service
RideShare_train %>%
  drop_na(price) %>%
  group_by(name) %>%
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(name, avg_price))  + geom_bar(stat = "identity")+
  scale_x_discrete(guide = guide_axis(angle = 90)) +
  labs(x = "Name", y = "Average Price")

## price by the ride sharing company
RideShare_train %>%
  drop_na(price) %>% 
  group_by(cab_type) %>% 
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(cab_type, avg_price))  + geom_bar(stat = "identity")+
  scale_x_discrete(guide = guide_axis(angle = 90)) +
  labs(x = "Cab Type", y = "Average Price")

####### Weather Features #######

# pressure
RideShare_train %>%
  drop_na(price) %>%
  group_by(pressure) %>% 
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(pressure, avg_price))  + geom_point() + geom_smooth() +
  labs(x = "Pressure", y = "Average Price")

# visibility
RideShare_train %>%
  drop_na(price) %>%
  group_by(visibility) %>% 
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(visibility, avg_price))  + geom_point() + geom_smooth() +
  labs(x = "Visibility", y = "Average Price")

# Temperature
RideShare_train %>%
  drop_na(price) %>%
  group_by(temperature) %>% 
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(temperature, avg_price))  + geom_point() + geom_smooth() +
  labs(x = "Temperature", y = "Average Price")

# Wind
RideShare_train %>%
  drop_na(price) %>%
  group_by(windSpeed) %>% 
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(windSpeed, avg_price))  + geom_point() + geom_smooth() +
  labs(x = "wind Speed", y = "Average Price")

# Humidity
RideShare_train %>%
  drop_na(price) %>%
  group_by(humidity) %>% 
  summarise(avg_price=mean(price)) %>%
  ggplot(aes(humidity, avg_price))  + geom_point() + geom_smooth() +
  labs(x = "Humidity", y = "Average Price")





