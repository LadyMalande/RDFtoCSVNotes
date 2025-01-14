function transform(message) {

    if (!message) return
    // Update header text
	console.log("message" + message)
    const pattern3 = /<https:\/\/blank_Nodes_IRI\.org\/.*/g;

    const updatedmessage2 = message.replace(pattern3, (match) => {
        return "_:" + match.slice(29); // Remove the first two characters and the last character
    });
	
	console.log("updatedmessage2 " + updatedmessage2)

    const pattern2 = /_:.*?>/g;

    const updatedmessage = updatedmessage2.replace(pattern2, (match) => {
        return match.slice(0, -1); // Remove the first two characters and the last character
    });


    return updatedmessage
}

const events = require('events');
const fs = require('fs');
const readline = require('readline');

async function processLineByLine(fileName) {
    try {
        const rl = readline.createInterface({
            input: fs.createReadStream(fileName),
            crlfDelay: Infinity
        });

        rl.on('line', (line) => {
            const transformed = transform(line)
            if (!transformed) {
                console.log("")
            } else {
                console.log(transform(line));
            }

        });

        await events.once(rl, 'close');

        //console.log('Reading file line by line with readline done.');
        //const used = process.memoryUsage().heapUsed / 1024 / 1024;
        //console.log(`The script uses approximately ${Math.round(used * 100) / 100} MB`);
    } catch (err) {
        console.error(err);
    }
}

process.argv.forEach((val, index) => {
    if (index == 2) {
        processLineByLine(val)
    }
});
