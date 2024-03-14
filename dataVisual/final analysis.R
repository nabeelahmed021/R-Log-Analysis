df1 <- rdata


sapply(df1, class) 

#cleansing data 

df_filter<- na.omit(df1)
df_filter 

class(df_filter) 
df1 <- df1[!df1$ip == "null", ] 
df1
sapply(df1, class)


#change types 

df1[['TIME']] <- as.POSIXct(df1[['TIME']], format = "%Y-%m-%d %H:%M:%S")
df1[['DATE']] <- as.POSIXct(df1[['DATE']], format = "%Y-%m-%d")
df1

which(is.na(df1))
sum(is.na(df1))
remove(is.na(df1))
df1 <- na.omit(df1)
df1 <- df1[!is.na(df1$TIME), ]
sum(is.na(df1))


summary(df1)
barplot(table(df1$dummy_report))

attach(df1)


#because of so many values that why we take sampled_df 1000 rows of table
sampled_df <- df1[sample(nrow(df1), 1000), ]

df <- sampled_df


#summarize no/user
user_activity <- df %>%
  group_by(users) %>%
  summarize(
    interactions = n(),
    avg_database_access = mean(!is.na(database)),
    avg_response = mean(!is.na(response)),
    avg_session = mean(!is.na(session))
  )



df$TIME <- as.POSIXct(paste(df$DATE, format(df$TIME, "%H:%M:%S")))

#summarize & count interactions per user
usage_over_time <- df %>%
  mutate(hour = format(DATE, "%Y-%m-%d %H:00:00")) %>%
  group_by(hour, users) %>%
  summarize(interactions = n(), .groups = 'drop')  # Use '.groups = 'drop'' to suppress grouped output



install.packages("dplyr")
library(dplyr)

install.packages("ggplot2")
library(ggplot2)


#user x dummy
ggplot(sampled_df, aes( x = users,y = dummy_report)) +
  geom_point()+
  coord_cartesian(xlim = c(0,10))



#user x ip 
ggplot(sampled_df, aes(x = users, y = ip)) +
  geom_point()+
  coord_cartesian(xlim = c(0,10))



sapply(sampled_df,class)



#USERS USAGES 

library(ggplot2)
ggplot(user_activity, aes(x=users,y=interactions))+
  geom_bar(stat = "identity",fill= "skyblue")+
  labs(x='USERS',y='USER_INTERACTION')+
  coord_cartesian(xlim = c(30,50))



