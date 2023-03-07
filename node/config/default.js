module.exports = {
    port: 8000,
    environment: 'development',
    jwtKey: process.env.JWT_KEY,
    dbConfig: {
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        port: 3306,
        db: process.env.DB_DATABASE,
        dialect: 'mysql',
        pool: {
            max: 5,
            min: 0,
            acquire: 30000,
            idle: 10000,
        },
    },
};
