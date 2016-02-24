<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/dtd.jspf" %>
<html>
<head>
<title>Insert title here</title>
<%@ include file="/WEB-INF/views/include/header.jspf" %>
<%@ include file="/WEB-INF/views/include/rsa.jspf" %>
<script language="JavaScript">
$(document).ready(function() {	
	var myUrl = "/offerer/offererlist.do";
	
	setValueDefault($("#line"), '${line}', 10);
	setValue($("#id"), '${id}');
	setValue($("#name"), '${name}');
	setValue($("#offererName"), '${offererName}');	
	
	$("#search").click(function() {
		var form = $("#form");
		$("#page").val(1);
		form.action = myUrl;
		form.submit();
	});
	
	$('#paging').paging({
		current : '${page}',
		max : '${navCount}',
		onclick : function(e, page) {
			var form = $("#form");
			$("#page").val(page);
			form.action = myUrl;
			form.submit();
		}
	});
	
	$("#line").change(function(){
		$("#search").trigger('click');
	});
	
	var popupUrl = "/offerer/detail.do";
	$(".data-table a").on("click", function() {
		var width = 600;
		var height = 300;		
		var x = (screen.availWidth - width) / 2;
		var y = (screen.availHeight - height) / 2;
		var id = $(this).text();
		window.open(popupUrl+"?id="+id, "", "width="+width+", height="+height+", toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, left="+x+", top="+y);
	});
});
</script>
</head>
<body>
<div id="site-wrapper">
	<%@ include file="../menu.jspf" %>
	
	<div id="splash">
		<h3>구직자 조회</h3>
		<form method="post" action="#" id="form">
			<table class="data-table">
				<tbody>
					<tr>
						<th>아이디</th>
						<td><input type="text" id="id" name="id" class="text" ></td>
						<th>이름</th>
						<td><input type="text" id="name" name="name" class="text" ></td>
						<th>상호</th>
						<td><input type="text" id="offererName" name="offererName" class="text" ></td>
						<th></th>
						<td><input type="button" id="search" value="검색" class="smallbutton"></td>
					</tr>
				</tbody>
			</table>
			<table class="data-table">
				<tbody>
					<th>아이디</th>
					<th>이름</th>
					<th>상호</th>
					<th>가입날짜</th>
					<th>사업자번호</th>
					<th>전화번호</th>
					<th>휴대폰</th>
					<c:forEach items="${list}" var="o">
					<tr>
						<td><a href="#"><c:out value="${o.id}" /></a></td>
						<td><c:out value="${o.name}" /></td>
						<td><c:out value="${o.offererName}" /></td>
						<td><fmt:formatDate pattern="yyyy-MM-dd" value="${o.registerDate}" /></td>
						<td><c:out value="${o.offererNumber}" /></td>
						<td><c:out value="${o.phone}" /></td>
						<td><c:out value="${o.cellPhone}" /></td>
					</tr>
					</c:forEach>
				</tbody>
			</table>

			<%@ include file="/WEB-INF/views/include/pagenumber.jspf" %>

		</form>
	</div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jspf" %>
</body>
</html>