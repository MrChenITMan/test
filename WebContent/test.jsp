<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" type="text/css" href="./jquery-easyui-1.3.5/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="./jquery-easyui-1.3.5/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="./jquery-easyui-1.3.5/demo.css">
	<script type="text/javascript" src="./jquery-easyui-1.3.5/jquery.min.js"></script>
	<script type="text/javascript" src="./jquery-easyui-1.3.5/jquery.easyui.min.js"></script>
<script type="text/javascript">
$(function() {
	var url = "";
	var templateID = $("#examTemplateId").val();
	if (templateID) {
		url = ctx + "/examTemplate/queryDetail.action?id=" + templateID;
	}
	// var difficultyType;
	// $.ajax({
	// url : ctx + '/common/getComboDataByType.action?type=007',
	// dataType : 'json',
	// type : 'POST',
	// async : false,
	// success : function(data) { // 传过来的json数据key是name，不能在数据表格里显示，要将name改为text
	// typeStr = JSON.stringify(data);
	// var reg = new RegExp("name", "g"); // 创建正则RegExp对象
	// var strJSON = typeStr.replace(reg, "text");
	// difficultyType = JSON.parse(strJSON);
	// }
	// });
	$("#examTemplateDetailsTable")
			.datagrid(
					{
						url : url,
						rownumbers : true,
						singleSelect : true,
						pagination : false,
						onClickRow : onClickRow,
						title : '题型',
						columns : [ [
								{
									field : 'id',
									hidden : true
								},
								{
									field : 'questionType',
									title : '题目类型',
									height : 100,
									width : 130,
									halign : "center",
									align : "left",
									editor : {
										type : 'validatebox',
										options : {
											required : true
										}
									}
								},
								{
									field : 'difficulty',
									title : '难易度',
									width : 130,
									halign : "center",
									align : "left",
									editor : {
										type : 'combobox',
										options : {
											url : ctx
													+ '/common/getComboDataByType.action?type=007',
											valueField : 'value',
											textField : 'name',
											panelHeight : 'auto'
										}
									},
									formatter : formatterDifficulty
								},
								{
									field : 'questionNumber',
									title : '题目数量',
									width : 130,
									halign : "center",
									align : "left",
									editor : {
										type : 'validatebox',
										options : {
											required : true
										}
									}
								},
								{
									field : 'opr',
									title : '操作',
									width : 100,
									halign : 'center',
									align : 'left',
									formatter : function(value, row, index) {
										var res = "";
											res += "<a href='#'  class='easyui-linkbutton' javascript:void(0) style='color:#00f;' onclick='setDifficulty("+row.id+")' >难易度设置</a>";
										return res;

									}
								} ] ]
					});

	$("#cancel").on("click", function() {
		$("#parent_win").window("close");
	});
	$("#saveTemplate").on(
			"click",
			function() {
				var submitUrl = ctx + "/examTemplate/save.action";
				var vali = $('#dataForm').form("validate");
				if (vali && endEditing()) {
					$('#examTemplateDetailsTable').datagrid('getChanges');
					var jsonData = "";
					var templateDetails = $('#examTemplateDetailsTable')
							.datagrid('acceptChanges').datagrid('getRows');
					jsonData = {
						template : JSON.stringify($('#dataForm')
								.serializeObject()),
						opChange : true,
						templateDetails : JSON.stringify(templateDetails)
					};

					$.ajax({
						cache : true,
						type : "POST",
						url : submitUrl,
						data : jsonData,
						async : true,
						error : function(request) {
							$parent.messager.alert("Connection error",
									result.msg, state);
						},
						success : function(data) {
							var result = eval("(" + data + ")");
							var state;
							if (result.success) {
								state = "info";
								refreshGrid('examTemplateTable');
								$("#parent_win").window("close");
							} else {
								state = "error";
							}
							$parent.messager.alert('提示', result.msg, state);
						}
					});
				}

			});
	$(function() {
		/* 扩展Editors的combobox方法 */
		$.extend($.fn.datagrid.defaults.editors, {
			combobox : {// 为方法取名
				init : function(container, options) {
					var editor = $('<input />').appendTo(container);
					options.editable = false;// 设置其不能手动输入
					editor.combobox(options);
					return editor;
				},
				getValue : function(target) {// 取值
					return $(target).combobox('getValue');
				},
				setValue : function(target, value) {// 设置值
					$(target).combobox('setValue', value);
				},
				resize : function(target, width) {
					$(target).combobox('resize', width);
				},
				destroy : function(target) {
					$(target).combobox('destroy');// 销毁生成的panel
				}
			}
		});
	});
});

var editIndex = undefined;

