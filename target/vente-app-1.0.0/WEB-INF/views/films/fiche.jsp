<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Fiche Film - ${film.titre}</title>
    
</head>
<style>
  body {
    background-color: #1c1c1c;
    color: #fff;
    font-family: Arial, sans-serif;
}

.container {
    width: 80%;
    margin: 20px auto;
    padding: 20px;
    background-color: #2b2b2b;
    border-radius: 10px;
}

h1 {
    color: #ff4d4d;
}

.film-info img.film-affiche {
    width: 200px;
    float: left;
    margin-right: 20px;
    border: 2px solid #ff4d4d;
}

.film-info p {
    margin: 5px 0;
}

.btn {
    display: inline-block;
    padding: 8px 12px;
    background-color: #ff4d4d;
    color: #fff;
    text-decoration: none;
    border-radius: 5px;
    margin-top: 20px;
}

.btn:hover {
    background-color: #cc0000;
}
  
</style>
<body>
<div class="container fiche-film">
    <h1>${film.titre}</h1>

    <div class="film-info">
        <c:if test="${film.image != null}">
    <img src="/images/${film.image}" 
         alt="${film.titre}" class="film-affiche" />
</c:if>



        <p><b>Genre :</b> <c:out value="${film.genre.nomGenre}" /></p>
        <p><b>Durée :</b> ${film.dureeMinutes} minutes</p>
        <p><b>Date de sortie :</b> <c:out value="${film.dateSortie}" /></p>
        <p><b>Statut :</b> ${film.statut}</p>
        <p><b>Description :</b></p>
        <p>${film.descriptionFilm}</p>
    </div>

    <a href="<c:url value='/films' />" class="btn">Retour à la liste</a>
</div>
</body>
</html>
