<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<HTML>

    <HEAD>

        <TITLE>JS画板</TITLE>

        <META NAME="Generator" CONTENT="EditPlus">

        <META NAME="Author" CONTENT="">

        <META NAME="Keywords" CONTENT="">

        <META NAME="Description" CONTENT="">

        <SCRIPT LANGUAGE="JavaScript">

        /* 珠峰培训  2011年12月9日课堂示例
        以下画点，画线，画圆的方法，都不是用HTML5的canvas，而是用的纯js
        用到了一些数学的三角函数方法 
        以下代码是课堂随机写出，没有做更多优化
        */
        /*
        张世民 2012年12月24日 http://www.cnblogs.com/zsmhhfy/
        面向对象封装，添加绘制矩形
        进一步优化代码
        */
        var Graphics = function(divId, color){
            this.divId = divId;
            this.color = color; //'#000000'或'black'
            this.drawPoint= function(x,y){
                //画点
                var oDiv=document.createElement('div');
                oDiv.style.position='absolute';
                oDiv.style.height='2px';
                oDiv.style.width='2px';
                oDiv.style.backgroundColor=this.color;
                oDiv.style.left=x+'px';
                oDiv.style.top=y+'px';
                //document.body.appendChild(oDiv);
                return oDiv;//注意：返回的值是一个dom节点，但并未追加到文档中    
            };
            this.drawLine = function(x1,y1,x2,y2){
                //画一条线段的方法。(x1,y1),(x2,y2)分别是线段的起点终点
                var x=x2-x1;//宽
                var y=y2-y1;//高
                var frag=document.createDocumentFragment();
                if(Math.abs(y)>Math.abs(x)){//那个边更长，用那边来做画点的依据（就是下面那个循环），如果不这样，当是一条垂直线或水平线的时候，会画不出来
                    if(y>0)//正着画线是这样的
                    for(var i=0;i<y;i++){
                        var width=x/y*i  //x/y是直角两个边长的比，根据这个比例，求出新坐标的位置
                        {
                            
                        frag.appendChild(drawPoint(width+x1,i+y1));
                        }
                    }
                    if(y<0){//有时候是倒着画线的
                        for(var i=0;i>y;i--){
                        var width=x/y*i
                        {
                            frag.appendChild(drawPoint(width+x1,i+y1));
                        }
                    }
                    }
                }//end if
                else {
                    
                    if(x>0)//正着画线是这样的
                for(var i=0;i<x;i++){
                    var height=y/x*i
                    {
                        
                    frag.appendChild(drawPoint(i+x1,height+y1));
                    }
                }
                if(x<0){//有时候是倒着画线的
                    for(var i=0;i>x;i--){
                    var height=y/x*i
                    {
                        frag.appendChild(this.drawPoint(i+x1,height+y1));
                    }
                }
                }//end if
                    
                }
                document.getElementById(this.divId).appendChild(frag);
            };
            this.drawCircle = function(r, x, y){
                //画个圆。x,原点横坐标；y,原点纵坐标；r,半径
                var frag=document.createDocumentFragment();
                for(var degree=0;degree<360;degree+=2){
                    var x1=r*Math.sin(degree*Math.PI/180);
                    var y1=r*Math.cos(degree*Math.PI/180);
                    frag.appendChild(drawPoint(x+x1,y+y1));
                }
                document.body.appendChild(frag);
            };
            this.dragCircle = function(x1,y1,x2,y2){
                //拖出一个圆来
                var r=Math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));//求出半径的长 直角三角形中 斜边的平方=两个直边的平方之和
                
                var frag=document.createDocumentFragment();
                for(var degree=0;degree<360;degree+=2){//每隔2度画一个点
                    var x2=r*Math.sin(degree*Math.PI/180);
                    var y2=r*Math.cos(degree*Math.PI/180);
                    frag.appendChild(drawPoint(x1+x2,y1+y2));
                }
                document.getElementById(this.divId).appendChild(frag);        
            };
            this.drawRect = function(startX, startY, lengthX, lengthY, newId, text){
                //(startX, startY)起点坐标，lengthX,长 lengthY,宽 newId,新创建的div的Id  text,div内容
                var myDiv=document.createElement('div');
                if(newId){
                    myDiv.id=newId;
                }
                myDiv.style.width= lengthX + 'px';
                myDiv.style.height= lengthY + 'px';
                myDiv.style.backgroundColor = this.color;
                myDiv.style.left=startX + 'px';
                myDiv.style.top=startY + 'px';
                myDiv.style.textAlign= 'center';
                if(text){
                    myDiv.innerHTML = text;
                }
                document.getElementById(this.divId).appendChild(myDiv);        
            };    
        }; 
            
        window.onload=function(){
            var g = new Graphics('div1', 'red');
            g.drawLine(500,30,0,30);
            g.color = '#CDC9C9';
            g.drawRect(10,10,200,200, '', '测试');
        }
        </SCRIPT>

        <STYLE TYPE="text/css">

            *{margin:0;padding:0} body{padding:5px}

        </STYLE>

    </HEAD>

    

    <BODY>

    </BODY>



</HTML>
