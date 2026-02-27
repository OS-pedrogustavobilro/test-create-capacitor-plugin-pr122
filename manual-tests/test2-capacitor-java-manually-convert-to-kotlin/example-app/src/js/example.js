import { CapacitorJavaToKotlin } from 'test2-capacitor-java-manually-convert-to-kotlin';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    CapacitorJavaToKotlin.echo({ value: inputValue })
}
