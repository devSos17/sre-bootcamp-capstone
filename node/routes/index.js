// import middleware from '../middleware';
import { health } from './health.js';
import { login } from './login.js';
import { cidrToMask, maskToCidr } from './cidr.js';

export const init = (app) => {
    app.get('/', health);
    app.get('/_health', health);
    app.post('/login', login);
    app.get('/cidr-to-mask', cidrToMask);
    app.get('/mask-to-cidr', maskToCidr);
};
