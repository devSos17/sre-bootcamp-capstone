import jwt from 'jsonwebtoken';
import config from 'config';
import crypto from 'crypto';
import { User } from '../models';

const secret = config.get('jwtKey');

export const loginFunction = async (username, inputPassword) => {
    try {
        const userData = await User.findByPk(username);
        // Check user exists
        if (!userData) {
            return null;
        }
        const user = userData.toJSON();

        const hashedPsk = crypto
            .createHash('sha512')
            .update(inputPassword + user.salt)
            .digest('hex');

        // Check password
        if (hashedPsk !== user.password) {
            return null;
        }
        return jwt.sign({ role: user.role }, secret, {
            noTimestamp: true,
        });
    } catch (err) {
        console.error(err);
        return null;
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
