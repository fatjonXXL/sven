function show_hide(element, changeElement, changeText1, changeText2) {
  el = document.getElementById(element);
  if(el != null) {
    if(el.style.display == "none") {
      el.style.display = "block";
    } else {
      el.style.display = "none";
    }

    if(changeElement != null) {
      chEl = document.getElementById(changeElement);
      chEl.innerHTML = (el.style.display == "none") ? changeText1 : changeText2;
    }

    return true;
  } else {
    return false;
  }
}

function image_show_hide(element, changeElement, changeImage1, changeImage2) {
  els = document.getElementsByClassName(element);
  for (i = 0; i < els.length; i++) {
    el = els[i];
    if(el != null) {
      if(el.style.display == "none") {
        el.style.display = "table-row";
      } else {
        el.style.display = "none";
      }

      if(changeElement != null) {
        chEl = document.getElementById(changeElement);
        chEl.src = (el.style.display == "none") ? changeImage1 : changeImage2;
      }
    }
  }
  
  return true;
}