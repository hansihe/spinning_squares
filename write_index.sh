cat <<EOT > out/www/index.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Lumen Spawn Chain Demo</title>
    <style>
      table {
        border-collapse: collapse;
      }

      td, th {
        border: 1px solid #898989;
        padding: 8px;
      }

      th {
        padding-top: 12px;
        padding-bottom: 12px;
        text-align: left;
        background-color: #7331af;
        color: white;
      }

      tr:nth-child(even) {
        background-color: #f2f2f2;
      }
    </style>
  </head>
  <body>
    <script src="./bootstrap.js"></script>
  </body>
</html>
EOT

cat <<EOT > out/www/bootstrap.js
// A dependency graph that contains any wasm must all be imported
// asynchronously. This `bootstrap.js` file does the single async import, so
// that no one else needs to worry about it again.
import("./index.js")
  .catch(e => console.error("Error importing `index.js`:", e));
EOT

cat <<EOT > out/www/index.js
import * as Interpreter from "interpreter-in-browser";

window.Interpreter = Interpreter;

const filesStr = "$1";
const files = filesStr.split(" ");
console.log(files);

function compile_url(url) {
    return fetch("src/" + url, {
        method: "GET",
    }).then((response) => {
        if (!response.ok) {
            throw "fail";
        }
        return response.text()
            .then((text) => {
                console.log(text);
                Interpreter.add_eir_module(text);
                return text;
            });
    });
}

Promise.all(files.map(url => compile_url(url))).then(() => {
    let heap = new Interpreter.JsHeap(1000);
    let num = heap.integer(12);
    console.log("spawning...");
    heap.spawn("foo", "bar", [num], 100000);
});

EOT
