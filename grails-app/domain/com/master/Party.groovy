package com.master

class Party {

    String name
    String address
    String contactNumber
    String email

    Boolean isDeleted = false
    String createdBy
    Date dateCreated
    String updatedBy
    Date lastUpdated

    static constraints = {
        name nullable: false
        address nullable: false
        contactNumber nullable: true
        email nullable: true
    }

    Map toMap(){
        return [
                id              : id,
                name            : name,
                address         : address,
                contactNumber   : contactNumber,
                email           : email
        ]
    }

    Map toCollectForDropDown(){
        return [
                id      : id,
                name    : name
        ]
    }
}