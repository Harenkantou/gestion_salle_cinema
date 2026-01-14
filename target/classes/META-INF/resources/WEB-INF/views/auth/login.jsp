<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />">
</head>
<body>
<div class="container">
    <h2>Connexion Client</h2>

    <c:if test="${param.error != null}">
        <p style="color:red;">Email ou mot de passe incorrect</p>
    </c:if>

    <form method="post" action="<c:url value='/login' />">
        <label>Email :</label>
        <input type="email" name="email" required />

        <label>Mot de passe :</label>
        <input type="password" name="motdepasse" required />

        <button type="submit">Se connecter</button>
    </form>
</div>
</body>
</html>
