// Copyright 2011 Software Freedom Conservatory
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// This code was built by the Selenium code base
// See https://github.com/SeleniumHQ/selenium/tree/master/javascript/watir-atoms

function(){return function(){var l=this;
function m(a){var c=typeof a;if(c=="object")if(a){if(a instanceof Array)return"array";else if(a instanceof Object)return c;var b=Object.prototype.toString.call(a);if(b=="[object Window]")return"object";if(b=="[object Array]"||typeof a.length=="number"&&typeof a.splice!="undefined"&&typeof a.propertyIsEnumerable!="undefined"&&!a.propertyIsEnumerable("splice"))return"array";if(b=="[object Function]"||typeof a.call!="undefined"&&typeof a.propertyIsEnumerable!="undefined"&&!a.propertyIsEnumerable("call"))return"function"}else return"null";else if(c==
"function"&&typeof a.call=="undefined")return"object";return c}function n(a,c){function b(){}b.prototype=c.prototype;a.i=c.prototype;a.prototype=new b};function o(a){this.stack=Error().stack||"";if(a)this.message=String(a)}n(o,Error);function aa(a){for(var c=1;c<arguments.length;c++){var b=String(arguments[c]).replace(/\$/g,"$$$$");a=a.replace(/\%s/,b)}return a}
function p(a,c){var b=0,d=String(a).replace(/^[\s\xa0]+|[\s\xa0]+$/g,"").split("."),f=String(c).replace(/^[\s\xa0]+|[\s\xa0]+$/g,"").split("."),k=Math.max(d.length,f.length);for(var j=0;b==0&&j<k;j++){var e=d[j]||"",g=f[j]||"",q=RegExp("(\\d*)(\\D*)","g"),s=RegExp("(\\d*)(\\D*)","g");do{var h=q.exec(e)||["","",""],i=s.exec(g)||["","",""];if(h[0].length==0&&i[0].length==0)break;b=r(h[1].length==0?0:parseInt(h[1],10),i[1].length==0?0:parseInt(i[1],10))||r(h[2].length==0,i[2].length==0)||r(h[2],i[2])}while(b==
0)}return b}function r(a,c){if(a<c)return-1;else if(a>c)return 1;return 0};function t(a,c){c.unshift(a);o.call(this,aa.apply(null,c));c.shift();this.l=a}n(t,o);function ba(a,c){if(!a){var b=Array.prototype.slice.call(arguments,2),d="Assertion failed";if(c){d+=": "+c;var f=b}throw new t(""+d,f||[]);}return a};var u=Array.prototype,ca=u.indexOf?function(a,c,b){ba(a.length!=null);return u.indexOf.call(a,c,b)}:function(a,c,b){b=b==null?0:b<0?Math.max(0,a.length+b):b;if(typeof a=="string"){if(typeof c!="string"||c.length!=1)return-1;return a.indexOf(c,b)}for(b=b;b<a.length;b++)if(b in a&&a[b]===c)return b;return-1};var v,w,x,y;function z(){return l.navigator?l.navigator.userAgent:null}y=x=w=v=false;var A;if(A=z()){var da=l.navigator;v=A.indexOf("Opera")==0;w=!v&&A.indexOf("MSIE")!=-1;x=!v&&A.indexOf("WebKit")!=-1;y=!v&&!x&&da.product=="Gecko"}var B=v,C=w,D=y,E=x,F;
a:{var G="",H;if(B&&l.opera){var I=l.opera.version;G=typeof I=="function"?I():I}else{if(D)H=/rv\:([^\);]+)(\)|;)/;else if(C)H=/MSIE\s+([^\);]+)(\)|;)/;else if(E)H=/WebKit\/(\S+)/;if(H){var J=H.exec(z());G=J?J[1]:""}}if(C){var K,L=l.document;K=L?L.documentMode:undefined;if(K>parseFloat(G)){F=String(K);break a}}F=G}var M={};var ea;!C||M["9"]||(M["9"]=p(F,"9")>=0);C&&(M["9"]||(M["9"]=p(F,"9")>=0));function N(a,c){this.x=a!==undefined?a:0;this.y=c!==undefined?c:0}N.prototype.toString=function(){return"("+this.x+", "+this.y+")"};function O(a){return a?new fa(P(a)):ea||(ea=new fa)}function P(a){return a.nodeType==9?a:a.ownerDocument||a.document}function fa(a){this.e=a||l.document||document}function ga(a){a=!E&&a.e.compatMode=="CSS1Compat"?a.e.documentElement:a.e.body;return new N(a.scrollLeft,a.scrollTop)};var Q="StopIteration"in l?l.StopIteration:Error("StopIteration");function ha(){}ha.prototype.next=function(){throw Q;};function R(a,c,b,d,f){this.a=!!c;a&&S(this,a,d);this.d=f!=undefined?f:this.c||0;if(this.a)this.d*=-1;this.h=!b}n(R,ha);R.prototype.b=null;R.prototype.c=0;R.prototype.g=false;function S(a,c,b,d){if(a.b=c)a.c=typeof b=="number"?b:a.b.nodeType!=1?0:a.a?-1:1;if(typeof d=="number")a.d=d}
R.prototype.next=function(){var a;if(this.g){if(!this.b||this.h&&this.d==0)throw Q;a=this.b;var c=this.a?-1:1;if(this.c==c){var b=this.a?a.lastChild:a.firstChild;b?S(this,b):S(this,a,c*-1)}else(b=this.a?a.previousSibling:a.nextSibling)?S(this,b):S(this,a.parentNode,c*-1);this.d+=this.c*(this.a?-1:1)}else this.g=true;a=this.b;if(!this.b)throw Q;return a};
R.prototype.splice=function(){var a=this.b,c=this.a?1:-1;if(this.c==c){this.c=c*-1;this.d+=this.c*(this.a?-1:1)}this.a=!this.a;R.prototype.next.call(this);this.a=!this.a;c=arguments[0];var b=m(c);c=b=="array"||b=="object"&&typeof c.length=="number"?arguments[0]:arguments;for(b=c.length-1;b>=0;b--)a.parentNode&&a.parentNode.insertBefore(c[b],a.nextSibling);a&&a.parentNode&&a.parentNode.removeChild(a)};function T(a,c,b,d){R.call(this,a,c,b,null,d)}n(T,R);T.prototype.next=function(){do T.i.next.call(this);while(this.c==-1);return this.b};function U(a,c){var b;a:{b=P(a);if(b.defaultView&&b.defaultView.getComputedStyle)if(b=b.defaultView.getComputedStyle(a,null)){b=b[c]||b.getPropertyValue(c);break a}b=""}return b||(a.currentStyle?a.currentStyle[c]:null)||a.style[c]}function ia(a){var c=a.getBoundingClientRect();if(C){a=a.ownerDocument;c.left-=a.documentElement.clientLeft+a.body.clientLeft;c.top-=a.documentElement.clientTop+a.body.clientTop}return c}
function ja(a){if(C)return a.offsetParent;var c=P(a),b=U(a,"position"),d=b=="fixed"||b=="absolute";for(a=a.parentNode;a&&a!=c;a=a.parentNode){b=U(a,"position");d=d&&b=="static"&&a!=c.documentElement&&a!=c.body;if(!d&&(a.scrollWidth>a.clientWidth||a.scrollHeight>a.clientHeight||b=="fixed"||b=="absolute"))return a}return null};String.fromCharCode(160);var ka=C?1:0,la=["dragstart","dragexit","mouseover","mouseout"];
function V(a,c,b){var d=P(a),f=d?d.parentWindow||d.defaultView:window,k=new N;if(a.nodeType==1)if(a.getBoundingClientRect){var j=ia(a);k.x=j.left;k.y=j.top}else{j=ga(O(a));var e,g=P(a),q=U(a,"position"),s=D&&g.getBoxObjectFor&&!a.getBoundingClientRect&&q=="absolute"&&(e=g.getBoxObjectFor(a))&&(e.screenX<0||e.screenY<0),h=new N(0,0),i;e=g?g.nodeType==9?g:P(g):document;if(i=C)i=O(e).e.compatMode!="CSS1Compat";i=i?e.body:e.documentElement;if(a!=i)if(a.getBoundingClientRect){e=ia(a);g=ga(O(g));h.x=e.left+
g.x;h.y=e.top+g.y}else if(g.getBoxObjectFor&&!s){e=g.getBoxObjectFor(a);g=g.getBoxObjectFor(i);h.x=e.screenX-g.screenX;h.y=e.screenY-g.screenY}else{e=a;do{h.x+=e.offsetLeft;h.y+=e.offsetTop;if(e!=a){h.x+=e.clientLeft||0;h.y+=e.clientTop||0}if(E&&U(e,"position")=="fixed"){h.x+=g.body.scrollLeft;h.y+=g.body.scrollTop;break}e=e.offsetParent}while(e&&e!=a);if(B||E&&q=="absolute")h.y-=g.body.offsetTop;for(e=a;(e=ja(e))&&e!=g.body&&e!=i;){h.x-=e.scrollLeft;if(!B||e.tagName!="TR")h.y-=e.scrollTop}}k.x=h.x-
j.x;k.y=h.y-j.y}else{j=m(a.f)=="function";h=a;if(a.targetTouches)h=a.targetTouches[0];else if(j&&a.f().targetTouches)h=a.f().targetTouches[0];k.x=h.clientX;k.y=h.clientY}i=b||{};b=(i.x||0)+k.x;k=(i.y||0)+k.y;j=i.button||ka;h=i.bubble||true;g=null;if(ca(la,c)>=0)g=i.related||null;q=!!i.alt;e=!!i.control;s=!!i.shift;i=!!i.meta;if(a.fireEvent&&d&&d.createEventObject){a=d.createEventObject();a.altKey=q;a.j=e;a.metaKey=i;a.shiftKey=s;a.clientX=b;a.clientY=k;a.button=j;a.relatedTarget=g}else{a=d.createEvent("MouseEvents");
if(a.initMouseEvent)a.initMouseEvent(c,h,true,f,1,0,0,b,k,e,q,s,i,j,g);else{a.initEvent(c,h,true);a.shiftKey=s;a.metaKey=i;a.altKey=q;a.ctrlKey=e;a.button=j}}return a}
function W(a,c,b){var d=P(a);a=d?d.parentWindow||d.defaultView:window;var f=b||{};b=f.keyCode||0;var k=f.charCode||0,j=!!f.alt,e=!!f.ctrl,g=!!f.shift;f=!!f.meta;if(D){d=d.createEvent("KeyboardEvent");d.initKeyEvent(c,true,true,a,e,j,g,f,b,k)}else{if(C)d=d.createEventObject();else{d=d.createEvent("Events");d.initEvent(c,true,true);d.charCode=k}d.keyCode=b;d.altKey=j;d.ctrlKey=e;d.metaKey=f;d.shiftKey=g}return d}
function ma(a,c,b){var d=P(a),f=b||{};b=f.bubble!==false;var k=!!f.alt,j=!!f.control,e=!!f.shift;f=!!f.meta;if(a.fireEvent&&d&&d.createEventObject){a=d.createEventObject();a.altKey=k;a.k=j;a.metaKey=f;a.shiftKey=e}else{a=d.createEvent("HTMLEvents");a.initEvent(c,b,true);a.shiftKey=e;a.metaKey=f;a.altKey=k;a.ctrlKey=j}return a}var X={};X.click=V;X.keydown=W;X.keypress=W;X.keyup=W;X.mousedown=V;X.mousemove=V;X.mouseout=V;X.mouseover=V;X.mouseup=V;function na(a,c,b){b=(X[c]||ma)(a,c,b);var d;if(!(d=m(a.fireEvent)=="function")){d=m(a.fireEvent);d=d=="object"||d=="array"||d=="function"}if(d){try{(P(a)?P(a).parentWindow||P(a).defaultView:window).event=b}catch(f){}a=a.fireEvent("on"+c,b)}else a=a.dispatchEvent(b);return a}var Y="_".split("."),Z=l;!(Y[0]in Z)&&Z.execScript&&Z.execScript("var "+Y[0]);for(var $;Y.length&&($=Y.shift());)if(!Y.length&&na!==undefined)Z[$]=na;else Z=Z[$]?Z[$]:Z[$]={};; return this._.apply(null,arguments);}.apply({navigator:typeof window!='undefined'?window.navigator:null}, arguments);}
