<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Billet</title>
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
    <h1>Billets</h1>

    <form method="post" action="<c:url value='/billets/list' />">

        <select name="idClient" id="IdClient">
            <c:forEach var="client" items="${clients}">
                <option value="${client.idClient}">${client.nom} ${client.prenom}</option>
            </c:forEach>
        </select>

        <button type="submit">Valider</button>
    </form>

    <table>
        <thead>
        <tr>
            <th>id_billets</th>
            <th>date_achat</th>
            <th>id_statut_billet</th>
            <th>prix</th>
            <th>client</th>
            <th>id_place</th>
            <th>id_seance</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="billet" items="${billets}">
            <tr>
                <td>${billet.idBillet}</td>
                <td>${billet.dateAchat}</td>
                <td>${billet.idStatutBillet}</td>
                <td>${billet.prix}</td>
                <td>${billet.client.nom} ${billet.client.prenom}</td>
                <td>Rangee : ${billet.place.rangee} - N°${billet.place.numero}</td>
                <td>${billet.seance.idSeance}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
