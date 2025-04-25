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
    const codeString = `cell get_child_code() asm "B{${string}} B>boc PUSHREF";\n`
    await fs.promises.rm(__dirname + "/_compiled_code.fc");
    await fs.promises.writeFile(__dirname + "/_compiled_code.fc", codeString);
}
async function compileParent(){
    const code = await compileFunc({
        sources: [
            {
                filename: "code.fc",
                content: await fs.promises.readFile(__dirname +"/code.fc", "utf-8"),
            },
            {
                filename: "imports/stdlib.fc",
                content: await fs.promises.readFile(__dirname +"/imports/stdlib.fc", "utf-8"),
            }
        ]
    })
    if(code.status !== "ok") {
        console.error(code.message);
        throw new Error("Compilation failed");
    }
    const cellCode = Cell.fromBase64(code.codeBoc);
    return cellCode;
}
async function replaceConstantInTactFile(codeToReplace: Cell) {
    const code = codeToReplace.toBoc().toString("hex");
    try {
        // Read the file asynchronously
        const filePath = __dirname + '/solution5.tact';
        let content = await fs.promises.readFile(filePath, 'utf-8');

        // Replace the blablabla with constant f
        const updatedContent = content.replace(
            /asm fun actual_code\(\): Cell \{ B\{.+\} B>boc PUSHREF }/,
            `asm fun actual_code(): Cell { B{${code}} B>boc PUSHREF }`
        );

        // Write the changes back to the file
        await fs.promises.writeFile(filePath, updatedContent);

        console.log('File updated successfully!');
    } catch (error) {
        console.error('Error processing file:', error);
    }
}


async function main(){
    // const code = await compileChild();
    // await writeCodeToFile(code);
    const parentCode = await compileParent();
    replaceConstantInTactFile(parentCode);
// in file solution3.tact replace asm fun actual_code(): Cell { B{blablabla} B>boc PUSHREF } with code
}
main()