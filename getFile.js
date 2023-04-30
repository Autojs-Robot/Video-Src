const fs = require('fs')

const index = {

}

const getFiles = (static = __dirname) => {
    index[static] = index[static] || 0;
    const files = fs.readdirSync(static).filter((item) => item.includes('.'))
    const file = files[index[static] % files.length]
    index[static] += 1;
    return file;
}

module.exports = getFiles;