import { cidrToMaskFunction, maskToCidrFunction } from '../services/cidr.js';

//cidrToMaskFunction
export const cidrToMask = (req, res, next) => {
    let value = req.query.value ?? false;
    if (!value) {
    } else {
        let mask = cidrToMaskFunction(value);
        // Error handling
        if (!mask) {
            res.status(422).send('No value provided');
            return;
        }
        let response = {
            function: 'cidrToMask',
            input: value,
            output: mask,
        };
        res.send(response);
        next();
    }
};

//maskToCidr
export const maskToCidr = (req, res, next) => {
    let value = req.query.value ? req.query.value : false;
    if (!value) {
        res.status(422).send('No value provided');
    } else {
        let cidrPrefix = maskToCidrFunction(value);
        // Error Handling
        if (!cidrPrefix) {
            res.status(422).send('No value provided');
            return;
        }
        let response = {
            function: 'maskToCidr',
            input: value,
            output: cidrPrefix,
        };
        res.send(response);
        next();
    }
};
