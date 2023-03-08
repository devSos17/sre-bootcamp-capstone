import chai from 'chai';
import { loginFunction, protectFunction } from '../services/auth.js';
import { cidrToMaskFunction, maskToCidrFunction } from '../services/cidr.js';

const expect = chai.expect;

const adminToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYWRtaW4ifQ.StuYX978pQGnCeeaj2E1yBYwQvZIodyDTCJWXdsxBGI';
const badToken = `${adminToken}_dataextra`;

describe('loginFunction()', function () {
    it('Test login', async function () {
        expect(adminToken).to.be.equal(await loginFunction('admin', 'secret'));
    });

    it('Test login wrong username', async function () {
        expect(await loginFunction('admins', 'secret')).to.be.equal(null);
    });

    it('Test login wrong password', async function () {
        expect(await loginFunction('admin', 'nocorrectpassword')).to.be.equal(
            null
        );
    });
});

describe('protectFunction()', function () {
    it('Test protected', function () {
        expect('You are under protected data').to.be.equal(
            protectFunction(adminToken)
        );
    });

    it('Test protected Endpoint with no valid jwt token', function () {
        expect(null).to.be.equal(protectFunction(badToken));
    });
});

describe('cidrToMaskFunction', function () {
    it('Test Correct conversion', function () {
        expect('255.255.255.0').to.be.equal(cidrToMaskFunction('24'));
    });

    it('Test invalid prefix', function () {
        expect(null).to.be.equal(cidrToMaskFunction('200'));
    });
});
describe('maskToCidrFunction', function () {
    it('Test correct conversion', function () {
        expect(16).to.be.equal(maskToCidrFunction('255.255.0.0'));
    });

    it('Test Invalid Mask', function () {
        expect(null).to.be.equal(maskToCidrFunction('256.255.255.0'));
    });
});
