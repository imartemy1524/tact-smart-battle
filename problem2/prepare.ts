import { compileFunc } from '@ton-community/func-js';
import fs from 'fs';
import { Cell } from '@ton/core';



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
        const filePath = 'solution2.tact';
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
    const parentCode = await compileParent();
    await replaceConstantInTactFile(parentCode);
// in file solution3.tact replace asm fun actual_code(): Cell { B{blablabla} B>boc PUSHREF } with code
}
main()