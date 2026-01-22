<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails Salle - ${salle.nomSalle}</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .container { max-width: 1000px; margin: 0 auto; padding: 20px; }
        h1 { color: #333; margin-bottom: 30px; }
        .detail-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .section-title {
            font-size: 18px;
            font-weight: bold;
            color: #007bff;
            margin-bottom: 15px;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; }
        .info-item { background: #f8f9fa; padding: 12px; border-radius: 4px; }
        .info-label { font-weight: bold; color: #333; font-size: 13px; text-transform: uppercase; }
        .info-value { font-size: 16px; color: #007bff; margin-top: 5px; }
        .revenu-box {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 25px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 20px;
        }
        .revenu-box h2 { margin: 0 0 10px 0; }
        .revenu-box .amount {
            font-size: 32px;
            font-weight: bold;
            margin: 10px 0;
        }
        .revenu-box .currency { font-size: 14px; }
        .type-place-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        .type-place-table th,
        .type-place-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .type-place-table th {
            background: #007bff;
            color: white;
            font-weight: bold;
        }
        .type-place-table tr:hover { background: #f8f9fa; }
        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-standard { background: #e9ecef; color: #495057; }
        .badge-premium { background: #ffc107; color: #333; }
        .badge-pmr { background: #17a2b8; color: white; }
        .places-detail {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            margin-top: 15px;
        }
        .places-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(80px, 1fr));
            gap: 8px;
            margin-top: 10px;
        }
        .place-item {
            background: white;
            padding: 8px;
            border-radius: 4px;
            text-align: center;
            font-size: 12px;
            border: 1px solid #ddd;
        }
        .back-link { color: #007bff; text-decoration: none; margin-top: 20px; display: inline-block; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <a href="/salles/list" class="back-link">← Retour à la liste</a>
        
        <h1>📽️ ${salle.nomSalle}</h1>
        
        <!-- Revenu Maximum -->
        <c:if test="${not empty detailRevenu}">
            <div class="revenu-box">
                <h2>💰 Revenu Maximum Possible</h2>
                <div class="amount">
                    <fmt:formatNumber value="${detailRevenu.revenuTotal}" type="number" maxFractionDigits="2" />
                </div>
                <div class="currency">Ariary (Ar)</div>
                <p style="margin-top: 15px; font-size: 13px;">
                    Revenu total si toutes les places sont vendues
                </p>
            </div>
        </c:if>
        
        <!-- Détails de la Salle -->
        <div class="detail-section">
            <div class="section-title">Informations Générales</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Nom</div>
                    <div class="info-value">${salle.nomSalle}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Capacité Totale</div>
                    <div class="info-value">${salle.capacite} places</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Places Configurées</div>
                    <div class="info-value">${detailRevenu.capaciteTotal} places</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Statut</div>
                    <div class="info-value" style="color: ${salle.statut ? 'green' : 'red'};">
                        ${salle.statut ? '✓ Disponible' : '✗ Indisponible'}
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Détails par Type de Place -->
        <c:if test="${not empty detailRevenu}">
            <div class="detail-section">
                <div class="section-title">Répartition des Places par Type</div>
                <table class="type-place-table">
                    <thead>
                        <tr>
                            <th>Type de Place</th>
                            <th>Nombre de Places</th>
                            <th>Prix Unitaire (Ar)</th>
                            <th>Revenu Total (Ar)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="type" items="${detailRevenu.nombrePlacesParType}">
                            <tr>
                                <td>
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${type.key eq 'Standard'}">badge-standard</c:when>
                                            <c:when test="${type.key eq 'Premium'}">badge-premium</c:when>
                                            <c:when test="${type.key eq 'PMR'}">badge-pmr</c:when>
                                            <c:otherwise>badge-standard</c:otherwise>
                                        </c:choose>
                                    ">
                                        ${type.key}
                                    </span>
                                </td>
                                <td>
                                    <strong>${type.value}</strong> place<c:if test="${type.value > 1}">s</c:if>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${detailRevenu.prixParType[type.key]}" type="number" maxFractionDigits="0" />
                                </td>
                                <td>
                                    <strong><fmt:formatNumber value="${detailRevenu.revenuParType[type.key]}" type="number" maxFractionDigits="0" /></strong>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        
        <!-- Plan des Places -->
        <c:if test="${not empty salle.places}">
            <div class="detail-section">
                <div class="section-title">Plan des Places</div>
                <div class="places-detail">
                    <p><strong>Total :</strong> ${salle.places.size()} places</p>
                    <div class="places-grid">
                        <c:forEach var="place" items="${salle.places}">
                            <div class="place-item"
                                style="background: 
                                    <c:choose>
                                        <c:when test="${place.typePlace.libelle eq 'Premium'}">linear-gradient(135deg, #ffc107, #ff9800)</c:when>
                                        <c:when test="${place.typePlace.libelle eq 'PMR'}">linear-gradient(135deg, #17a2b8, #20c997)</c:when>
                                        <c:otherwise>linear-gradient(135deg, #e9ecef, #dee2e6)</c:otherwise>
                                    </c:choose>
                                ; color: 
                                    <c:choose>
                                        <c:when test="${place.typePlace.libelle eq 'Standard'}">
                                            #495057
                                        </c:when>
                                        <c:otherwise>white</c:otherwise>
                                    </c:choose>
                                ;">
                                <div>${place.rangee}${place.numero}</div>
                                <div style="font-size: 10px; margin-top: 2px;">${place.typePlace.libelle}</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</body>
</html>
