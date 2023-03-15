"use strict";

const punchLine = document.querySelector(".punchLine h1");
const hiddenElements = document.querySelectorAll(".hidden");
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

//footer
const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    console.log(entry);
    if (entry.isIntersecting) {
      entry.target.classList.add("show");
    } else {
      entry.target.classList.remove("show");
    }
  });
});
hiddenElements.forEach((el) => observer.observe(el));
console.log(hiddenElements);
