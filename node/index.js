import Config from 'config';
import app from './server';

let config = Config;

let server = app.listen(config.port, function () {
    console.log('listening at', config.port);
});

process.on('SIGTERM', function () {
    console.log('Shitting down');
    server.close();
});
