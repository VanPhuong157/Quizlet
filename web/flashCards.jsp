<%-- 
    Document   : flashCards
    Created on : Dec 13, 2022, 12:43:59 AM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thẻ ghi nhớ | Quizlet</title>
        <link rel="stylesheet" href="css/flashCards.css" />
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
            />
    </head>
    <body>
        <%@include file="header.jsp" %> 
        <c:if test="${isShare}">
            <div class="container-body">
                <div class="title-study-set">${set.getTitle()}</div>
                <div class="study-preview">
                    <div class="preview-item">
                        <a href="study?id=${set.getId()}">Thẻ ghi nhớ</a>
                    </div>
                    <div class="preview-item">
                        <a href="learn?id=${set.getId()}">Học</a>
                    </div>
                    <div class="preview-item">
                        <a href="test?id=${set.getId()}">Kiểm tra</a>
                    </div>
                    <div class="preview-item">Ghép thẻ</div>
                </div>
                <div class="container-progress">
                    <div id="progress-study"></div>
                </div>
                <div class="container-slide">
                    <div id="contain-slide">
                        <c:forEach items="${listC}" var="c">
                            <div class="slide">
                                <div class="flip-container" onclick="handleFlipCard(${u.getNumberCard(listC, c)} - 1)">
                                    <div class="card-container">
                                        <div class="front">
                                            <div class="container-info">
                                                <div>
                                                    Thuật ngữ
                                                    <i class="fa-regular fa-volume"></i>
                                                </div>
                                                <div class="num-card">${u.getNumberCard(listC, c)} / ${listC.size()}</div>
                                                <i class="fa-solid fa-star"></i>
                                            </div>
                                            <div class="container-content">${c.getTerm()}</div>
                                        </div>
                                        <div class="back">
                                            <div class="container-info">
                                                <div>Định nghĩa</div>
                                                <div class="num-card">${u.getNumberCard(listC, c)} / ${listC.size()}</div>
                                                <i class="fa-solid fa-star"></i>
                                            </div>
                                            <div class="container-content">${c.getDefinition()}</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <div class="btn-prev" onclick="goPrev()" ><i class="fa-solid fa-angle-left"></i></div>
                                    <div class="btn-next" onclick="goNext(${u.getNumberCard(listC, c)}, ${listC.size()})" ><i class="fa-solid fa-angle-right"></i></div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div id="container-complete" class="animate__animated animate__zoomIn">
                        <div class="complete-header">
                            <p class="title-complete">Chúc mừng! Bạn đã ôn tập tất cả các thẻ.</p>
                            <img src="https://quizlet.com/_next/static/media/permafetti.e8a628fc.svg" alt="alt"/>
                        </div>
                        <p class="continue-title">Bước tiếp theo</p>
                        <div class="continue-container">
                            <div class="continue-item" onclick="handleLearn(${set.getId()})">
                                <p>Học các thuật ngữ này</p>
                                <p>Trả lời các câu hỏi về ${listC.size()} thuật ngữ này để xây dựng kiến thức.</p>
                            </div>
                            <div class="continue-item" onclick="handleReset(${user.getId()}, ${set.getId()})">
                                <p>Đặt lại thẻ ghi</p>
                                <p>Học lại ${listC.size()} thuật ngữ từ đầu.</p>
                            </div>
                        </div>
                        <div class="navigate">
                            <div onclick="goPrev()"><i class="fa-solid fa-left-long"></i>Quay lại câu hỏi cuối cùng</div>
                            <div>Tiếp tục<i class="fa-solid fa-right-long"></i></div>
                        </div>
                    </div>
                    <div id="list-size">${listC.size()}</div>
                </div>
                <div class="container-cards">
                    <div class="container-info">
                        <div class="contain-info">
                            <div class="avt">${requestScope.author.getName().charAt(0)}</div>
                            <div class="container-name">
                                <div>Tạo bởi</div>
                                <div>${requestScope.author.getName()}</div>
                            </div> 
                        </div>
                        <div class="contain-controller" style="${user.getId() != requestScope.author.getId() ? "display: none" : ""}">
                            <div class="item-controller"><i class="fa-solid fa-plus" onclick="handleOpenModalAdd()"></i></div>
                            <div class="item-controller"><i class="fa-regular fa-share-from-square"></i></div>
                            <div class="item-controller"><a href="update?id=${set.getId()}"><i class="fa-solid fa-pencil"></i></a></div>
                            <div class="item-controller" onclick="handleOpenModalDel()"><i class="fa-regular fa-trash-can"></i></div>
                        </div>
                    </div>
                    <div id="myModalNewFolder" class="modal">
                        <div class="modal-content">
                            <span class="close" onClick="handleCloseNewFolder()">×</span>
                            <h1 style="color: black">Tạo thư mục mới</h1>
                            <form action="folder" method="POST">
                                <input type="hidden" name="studySetId" value="${id}"/>
                                <input class="title" type="text" name="title" placeholder="Nhập tiêu đề"><br/>
                                <input class="details" type="text" name="details" placeholder="Nhập mô tả(tùy chọn)">
                                <div class="button-folder">
                                    <input type="submit" value="Tạo thư mục" class="create-button"/>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div id="myModalNewClass" class="modal">
                        <div class="modal-content">
                            <span class="close" onClick="handleCloseNewClass()">×</span>
                            <h1 style="color: white">Tạo lớp mới</h1>
                            <p>Sắp xếp tài liệu học của bạn và chia sẻ chúng với bạn học của bạn.</p>
                            <form action="class" method="post">
                                <input type="hidden" name="studySetId" value="${id}"/>
                                <input  class="class-na" type="text" name="classname" placeholder="Nhập tên lớp (khóa học, giáo viên, năm nay, phần vv)"></br>
                                <input class="details-cl" type="text" name="detailsclass" placeholder="Nhập mô tả(tùy chọn)">
                                <input class="accept" type="checkbox" name="adddel" value="True"/>cho phép các thành viên trong lớp thêm và bỏ học phần</br> </br> 
                                <input class="accept" type="checkbox" name="addpeople" value="True"/>cho phép các thành viên trong lớp mời thành viên mới </br>
                                <input  class="school-na" type="text" name="schoolname" placeholder="Nhập tên trường của bạn"></br>

                                <div class="button-folder">
                                    <input type="submit" value="Tạo lớp" class="create-button-cl"/>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div id="myModalAdd" class="modalAdd">
                        <div class="modal-content1">
                            <span class="close" onClick="handleCloseModalAdd()">×</span>
                            <div class="header-studySet">
                                Thêm vào lớp học hoặc thư mục 
                            </div>
                            <div class="add-new">
                                <span class="add-item" id="item1" onclick="handleOpenAddClass()">Thêm vào lớp học </span>
                                <span class="add-item" id="item2" onclick="handleOpenAddFolder()">Thêm vào thư mục</span>
                            </div>
                            <div class="create-studySet">
                                <button class="new-class" id="nclass" onClick="handleOpenNewClass()">+ Tạo một lớp mới</button>
                                <button class="new-folder" id="nfolder" onClick="handleOpenNewFolder()">+ Tạo thư mục mới</button>
                            </div>

                            <div class="content-container">
                                <div class="list-class" id="class-add">
                                    <c:forEach items="${listClass}" var="c">
                                        <span > 
                                            <div class="item-study-set1">
                                                <div class="title-study-set1">
                                                    <a href="classSet?id=${c.getId()}">
                                                        ${c.getName()}
                                                    </a>
                                                </div>
                                                <div class="control-class">
                                                    <c:set var="checkAdded" scope="request" value="${d.isAddedInClass(c.getId(),id)}" />
                                                    <c:if test="${checkAdded}">
                                                        <i class="fa-solid fa-minus" onclick="sendMethod2(${id}, ${c.getId()}, 'delete')"></i>
                                                    </c:if>
                                                    <c:if test="${!checkAdded}">
                                                        <i class="fa-solid fa-plus add-icon" onclick="sendMethod2(${id}, ${c.getId()}, 'add')"></i>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </span>
                                    </c:forEach>
                                </div>
                                <div class="list-class" id="folder-add">
                                    <c:forEach items="${listFl}" var="s">
                                        <span > 
                                            <div class="item-study-set1">
                                                <div class="title-study-set1">
                                                    <a href="folderSet?id=${s.getId()}">
                                                        ${s.getTitle()}
                                                    </a>
                                                </div>
                                                <div class="control-class">
                                                    <c:set var="checkAdded" scope="request" value="${d.isAddedInFolder(s.getId(),id)}" />
                                                    <c:if test="${checkAdded}">
                                                        <i class="fa-solid fa-minus" onclick="sendMethod(${id}, ${s.getId()}, 'delete')"></i>
                                                    </c:if>
                                                    <c:if test="${!checkAdded}">
                                                        <i class="fa-solid fa-plus add-icon" onclick="sendMethod(${id}, ${s.getId()}, 'add')"></i>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </span>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="myModalDel" class="modalDel">
                        <div class="modalDel-content">
                            <div class="modal-container">
                                <span class="close" onClick="handleCloseModalDel()">×</span>
                                <h1>Xóa học phần này?</h1>
                                <h2>${set.getTitle()}</h2>
                                <h4>Bạn sắp xoá học phần này và toàn bộ dữ liệu trong đó. Không ai có thể truy cập vào học phần này nữa.</h4>
                                <p>Bạn có chắc chắn không? Bạn sẽ không được hoàn tác.</p>
                            </div>
                            <div class="container-controll">
                                <div class="btn-cancel" onClick="handleCloseModalDel()">Hủy</div>
                                <div class="btn-del" onclick="handleDelete(${set.getId()})">
                                    Vâng, hãy xóa học phần
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="number-card">Thuật ngữ trong phần này (${listC.size()})</div>
                    <c:if test="${listCSL.size() > 0}">
                        <div class="still-learning">
                            Đang học (${listCSL.size()})
                            <p>Bạn đã bắt đầu học những thuật ngữ này. Tiếp tục phát huy nhé!</p>
                        </div>
                        <c:forEach items="${listCSL}" var="a">
                            <div class="card-item">
                                <div class="card-title">${a.getTerm()}</div>
                                <div class="card-desc">${a.getDefinition()}</div>
                            </div>
                        </c:forEach>
                    </c:if>
                    <c:if test="${listCM.size() > 0}">
                        <div class="mastered">
                            Thành thạo (${listCM.size()})
                            <p>Bạn đã trả lời đúng các thuật ngữ này!</p>
                        </div>
                        <c:forEach items="${listCM}" var="cm">
                            <div class="card-item">
                                <div class="card-title">${cm.getTerm()}</div>
                                <div class="card-desc">${cm.getDefinition()}</div>
                            </div>
                        </c:forEach>
                    </c:if>
                    <c:if test="${listUL.size() > 0}">
                        <div class="not-studied">
                            Chưa học (${listUL.size()})
                            <p>Bạn chưa học các thuật ngữ này!</p>
                        </div>
                        <c:forEach items="${listUL}" var="x">
                            <div class="card-item">
                                <div class="card-title">${x.getTerm()}</div>
                                <div class="card-desc">${x.getDefinition()}</div>
                            </div>
                        </c:forEach>        
                    </c:if>
                    <c:if test="${listCSL.size() == 0 && listCM.size() == 0}">
                        <c:forEach items="${listC}" var="c">
                            <div class="card-item">
                                <div class="card-title">${c.getTerm()}</div>
                                <div class="card-desc">${c.getDefinition()}</div>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
            </div>  
        </c:if>
        <c:if test="${!isShare}">
            <div class="container-block">
                <h1 class="title-block">Học phần đã được bảo vệ</h1>
                <p class="sub-title">Rất tiếc, chúng tôi cần sự riêng tư!</p>
            </div>
        </c:if>
        <div id="current-numCard">${currentNumCard}</div>
    </body>
    <script>
        var modalAdd = document.getElementById("myModalAdd");
        var modalAddNewClass = document.getElementById("myModalNewClass");
        var modalAddNewFolder = document.getElementById("myModalNewFolder");

        function handleOpenModalAdd() {
            modalAdd.style.display = "block";
            folderAdd.style.display = "none";
            classAdd.style.display = "block";

        }

        function handleCloseModalAdd() {
            modalAdd.style.display = "none";

        }
        function handleCloseNewClass() {
            modalAdd.style.display = "block";
            modalAddNewClass.style.display = "none";
        }
        function handleCloseNewFolder() {
            modalAdd.style.display = "block";
            modalAddNewFolder.style.display = "none";
        }
        function handleOpenNewClass() {
            modalAdd.style.display = "none";
            modalAddNewClass.style.display = "block";
        }

        function handleOpenNewFolder() {
            modalAdd.style.display = "none";
            modalAddNewFolder.style.display = "block";
        }

        var underAdd2 = document.getElementById("item2");
        var underAdd1 = document.getElementById("item1");
        var folderAdd = document.getElementById("folder-add");
        var classAdd = document.getElementById("class-add");
        var newClass = document.getElementById("nclass");
        var newFolder = document.getElementById("nfolder");
        function handleOpenAddFolder() {
            folderAdd.style.display = "block";
            classAdd.style.display = "none";
            newFolder.style.display = "block";
            newClass.style.display = "none";
            underAdd2.classList.toggle("under");
            underAdd1.classList.remove("under");
        }

        function handleOpenAddClass() {
            folderAdd.style.display = "none";
            classAdd.style.display = "block";
            newFolder.style.display = "none";
            newClass.style.display = "block";
            underAdd1.classList.toggle("under");
            underAdd2.classList.remove("under");
        }
        var load = document.getElementsByClassName("container-body")[0];
        let containerSlide = document.getElementById("contain-slide");
        let containerComplete = document.getElementById("container-complete");


        setTimeout(function () {
            slideImage();
            if (count - size === 0) {
                containerComplete.style.display = "block";
            }
        }, 0);

        setTimeout(function () {
            load.style.display = "block";
        }, 400);

        function handleFlipCard(i) {
            var cards = document.querySelectorAll(".card-container");
            if (cards[i].style.transform === "") {
                cards[i].style.transform = "rotateX(180deg)";
            } else {
                cards[i].style.transform = "";
            }
        }

        function handleDelete(id) {
            window.location.href = "http://localhost:8080/projectquizlet/delete?id=" + id;
        }

        function handleLearn(studySetId) {
            window.location.href = "http://localhost:8080/projectquizlet/learn?id=" + studySetId;
        }

        const currentNumCard = document.getElementById("current-numCard").innerHTML;

        const slides = document.querySelectorAll(".slide");
        var count = currentNumCard;
        slides.forEach((slide, index) => {
            var pos = index * 100;
            slide.style.left = pos + "%";
        });
        const slideImage = () => {
            const progressStudy = document.getElementById("progress-study");
            var width = count * (100 / size) + "%";
            progressStudy.style.width = width;
            slides.forEach(slide => {
                var counter = count * 100;
                slide.style.transform = "translateX(-" + counter + "%)";
            });
            cards = document.querySelectorAll(".card-container");
            cards.forEach(card => {
                card.style.transform = "";
            });
            if (size === count) {
                containerSlide.style.display = "none";
                containerComplete.style.display = "block";
            } else if (containerSlide.style.display === "none") {
                containerSlide.style.display = "block";
                containerComplete.style.display = "none";
            }
        };
        function sendMethod(studySetId, folderId, method) {
            window.location.href = "http://localhost:8080/projectquizlet/controllerFlashCards?studySetId=" + studySetId + "&folderId=" + folderId + "&method=" + method;
        }
        function sendMethod2(studySetId, classId, method) {
            window.location.href = "http://localhost:8080/projectquizlet/controllerFlashCardsInClass?studySetId=" + studySetId + "&classId=" + classId + "&method2=" + method;
        }

        var listSize = document.getElementById("list-size");
        var size = parseInt(listSize.innerHTML);

        const goNext = () => {
            if (count < size) {
                count++;
                slideImage();
            }
        };

        const goPrev = () => {
            if (count > 0) {
                count--;
            }
            slideImage();
            if (containerComplete.style.display === "block") {
                containerComplete.style.display = "none";
            }
        };

        var modalDel = document.getElementById("myModalDel");

        function handleOpenModalDel() {
            modalDel.style.display = "block";
        }

        function handleCloseModalDel() {
            modalDel.style.display = "none";
        }

        window.onclick = function (e) {
            if (e.target.matches("#myModalDel")) {
                modalDel.style.display = "none";
            }
        };

        window.onkeydown = function (e) {
            if (e.keyCode === 39) {
                goNext();
            }
            if (e.keyCode === 37) {
                goPrev();
            }
            if (e.keyCode === 32) {
                e.preventDefault();
                handleFlipCard(count);
            }
        };

        function handleReset(userId, studySetId) {
            window.location.href = "http://localhost:8080/projectquizlet/resetStudiedCard?userId=" + userId + "&studySetId=" + studySetId + "&mode=flashCards";
        }
    </script>
</html>
