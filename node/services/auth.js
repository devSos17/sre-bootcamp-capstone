const jwt = require('jsonwebtoken');
const mysql = require('mysql');
const util = require('util');
const crypto = require('crypto');

const hostdb = process.env.DB_HOST;
const userdb = process.env.DB_USER;
const passworddb = process.env.DB_PASSWORD;
const database = process.env.DB_DATABASE;
const secret = process.env.JWT_KTY;
/* This database data is here just for you to test, please, remember to define your own DB
# You can test with username = admin, password = secret  
# This DB has already a best practice: a salt value to store the passwords*/
export const loginFunction = async (username, input_password) => {
    const db = mysql.createConnection({
        host: hostdb,
        user: userdb,
        password: passworddb,
        database: database,
    });
    db.query = util.promisify(db.query);
    try {
        const results = await db.query(
            'SELECT username, salt, role,password FROM users WHERE username = ?',
            [username]
        );
        const userobj = results[0];
        const hashedPassword = crypto
            .createHash('sha512')
            .update(input_password + userobj.salt)
            .digest('hex');
        if (!hashedPassword.localeCompare(userobj.password)) {
            const tokenJWT = jwt.sign(
                {
                    role: userobj.role,
                },
                secret,
                {
                    noTimestamp: true,
                }
            );
            return tokenJWT;
        }
        return null;
    } catch (err) {
        console.error(err);
    }
};

export const protectFunction = (authorization) => {
    try {
        const user = jwt.verify(authorization, secret);
        if (user) {
            return 'You are under protected data';
        }
        return null;
    } catch (err) {
        console.error('Invalid JWT Token!');
        return null;
    }
};
