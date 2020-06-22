library(data.table)


# Change locale setting ---------------------------------------------------


# Store original locale before changes it
Original_locale <- Sys.getlocale("LC_TIME")

# Change locale to US
Sys.setlocale("LC_TIME","us")


# Read data ---------------------------------------------------------------


filename <- "household_power_consumption.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if file exists
if (!file.exists("household_power_consumption.txt")) { 
  unzip(filename) 
}

# Read the entire data into R
total_data <- fread("household_power_consumption.txt")


# Change classes of the data
total_data$Date <- as.Date(total_data$Date, format="%d/%m/%Y")
total_data$Global_active_power <- as.numeric(total_data$Global_active_power)
total_data$Global_reactive_power <- as.numeric(total_data$Global_reactive_power)
total_data$Voltage <- as.numeric(total_data$Voltage)
total_data$Global_intensity <- as.numeric(total_data$Global_intensity)
# Warnings will appear: "NAs introduced by coercion"
total_data$Sub_metering_1 <- as.numeric(total_data$Sub_metering_1)
total_data$Sub_metering_2 <- as.numeric(total_data$Sub_metering_2)
total_data$Sub_metering_3 <- as.numeric(total_data$Sub_metering_3)
# Create Date_Time variable
total_data$Date_Time <- paste(total_data$Date, total_data$Time, sep = " ")
total_data$Date_Time <- as.POSIXct(strptime(total_data$Date_Time, 
                                            format = "%Y-%m-%d %H:%M:%S"))


# Use data only from the dates 2007-02-01 and 2007-02-02
sub_data <- subset(total_data, Date == "2007-02-01" | Date == "2007-02-02")



# plot --------------------------------------------------------------------

par(mfrow = c(1,1))

plot(x = sub_data$Date_Time, 
     y = sub_data$Global_active_power,
     type = "l",
     ylab = "Gloval Active Power (kikowatts)",
     xlab = "")

# Save to a file
dev.copy(png, "plot2.png", width = 480, height = 480)
dev.off()

# restore locale to the original
Sys.setlocale("LC_TIME", Original_locale)
