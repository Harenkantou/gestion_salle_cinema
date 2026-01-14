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

    <!-- Formulaire filtre -->
    <form method="get" action="<c:url value='/seances/liste-seances' />">
        <label>Genre :</label>
        <select name="genre">
            <option value="">Tous</option>
            <c:forEach var="g" items="${genres}">
                <option value="${g.nomGenre}">${g.nomGenre}</option>
            </c:forEach>
        </select>

        
        <label>Date :</label>
       <input type="date" name="dateSeance" id="dateSeance">
     

        <label>Heure :</label>
         <select name="comparaison">
            <option value="avant">Avant :</option>
            <option value="apres">Après :</option>
        </select>
        <input type="time" name="heure"> <!-- format HH:mm -->
       

        <label>Salle :</label>
        <select name="salle">
            <option value="">Toutes</option>
            <c:forEach var="s" items="${salles}">
                <option value="${s.idSalle}">${s.nomSalle}</option>
            </c:forEach>
        </select>

        <label>Prix max :</label>
        <input type="number" step="0.01" name="prixMax" />

        <button type="submit">Filtrer</button>
    </form>

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
           
            <th>Reservation</th>
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
                             <a href="<c:url value='/billets/reserver/${s.idSeance}' />" class="btn">
                Réserver un billet
            </a>
                </td>
      

            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
