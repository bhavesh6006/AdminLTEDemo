package com.util

/**
 * Holds the users Service context parameters
 * Whenever application needs the current user details just call the toMap() method
 */
class ServiceContext {

    Long   id
    String userName
    List   userRoles
    String mobileNumber
    String email
    String fullName
    Long companyId

    public toMap() {

        return [
                id              : id,
                userName        : userName,
                userRoles       : userRoles,
                mobileNumber    : mobileNumber,
                email           : email,
                fullName        : fullName,
                companyId       : companyId
        ]
    }

    @Override
    public String toString() {
        return "ServiceContext{" +
                "id = " + id +
                ", userName = '" + userName + '\'' +
                ", userRoles = " + userRoles +
                ", mobileNumber = '" + mobileNumber + '\'' +
                ", email = '" + email + '\'' +
                ", fullName = '" + fullName +
                ", companyId = '" + companyId + '\''
                '}'
    }
}
