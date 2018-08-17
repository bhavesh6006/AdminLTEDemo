println "**************************************** DEV EXTERNAL CONFIG PICKED UP ****************************************"

import com.util.CodeConstants
import org.apache.log4j.*

/*-------------------------------------------------------------------------------------------------------
    SERVER CONFIGURATIONS
-------------------------------------------------------------------------------------------------------*/
// TODO : Set your server configuration
application.serviceHost                   = '192.168.150.67'
application.servicePort                   = '8080'
application.appServerURL	              = "http://${application.serviceHost}:${application.servicePort}/AdminLTEDemo"
grails.serverURL                          = "http://192.168.150.67:8080/AdminLTEDemo"
applicationBaseDir                        = "/home/KS127/dev/grails_projects/mdt"
application.war.userMode                  = 'Dev'
application.war.HostServerName            = '192.168.150.67'
application.war.HostServerCanonicalName	  = '192.168.150.67'
application.war.ServerIPAddress           = '192.168.150.67'
application.war.ServerMACAddress          = 'E0-69-95-A2-8D-67'

/*------------------------------------------------------------------------------------------------------
		                                DIRECTORY PATH CONFIGURATIONS
-------------------------------------------------------------------------------------------------------*/
applicationStorageDirectoryPath = System.getProperty("user.home") + File.separator + "${grails.util.Metadata.current.getApplicationName()}" + File.separator

/*------------------------------------------------------------------------------------------------------
    BOOTSTRAP DEFAULT ROLES AND ADMINS
 ------------------------------------------------------------------------------------------------------*/

// TODO : To add default roles add role in the below list
bootstrap.system.roles = [
        CodeConstants.ROLE_SUPER_ADMIN,
        CodeConstants.ROLE_ADMIN
]

// TODO : To add default super-admin user add details in the below list
bootstrap.system.default.superadmins = [
        [
                userName     : 'superAdmin',
                password     : 'user123',
                firstName    : 'Super',
                lastName     : 'Admin',
                email        : 'superadmin@mailinator.com',
                mobileNumber : "9898989898"
        ]
]

// TODO : To add default admin user add details in the below list
bootstrap.system.default.admins = [
        [
                userName     : 'admin',
                password     : 'user123',
                firstName    : 'Company',
                lastName     : 'Admin',
                email        : 'companyAdmin@mailinator.com',
                mobileNumber : "9863254712"
        ]
]

// TODO: To add default company add details in the below list
bootstrap.system.default.companies = [
        [
                companyName : 'Demo - 1 Company',
                address     : 'Pune'
        ],
        [
                companyName : 'Demo - 2 Company',
                address     : 'Mumbai'
        ]
]

/*------------------------------------------------------------------------------------------------------
    LOG4J configuration
-------------------------------------------------------------------------------------------------------*/
// TODO: Please check below logger file path
logger.files.folder.location = "${applicationStorageDirectoryPath}logs" + File.separator

println('************************** Application logs storage directory path ****************************' + logger.files.folder.location)

log4j.main = {

    appenders  {
        file name 	: 'loggernewMessageContentFile',
                file		: logger.files.folder.location + "logger-file.log",
                append		: false,
                layout		: pattern(conversionPattern: '%d{dd-MM-yyyy HH:mm:ss} [%5p] - %m%n')
        console name	: 'stdout',
                layout		: pattern(conversionPattern: '%d{dd-MM-yyyy HH:mm:ss ZZZ} [%5p] - %m%n')
        appender new DailyRollingFileAppender(
                name		: 'dailyAppender',
                datePattern	: "'.'yyyy-MM-dd",
                fileName	: logger.files.folder.location + "logger-file.log",
                layout	: pattern(conversionPattern: '%d{dd-MM-yyyy HH:mm:ss ZZZ} [%5p] [%c{1}] - %m%n')
        )
    }

    root{
        //debug 'dailyAppender'
        //info 'dailyAppender'
        info 'stdout', 'dailyAppender'
        //additivity = true
    }
}

/*------------------------------------------------------------------------------------------------------
    MySQL configuration
-------------------------------------------------------------------------------------------------------*/
mysqlDBName = "admin_lte_demo"

dataSource {
    dialect		    = 'hibernateutil.MySQL5InnoDBDialectBitFixed'
    pooled 		    = true
    dbCreate 	    = "update"
    url 		    = "jdbc:mysql://localhost/${mysqlDBName}?autoReconnect=true"
    driverClassName = "com.mysql.jdbc.Driver"
    username 		= "root"
    password 		= ""
}

system.big.logo.display.name = ""
system.small.logo.display.name = ""
system.login.page.logo = ""