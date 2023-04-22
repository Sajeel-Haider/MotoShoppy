// Optional code to randomly shuffle explore items
const exploreContainer = document.querySelector(".explore-container");
for (let i = exploreContainer.children.length; i >= 0; i--) {
  exploreContainer.appendChild(
    exploreContainer.children[(Math.random() * i) | 0]
  );
}
