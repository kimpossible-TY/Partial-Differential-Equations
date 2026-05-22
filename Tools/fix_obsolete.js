const fs = require('fs');
const path = require('path');
const obsoletePath = path.join(process.env.HOME, '.vscode/extensions/.obsolete');

if (fs.existsSync(obsoletePath)) {
    try {
        const content = fs.readFileSync(obsoletePath, 'utf8');
        const obsolete = JSON.parse(content);
        const key = 'antigravity.close-non-typ-tabs-0.0.1';

        if (obsolete[key]) {
            console.log(`Found ${key} in .obsolete, removing...`);
            delete obsolete[key];
            fs.writeFileSync(obsoletePath, JSON.stringify(obsolete, null, 2));
            console.log('Successfully updated .obsolete file.');
        } else {
            console.log(`${key} not found in .obsolete.`);
        }
    } catch (e) {
        console.error('Error processing .obsolete file:', e);
    }
} else {
    console.log('.obsolete file not found.');
}
