// (c) Cipher Brain SPRL, 2010 by Vincent Cautaerts (email: vincent AT cipherbrain DOT be)
function append_qrcode(typeNumber,elem_id,text) {
	var cs=4;// cell size

	var e=document.getElementById(elem_id);
	if (e) {
		var canvas=document.createElement('canvas');
		/*if (G_vmlCanvasManager) { // IE and excanvas
			canvas=G_vmlCanvasManager.initElement(canvas);
		}*/
		var ctx = canvas.getContext('2d');

		var qr = new QRCode(typeNumber, QRErrorCorrectLevel.H);

		qr.addData(text);

		qr.make();

		canvas.setAttribute('width',qr.getModuleCount()*cs);
		canvas.setAttribute('height',qr.getModuleCount()*cs);
		e.appendChild(canvas);

		if (canvas.getContext){
			for (var r = 0; r < qr.getModuleCount(); r++) {
				for (var c = 0; c < qr.getModuleCount(); c++) {
					if (qr.isDark(r, c) ) {
						ctx.fillStyle = "rgb(0,0,0)";  
					} else {
						ctx.fillStyle = "rgb(255,255,255)";  
					}
					ctx.fillRect (c*cs,r*cs,cs,cs);  
				}	
			}

		}
	}
}

