package com.master

class Company {

    String companyName
    String address

    Boolean isDeleted = false
    String createdBy
    Date dateCreated
    String updatedBy
    Date lastUpdated

    static constraints = {
        companyName nullable: false
        address nullable: false
    }
}
