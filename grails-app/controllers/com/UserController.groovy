package com

import com.util.ServiceContext
import grails.plugin.springsecurity.annotation.Secured

class UserController {

    def sessionUtilService

    @Secured(['ROLE_SUPER_ADMIN', 'ROLE_ADMIN'])
    def home() {

        ServiceContext sCtx = sessionUtilService.fetchServiceContext(request)

        println ">>>>>>>>>>>>> Service Context >>>>>>>>>> "  + sCtx

        [title : "Dashboard"]
    }
}