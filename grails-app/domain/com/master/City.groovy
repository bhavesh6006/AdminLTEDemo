package com.master

class City {

    String name

    Boolean isDeleted = false
    String createdBy
    Date dateCreated
    String updatedBy
    Date lastUpdated

    static constraints = {
        name nullable: false
    }

    Map toMap(){
        return [
                id      : id,
                name    : name
        ]
    }

    Map toCollectForDropDown(){
        return [
                id      : id,
                name    : name
        ]
    }
}