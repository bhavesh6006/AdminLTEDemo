package com

import com.master.City
import com.master.Party
import com.master.VehicleType
import com.util.CodeConstants
import com.util.ServiceContext
import grails.transaction.Transactional

@Transactional
class MasterManagementService {

    /**
     * Method to fetch all Vehicle Types
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

    /**
     * Method to fetch all Cities
     *
     * @param paginationDetails     Pagination start index and users role
     * @return                      Response map with List of Cities and total records found
     */
    Map fetchAllCities(Map params) {

        Map responseMap = [userList: [], totalCount: 0]

        try {
            def cityList = City.createCriteria().list(max: CodeConstants.NUMBER_OF_RECORDS_PER_PAGE_IN_DATA_TABLE, offset: params?.start) {

                if (params.searchByCity) {
                    like("name", '%' + params.searchByCity + '%')
                }

                if (params.columnName) {
                    order(params.columnName, params.order)
                } else {
                    order("id", "desc")
                }

                eq("isDeleted", false)

                setReadOnly true
            }

            responseMap = [dataList: cityList*.toMap(), totalCount: cityList.totalCount]

        } catch (Exception e) {
            log.info("Exception ::: Service -> MasterManagementService ::: Method -> fetchAllCities ::: " + e.printStackTrace())
        }

        return responseMap
    }

    /**
     * Method to City CRUD
     *
     * @param sCtx      ServiceContext
     * @param params    Input params
     * @return          Response map with appropriate status and message
     */
    Map cityCRUD(ServiceContext sCtx, Map params) {

        Map responseMap = [(CodeConstants.RESPONSE_STATUS): false, (CodeConstants.RESPONSE_MESSAGE): "Something went wrong. Please try again."]

        try {

            City city = null
            def savedData = null

            switch (params.CRUD_MODE) {
                case "ADD":
                    city = new City()
                    city.name = params.name
                    city.createdBy = sCtx.id

                    savedData = city.save(flush: true)

                    if (savedData) {
                        responseMap = [(CodeConstants.RESPONSE_STATUS): true, (CodeConstants.RESPONSE_MESSAGE): "City has been saved successfully."]
                    }
                    break

                case "UPDATE":
                    city = City.findById(params.id as Long)
                    city.name = params.name
                    city.updatedBy = sCtx.id

                    savedData = city.save(flush: true)

                    if (savedData) {
                        responseMap = [(CodeConstants.RESPONSE_STATUS): true, (CodeConstants.RESPONSE_MESSAGE): "City has been updated successfully."]
                    }
                    break

                case "DELETE":
                    city = City.findById(params.id as Long)
                    city.isDeleted = true
                    city.updatedBy = sCtx.id

                    savedData = city.save(flush: true)

                    if (savedData) {
                        responseMap = [(CodeConstants.RESPONSE_STATUS): true, (CodeConstants.RESPONSE_MESSAGE): "City has been deleted successfully."]
                    }
                    break
            }
        } catch (Exception e) {
            log.info("Exception ::: Service -> MasterManagementService ::: Method -> cityCRUD ::: " + e.printStackTrace())
        }

        return responseMap
    }

    /**
     * Method to fetch details of City by id
     *
     * @param sCtx      ServiceContext
     * @param params    Input params
     * @return          Response map with appropriate status and details
     */
    Map fetchCityDetailsById(ServiceContext sCtx, Map params) {

        Map responseMap = [(CodeConstants.RESPONSE_STATUS): false, data: []]

        try {

            def cityData = City.findById(params.id as Long)

            if (cityData) {
                responseMap = [(CodeConstants.RESPONSE_STATUS): false, data: cityData.toMap()]
            }

        } catch (Exception e) {
            log.info("Exception ::: Service -> MasterManagementService ::: Method -> fetchCityDetailsById ::: " + e.printStackTrace())
        }

        return responseMap
    }

    /**
     * Method to fetch all Parties
     *
     * @param paginationDetails     Pagination start index and users role
     * @return                      Response map with List of Parties and total records found
     */
    Map fetchAllParties(Map params) {

        Map responseMap = [userList: [], totalCount: 0]

        try {
            def partyList = Party.createCriteria().list(max: CodeConstants.NUMBER_OF_RECORDS_PER_PAGE_IN_DATA_TABLE, offset: params?.start) {

                if (params.searchByPartyName) {
                    like("name", '%' + params.searchByPartyName + '%')
                }

                if (params.columnName) {
                    order(params.columnName, params.order)
                } else {
                    order("id", "desc")
                }

                eq("isDeleted", false)

                setReadOnly true
            }

            responseMap = [dataList: partyList*.toMap(), totalCount: partyList.totalCount]

        } catch (Exception e) {
            log.info("Exception ::: Service -> MasterManagementService ::: Method -> fetchAllParties ::: " + e.printStackTrace())
        }

        return responseMap
    }

    /**
     * Method to Party CRUD
     *
     * @param sCtx      ServiceContext
     * @param params    Input params
     * @return          Response map with appropriate status and message
     */
    Map partyCRUD(ServiceContext sCtx, Map params) {

        Map responseMap = [(CodeConstants.RESPONSE_STATUS): false, (CodeConstants.RESPONSE_MESSAGE): "Something went wrong. Please try again."]

        try {

            Party party = null
            def savedData = null

            switch (params.CRUD_MODE) {
                case "ADD":
                    party = new Party()
                    party.name          = params.name
                    party.address       = params.address
                    party.contactNumber = params.contactNumber
                    party.email         = params.email
                    party.createdBy     = sCtx.id

                    savedData = party.save(flush: true)

                    if (savedData) {
                        responseMap = [(CodeConstants.RESPONSE_STATUS): true, (CodeConstants.RESPONSE_MESSAGE): "Party has been saved successfully."]
                    }
                    break

                case "UPDATE":
                    party = Party.findById(params.id as Long)
                    party.name          = params.name
                    party.address       = params.address
                    party.contactNumber = params.contactNumber
                    party.email         = params.email
                    party.updatedBy     = sCtx.id

                    savedData = party.save(flush: true)

                    if (savedData) {
                        responseMap = [(CodeConstants.RESPONSE_STATUS): true, (CodeConstants.RESPONSE_MESSAGE): "Party has been updated successfully."]
                    }
                    break

                case "DELETE":
                    party = Party.findById(params.id as Long)
                    party.isDeleted = true
                    party.updatedBy = sCtx.id

                    savedData = party.save(flush: true)

                    if (savedData) {
                        responseMap = [(CodeConstants.RESPONSE_STATUS): true, (CodeConstants.RESPONSE_MESSAGE): "Party has been deleted successfully."]
                    }
                    break
            }
        } catch (Exception e) {
            log.info("Exception ::: Service -> MasterManagementService ::: Method -> partyCRUD ::: " + e.printStackTrace())
        }

        return responseMap
    }

    /**
     * Method to fetch details of Party by id
     *
     * @param sCtx      ServiceContext
     * @param params    Input params
     * @return          Response map with appropriate status and details
     */
    Map fetchPartyDetailsById(ServiceContext sCtx, Map params) {

        Map responseMap = [(CodeConstants.RESPONSE_STATUS): false, data: []]

        try {

            def partyData = Party.findById(params.id as Long)

            if (partyData) {
                responseMap = [(CodeConstants.RESPONSE_STATUS): false, data: partyData.toMap()]
            }

        } catch (Exception e) {
            log.info("Exception ::: Service -> MasterManagementService ::: Method -> fetchPartyDetailsById ::: " + e.printStackTrace())
        }

        return responseMap
    }
}
