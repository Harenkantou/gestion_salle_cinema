<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
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
   <form action="<c:url value='/seances/save' />" method="post">
    <input type="hidden" name="idSeance" value="${seance.idSeance}" />

    <label>Film :</label>
    <select name="film.idFilm" required>
        <option value="">-- Choisir un film --</option>
        <c:forEach var="f" items="${films}">
            <option value="${f.idFilm}" 
                <c:if test="${seance.film != null && seance.film.idFilm == f.idFilm}">selected</c:if>>
                ${f.titre}
            </option>
        </c:forEach>
    </select>

    <label>Salle :</label>
    <select name="salle.idSalle" required>
        <option value="">-- Choisir une salle --</option>
        <c:forEach var="s" items="${salles}">
            <option value="${s.idSalle}"
                <c:if test="${seance.salle != null && seance.salle.idSalle == s.idSalle}">selected</c:if>>
                ${s.nomSalle} (capacité: ${s.capacite})
            </option>
        </c:forEach>
    </select>

    <label>Date :</label>
    <input type="date" name="dateSeance" value="${seance.dateSeance}" required />

    <label>Heure :</label>
    <input type="time" name="heureDebut" value="${seance.heureDebut}" required />

    <label>Prix :</label>
    <input type="number" name="prix" value="${seance.prix}" step="0.01" min="0" required />

    <label>Statut :</label>
    <select name="statut">
        <option value="true" ${seance.statut ? 'selected' : ''}>Programmé</option>
        <option value="false" ${!seance.statut ? 'selected' : ''}>Annulé</option>
    </select>

    <button type="submit">Enregistrer</button>
    <a href="<c:url value='/seances' />">Annuler</a>
</form>
 
</body>
</html>
