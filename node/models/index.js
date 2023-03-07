import { Sequelize } from 'sequelize';
import config from 'config';

const dbConfig = config.get('dbConfig');

const sequelize = new Sequelize(dbConfig.db, dbConfig.user, dbConfig.password, {
    host: dbConfig.host,
    port: dbConfig.port,
    dialect: dbConfig.dialect,
    operatorAliases: false,
    pool: dbConfig.pool,
    define: {
        timestamps: false,
    },
});

export default sequelize;

export const User = require('./User.js')(sequelize);
