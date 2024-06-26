var express = require('express');
var path = require('path');
var fs = require('fs');
var moment = require('moment');
var getFile = require('../getFile');
var router = express.Router();



router.get('/', function (req, res, next) {
  res.render('index', {
    title: 'Express', file: 'https://media.w3.org/2010/05/sintel/trailer.mp4'
  });
});


router.get('/data/:time/:folder/:name', function (req, res, next) {
  const from = req.path
  console.log("下载文件", req.path);
  res.sendFile(from, (err) => {
    if (!err) {
      const name = from.toString().replace(/\//g, '-')
      const to = path.join("/data", "used", name)
      fs.rename(from, to, (err) => {
        console.log(from, "=>", to, err);
      })
    }
  });
});


router.get('/upload/:time/:folder', function (req, res, next) {
  const { time, folder } = req.params;
  let t = time === 'yesterday' ? moment().subtract(1, 'days') : moment(time);
  if (!t.isValid()) {
    if (time == 'today') {
      t = moment()
    } else {
      t = moment().subtract(1, 'days')
    }
  }
  const dir = path.join("/data", t.format('YYYY-MM-DD'), folder)
  const filename = getFile(dir);
  const from = path.resolve(dir, filename)
  res.redirect(from.toString())
  // res.sendFile(from, (err) => {
  //   if (!err) {
  //     const name = from.toString().replace(/\//g, '-')
  //     const to = path.join("/data", "used", name)
  //     fs.rename(from, to, (err) => {
  //       console.log(from, "=>", to, err);
  //     })
  //   }
  // });

});


router.get('/:time/:folder', function (req, res, next) {
  const { time, folder } = req.params;
  let t = time === 'yesterday' ? moment().subtract(1, 'days') : moment(time);
  if (!t.isValid()) {
    if (time == 'today') {
      t = moment()
    } else {
      t = moment().subtract(1, 'days')
    }
  }
  const dir = path.join('/upload', t.format('YYYY-MM-DD'), folder)
  res.render('index', { title: 'Express', file: dir });
});

module.exports = router;
