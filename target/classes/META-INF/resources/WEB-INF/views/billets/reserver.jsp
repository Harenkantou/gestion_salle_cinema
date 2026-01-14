<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
   
    <title>Réserver une place</title>
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
    <h2>Réserver pour la séance : ${seance.film.titre}</h2>
    <p>Salle : ${seance.salle.nomSalle} | Date : ${seance.dateSeance} | Heure : ${seance.heureDebut}</p>

    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>

    <form method="post" action="<c:url value='/billets/reserver/${seance.idSeance}' />">
        <label>Choisir une place :</label>
        <select name="idPlace" required>
            <c:forEach var="place" items="${placesDisponibles}">
                <option value="${place.idPlace}"> ${seance.salle.nomSalle}- Rang ${place.rangee} - Num ${place.numero}</option>
            </c:forEach>
        </select>
        <br/><br/>
        <button type="submit">Réserver</button>
    </form>

    <a href="<c:url value='/seances/liste-seances' />">Retour à la liste des séances</a>
</div>
</body>
</html>
