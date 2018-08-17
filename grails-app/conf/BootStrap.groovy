import com.auth.Role
import com.auth.User
import com.auth.UserRole
import com.master.Company
import com.util.CodeConstants
import grails.util.Holders

class BootStrap {

    def init = { servletContext ->

        // Bootstrap default companies
        bootstrapDefaultCompanies()

        // Bootstrap system roles
        bootstrapSystemRoles()

        // Bootstrap system default admin/super-admin
        bootstrapDefaultSystemAdminUsers()
    }

    /**
     * Create default company in the system
     */
    void bootstrapDefaultCompanies() {

        try {

            // Default company details list
            def defaultCompanies = Holders.config.bootstrap.system.default.companies

            defaultCompanies.each { companyDetails ->

                Company company = Company.findByCompanyName(companyDetails.companyName)

                if (!company) {
                    Company newCompany = new Company(
                            companyName : companyDetails.companyName,
                            address     : companyDetails.address
                    )

                    newCompany.save(flush: true)
                }
            }

        } catch (Exception e) {
            log.info("Exception ::: Class -> BootStrap ::: Method -> bootstrapDefaultCompanies ::: " + e.printStackTrace())
        }
    }

    /**
     * Create default roles for the system
     */
    void bootstrapSystemRoles() {

        try {
            // List of system roles
            List systemRoles = Holders.config.bootstrap.system.roles

            systemRoles.each { authority ->
                // Create new user role
                if (!Role.findByAuthority(authority)) {
                    new Role(authority: authority).save(flush: true)
                }
            }
        } catch (Exception e) {
            log.info("Exception ::: Class -> BootStrap ::: Method -> bootstrapSystemRoles ::: " + e.printStackTrace())
        }
    }

    /**
     * Create default super-admin and admin users in the system
     */
    void bootstrapDefaultSystemAdminUsers() {

        User user

        try {
            // Default super admin users registration details list
            def defaultSuperAdminUsers = Holders.config.bootstrap.system.default.superadmins

            defaultSuperAdminUsers.each { superAdminUser ->

                try {
                    user = User.findByUsername(superAdminUser?.userName, [readonly: true])

                    // If user doesn't exists then create new user
                    if (!user) {
                        // Create default super-admin user
                        User superAdmin = new User(
                                username        : superAdminUser?.userName,
                                password        : superAdminUser?.password,
                                firstName       : superAdminUser?.firstName,
                                lastName        : superAdminUser?.lastName,
                                email           : superAdminUser?.email,
                                mobileNumber    : superAdminUser?.mobileNumber,
                                companyId       : Company.first()?.id
                        )

                        superAdmin.save(flush: true)

                        // Assign role to super admin
                        Role superAdminRole = Role.findByAuthority(CodeConstants.ROLE_SUPER_ADMIN)
                        UserRole superAdminUserRole = UserRole.get(superAdmin.id, superAdminRole.id)
                        if (!superAdminUserRole) {
                            UserRole.create(superAdmin, superAdminRole, true)
                        }
                    }
                } catch (Exception e) {
                    log.info("Exception ::: Class -> BootStrap ::: Method -> bootstrapDefaultSystemSuperAdminUsers ::: " + e.printStackTrace())
                }
            }

        } catch (Exception e) {
        }
    }

    def destroy = {
    }
}
