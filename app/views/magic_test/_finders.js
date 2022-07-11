function getPathTo(element) {
  if (element.tagName === 'HTML') {
    return '/HTML[1]';
  }
  if (element===document.body) {
    return '/HTML[1]/BODY[1]';
  }
  var ix = 0;
  var siblings = element.parentNode.childNodes;
  for (var i= 0; i<siblings.length; i++) {
    var sibling= siblings[i];
    if (sibling===element) {
      return getPathTo(element.parentNode)+'/'+element.tagName+'['+(ix+1)+']';
    }
    if (sibling.nodeType===1 && sibling.tagName===element.tagName) {
      ix++;
    }
  }
}

function visibleFilter(target){
  var computedStyle = window.getComputedStyle(target);
  return !(computedStyle.display === 'none' || computedStyle.visibility === 'hidden' || target.hidden)
}


function finderForElement(element) {
  // Try to find just using the element tagName
  var tagName = element.tagName.toLowerCase();
  if (document.querySelectorAll(tagName).length === 1) {
    return `find('${tagName}')`;
  }
  // Try adding in the classes of the element
  var classList = [].slice.apply(element.classList)
  var classString = classList.length ? "." + classList.join('.') : "";
  if (classList.length && document.querySelectorAll(tagName + classList).length === 1) {
    return `find('${tagName}${classString}')`;
  }
  // Try adding in the text of the element
  var text = element.textContent.trim();
  var targets = Array.from(document.querySelectorAll(`${tagName}${classString}`))
                     .filter(visibleFilter)
                     .filter((el) => el.textContent.includes(text))
  if (text && targets.length === 1) {
    return `find('${tagName}${classString}', text: '${text}')`;
  }
  // use the xpath to the element
  return `find(:xpath, '${getPathTo(element)}')`;
}
