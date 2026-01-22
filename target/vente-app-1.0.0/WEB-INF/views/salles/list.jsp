<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Salles</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .container { max-width: 1000px; margin: 0 auto; padding: 20px; }
        h1 { color: #333; text-align: center; margin-bottom: 30px; }
        .salle-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .salle-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-left: 4px solid #007bff;
        }
        .salle-card h3 { margin: 0 0 10px 0; color: #007bff; }
        .salle-info { font-size: 14px; margin: 8px 0; }
        .salle-info strong { color: #333; }
        .salle-info span { color: #666; }
        .btn-container { margin-top: 15px; }
        .btn {
            display: inline-block;
            padding: 8px 15px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 13px;
            transition: background 0.3s;
        }
        .btn:hover { background: #0056b3; }
        .statut-actif { color: green; font-weight: bold; }
        .statut-inactif { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📽️ Liste des Salles du Cinéma</h1>
        
        <c:if test="${empty salles}">
            <p style="text-align: center; color: #666;">Aucune salle disponible.</p>
        </c:if>
        
        <div class="salle-grid">
            <c:forEach var="salle" items="${salles}">
                <div class="salle-card">
                    <h3>${salle.nomSalle}</h3>
                    <div class="salle-info">
                        <strong>Capacité :</strong>
                        <span>${salle.capacite} places</span>
                    </div>
                    <div class="salle-info">
                        <strong>Status :</strong>
                        <span class="${salle.statut ? 'statut-actif' : 'statut-inactif'}">
                            ${salle.statut ? 'Disponible' : 'Indisponible'}
                        </span>
                    </div>
                    <div class="salle-info">
                        <strong>Nombre de places configurées :</strong>
                        <span>${salle.places.size()} places</span>
                    </div>
                    <div class="btn-container">
                        <a href="/salles/${salle.idSalle}" class="btn">Voir Détails & Revenu</a>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="/" style="color: #007bff; text-decoration: none;">← Retour à l'accueil</a>
        </div>
    </div>
</body>
</html>
