<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Films</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css' />">
</head>
<style>
   
body {
    font-family: Arial, sans-serif;
    background-color: #1a1a1a;
    color: #fff;
    margin: 0;
    padding: 0;
}

.container {
    max-width: 800px;
    margin: 30px auto;
    padding: 20px;
    background-color: #330000;
    border-radius: 10px;
}

h1 {
    color: #ff4d4d;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

table, th, td {
    border: 1px solid #ff4d4d;
}

th, td {
    padding: 8px;
    text-align: left;
}

a {
    color: #ff4d4d;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

input, textarea, select, button {
    display: block;
    width: 100%;
    margin: 5px 0 15px 0;
    padding: 8px;
    border-radius: 5px;
    border: none;
}

button {
    background-color: #ff4d4d;
    color: white;
    cursor: pointer;
}

button:hover {
    background-color: #e60000;
}
 
</style>
<body>
<div class="container">
    <h1>Films</h1>
    <a href="<c:url value='/films/new' />" class="btn">Ajouter un film</a>
    <table>
        <thead>
        <tr>
            <th>Image</th>
            <th>Titre</th>
            <th>Genre</th>
            <th>Durée</th>
            <th>Statut</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="film" items="${films}">
            <tr>
                <td>
    <c:if test="${film.image != null}">
        <img src="<c:url value='/images/${film.image}' />" alt="${film.titre}" width="100"/>
    </c:if>
</td>
                <td>${film.titre}</td>
                <td>${film.genre.nomGenre}</td>
                <td>${film.dureeMinutes} min</td>
                <td>${film.statut}</td>
                <td>
                    <a href="<c:url value='/films/edit/${film.idFilm}' />">Editer</a> |
                    <a href="<c:url value='/films/delete/${film.idFilm}' />"
                       onclick="return confirm('Supprimer ce film ?');">Supprimer</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
