import { loginFunction } from '../services/auth.js';

//login
export const login = async (req, res, next) => {
    let username = req.body.username;
    let password = req.body.password;

    let response = {
        data: await loginFunction(username, password),
    };
    if (!response.data) {
        res.sendStatus(403);
        return;
    }
    res.send(response);
    next();
};
