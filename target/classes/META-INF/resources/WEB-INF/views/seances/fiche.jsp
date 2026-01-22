<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Détail de la Séance</title>
   
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

.detail-section {
    margin: 20px 0;
    padding: 15px;
    background-color: #550000;
    border-left: 4px solid #ff4d4d;
    border-radius: 5px;
}

.detail-row {
    display: flex;
    justify-content: space-between;
    margin: 10px 0;
    padding: 10px;
}

.label {
    font-weight: bold;
    color: #ffcc00;
}

.value {
    color: #fff;
}

.actions {
    text-align: center;
    margin-top: 20px;
}

button {
    background-color: #ff4d4d;
    color: white;
    cursor: pointer;
    padding: 12px 30px;
    font-size: 16px;
    border: none;
    border-radius: 5px;
    margin: 0 5px;
}

button:hover {
    background-color: #e60000;
}

a {
    color: #ff4d4d;
    text-decoration: none;
    display: inline-block;
    padding: 10px 15px;
    margin: 5px;
}

a:hover {
    text-decoration: underline;
}

.info-places {
    background-color: #ffcc00;
    color: #000;
    padding: 10px;
    border-radius: 5px;
    margin: 10px 0;
}
 
</style>
<body>
<div class="container">
    <h1>Détail de la Séance</h1>

    <div class="detail-section">
        <div class="detail-row">
            <span class="label">Film:</span>
            <span class="value">
                <a href="<c:url value='/films/fiche/${seance.film.idFilm}' />">
                    ${seance.film.titre}
                </a>
            </span>
        </div>
        
        <div class="detail-row">
            <span class="label">Genre:</span>
            <span class="value">${seance.film.genre.nomGenre}</span>
        </div>

        <div class="detail-row">
            <span class="label">Durée:</span>
            <span class="value">${seance.film.dureeMinutes} minutes</span>
        </div>
    </div>

    <div class="detail-section">
        <div class="detail-row">
            <span class="label">Salle:</span>
            <span class="value">${seance.salle.nomSalle}</span>
        </div>

        <div class="detail-row">
            <span class="label">Capacité:</span>
            <span class="value">${seance.salle.capacite} places</span>
        </div>

        <div class="detail-row">
            <span class="label">Date:</span>
            <span class="value">${seance.dateSeance}</span>
        </div>

        <div class="detail-row">
            <span class="label">Heure:</span>
            <span class="value">${seance.heureDebut}</span>
        </div>

        <div class="detail-row">
            <span class="label">Prix:</span>
            <span class="value">${seance.prix} €</span>
        </div>

        <div class="detail-row">
            <span class="label">Statut:</span>
            <span class="value">${seance.statut ? 'Programmée' : 'Annulée'}</span>
        </div>
    </div>

    <c:if test="${seance.statut}">
        <div class="actions">
            <form action="<c:url value='/billets/reserver/${seance.idSeance}' />" method="get" style="display:inline;">
                <button type="submit">Réserver des places</button>
            </form>
        </div>
    </c:if>

    <div class="actions">
        <a href="<c:url value='/seances/liste-seances' />">Retour à la liste des séances</a>
    </div>
</div>
</body>
</html>
