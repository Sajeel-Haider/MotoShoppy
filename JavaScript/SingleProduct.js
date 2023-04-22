"use strict";
const productImg = document.getElementById("productImg");
const SmallImg = document.getElementsByClassName("small-img");

console.log(SmallImg);
console.log(productImg);

SmallImg[0].onclick = function () {
  productImg.src = SmallImg[0].src;
};
SmallImg[1].onclick = function () {
  productImg.src = SmallImg[1].src;
};
SmallImg[2].onclick = function () {
  productImg.src = SmallImg[2].src;
};
SmallImg[3].onclick = function () {
  productImg.src = SmallImg[3].src;
};
