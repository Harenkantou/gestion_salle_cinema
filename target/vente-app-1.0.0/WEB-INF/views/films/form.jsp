<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Film</title>
    
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
    <h1>${film.idFilm != null ? "Editer Film" : "Ajouter Film"}</h1>
    <form action="<c:url value='/films/save' />" method="post" enctype="multipart/form-data">
        <input type="hidden" name="idFilm" value="${film.idFilm}" />
        <label>Titre :</label>
        <input type="text" name="titre" value="${film.titre}" required />

        <label>Description :</label>
        <textarea name="descriptionFilm">${film.descriptionFilm}</textarea>

        <label>Durée (minutes) :</label>
        <input type="number" name="dureeMinutes" value="${film.dureeMinutes}" required />

        <label>Genre :</label>
<select name="genre.idGenre" required>
    <option value="">-- Sélectionnez un genre --</option>
    <c:forEach var="g" items="${genres}">
        <option value="${g.idGenre}"
            <c:if test="${film.genre != null && film.genre.idGenre == g.idGenre}">selected</c:if>>
            ${g.nomGenre}
        </option>
    </c:forEach>
</select>
        <label>Date de sortie :</label>
        <input type="date" name="dateSortie" value="${film.dateSortie}" />

       <label>Image :</label>
    <input type="file" name="imageFile" />

        <label>Statut :</label>
        <select name="statut">
            <option value="ACTIF" ${film.statut == 'ACTIF' ? 'selected' : ''}>ACTIF</option>
            <option value="INACTIF" ${film.statut == 'INACTIF' ? 'selected' : ''}>INACTIF</option>
        </select>

        <button type="submit">Enregistrer</button>
        <a href="<c:url value='/films' />">Annuler</a>
    </form>
</div>
</body>

</html>
