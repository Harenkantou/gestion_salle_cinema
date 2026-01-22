<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Séances</title>
   
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
    
    <a href="<c:url value='/seances/new' />" style="display: inline-block; background-color: #00cc00; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin-bottom: 20px; font-weight: bold;">
        ➕ Ajouter une Séance
    </a>

    <!-- Formulaire filtre -->
    <form method="get" action="<c:url value='/seances/liste-seances' />">
        <label>Nom du Film :</label>
        <input type="text" name="nomFilm" placeholder="Ex: Avatar" />

        <label>Genre :</label>
        <select name="genre">
            <option value="">Tous les genres</option>
            <c:forEach var="g" items="${genres}">
                <option value="${g.nomGenre}">${g.nomGenre}</option>
            </c:forEach>
        </select>

        <label>Date :</label>
        <input type="date" name="dateSeance" id="dateSeance">

        <label>Heure :</label>
        <div style="display: flex; gap: 10px; margin-bottom: 10px;">
            <select name="comparaison" style="flex: 1;">
                <option value="">-- Sélectionner --</option>
                <option value="exactement">Exactement à</option>
                <option value="avant">Avant</option>
                <option value="apres">Après</option>
            </select>
            <input type="time" name="heure" style="flex: 1;" />
        </div>

        <label>Salle :</label>
        <select name="salle">
            <option value="">Toutes les salles</option>
            <c:forEach var="s" items="${salles}">
                <option value="${s.idSalle}">${s.nomSalle}</option>
            </c:forEach>
        </select>

        <button type="submit">Rechercher</button>
        <button type="reset">Réinitialiser</button>
    </form>

    <!-- Liste des séances -->
    <c:if test="${not empty seances}">
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
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="s" items="${seances}">
                <tr>
                    <td>
                        <a href="<c:url value='/films/fiche/${s.film.idFilm}' />">
                            ${s.film.titre}
                        </a>
                    </td>
                    <td>${s.film.genre.nomGenre}</td>
                    <td>${s.salle.nomSalle}</td>
                    <td>${s.dateSeance}</td>
                    <td>${s.heureDebut}</td>
                    <td>${s.prix}</td>
                    <td>
                        <c:if test="${s.statut}">
                            <span style="color: #00ff00;">Programmée</span>
                        </c:if>
                        <c:if test="${!s.statut}">
                            <span style="color: #ff0000;">Annulée</span>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${s.statut}">
                            <a href="<c:url value='/seances/fiche/${s.idSeance}' />" class="btn">
                                Détails
                            </a>
                        </c:if>
                        <c:if test="${!s.statut}">
                            <span style="color: #999;">Non disponible</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty seances}">
        <p style="color: #ffcc00; font-size: 18px; text-align: center;">Aucune séance trouvée. Essayez de modifier vos critères de recherche.</p>
    </c:if>
</div>
</body>
</html>
