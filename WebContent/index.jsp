<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="JavaScript">
function callerDemo() {
	  if (callerDemo.caller) {
	      var a= callerDemo.caller;
	      alert(a);
	 } else{
	    alert("this is a top function");
	 }
	}
	function handleCaller() {
	    callerDemo();
	}
</script>
</head>
<body>
<input type="button" value="Replace Content" onClick="handleCaller()">
</body>
</html>