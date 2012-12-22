    <style>
    	body,td
    	{
    		margin: 0; padding: 0;
			font: normal 14px arial, sans-serif;
    	}
    	.nested
    	{
    		margin-left:10px; margin-top: 10px;
			font: normal 12px arial, sans-serif;
    	}
    	#top
    	{
			height: 15px;
			border-top: solid 5px #ED7B09;
    	}
    	#banner
    	{
			height: 50px;
			border-bottom: solid 1px #E1E1E1;
    	}
    	#banner div{display:inline;vertical-align:middle;}
    	#banner #title
    	{
    		margin-left: 10px;
    		color:#ED7B09;
    		font: normal 28px arial, sans-serif;
    	}
    	#banner #login{position: absolute; top: 30px; right: 20px;}
    	#banner #login span{color:#ED7B09;}
    	#banner #login a{text-decoration:none;}
    	
    	.topic
    	{
    		margin-top: 10px;
    		margin-bottom: 20px;
    		margin-left: 20px;
    		font: bold 20px arial, sans-serif;
    	}
    	.topic span{color:#ED7B09;}
    	
    	.item
    	{
    		width: 800px;
    		margin-left: 40px;
    		margin-bottom: 10px;
			border-bottom: dashed 1px #E1E1E1;
    	}
    	.count
    	{
    		color: #ED7B09;
			font: bold 18px arial, sans-serif;
    		margin-right: 10px;
    	}
    	.view div{width: 100%; margin-top: 10px; margin-left: 40px;}
    	.script{width: 80%; height: 400px;}
    	.name{font: bold 16px arial, sans-serif;}
    	.code
    	{
    		width: 600px;
    		height: 40px;
			font: normal 10px arial, sans-serif;
    	}
    	.modified
    	{
			font: normal 12px arial, sans-serif;
    		margin-bottom: 10px;
    	}
    	
    	.submit
    	{
    		width:80px; height:30px;
    		border:solid 0px white; background-color:#ED7B09;
    		font:normal 18px sans-serif; color:white;
    	}
    	
    	#canvas{position:relative; left:20px;}
    	.flow{float:left;}
    	.break{clear:both;}
    	.vars{min-height:200px;}
    	.move{margin-top:50px;}
    	
    	.inout .top td{font: bold 12px arial, sans-serif;}
    	.inout td,select,input,textarea{font: normal 12px arial, sans-serif;}
    	.inout .text,.number,.date{width:120px;height:16px;}
    	.inout tr{height:22px;}
    	.inout tr:nth-child(odd){background-color: #E1E1E1;}
    	
    	#testForm textarea{display:none;}
    	
    	#preview{position:absolute; width:360px; top:0px; right:40px;}
    	.PropertySheet{border:1px dotted blue; background-color:#D9E5F3; border-spacing:0; width:300px;}
    	.PropertySheet .sect{background-color:#274F7E; color:white; text-align:center;}
    	.PropertySheet td{font-family:Verdana,Arial,sans-serif; font-size:11px; font-weight:normal;
    						border:1px dotted blue; padding:1px;}
    	.PropertySheet input{background-color:#D9E5F3; border:0 none; width:100%;}
    	.PropertySheet select{border:0 none;}
    	#preview textarea{width:100%; height:200px; font: normal 10px arial, sans-serif;}
    	.soap{font-family:Verdana,Arial,sans-serif; font-size:9px; font-weight:normal; color:maroon;}
    </style>