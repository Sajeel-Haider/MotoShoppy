"use strict";

const punchLine = document.querySelector(".punchLine h1");
const btnScrollTo = document.querySelector(".btn--scroll");
const sectionExpl = document.querySelector("#section--exploreId");
const exploreBtn = document.querySelector(".nav--explore");

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

// Button scrolling
btnScrollTo.addEventListener("click", function (e) {
  const s1coords = sectionExpl.getBoundingClientRect();
  console.log(s1coords);

  console.log(e.target.getBoundingClientRect());

  console.log("Current scroll (X/Y)", window.pageXOffset, window.pageYOffset);

  console.log(
    "height/width viewpoTTrt",
    document.documentElement.clientHeight,
    document.documentElement.clientWidth
  );

  sectionExpl.scrollIntoView({ behavior: "smooth" });
});

exploreBtn.addEventListener("click", function (e) {
  e.preventDefault();

  // Matching strategy
  if (e.target.classList.contains("nav--explore")) {
    const id = e.target.getAttribute("href");
    document.querySelector(id).scrollIntoView({ behavior: "smooth" });
  }
});
