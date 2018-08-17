package com.master

class VehicleType {

    String type

    Boolean isDeleted = false
    String createdBy
    Date dateCreated
    String updatedBy
    Date lastUpdated

    static constraints = {
        type nullable: false
    }

    Map toMap(){
        return [
                id      : id,
                type    : type
        ]
    }

    Map toCollectForDropDown(){
        return [
                id      : id,
                type    : type
        ]
    }
}