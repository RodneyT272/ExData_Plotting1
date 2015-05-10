## File: plot4.R
## 


## Read needed rows from data file and format data frame.

## Get variable names
col_names_df <- read.delim("household_power_consumption.txt", sep = ";", nrows = 1, header = FALSE)
col_names_vector <- as.vector(t(col_names_df[1,]))

## Read pre-determined set of rows, set na strings, set variable types
electricity_usage_data <- read.delim("household_power_consumption.txt", sep = ";", skip = 66637,
                                     nrows = 2880, header = FALSE, na.strings = "?",
                                     col.names = col_names_vector, colClasses = c(rep("character", 2),
                                                                                  rep("numeric", 7)))

## Get R type dates from the date and time columns,
## replace these into data frame for the original variables
StrDateTime <- paste(electricity_usage_data$Date, electricity_usage_data$Time, sep = " ")
DateTimeCode <- strptime(StrDateTime, format="%d/%m/%Y %H:%M:%S")
WeekDaysTmp <- c("Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat")[as.POSIXlt(DateTimeCode)$wday + 1]
WeekDaysTmp <- factor(WeekDaysTmp)
WeekDaysTmp <- factor(WeekDaysTmp, levels(WeekDaysTmp)[c(2,1)])
electricity_usage_data$DateTime <- DateTimeCode
electricity_usage_data$WeekDays <- WeekDaysTmp
electricity_usage_data <- electricity_usage_data[,c(10,11,3,4,5,6,7,8,9)]

## Clean up a bit
rm(col_names_df, col_names_vector, StrDateTime, DateTimeCode, WeekDaysTmp)

## Create chart file

png(filename = "plot4.png", width = 480, height = 480)

par(mfcol = c(2,2))

## Top left active power line chart
with(electricity_usage_data, plot(DateTime, Global_active_power, col = "black",
                                  type = "l", xlab = "", ylab = "Global Active Power"))

## Bottom left sub-metering multi-line chart
with(electricity_usage_data, plot(DateTime, Sub_metering_1, col = "black",
                                  type = "l", xlab = "", ylab = "Energy sub metering"))
with(electricity_usage_data, lines(DateTime, Sub_metering_2, col = "red"))
with(electricity_usage_data, lines(DateTime, Sub_metering_3, col = "blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lwd = 1, box.lwd = 0)

## Top right line Voltage chart
with(electricity_usage_data, plot(DateTime, Voltage, col = "black",
                                  type = "l", xlab = "datetime", ylab = "Voltage"))

## Bottom right reactive power chart
with(electricity_usage_data, plot(DateTime, Global_reactive_power, col = "black",
                                  type = "l", xlab = "datetime", ylab = "Global_reactive_power"))

dev.off()

## Done