<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rapport de Revenu - ${detailRevenu.salle.nomSalle}</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        .container { max-width: 900px; margin: 0 auto; padding: 20px; }
        .header { background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .header h1 { margin: 0; color: #333; }
        .header p { margin: 5px 0 0 0; color: #666; }
        .revenu-box {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 30px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 20px;
        }
        .revenu-box .label { font-size: 16px; opacity: 0.9; }
        .revenu-box .amount {
            font-size: 48px;
            font-weight: bold;
            margin: 15px 0;
        }
        .revenu-box .currency { font-size: 14px; opacity: 0.8; }
        .section { background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .section-title { font-size: 18px; font-weight: bold; color: #007bff; margin-bottom: 15px; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; }
        .info-item { background: #f8f9fa; padding: 12px; border-radius: 4px; }
        .info-label { font-weight: bold; color: #333; font-size: 12px; text-transform: uppercase; margin-bottom: 5px; }
        .info-value { font-size: 18px; color: #007bff; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        table th, table td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        table th { background: #007bff; color: white; font-weight: bold; }
        table tr:hover { background: #f8f9fa; }
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
        .btn-back { display: inline-block; padding: 10px 20px; background: #6c757d; color: white; text-decoration: none; border-radius: 4px; margin-top: 20px; }
        .btn-back:hover { background: #5a6268; }
        .amount-format { text-align: right; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Rapport de Revenu - ${detailRevenu.salle.nomSalle}</h1>
            <p>Calcul du revenu maximum pour une diffusion de film</p>
        </div>
        
        <!-- Revenu Maximum -->
        <div class="revenu-box">
            <div class="label">Revenu Maximum Possible</div>
            <div class="amount">
                <fmt:formatNumber value="${detailRevenu.revenuTotal}" type="number" maxFractionDigits="0" />
            </div>
            <div class="currency">Ariary (Ar)</div>
            <p style="margin-top: 15px; opacity: 0.9;">
                Revenu généré si toutes les places sont vendues au prix complet
            </p>
        </div>
        
        <!-- Informations Générales -->
        <div class="section">
            <div class="section-title">🏢 Informations de la Salle</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Nom de la Salle</div>
                    <div class="info-value">${detailRevenu.salle.nomSalle}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Capacité Totale</div>
                    <div class="info-value">${detailRevenu.salle.capacite} places</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Places Configurées</div>
                    <div class="info-value">${detailRevenu.capaciteTotal} places</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Statut</div>
                    <div class="info-value" style="color: ${detailRevenu.salle.statut ? '#28a745' : '#dc3545'};">
                        ${detailRevenu.salle.statut ? '✓ Actif' : '✗ Inactif'}
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Détail par Type de Place -->
        <c:if test="${not empty detailRevenu.nombrePlacesParType}">
            <div class="section">
                <div class="section-title">🎫 Détail des Places par Type</div>
                <table>
                    <thead>
                        <tr>
                            <th>Type de Place</th>
                            <th style="text-align: center;">Nombre</th>
                            <th class="amount-format">Prix Unitaire</th>
                            <th class="amount-format">Revenu Total</th>
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
                                <td style="text-align: center;">
                                    <strong>${type.value}</strong>
                                </td>
                                <td class="amount-format">
                                    <fmt:formatNumber value="${detailRevenu.prixParType[type.key]}" type="number" maxFractionDigits="0" /> Ar
                                </td>
                                <td class="amount-format">
                                    <strong><fmt:formatNumber value="${detailRevenu.revenuParType[type.key]}" type="number" maxFractionDigits="0" /> Ar</strong>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        
        <!-- Résumé -->
        <div class="section">
            <div class="section-title">📈 Résumé</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Total Places</div>
                    <div class="info-value">${detailRevenu.capaciteTotal}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Nombre Types</div>
                    <div class="info-value">${detailRevenu.nombrePlacesParType.size()}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Revenu Maximum</div>
                    <div class="info-value">
                        <fmt:formatNumber value="${detailRevenu.revenuTotal}" type="number" maxFractionDigits="0" /> Ar
                    </div>
                </div>
            </div>
        </div>
        
        <a href="/salles/list" class="btn-back">← Retour à la liste des salles</a>
    </div>
</body>
</html>
