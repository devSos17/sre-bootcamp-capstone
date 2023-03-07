import { protectFunction } from '../services/auth.js';

export const authenticate = (req, res, next) => {
    // Strip the Bearer string
    try {
        const token = req.headers?.authorization?.split(' ')[1];
        const authenticated = protectFunction(token);
        if (authenticated) {
            next();
        } else {
            res.sendStatus(401);
        }
    } catch (error) {
        console.error(error);
        res.sendStatus(401);
    }
};
