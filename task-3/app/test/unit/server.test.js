const chai = require('chai');
const chaiHttp = require('chai-http');
const server = require('../../src/server');

const { expect } = chai;
chai.use(chaiHttp);

describe('server.js', () => {
  let port = 8089;

  before((done) => {
    server.listen(port, () => {
      done();
    });
  });

  after((done) => {
    server.close(() => {
      done();
    });
  });

  it('should return "ReallyNotBad" when POST request to "/" contains header "NotBad" with value "true"', (done) => {
    chai.request(`http://localhost:${port}`)
      .post('/')
      .set('NotBad', 'true')
      .end((err, res) => {
        expect(err).to.be.null;
        expect(res).to.have.status(200);
        expect(res.text).to.equal('ReallyNotBad');
        done();
      });
  });

  it('should return 404 when POST request is sent to path other than "/" with header "NotBad" with value "ture"', (done) => {
    chai.request(`http://localhost:${port}`)
      .post('/testing')
      .set('NotBad', 'true')
      .end((err, res) => {
        expect(err).to.be.null;
        expect(res).to.have.status(404);
        expect(res.text).to.equal('Not found');
        done();
      });
  });

  it('should return 404 when POST request is sent with header "NotBad" with value "false"', (done) => {
    chai.request(`http://localhost:${port}`)
      .post('/')
      .set('NotBad', 'false')
      .end((err, res) => {
        expect(err).to.be.null;
        expect(res).to.have.status(404);
        expect(res.text).to.equal('Not found');
        done();
      });
  });

  it('should return 404 when GET request is sent', (done) => {
    chai.request(`http://localhost:${port}`)
      .get('/')
      .end((err, res) => {
        expect(err).to.be.null;
        expect(res).to.have.status(404);
        expect(res.text).to.equal('Not found');
        done();
      });
  });

  it('should return 404 when POST request is sent without header "notbad"', (done) => {
    chai.request(`http://localhost:${port}`)
      .post('/')
      .end((err, res) => {
        expect(err).to.be.null;
        expect(res).to.have.status(404);
        expect(res.text).to.equal('Not found');
        done();
      });
  });
});