# when reading data by read.table one cannot preserve header and skip rows at the same time,
# thats why one should do it in several steps

# First, read the header
header <- read.table("household_power_consumption.txt", header = FALSE, sep = ";", nrows = 1, stringsAsFactors = FALSE)

# While exploring data, I found that it is sorted by date.
# (If you want you can uncomment and run the code below to check its validity)
# data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";",
#                    na.strings = "?", stringsAsFactors = FALSE)
# Than I found the rows which correspond to requiered dates:
# required_rows <- rownames(data[data$Date %in% c("1/2/2007", "2/2/2007"), ])
# length(required_rows) # length is 2880,
# head(required_rows) # starts from 66637
# tail(required_rows) #  ends 69516,

# Second, read data: need to skip 66636 rows and then read 2880 rows
dat <- read.table("household_power_consumption.txt", header = TRUE, sep = ";",
                  na.strings = "?", skip = 66636, nrows = 2880, stringsAsFactors = FALSE)
# Third, combine header and data:
colnames(dat) <- unlist(header)

# We need exact time and date to build our plots,
# so lets combine and format these variables
dates <- dat$Date
times <- dat$Time
date_time <- strptime(paste(dates, times), format="%d/%m/%Y %H:%M:%S")

# Add new column into the data frame
dat$datetime <- date_time

# 3rd plot
png(file = "plot3.png")
with(dat,plot(datetime, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering"))

with(dat, {
        lines(datetime, Sub_metering_1)
        lines(datetime, Sub_metering_2, col = "red")
        lines(datetime, Sub_metering_3, col = "blue")
        legend("topright", col = c("black", "red", "blue"), lty = 1,
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})
dev.off()