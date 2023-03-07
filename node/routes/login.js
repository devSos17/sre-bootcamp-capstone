import { loginFunction } from "../services/auth.js"

//login
export const login = async (req, res, next) => {
    let username = req.body.username;
    let password = req.body.password;

    let response = {
        data: await loginFunction(username, password),
    };
    //console.log(response)
    res.send(response);
    next();
};
