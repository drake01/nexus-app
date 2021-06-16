var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/greet', function(req, res, next) {
  out = 'Got a GET request at /greet\nGreetings Friend!!\n';
  const greet = process.env.GREET || 'DEFAULT VALUE';
  out += `Using environment variable $GREET: ${greet} \n`;
  res.send(out);
});

module.exports = router;