function endEditing() {// 结束编辑
	if (editIndex == undefined) {
		return true
	}
	if ($('#examTemplateDetailsTable').datagrid('validateRow', editIndex)) {

		$("#examTemplateDetailsTable").datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function onClickRow(index) {
	if (editIndex != index) {
		if (endEditing()) {
			$('#examTemplateDetailsTable').datagrid('selectRow', index)
					.datagrid('beginEdit', index);
			editIndex = index;
		} else {
			$('#examTemplateDetailsTable').datagrid('selectRow', editIndex);
		}
	}
}
function append() {
	if (endEditing()) {
		$('#examTemplateDetailsTable').datagrid('appendRow', {
			id : 0,
			questionType : '',
			difficulty : '',
			questionNumer : ''
		});
		editIndex = $('#examTemplateDetailsTable').datagrid('getRows').length - 1;
		$('#examTemplateDetailsTable').datagrid('selectRow', editIndex)
				.datagrid('beginEdit', editIndex);
	}
}
function removedit() {
	if (editIndex == undefined) {
		return;
	}
	$('#examTemplateDetailsTable').datagrid('cancelEdit', editIndex).datagrid(
			'deleteRow', editIndex);
	editIndex = undefined;
}

function accept() {
	if (endEditing()) {
		$('#examTemplateDetailsTable').datagrid('acceptChanges');
	}
}

var difficultyData = directoryMapping("007");
function formatterDifficulty(value) {
	if (value) {
		return difficultyData[value];
	} else {
		return value;
	}
}

function setDifficulty(id){
	$('#parent_win').modalDialogTwo({   
	    width:150,    
	    height:150,    
	    href : ctx + '/examTemplate/difficulty.action?id='+id  
	}); 
}
</script>
</head>
<body>
<div class="content" style="padding-bottom: 3px;">
	<form method="post" action="" id="dataForm">
		<div class="formheader"><c:out value="${opType == 'add'? '新增':(opType == 'edit'?'修改':'查看')}"/>试题</div>
		<input type="hidden" name="id" value="${examTemplate.id}" id="examTemplateId"/>
		<table>
			<tr>
				<td class="prompt"><label for="name"><span>*</span>模版名称：</label></td>
				<td colspan="3" >
					<input class="easyui-validatebox full" name="name" value="${examTemplate.name}" data-options="
						height:'32px',
						required:true
					"/>
				</td>
			</tr>
			<tr>
				<td class="prompt"><label for="questionLib">题库：</label></td>
				<td>
					<input class="easyui-validatebox full" name="questionLib" value="${examTemplate.questionLib}" style="width: 100%;" data-options="
						height:'32px'
					"/>
				</td>
				<td class="prompt"><label for="difficulty">试卷难易程度：</label></td>
				<td >
					<input class="easyui-combobox" name="difficulty" value="${examTemplate.difficulty}" style="width: 100%;" data-options="
						url:'${ctx}/common/getComboDataByType.action?type=007',
						valueField:'value',
					    textField:'name',
					    height:'32px',
					    panelHeight: 'auto'
					"/>
				</td>
				</td>
			</tr>
			<tr>
				<td class="prompt"><label for="subject">考试科目：</label></td>
				<td>
					<input class="easyui-combobox full" name="subject" id="subject" value="${examTemplate.subject}" style="width: 100%;" data-options="
						url:'${ctx}/common/getComboDataByType.action?type=005',
					    valueField:'value',
					    textField:'name',
						height: '32px',
						panelHeight: 'auto',
						onChange: function(newValue, oldValue){
							var url = '${ctx}/knowledge/getKnowledgeTree.action?subject='+newValue+'&id=0&root=false';
							$('#knowledge').combotree('reload',url);
							$('#knowledge').combotree('setValue','');
						}
					"/>
				</td>
				<td class="prompt"><label for="knowledge">知识点：</label></td>
					<td>
					<input class="easyui-combotree" name="knowledge" id="knowledge" style="width: 100%;" data-options="
						url:'',
						height: 32,
						panelHeight: 'auto',
						value: '${examTemplate.knowledge}',
						onBeforeLoad: function(node,param){
							var subject = $('#subject').combobox('getValue');
				      		if(node){
				      			$(this).tree('options').url=ctx+'/knowledge/getKnowledgeTree.action?subject='+subject+'&id='+node.id+'&root=false';
				      		} else {
				      			if(subject){
				      				$('#knowledge').combotree('setText','${examTemplate.knowledge}');
				      			}
				      		}
					    },
					    onShowPanel: function(){
					    	var subject = $('#subject').combobox('getValue');
					    	if(!subject){
			      				$.messager.show({
									title:'提示',
									msg:'请选择科目后再选择知识点.',
									timeout:2000,
									showType:'show',
					                style:{
					                    left:'',
					                    right:0,
					                    top:document.body.scrollTop+document.documentElement.scrollTop,
					                    bottom:''
					                }
								});
								return;
							} else {
								if(!$('#knowledge').combotree('options').url){
									var url='${ctx }/knowledge/getKnowledgeTree.action?subject='+subject+'&id=0&root=false';
									$('#knowledge').combotree('reload',url);
								}
							}
					    }
					"/>
			</tr>
			<tr>
				<td colspan="4" style="text-align: center;">
		      		<a id="saveTemplate" class="easyui-linkbutton my-dialog-button" plain="true" icon="icon-save" href="javascript:void(0)" >保存模版</a> 
				</td>
			</tr>
	    </table>
    </form>
</div>
<div style="padding-right: 20px;padding-left: 20px;">
<c:if test="${opType !='view'}">
    <div id="tb" class="datagrid-toolbar" style="text-align: left;">
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onClick="append()">添加</a>  
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onClick="removedit()">删除</a>  
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onClick="accept()">保存</a>  
	</div>
</c:if>
<table id="examTemplateDetailsTable" style="table-layout: fixed;padding:3px;"></table>
</div>
</body>
</html>