Fx.ProgressBar=new Class({Extends:Fx,options:{text:null,transition:Fx.Transitions.Circ.easeOut,link:"cancel"},initialize:function(b,a){this.element=$(b);this.parent(a);this.text=$(this.options.text);this.set(0)},start:function(b,a){return this.parent(this.now,(arguments.length==1)?b.limit(0,100):b/a*100)},set:function(a){this.now=a;this.element.setStyle("backgroundPosition",(100-a)+"% 0px");if(this.text){this.text.set("text",Math.round(a)+"%")}return this}});