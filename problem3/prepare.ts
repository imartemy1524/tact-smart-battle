import { compileFunc } from '@ton-community/func-js';
import fs from 'fs';
import { Cell } from '@ton/core';


async function compileChild(){
    const code = await compileFunc({
        sources: [
            {
                filename: "index.fc",
                content: await fs.promises.readFile(__dirname +"/child_code.fc", "utf-8"),
            },
            {
                filename: "imports/stdlib.fc",
                content: await fs.promises.readFile(__dirname +"/imports/stdlib.fc", "utf-8"),
            }
        ]
    })
    if(code.status !== "ok") {
        console.log(code);
        throw new Error("Compilation failed");
    }
    const cellCode = Cell.fromBase64(code.codeBoc);
    return cellCode;
}
async function writeCodeToFile(code: Cell){
    const string = code.toBoc().toString("hex")
    const codeString = `cell get_child_code() asm "B{${string}} B>boc PUSHREF";`
    await fs.promises.rm(__dirname + "/_compiled_code.fc");
}