<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/dtd.jspf" %>
<html>
<head>
<%@ include file="/WEB-INF/views/include/header.jspf" %>
<%@ include file="/WEB-INF/views/include/rsa.jspf" %>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script language="JavaScript">

$(document).ready(function() {	
	
	$("#allowAll").click(function(){
		//alert($(this).is(":checked"));
		$("input:checkbox[name=allow]").prop("checked", $(this).is(":checked"));
	});
	
	$("#execDaumPostcode").click(function() {
		var width = 300; //팝업의 너비
		var height = 100; //팝업의 길이
        new daum.Postcode({
        	width: width,
        	height: height,
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = ''; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    fullAddr = data.roadAddress;

                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    fullAddr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                if(data.userSelectedType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                $("#postcode").val(data.zonecode);  //5자리 새우편번호 사용
                $("#address1").val(fullAddr);
                $("#sidoId").val(data.bcode.substring(0, 2));
                $("#sigunguId").val(data.bcode.substring(2, 5));
                
                // 커서를 상세주소 필드로 이동한다.
                $("#address2").focus();
            }
        }).open({
        	popupName: '주소 검색',
        	left: (window.screen.width / 2) - (width / 2),
            top: 0
        });
	});	
	
	$("#join").click(function() {
		var v = new Validator();
		
		v.add($("#myid"), "아이디를 꼭 입력하세요.");
		v.add($("#myname"), "이름을 꼭 입력하세요.");
		v.add($("#offererName"), "상호를 꼭 입력하세요.");
		v.add($("#sidoId"), "주소를 꼭 입력하세요.");
		v.add($("#sigunguId"), "주소를 꼭 입력하세요.");
		v.add($("#postcode"), "주소를 꼭 입력하세요.");
		v.add($("#address1"), "주소를 꼭 입력하세요.");
		v.add($("#mypassword"), "비밀번호를 꼭 입력하세요.");
		v.add($("#mypassword1"), "비밀번호를 꼭 입력하세요.");
		v.add($("#offererNumber1"), "사업자번호를 꼭 입력하세요.");
		v.add($("#offererNumber2"), "사업자번호를 꼭 입력하세요.");
		v.add($("#offererNumber3"), "사업자번호를 꼭 입력하세요.");
		v.add($("#phone1"), "전화번호를 꼭 입력하세요.");
		v.add($("#phone2"), "전화번호를 꼭 입력하세요.");
		v.add($("#phone3"), "전화번호를 꼭 입력하세요.");
		v.add($("#cellPhone1"), "휴대폰번호를 꼭 입력하세요.");
		v.add($("#cellPhone2"), "휴대폰번호를 꼭 입력하세요.");
		v.add($("#cellPhone3"), "휴대폰번호를 꼭 입력하세요.");
		if (!v.isValid()) return;
		
		$("#offererNumber").val($("#offererNumber1").val()+"-"+$("#offererNumber2").val()+"-"+$("#offererNumber3").val());
		$("#cellPhone").val($("#cellPhone1").val()+"-"+$("#cellPhone2").val()+"-"+$("#cellPhone3").val());
		$("#phone").val($("#phone1").val()+"-"+$("#phone2").val()+"-"+$("#phone3").val());
		
		if (!isPhoneNumber($("#phone").val())) {
			alert("전화번호 형식이 올바르지 않습니다.");
			$("#phone").focus();
			return;
		}
		if (!isPhoneNumber($("#cellPhone").val())) {
			alert("휴대폰번호 형식이 올바르지 않습니다.");
			$("#cellPhone").focus();
			return;
		}
		
		if ($("#mypassword").val() != $("#mypassword1").val()) {
			alert("동일한 비밀번호를 입력하세요.");
			$("#mypassword1").focus();
			return;
		}
		
		var rsa = new RSAKey();
		rsa.setPublic($("#publicKeyModulus").val(), $("#publicKeyExponent").val());
		$("#id").val(rsa.encrypt($("#myid").val()));
		$("#name").val(rsa.encrypt($("#myname").val()));
		$("#password").val(rsa.encrypt($("#mypassword").val()));	
		
		var formData = $("#form").serialize();
		$.ajax({
			type : "POST",
			url : '/join/offerer_r.do',
			dataType : 'JSON',
			cache : false,
			data : formData,
			success : function(data) {
				Responser.action(data);
			},
			complete : function(data) {
				// 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
			},
			error : function(xhr, status, error) {
				alert("xhr="+xhr+"\nstatus="+status+"\nerror="+error);
			}
		});
	});
	
	$("#dup_check").click(function() {
		var myid = $("#myid").val();
		if (myid == "") {
			return;
		}
		var params = "id="+myid;
		$.ajax({
			type : "POST",
			url : '/check_dup_offerer.do?'+params,
			dataType : 'JSON',
			cache : false,
			success : function(data) {
				var responser = new Responser(data);
				alert(responser.ok)
			},
			complete : function(data) {
				// 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
			},
			error : function(xhr, status, error) {
				alert("xhr="+xhr+"\nstatus="+status+"\nerror="+error);
			}
		});
	});
});

