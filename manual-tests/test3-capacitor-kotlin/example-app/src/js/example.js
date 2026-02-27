import { CapacitorKotlin } from 'test3-capacitor-kotlin';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    CapacitorKotlin.echo({ value: inputValue })
}
