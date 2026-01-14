<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Fiche des Séances</title>
   
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
    <h1>Fiche des Séances</h1>

    <!-- Liste des séances -->
    <table>
        <thead>
        <tr>
            <th>Film</th>
            <th>Genre</th>
            <th>Salle</th>
            <th>Date</th>
            <th>Heure</th>
            <th>Prix (€)</th>
            <th>Statut</th>
        </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <a href="<c:url value='/films/fiche/${seance.film.idFilm}' />">
                        ${seance.film.titre}
                    </a>
                </td>
                <td>${seance.film.genre.nomGenre}</td>
                <td>${seance.salle.nomSalle} (capacité: ${seance.salle.capacite})</td>
                <td>${seance.dateSeance}</td>
                <td>${seance.heureDebut}</td>
                <td>${seance.prix}</td>
                <td>${seance.statut ? 'Programmé' : 'Annulé'}</td>
            </tr>
        </tbody>
    </table>
</div>
</body>
</html>