ggplot(user_activity, aes(x = users, y = avg_database_access)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  labs(x = "Users", y = "Average Database Used", title = "Average Database Usage")+
  coord_cartesian(xlim = c(10,40))

ggplot(user_activity, aes(x = users, y = avg_response)) +
  geom_bar(stat = "identity", fill = "orange") +
  labs(x = "Users", y = "Average Response Time", title = "Average Response Time")

ggplot(user_activity, aes(x = users, y = avg_session)) +
  geom_bar(stat = "identity", fill = "pink") +
  labs(x = "Users", y = "Average Session Duration", title = "Average Session Duration")




#PROPER DATA SET GRAPHS 


ggplot(df1, aes(x = users, y = database)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  labs(x = "Users", y = "Average Database Used", title = "Average Database Usage")+
  coord_cartesian(xlim = c(10,20), ylim = c(0,100))


ggplot(df1, aes(x = users, y = response)) +
  geom_bar(stat = "identity", fill = "orange") +
  labs(x = "Users", y = "Average Response Time", title = "Average Response Time")+
  coord_cartesian(xlim = c(40,60), ylim = c(0,500))


ggplot(df1, aes(x = users, y = session)) +
  geom_bar(stat = "identity", fill = "pink") +
  labs(x = "Users", y = "Average Session Duration", title = "Average Session Duration")+
  coord_cartesian(xlim = c(0,30), ylim = c(0,50))




# users x ip

ggplot(sampled_df, aes( x = users,y = ip)) +
  geom_point()+
  coord_cartesian(xlim = c(0,10))+
  coord_cartesian(ylim = c(0,10))

#ip x users fet 20 ips and 10 users

ggplot(data = df, aes(x = ip, y = users)) +
  geom_point(alpha = 0.1,color = "blue" ) +
  coord_cartesian(xlim = c(0,20),ylim = c(0,10))


ggplot(df, aes(x=users, y= ip, fill = users)) + 
  geom_bar(stat = "identity")+
  coord_cartesian(xlim = c(0,30), ylim = c(0,100))



ggplot(df, aes(x=server,y=users))+
  geom_line()+
  facet_wrap(facets =  vars(users[10]))+
  coord_cartesian(xlim = c(0,10),ylim=c(0,10))

ggplot(df,mapping = aes( x= id, y= users,color=users))+
  geom_line()+
  facet_wrap(vars(id))+
  labs(title= "observed user through ids",
       x='num of obs',
       Y="num of id")+
  theme_bw()+
  theme(text = element_text(size = 16))+
  coord_cartesian(xlim = c(0,10),ylim = c(0,100))




hist(user_activity$avg_response, breaks= 20)





#boxplot

ggplot(df,mapping = aes(x=users, y=server, color=server))+
  geom_boxplot()+
  coord_cartesian(xlim = c(0,10))


ggplot(df, aes(users))+ geom_bar()+
  scale_x_discrete("users",labels= c(0,100))



hist(df$TIME, breaks = 100)




# Example code to calculate user activity metrics
library(dplyr)
library(ggplot2)

# Assuming df is your dataframe containing the required columns

# Visualize user activity metrics
ggplot(user_activity, aes(x = users, y = interactions)) +
  geom_bar(stat = "identity") +
  labs(x = "User", y = "Number of Interactions")+
  coord_cartesian(c(0,15))



library(dplyr)
library(ggplot2)


# Combine date and time columns into a single datetime column
sampled_df$TIME <- as.POSIXct(paste(sampled_df$TIME, format(sampled_df$TIME, "%H:%M:%S")))

# Plot user usage over time
ggplot(usage_over_time, aes(x = hour, y = interactions, color = users)) +
  geom_line() +
  labs(x = "Date and Time", y = "Number of Interactions", color = "User") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis labels for better readability



#2nd
ggplot(usage_over_time, aes(x = hour, y = interactions, color = users)) +
  geom_line(size = 1) +  # Increase the size of the lines
  labs(x = "Date and Time", y = "Number of Interactions", color = "User") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability









# Aggregate data by time intervals (e.g., hourly) and count interactions per user
usage_over_time <- sampled_df %>%
  mutate(hour = format(TIME, "%Y-%m-%d %H:00:00")) %>%
  group_by(hour, users) %>%
  summarize(interactions = n(), .groups = 'drop')  # Use '.groups = 'drop'' to suppress grouped output









#copied


install.packages("plotly")


library(dplyr)
library(ggplot2)
library(plotly)

# Assuming your dataframe is named 'df'

# Combine date and time columns into a single datetime column
df$TIME <- as.POSIXct(paste(df$DATE, format(df$TIME, "%H:%M:%S")))

# Aggregate data by time intervals (e.g., hourly) and count interactions per user
usage_over_time <- df %>%
  mutate(hour = format(DATE, "%Y-%m-%d %H:00:00")) %>%
  group_by(hour, users) %>%
  summarize(interactions = n(), .groups = 'drop')  # Use '.groups = 'drop'' to suppress grouped output


#practice USER_USAGE



library(plotly)
fig <- plot_ly(x=user_activity$interactions,y=user_activity$users, type= "histogram")
fig


fig <- plot_ly(alpha = 0.6)
fig <- fig %>% add_histogram(x = user_activity$users)
#fig <- fig %>% add_histogram(x = user_activity$interactions + 1)
fig <- fig %>% layout(barmode = "overlay")

fig



       