package com.auth

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class User implements Serializable {

	private static final long serialVersionUID = 1

	transient springSecurityService

	String username
	String password
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired

    String firstName
    String lastName
    String email
    String mobileNumber
    Long companyId

//	User(String username, String password) {
//		this()
//		this.username = username
//		this.password = password
//	}

	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this)*.role
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
	}

	static transients = ['springSecurityService']

	static constraints = {
		username blank: false, unique: true
		password blank: false
        firstName nullable: false
        lastName nullable: false
        email nullable: true
        mobileNumber nullable: true
        companyId nullable: false
	}

	static mapping = {
		password column: '`password`'
	}

    Map toMap(){
        return [
                id                                  : id,
                userName                            : username,
                firstName                           : firstName,
                lastName                            : lastName,
                fullName                            : (firstName + " " + lastName),
                email                               : email,
                mobileNumber                        : mobileNumber,
                userRoles                           : getAuthorities()*.authority,
                enabled                             : enabled,
                accountExpired                      : accountExpired,
                accountLocked                       : accountLocked,
                passwordExpired                     : passwordExpired,
                companyId                           : companyId
        ]
    }
}
