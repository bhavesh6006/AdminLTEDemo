package hibernateutil;

import org.hibernate.dialect.MySQL5InnoDBDialect;

import java.sql.Types;

public class MySQL5InnoDBDialectBitFixed extends MySQL5InnoDBDialect {

    public MySQL5InnoDBDialectBitFixed() {
        super();
        registerColumnType(Types.BIT, "tinyint(1)");
    }
}