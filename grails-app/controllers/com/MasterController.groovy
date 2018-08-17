package com

import com.util.ServiceContext
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

class MasterController {

    def sessionUtilService
    def masterManagementService

    @Secured(['ROLE_SUPER_ADMIN', 'ROLE_ADMIN'])
    def vehicleType() {
        [title : "Vehicle Type"]
    }

    /**
     * Function used for fetch all Vehicle Types
     */
    @Secured(['ROLE_SUPER_ADMIN', 'ROLE_ADMIN'])
    def fetchAllVehicleTypes() {

        log.info "===== fetchAllVehicleTypes ====="

        Map inputParams  = (request.JSON) ?: params

        Map responseMap = masterManagementService.fetchAllVehicleTypes(inputParams)

        // Paginate the response
        Map paginatedResponseMap = [
                recordsTotal    : (responseMap?.totalCount) ?: 0,
                recordsFiltered : (responseMap?.totalCount) ?: 0,
                data            : (responseMap?.dataList) ?:[],
                sStart          : inputParams.start
        ]

        render paginatedResponseMap as JSON
    }

    /**
     * Function used for vehicle Type CRUD
     */
    @Secured(['ROLE_SUPER_ADMIN', 'ROLE_ADMIN'])
    def vehicleTypeCRUD() {

        log.info "===== vehicleTypeCRUD ====="

        Map inputParams = (request.JSON) ?: params
        ServiceContext sCtx = sessionUtilService.fetchServiceContext(request)

        Map responseMap = masterManagementService.vehicleTypeCRUD(sCtx, inputParams)

        render(responseMap as JSON)
    }

    /**
     * Function used for fetch details of vehicle Type by id
     */
    @Secured(['ROLE_SUPER_ADMIN', 'ROLE_ADMIN'])
    def fetchVehicleTypeDetailsById() {

        log.info "===== fetchVehicleTypeDetailsById ====="

        Map inputParams = (request.JSON) ?: params
        ServiceContext sCtx = sessionUtilService.fetchServiceContext(request)

        Map responseMap = masterManagementService.fetchVehicleTypeDetailsById(sCtx, inputParams)

        render(responseMap as JSON)
    }
}
