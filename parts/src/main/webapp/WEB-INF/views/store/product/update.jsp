<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c"%><%@ taglib uri="http://www.springframework.org/security/tags"
prefix="sec"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>
    <script src="/js/category.js"></script>
    <title>Document</title>
  </head>
  <body>
    <sec:authorize access="isAuthenticated()">
      <sec:authentication property="principal" var="principal" />
    </sec:authorize>
    <div class="container">
      <form class="add-form" method="post" enctype="multipart/form-data">
        <div>
          <h2>기본 정보</h2>
        </div>
        <div class="mt-2">
          <label class="col-1">제품 이미지:</label>
          <input id="myfiles" multiple type="file" name="uploadFile" />
          <div id="output"></div>
        </div>
        <input
          type="hidden"
          name="${_csrf.parameterName}"
          value="${_csrf.token}"
        />
        <div class="inputbar">
          <input
            class="input_inner productName"
            type="text"
            name="productName"
            value="${item.productName}"
          /><label class="input_label">상품명:</label>
        </div>
        <div class="selector-box">
          <div>
            <label>카테고리1:</label>
            <select
              class="selector"
              id="category1"
              name="name"
              size="5"
              onchange="category1Changed()"
            >
              <c:forEach var="category" items="${category}">
                <c:choose>
                  <c:when test="${category.name eq item.name}">
                    <option value="${category.name}" selected="selected">
                      ${category.name}
                    </option>
                  </c:when>
                  <c:otherwise>
                    <option value="${category.name}">${category.name}</option>
                  </c:otherwise>
                </c:choose>
              </c:forEach>
            </select>
          </div>
          <div>
            <label>카테고리2:</label>
            <select
              class="selector"
              id="category2"
              name="name2"
              size="5"
            ></select>
          </div>
        </div>

        <div class="inputbar">
          <input
            class="input_inner price"
            type="number"
            name="productPrice"
            min="0"
            value="${item.productPrice}"
          /><label class="input_label">가격:</label>
        </div>

        <div class="inputbar">
          <input
            class="input_inner"
            type="number"
            name="deliveryPrice"
            min="0"
            value="${item.deliveryPrice}"
          /><label class="input_label">배송비:</label>
        </div>

        <div class="inputbar productStock">
          <input
            class="input_inner"
            type="number"
            name="productStock"
            value="${item.productStock}"
          />
          <label class="input_label">수량:</label>
        </div>

        <div class="inputbar row">
          <label>상태:</label>
          <div>
            <input type="radio" name="productStatus" value="0" checked /><label
              >새상품</label
            >
          </div>
          <div>
            <input type="radio" name="productStatus" value="1" /><label
              >중고</label
            >
          </div>
        </div>

        <div>
          <div class="inputbar">
            <textarea class="input_inner" name="productDetail">
${item.productDetail}</textarea
            >
            <label class="input_label">상세 설명:</label>
          </div>
        </div>
        <div class="buttons">
          <button
            type="button"
            onclick="formUpload()"
            class="long-button c-blue"
          >
            등록
          </button>
          <a href="/" class="long-button c-gray">취소</a>
        </div>
      </form>
    </div>
  </body>
  <script>
    function formUpload() {
      var path = window.location.pathname;
      // 경로에서 userId와 productId 추출하기
      var userIdMatch = path.match(/\/store\/(\d+)\/(\d+)/);

      // userId와 productId가 존재하면 값을 추출
      const userId = userIdMatch ? userIdMatch[1] : null;
      const productId = userIdMatch ? userIdMatch[2] : null;

      const csrfHeader = document.querySelector(
        'meta[name="_csrf_header"]'
      ).content;
      const csrfToken = document.querySelector('meta[name="_csrf"]').content;

      const formData = new FormData(document.querySelector(".add-form"));
      formData.append("userId", userId);
      formData.append("productId", productId);

      console.log(formData);

      const fileInput = document.querySelector('input[name="uploadFile"]');
      if (fileInput.files.length > 0) {
        formData.append("uploadFile", fileInput.files[0]);
      }

      fetch("/api/product/update", {
        method: "POST",
        headers: {
          [csrfHeader]: csrfToken,
        },
        body: formData,
      })
        .then((resp) => resp.text())
        .then((result) => {
          history.back();
        });
    }
  </script>
  <script>
    window.addEventListener("DOMContentLoaded", () => {
      getFile();
      category1Changed().then(() => {
        const category2 = document.getElementById("category2");
        console.log(category2.options);

        for (const option of category2.options) {
          if (option.value == "${item.name2}") {
            option.selected = true;
            console.log(option.value);
          }
        }
      });
    });
  </script>
  <script>
    const output = document.getElementById("output");
    const fileInput = document.getElementById("myfiles");
    const principalUserId = `${principal.userId}`;

    fileInput.addEventListener("change", () => {
      getFile();
    });

    function getFile() {
      const csrfHeader = document.querySelector(
        'meta[name="_csrf_header"]'
      ).content;
      const csrfToken = document.querySelector('meta[name="_csrf"]').content;

      const formData = new FormData();
      for (let i = 0; i < fileInput.files.length; i++) {
        formData.append("uploadFile", fileInput.files[i]);
      }
      formData.append("userId", principalUserId);

      fetch("/api/cache", {
        method: "POST",
        headers: {
          [csrfHeader]: csrfToken,
        },
        body: formData,
      })
        .then((resp) => resp.json())
        .then((result) => {
          console.log(result);
          displayFiles(result);
        });
    }

    function displayFiles(image) {
      output.innerHTML = "";
      for (let i = 0; i < image.length; i++) {
        var divContainer = document.createElement("div");
        var Fileimg = document.createElement("img");
        divContainer.classList.add("product-image");

        // 클로저 밖에서 변수로 선언
        let currentDivContainer = divContainer;

        divContainer.onclick = async () => {
          await imageDelete(image[i].uuid + "_" + image[i].imageName);
          currentDivContainer.remove();
        };

        Fileimg.classList.add("img-full");
        Fileimg.src =
          "/cache/" +
          principalUserId +
          "/" +
          image[i].uuid +
          "_" +
          image[i].imageName;

        Fileimg.dataset.imagename = image[i].uuid + "_" + image[i].imageName;
        divContainer.appendChild(Fileimg);
        output.appendChild(divContainer);
      }
    }

    function imageDelete(image, divContainer) {
      console.log(image);
      const csrfHeader = document.querySelector(
        'meta[name="_csrf_header"]'
      ).content;
      const csrfToken = document.querySelector('meta[name="_csrf"]').content;
      fetch("/api/cache/delete?imageName=" + image, {
        method: "DELETE",
        headers: {
          [csrfHeader]: csrfToken,
          "Content-Type": "application/json",
        },
      })
        .then((resp) => resp.text())
        .then((result) => {});
    }
  </script>
</html>
