<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Séances</title>
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
    <h1>Liste des Séances</h1>
    <a href="<c:url value='/seances/new' />" class="btn">Ajouter une séance</a>
    
    <table>
        <thead>
        <tr>
            <th>Film</th>
            <th>Salle</th>
            <th>Date</th>
            <th>Heure</th>
            <th>Prix (€)</th>
            <th>Statut</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="s" items="${seances}">
            <tr>
                <td>${s.film.titre}</td>
                <td>${s.salle.nomSalle} (capacité: ${s.salle.capacite})</td>
                <td>${s.dateSeance}</td>
                <td>${s.heureDebut}</td>
                <td>${s.prix}</td>
                <td>${s.statut ? 'Programmé' : 'Annulé'}</td>
                <td>
                    <a href="<c:url value='/seances/edit/${s.idSeance}' />">Editer</a> |
                    <a href="<c:url value='/seances/delete/${s.idSeance}' />"
                       onclick="return confirm('Supprimer cette séance ?');">Supprimer</a> |
                    <a href="<c:url value='/seances/fiche/${s.idSeance}' />">Fiche</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
