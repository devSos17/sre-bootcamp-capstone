import chai from 'chai';
import * as methods from '../../services/methods.s';

const expect = chai.expect;

const adminToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYWRtaW4ifQ.StuYX978pQGnCeeaj2E1yBYwQvZIodyDTCJWXdsxBGI';
const badToken = `${adminToken}_dataextra`;

describe('loginFunction()', function () {
    it('Test login', async function () {
        expect(adminToken).to.be.equal(
            await methods.loginFunction('admin', 'secret')
        );
    });

    it('Test login wrong credentials', async function () {
        expect(
            await methods.loginFunction('admin', 'nocorrectpassword')
        ).to.be.equal(null);
    });
});

describe('protectFunction()', function () {
    it('Test protected', function () {
        expect('You are under protected data').to.be.equal(
            methods.protectFunction(adminToken)
        );
    });

    it('Test protected Endpoint with no valid jwt token', function () {
        expect(null).to.be.equal(methods.protectFunction(badToken));
    });
});
