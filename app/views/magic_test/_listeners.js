// document.addEventListener('keydown', function(e){keyDownFunction(e)}, true);
// document.addEventListener('keyup', function(e){keyUpFunction(e)}, true);
document.addEventListener('keypress', function(e){keypressFunction(e)});
document.addEventListener('mouseover', function(evt){mutationStart(evt)}, true);
document.addEventListener('mouseover', function(){mutationEnd()}, false);
document.addEventListener('click', function(event){clickFunction(event)});
