package com

import com.auth.User
import com.util.CodeConstants
import com.util.ServiceContext
import grails.transaction.Transactional

@Transactional
class SessionUtilService {

    def springSecurityService

    /**
     * Decides whether to call get service context or set depending on the call is from
     * mobile device or browser
     *
     * @param request : Holds the request
     *
     * @return : Service context of the user
     */
    ServiceContext fetchServiceContext(def request){

        ServiceContext sCtx

        // Construct the serviceContext
        if(request.getHeader("Authorization")) {
            sCtx = setServiceContextFromSpringSecurity()
        } else {

            sCtx = getServiceContext(request)
        }

        return sCtx
    }

    /**
     * Store user related data from spring security to service context.
     *
     * @return sCtx : Holds the current users security context
     */
    ServiceContext setServiceContextFromSpringSecurity(){

        Long id                     //table row id
        String userName             //user name of the user
        List userRoles      = []    //list of roles of a user
        ServiceContext sCtx

        try {
            id          = springSecurityService?.principal?.id
            userName    = springSecurityService?.principal?.username

            //fetching user
            User user = User.findByUsername(userName)

            //Get the role of logged in user.
            List authorities = springSecurityService?.principal?.authorities as List
            authorities.each { authority ->

                //fetching list roles a user has
                userRoles << authority.toString()
            }

            // Initialize the ServiceContext instance
            sCtx = new ServiceContext(
                    id              : id,
                    userName        : userName,
                    userRoles       : userRoles,
                    mobileNumber    : user.mobileNumber,
                    email           : user.email,
                    fullName        : user?.firstName + " " + user?.lastName,
                    companyId       : user?.companyId
            )
        }catch (Exception e){
            log.info "Exception ::: Service -> SessionUtilService ::: method -> setServiceContextFromSpringSecurity" + e.printStackTrace()
        }

        return sCtx
    }

    /**
     * For fetching the current user service context
     *
     * @param request : Holds the user request
     *
     * @return : Service context instance
     */
    ServiceContext getServiceContext(def request) {

        ServiceContext sCtx

        if(!(springSecurityService?.principal instanceof String)) {

            def session = request.session

            if(!session.getAttribute(CodeConstants.SERVICE_CONTEXT_ATTRIBUTE_NAME)) {

                // Construct the serviceContext
                sCtx = setServiceContextFromSpringSecurity()
                sCtx = setServiceContext(request, sCtx)
            } else {

                // Retrieving cached serviceContext from the session
                sCtx = session.getAttribute(CodeConstants.SERVICE_CONTEXT_ATTRIBUTE_NAME)
            }
        }

        return sCtx
    }

    /**
     * For setting the service context into the current session
     *
     * @param request   : Holds the request
     * @param sCtx      : Holds the current user service context
     *
     * @return : service context after setting it in session
     */
    ServiceContext setServiceContext(def request, ServiceContext sCtx) {

        def session = request.session

        // Cache  the serviceContext in the session
        session.setAttribute(CodeConstants.SERVICE_CONTEXT_ATTRIBUTE_NAME, sCtx)

        /*
         * The setMaxInactiveInterval function specifies the time, in seconds, between client requests
         *  before the servlet container will invalidate this session. We have set this threshold to an hour.
         */
        session.setMaxInactiveInterval(1800)

        return sCtx
    }
}
