library( data.table )
library( xlsx ) # xlsx depends on rJava, on Ubuntu install rJava via: apt-get install r-cran-rjava <[1]>
library( XML )


### obtain data from    about American Communities

if( !file.exists( './data' ) ){ # create data dir if it doesn't exist
    dir.create( 'data' )
}
download.file( url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", dest="./data/AmericanCommunities.csv", method="curl" ) # download file

download.file( url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf", dest="./data/AmericanCommunitiesCodebook.pdf", method="curl" ) # download codebook

downloadDate <- date() #mark record date

amcomm <- as.data.table( read.table( './data/AmericanCommunities.csv', sep=",", header=TRUE ) ) # load the csv file

amcomm[ VAL==24, .N ] # finding count of properties with value >1000000, using Data.table's .N feature




### obtain data for the topic of Natural Gas Acquisition

download.file( url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", dest="data/NaturalGasAcquisition.xlsx", method="curl" ) # download data
ngaDwnloadDate <- date()

dat <- as.data.table (read.xlsx( "data/NaturalGasAcquisition.xlsx", sheetIndex=1, colIndex=7:15, rowIndex=18:23, header=TRUE ) ) # load data

### value of sum(dat$Zip*dat$Ext,na.rm=T)
sum(dat$Zip*dat$Ext,na.rm=T)




### obtain the Baltimore Restaurant XML data
inData <- xmlTreeParse( "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", useInternal=TRUE ) # remove s from https <[2]>
rootNode <- xmlRoot(inData) # get the root node
xmlName(rootNode) # check what is that root node named
names( rootNode ) # see what nodes does that root node ocntains
cnode1 <- rootNode[[1]] # get the child node of the rootNode (there's only one)
xmlName( cnode1 ) # check the name of this first child node
names( cnode1 ) # see what other child notes does this first child node contains

cnode2 <- cnode1[[1]]
names( cnode2 )

extracted <- xpathApply( cnode1, "//zipcode", xmlValue ) # don't use xmlSApply for xpath <[3]>

### instead of a vector, the above line returns a list, each element contains a vector of one element. So need to fix this with:
zipcodes_list <- c()
for( i in extracted ){
    zipcodes_list <- c( zipcodes_list, i[1] )
}
zipcodes_list # is a vector containing 1327 zip code elements

sum( zipcodes_list == "21231" ) # number of restaurants in zipcode 21231



### American Communiities

download.file( ur="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", dest="data/AmericanCommunities2.csv", method="curl" )

DT <- as.data.table( fread( "data/AmericanCommunities2.csv", sep=",", header=TRUE ) ) # read in the file as a data table

DT[,mean(pwgtp15),by=SEX] # computes mean for variable pwgtp15, grouped by SEX




### <[1]> https://stackoverflow.com/questions/13462890/cant-install-rjava-on-ubuntu-system

### <[2]> https://stackoverflow.com/questions/23584514/error-xml-content-does-not-seem-to-be-xml-r-3-1-0

### <[3]> http://www.omegahat.net/RSXML/shortIntro.html
