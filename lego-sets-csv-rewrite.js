const fs = require("fs");
const csv = require("csv");

let firstRecord = true;

const transform = ([first, ...rest]) => {
  if (firstRecord) {
    firstRecord = false;
    return [first, "variant", ...rest];
  }

  const fifthColumn = rest[3];
  if (!/^[1-9]\d*$/.test(fifthColumn)) return null;

  const match = first.match(/[0-9]+/g);
  if (match) {
    const [number, ...otherNumbers] = match;
    return [number, otherNumbers.join("-") || "", ...rest];
  }
  return [first, "", ...rest];
};

fs.createReadStream("sets.csv")
  .pipe(csv.parse({}))
  .pipe(csv.transform(transform))
  .pipe(csv.stringify({ delimiter: "\t" }))
  .pipe(process.stdout);
