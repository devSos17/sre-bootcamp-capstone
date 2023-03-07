import { cidrToMaskFunction, maskToCidrFunction } from '../services/cidr.js';

//cidrToMaskFunction
export const cidrToMask = (req, res, next) => {
    let value = req.query.value ?? false;
    if (!value) {
        res.send(422, 'No value provided');
    } else {
        let response = {
            function: 'cidrToMask',
            input: value,
            output: cidrToMaskFunction(value),
        };
        res.send(response);
        next();
    }
};

//maskToCidr
export const maskToCidr = (req, res, next) => {
    let value = req.query.value ? req.query.value : false;
    if (!value) {
        res.send(422, 'No value provided');
    } else {
        let response = {
            function: 'maskToCidr',
            input: value,
            output: maskToCidrFunction(value),
        };
        res.send(response);
        next();
    }
};