</script>
</head>
<body>
<div id="site-wrapper">
	<%@ include file="../menu.jspf" %>
	
	<div id="splash" class="subline">
		<div class="sub-nav-img">
			<div class="loginme">고용주 회원가입</div>
		</div>
		
		<form method="post" id="form">
			<input type="hidden" id="publicKeyModulus"  value='<c:out value="${publicKeyModulus}" />' />
			<input type="hidden" id="publicKeyExponent" value='<c:out value="${publicKeyExponent}" />' />
			<table class="data-table">
				<tbody>
					<tr>
						<th>아이디</th>
						<td>
							<input type="hidden" id="id" name="id" /> 
							<input type="text" id="myid" class="text" placeholder="아이디" />
							<a id="dup_check" href="#" style="text-decoration: none;"><img src="/img/dup.png">중복검사</a>
						</td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td>
							<input type="hidden" id="password" name="password" />
							<input type="password" class="text" id="mypassword" />
						</td>
					</tr>
					<tr>
						<th>비밀번호 확인</th>
						<td>
							<input type="password" class="text" id="mypassword1" />
						</td>
					</tr>
					<tr>
						<th>대표자명</th>
						<td>
							<input type="hidden" id="name" name="name" /> 
							<input type="text" id="myname" class="text" placeholder="이름" />
						</td>
					</tr>
					<tr>
						<th>상호명</th>
						<td>
							<input type="text" id="offererName" name="offererName" class="text" placeholder="상호" />
						</td>
					</tr>
					<tr>
						<th>사업자등록번호</th>
						<td>
							<input type="hidden" name="offererNumber" id="offererNumber" />
							<input type="text" name="offererNumber1" id="offererNumber1" class="text w40"/>
							-
							<input type="text" name="offererNumber2" id="offererNumber2" class="text w40"/>
							-
							<input type="text" name="offererNumber3" id="offererNumber3" class="text w40"/>
						</td>
					</tr>
					<tr>
						<th>주소</th>
						<td>
							<input type="hidden" id="sidoId" name="sidoId">
							<input type="hidden" id="sigunguId" name="sigunguId">
							<input type="text" id="postcode" name="postcode" class="text" placeholder="우편번호">
							<input type="button" id="execDaumPostcode" class="button" value="우편번호 찾기"><br>
							<input type="text" id="address1" name="address1" class="text" style="width: 200px;" placeholder="주소">
							<input type="text" id="address2" name="address2" class="text" style="width: 100px;" placeholder="상세주소">
						</td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td>
							<input type="hidden" name="phone" id="phone" />
							<input type="text" name="phone1" id="phone1" class="text w40"/>
							-
							<input type="text" name="phone2" id="phone2" class="text w40"/>
							-
							<input type="text" name="phone3" id="phone3" class="text w40"/>
							(형식: 000-00-00000)
						</td>
					</tr>
					<tr>
						<th>업종</th>
						<td>
							<c:forEach items="${context.KindOfBusiness}" var="business">
								<input type="radio" name="kindOfBusiness" value="${business}" >
								<c:out value="${business}" />
							</c:forEach>
						</td>
					</tr>
					<tr>
						<th>휴대폰</th>
						<td>
							<input type="hidden" name="cellPhone" id="cellPhone" />
							<select name="cellPhone1" id="cellPhone1" class="w60">
								<option value="010">010</option>
								<option value="011">011</option>
								<option value="016">016</option>
								<option value="017">017</option>
								<option value="018">018</option>
								<option value="019">019</option>
							</select>
							-
							<input type="text" name="cellPhone2" id="cellPhone2" class="text w40"/>
							-
							<input type="text" name="cellPhone3" id="cellPhone3" class="text w40"/>
						</td>
					</tr>
					<tr>
						<th>이용약관 동의</th>
						<td>
							<a href="#">자세히</a>
							<input type="checkbox" name="allow" id="allow1" value="allow1">
							<label for="allow1">동의</label>
						</td>
					</tr>
					<tr>
						<th>개인정보 취급약관 동의</th>
						<td>
							<a href="#">자세히</a>
							<input type="checkbox" name="allow" id="allow2" value="allow2">
							<label for="allow2">동의</label>
						</td>
					</tr>
					<tr>
						<th>상품이용 약관 동의</th>
						<td>
							<a href="#">자세히</a>
							<input type="checkbox" name="allow" id="allow3" value="allow3">
							<label for="allow3">동의</label>
						</td>
					</tr>
					<tr>
						<th></th>
						<td>
							<input type="checkbox" id="allowAll" name="allowAll">
							<label for="allowAll">전체동의</label>
						</td>
					</tr>
					<tr>
						<th></th>
						<td>
							<input type="button" id="join" value="회원가입" class="bigbutton">
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jspf" %>
</body>
</html>