"use strict";

const punchLine = document.querySelector(".punchLine h1");

const pLText = punchLine.textContent;
console.log(pLText);

punchLine.textContent = "";

const splitpL = pLText.split("");
console.log(splitpL);
for (let i = 0; i < splitpL.length; i++) {
  punchLine.innerHTML += "<span>" + splitpL[i] + "</span>";
}
let char = 0;
let timer = setInterval(onTick, 50);
function onTick() {
  const span = punchLine.querySelectorAll("span")[char];
  span.classList.add("fade");
  char++;
  if (char === pLText.length) {
    complete();
    return;
  }
}
function complete() {
  clearInterval(timer);
  timer = null;
}
