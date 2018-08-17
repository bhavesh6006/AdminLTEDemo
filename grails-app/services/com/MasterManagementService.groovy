package com

import com.master.VehicleType
import com.util.CodeConstants
import com.util.ServiceContext
import grails.transaction.Transactional

@Transactional
class MasterManagementService {

    /**
     * Method to fetch all users with given role
     *
     * @param paginationDetails     Pagination start index and users role
     * @return                      Response map with List of Vehicle Types and total records found
     */
    Map fetchAllVehicleTypes(Map params) {

        Map responseMap = [userList: [], totalCount: 0]

        try {
            def vehicleTypeList = VehicleType.createCriteria().list(max: CodeConstants.NUMBER_OF_RECORDS_PER_PAGE_IN_DATA_TABLE, offset: params?.start) {

                if (params.searchByVehicleType) {
                    like("type", '%' + params.searchByVehicleType + '%')
                }

                if (params.columnName) {
                    order(params.columnName, params.order)
                } else {
                    order("id", "desc")
                }

                eq("isDeleted", false)

                setReadOnly true
            }

            responseMap = [dataList: vehicleTypeList*.toMap(), totalCount: vehicleTypeList.totalCount]

        } catch (Exception e) {
            log.info("Exception ::: Service -> MasterManagementService ::: Method -> fetchAllVehicleTypes ::: " + e.printStackTrace())
        }

        return responseMap
    }

    /**
     * Method to Vehicle Type CRUD
     *
     * @param sCtx      ServiceContext
     * @param params    Input params
     * @return          Response map with appropriate status and message
     */
    Map vehicleTypeCRUD(ServiceContext sCtx, Map params) {

        Map responseMap = [(CodeConstants.RESPONSE_STATUS): false, (CodeConstants.RESPONSE_MESSAGE): "Something went wrong. Please try again."]

        try {

            VehicleType vehicleType = null
            def savedData = null

            switch (params.CRUD_MODE) {
                case "ADD":
                    vehicleType = new VehicleType()
                    vehicleType.type = params.type
                    vehicleType.createdBy = sCtx.id

                    savedData = vehicleType.save(flush: true)

                    if (savedData) {
                        responseMap = [(CodeConstants.RESPONSE_STATUS): true, (CodeConstants.RESPONSE_MESSAGE): "Vehicle Type has been saved successfully."]
                    }
                    break

                case "UPDATE":
                    vehicleType = VehicleType.findById(params.id as Long)
                    vehicleType.type = params.type
                    vehicleType.updatedBy = sCtx.id

                    savedData = vehicleType.save(flush: true)

                    if (savedData) {
                        responseMap = [(CodeConstants.RESPONSE_STATUS): true, (CodeConstants.RESPONSE_MESSAGE): "Vehicle Type has been updated successfully."]
                    }
                    break

                case "DELETE":
                    vehicleType = VehicleType.findById(params.id as Long)
                    vehicleType.isDeleted = true
                    vehicleType.updatedBy = sCtx.id

                    savedData = vehicleType.save(flush: true)

                    if (savedData) {
                        responseMap = [(CodeConstants.RESPONSE_STATUS): true, (CodeConstants.RESPONSE_MESSAGE): "Vehicle Type has been deleted successfully."]
                    }
                    break
            }
        } catch (Exception e) {
            log.info("Exception ::: Service -> MasterManagementService ::: Method -> vehicleTypeCRUD ::: " + e.printStackTrace())
        }

        return responseMap
    }

    /**
     * Method to fetch details of Vehicle Type by id
     *
     * @param sCtx      ServiceContext
     * @param params    Input params
     * @return          Response map with appropriate status and details
     */
    Map fetchVehicleTypeDetailsById(ServiceContext sCtx, Map params) {

        Map responseMap = [(CodeConstants.RESPONSE_STATUS): false, data: []]

        try {

            def vehicleTypeData = VehicleType.findById(params.id as Long)

            if (vehicleTypeData) {
                responseMap = [(CodeConstants.RESPONSE_STATUS): false, data: vehicleTypeData.toMap()]
            }

        } catch (Exception e) {
            log.info("Exception ::: Service -> MasterManagementService ::: Method -> fetchVehicleTypeDetailsById ::: " + e.printStackTrace())
        }

        return responseMap
    }
}
