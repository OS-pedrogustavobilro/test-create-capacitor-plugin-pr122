import { CapacitorJava } from 'test1-capacitor-java';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    CapacitorJava.echo({ value: inputValue })
}
